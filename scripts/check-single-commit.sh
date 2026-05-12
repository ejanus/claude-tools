#!/usr/bin/env bash
# Pre-push hook: refuse pushes that include more than one commit.
#
# Why: each push triggers one CI run that scans the cumulative diff. If a
# branch accumulates multiple commits locally and pushes them together,
# intermediate states never reach CI individually — a commit could
# introduce malicious content that a later commit "fixes" and the CI diff
# would never see it. Enforcing one commit per push gives every commit
# its own CI run.
#
# Invoked exclusively via the pre-commit framework (stages: [pre-push]),
# which sets PRE_COMMIT_FROM_REF and PRE_COMMIT_TO_REF.

set -uo pipefail

ZERO_SHA="0000000000000000000000000000000000000000"
from_ref="${PRE_COMMIT_FROM_REF:-}"
to_ref="${PRE_COMMIT_TO_REF:-}"

if [ -z "$from_ref" ] || [ -z "$to_ref" ]; then
    echo "ERROR: PRE_COMMIT_FROM_REF/TO_REF not set. Invoke via pre-commit framework." >&2
    exit 2
fi

if [ "$from_ref" = "$ZERO_SHA" ]; then
    # New branch on remote — count from merge-base with default branch
    default_ref=$(git symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null || echo "origin/main")
    base=$(git merge-base "$to_ref" "$default_ref" 2>/dev/null) || exit 0
    range="$base..$to_ref"
else
    range="$from_ref..$to_ref"
fi

count=$(git rev-list --count "$range" 2>/dev/null || echo 0)

if [ "$count" -gt 1 ]; then
    cat >&2 <<EOF

Push blocked: $count commits would be pushed.

This repo enforces one commit per push so every commit gets its own CI
run and is independently scanned. Bundled pushes can hide intermediate
states from CI.

To proceed, squash with interactive rebase:
  git rebase -i HEAD~$count

EOF
    exit 1
fi

exit 0
