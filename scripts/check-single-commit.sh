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
    # New branch on remote — count from merge-base with the remote's
    # default branch. Use $PRE_COMMIT_REMOTE_NAME (set by the pre-commit
    # framework) instead of hardcoding "origin" so the hook works for
    # forks or non-standard remote names.
    remote="${PRE_COMMIT_REMOTE_NAME:-origin}"
    default_ref=$(git symbolic-ref "refs/remotes/$remote/HEAD" --short 2>/dev/null || echo "")

    if [ -z "$default_ref" ]; then
        cat >&2 <<EOF

Push blocked: cannot resolve default branch for remote "$remote".

This pre-push hook counts commits against the remote's default branch
on new-branch pushes, but $remote/HEAD is not set locally. Fix with:

  git remote set-head $remote --auto

Then retry the push. Failing closed rather than skipping the check —
the whole point of this hook is to gate every commit through CI.

EOF
        exit 1
    fi

    base=$(git merge-base "$to_ref" "$default_ref" 2>/dev/null) || {
        cat >&2 <<EOF

Push blocked: no common ancestor between $to_ref and $default_ref.

This usually means the branch was created from a different root than
the remote's default branch, so there is no shared history to count
commits against. Rebase onto the default branch and retry:

  git fetch $remote
  git rebase $default_ref

Failing closed rather than skipping the check — the whole point of
this hook is to gate every commit through CI.

EOF
        exit 1
    }
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
