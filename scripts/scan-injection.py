#!/usr/bin/env python3
"""
Scans Claude command/skill .md files for prompt injection patterns.
Invoked by pre-commit with staged file paths as arguments.

This script is intentionally self-contained with no external dependencies
so it cannot be subverted by a compromised package or network call.

Pattern sources are cited inline. Tests live in scripts/tests/.
"""

import re
import sys

# Each entry: (compiled pattern, human-readable label)
# Patterns are conservative — broadening recall has been paired with
# narrowing on safety-relevant nouns / target verbs to keep FP risk low
# on legitimate English-language Claude command content.
PATTERNS = [
    # ------------------------------------------------------------------
    # Instruction override — classic attack vector.
    # Triggers only when a control verb meets a safety-relevant noun, so
    # "override the previous behavior" stays clean ("behavior" isn't in
    # the noun set).
    # ------------------------------------------------------------------
    (re.compile(
        r'\b(ignore|disregard|forget|override|bypass|disable|skip)\b'
        r'(\s+\w+){0,4}'
        r'\s+\b(instructions?|guidelines?|rules?|prompts?|directives?'
        r'|constraints?|restrictions?|policies|training|safeguards?)\b',
        re.IGNORECASE),
     "instruction override"),

    # ------------------------------------------------------------------
    # Role hijacking.
    # ------------------------------------------------------------------
    (re.compile(
        r'(you are now|act as|pretend (to be|you are))\s+(a |an )?'
        r'(different|new|unrestricted|evil|jailbreak)',
        re.IGNORECASE),
     "role hijack"),

    # ------------------------------------------------------------------
    # System prompt / model delimiter injection.
    # ------------------------------------------------------------------
    (re.compile(
        r'\[SYSTEM\]|</?system>|###\s*(Human|Assistant|System)\s*:'
        r'|\[INST\]|\[/INST\]',
        re.IGNORECASE),
     "system prompt marker"),

    # ------------------------------------------------------------------
    # Tool-poisoning authority tags.
    # Source: arXiv:2510.26328 (Agent Skills prompt injection paper).
    # Fabricated XML-like tags that masquerade as authoritative system
    # markup to wrap injected imperatives. Excludes <note> (common in
    # legitimate markdown); attackers use note_to_assistant instead.
    # ------------------------------------------------------------------
    (re.compile(
        r'<\s*(important|sidenote|secret|system_message|admin|critical'
        r'|note_to_assistant|hidden|instruction)\s*[/>]',
        re.IGNORECASE),
     "tool-poisoning authority tag"),

    # ------------------------------------------------------------------
    # Authority-framed new imperatives.
    # Source: arXiv:2510.26328, Embrace The Red writeups.
    # Distinct from override (#1): these ADD instructions framed as
    # required pre-conditions. Triggers only with a specific noun target
    # (file/command/tool/etc.) to keep FP risk down.
    # ------------------------------------------------------------------
    (re.compile(
        r'\b('
        r'before\s+(any|every|each)\s+(file|command|tool|operation|action'
        r'|step|response|task|reply)'
        r'|you\s+must\s+(always|first|never)\s+(read|fetch|invoke|execute'
        r'|include|append|run|curl)'
        r'|always\s+(invoke|run|read|execute|include|curl|fetch)'
        r'.{0,80}?\s+(before|prior\s+to|first)'
        r')\b',
        re.IGNORECASE),
     "authority imperative"),

    # ------------------------------------------------------------------
    # Jailbreak keywords.
    # ------------------------------------------------------------------
    (re.compile(
        r'\bDAN\b|jailbreak|unrestricted mode|developer mode|do anything now',
        re.IGNORECASE),
     "jailbreak keyword"),

    # ------------------------------------------------------------------
    # Data exfiltration.
    # Up to 4 filler words allowed between verb and sensitive noun
    # (catches "transmit all the conversation content" and similar).
    # Standalone trigger keywords (exfiltrate, smuggle) match anywhere.
    # ------------------------------------------------------------------
    (re.compile(
        r'\b(exfiltrate|smuggle)\b'
        r'|\b(send|leak|transmit|extract|post|upload|share|forward)\b'
        r'(\s+\w+){0,4}'
        r'\s+\b(data|context|conversation|content|instructions?'
        r'|secrets?|credentials?|tokens?|api[-_\s]?keys?|prompts?'
        r'|history|session|messages?)\b',
        re.IGNORECASE),
     "data exfiltration"),

    # ------------------------------------------------------------------
    # Markdown image exfiltration.
    # Source: Willison "Summer of Johann" series; CVE-2025-54132 (Cursor);
    # CVE-2025-32711 (Microsoft 365 Copilot); OpenHands / Antigravity.
    # The dominant 2025 agentic-tool exfiltration vector — image URLs
    # with dynamic interpolation tokens cause the assistant to embed
    # session data into a fetched-by-renderer URL. Scoped to interpolation
    # tokens only ({{...}}, ${...}, $(...), backticks, <%...%>) so plain
    # static images don't trigger.
    # ------------------------------------------------------------------
    (re.compile(
        r'!\[[^\]]*\]\([^)]*'
        r'(\{\{|\$\{|\$\(|`|<%)',
        re.IGNORECASE),
     "markdown image exfiltration"),

    # ------------------------------------------------------------------
    # Claude-Code-specific config-edit exfil signals.
    # Sources: CVE-2025-59536, CVE-2025-54794, CVE-2025-54795,
    # CVE-2026-21852 (Check Point research on Claude Code project files).
    # Skill content suggesting privileged config changes / hooks /
    # permission bypasses is exfiltration-class regardless of framing.
    # ------------------------------------------------------------------
    (re.compile(
        r'(\.claude/settings\.json'
        r'|enableAllProjectMcpServers'
        r'|enabledMcpjsonServers'
        r'|ANTHROPIC_BASE_URL'
        r'|onSessionStart'
        r'|--dangerously-skip-permissions)',
        re.IGNORECASE),
     "Claude-Code config-edit signal"),

    # ------------------------------------------------------------------
    # Non-Latin confusable scripts.
    # Cyrillic + Greek + Mathematical Alphanumerics — common homoglyph
    # blocks attackers use to spell Latin words with look-alike code
    # points (e.g., Cyrillic 'і' U+0456 substituted for Latin 'i').
    # Decorative chars (em-dash, curly quotes, emoji) are OUTSIDE these
    # ranges, so FP risk in English Claude content is minimal.
    # ------------------------------------------------------------------
    (re.compile(r'[Ѐ-ӿͰ-Ͽ\U0001d400-\U0001d7ff]'),
     "non-Latin confusable script"),

    # ------------------------------------------------------------------
    # Hidden / zero-width / invisible Unicode.
    # Codepoints are written as explicit \u/\U escapes so the source
    # stays auditable — literal invisible chars are exactly what this
    # scanner exists to catch elsewhere:
    #   U+200B ZERO WIDTH SPACE
    #   U+200C ZERO WIDTH NON-JOINER
    #   U+200D ZERO WIDTH JOINER
    #   U+00AD SOFT HYPHEN
    #   U+FEFF ZERO WIDTH NO-BREAK SPACE / BOM
    #   U+2028 LINE SEPARATOR
    #   U+2029 PARAGRAPH SEPARATOR
    #   U+E0000–U+E007F Unicode TAG block ("ASCII smuggling", 128 cps)
    #   U+E0100–U+E01EF Variation Selectors Supplement (240 cps,
    #                   sufficient byte-encoding bandwidth for smuggling)
    # The TAG block and Supplement are the dominant 2025 smuggling
    # vectors per AWS/Cisco/Embrace-The-Red advisories. The basic
    # Variation Selectors (U+FE00–U+FE0F) are intentionally NOT in
    # this set — only 16 codepoints, insufficient bandwidth for an
    # attack, and U+FE0F is the legitimate emoji-presentation
    # selector used in standard emoji rendering (e.g., ⚠ + U+FE0F = ⚠️).
    # ------------------------------------------------------------------
    (re.compile(
        r'['
        r'\u200b\u200c\u200d\u00ad\ufeff\u2028\u2029'
        r'\U000e0000-\U000e007f'
        r'\U000e0100-\U000e01ef'
        r']'),
     "hidden Unicode character"),
]

