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
# which sets PRE_COMMIT_FROM_REF and PRE_COMMIT_TO_REF. Also reads
# $PRE_COMMIT_REMOTE_NAME so the hook works for forks / non-standard
# remote names.

set -uo pipefail

# Read message from stdin and exit 1. The whole script fails closed —
# this helper centralizes the "print to stderr + exit 1" pattern.
fail_closed() {
    cat >&2
    exit 1
}

ZERO_SHA="0000000000000000000000000000000000000000"
from_ref="${PRE_COMMIT_FROM_REF:-}"
to_ref="${PRE_COMMIT_TO_REF:-}"
remote="${PRE_COMMIT_REMOTE_NAME:-origin}"

if [ -z "$from_ref" ] || [ -z "$to_ref" ]; then
    echo "ERROR: PRE_COMMIT_FROM_REF/TO_REF not set. Invoke via pre-commit framework." >&2
    exit 2
fi

if [ "$from_ref" = "$ZERO_SHA" ]; then
    # New branch on remote — count from merge-base with the remote's
    # default branch.
    default_ref=$(git symbolic-ref "refs/remotes/$remote/HEAD" --short 2>/dev/null || echo "")

    if [ -z "$default_ref" ]; then
        fail_closed <<EOF

Push blocked: cannot resolve default branch for remote "$remote".

This pre-push hook counts commits against the remote's default branch
on new-branch pushes, but $remote/HEAD is not set locally. Fix with:

  git remote set-head $remote --auto

Then retry the push. Failing closed rather than skipping the check —
the whole point of this hook is to gate every commit through CI.

EOF
    fi

    base=$(git merge-base "$to_ref" "$default_ref" 2>/dev/null) || fail_closed <<EOF

Push blocked: no common ancestor between $to_ref and $default_ref.

This usually means the branch was created from a different root than
the remote's default branch, so there is no shared history to count
commits against. Rebase onto the default branch and retry:

  git fetch $remote
  git rebase $default_ref

Failing closed rather than skipping the check — the whole point of
this hook is to gate every commit through CI.

EOF
    range="$base..$to_ref"
else
    range="$from_ref..$to_ref"
fi

count=$(git rev-list --count "$range" 2>/dev/null) || fail_closed <<EOF

Push blocked: git rev-list --count $range failed.

A ref in the push range is missing or invalid. Fetch the remote and
retry; if the error persists, inspect with the same command:

  git fetch $remote
  git rev-list --count $range

Failing closed rather than treating the count as 0 — the whole point
of this hook is to gate every commit through CI.

EOF

if [ "$count" -gt 1 ]; then
    fail_closed <<EOF

Push blocked: $count commits would be pushed.

This repo enforces one commit per push so every commit gets its own CI
run and is independently scanned. Bundled pushes can hide intermediate
states from CI.

To proceed, squash with interactive rebase:
  git rebase -i HEAD~$count

EOF
fi

exit 0
