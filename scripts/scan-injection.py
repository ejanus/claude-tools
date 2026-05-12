#!/usr/bin/env python3
"""
Scans Claude command/skill .md files for prompt injection patterns.
Invoked by pre-commit with staged file paths as arguments.

This script is intentionally self-contained with no external dependencies
so it cannot be subverted by a compromised package or network call.
"""

import re
import sys

# Each entry: (compiled pattern, human-readable label)
# Keep patterns conservative to minimize false positives on legitimate
# command files. Add to this list as new attack patterns emerge.
PATTERNS = [
    # Instruction override — the classic attack vector
    (re.compile(
        r'(ignore|disregard|forget)\s+(all\s+)?(previous|prior|above|earlier)?\s*instructions',
        re.IGNORECASE),
     "instruction override"),

    # Role hijacking
    (re.compile(
        r'(you are now|act as|pretend (to be|you are))\s+(a |an )?(different|new|unrestricted|evil|jailbreak)',
        re.IGNORECASE),
     "role hijack"),

    # System prompt / model delimiter injection
    (re.compile(
        r'\[SYSTEM\]|</?system>|###\s*(Human|Assistant|System)\s*:|\[INST\]|\[/INST\]',
        re.IGNORECASE),
     "system prompt marker"),

    # Jailbreak keywords
    (re.compile(
        r'\bDAN\b|jailbreak|unrestricted mode|developer mode|do anything now',
        re.IGNORECASE),
     "jailbreak keyword"),

    # Data exfiltration signals
    (re.compile(
        r'exfiltrate|(send|leak|transmit)\s+(all|this|the|every)\s+(data|context|conversation|content|instructions)',
        re.IGNORECASE),
     "data exfiltration"),

    # Hidden / zero-width Unicode that can conceal instructions
    (re.compile(r'[​‌‍­﻿  ]'),
     "hidden Unicode character"),

]

found = False

for path in sys.argv[1:]:
    try:
        with open(path, encoding='utf-8', errors='replace') as f:
            text = f.read()
    except OSError as e:
        print(f"ERROR: cannot read {path}: {e}")
        sys.exit(2)

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