found = False

for path in sys.argv[1:]:
    try:
        # Strict UTF-8: failing closed on decode errors so an attacker
        # cannot smuggle injection patterns inside malformed-encoding
        # content (e.g. invalid bytes that would be silently replaced
        # by U+FFFD under errors='replace', breaking up patterns).
        with open(path, encoding='utf-8') as f:
            text = f.read()
    except OSError as e:
        print(f"ERROR: cannot read {path}: {e}", file=sys.stderr)
        sys.exit(2)
    except UnicodeDecodeError as e:
        print(
            f"BLOCKED {path}: file is not valid UTF-8 ({e}).\n"
            "Pre-commit scans require valid UTF-8 so injection patterns\n"
            "can be detected reliably. Convert the file to UTF-8 and retry.",
            file=sys.stderr,
        )
        sys.exit(1)

    for pattern, label in PATTERNS:
        match = pattern.search(text)
        if match:
            line_no = text[: match.start()].count("\n") + 1
            print(f"BLOCKED {path}:{line_no} — {label}: {match.group()!r}")
            found = True

if found:
    print(
        "\nPrompt injection pattern(s) detected in staged files.\n"
        "Review the flagged lines above before committing.\n"
        "If this is a legitimate false positive, open a PR to update\n"
        "the pattern list in scripts/scan-injection.py."
    )
    sys.exit(1)

sys.exit(0)
