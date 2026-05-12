#!/usr/bin/env bash
# Tests for scripts/check-single-commit.sh.
#
# Each git-state test runs the hook against a HERMETIC temporary git
# repo created on the fly. This isolates test outcomes from the
# surrounding repo's history, remote configuration, and CI checkout
# depth (in CI, HEAD is a PR merge commit with non-trivial parent
# geometry that breaks naive HEAD~N assumptions).
#
# Run via: scripts/tests/test_check_single_commit.sh
# Or:      scripts/tests/run-all.sh

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
HOOK="$REPO_ROOT/scripts/check-single-commit.sh"

ZERO_SHA="0000000000000000000000000000000000000000"

PASS=0
FAIL=0
FAILED_NAMES=()

# Tmp paths registered here are removed at exit — covers early-fail
# under `set -e`, where a per-test rm would never run.
TMP_PATHS=()
cleanup() {
    if [ "${#TMP_PATHS[@]}" -gt 0 ]; then
        rm -rf "${TMP_PATHS[@]}" 2>/dev/null || true
    fi
}
trap cleanup EXIT

# ---------------------------------------------------------------------
# Assertion helper.
# ---------------------------------------------------------------------
expect_exit() {
    local name="$1"
    local expected="$2"
    local actual="$3"
    local stderr_file="$4"
    local extra_check="${5:-}"

    if [ "$actual" != "$expected" ]; then
        FAIL=$((FAIL+1))
        FAILED_NAMES+=("$name")
        printf "  ✗ %s — expected exit %s, got %s\n" "$name" "$expected" "$actual"
        if [ -s "$stderr_file" ]; then
            sed 's/^/      /' "$stderr_file"
        fi
        return
    fi

    if [ -n "$extra_check" ] && ! grep -q -- "$extra_check" "$stderr_file"; then
        FAIL=$((FAIL+1))
        FAILED_NAMES+=("$name (missing output)")
        printf "  ✗ %s — exit %s ok but stderr missing %q\n" "$name" "$actual" "$extra_check"
        sed 's/^/      /' "$stderr_file"
        return
    fi

    PASS=$((PASS+1))
    printf "  ✓ %s (exit %s)\n" "$name" "$actual"
}

# ---------------------------------------------------------------------
# Allocate a tmp file path registered for cleanup at script exit.
# ---------------------------------------------------------------------
tmpfile() {
    local f
    f=$(mktemp)
    TMP_PATHS+=("$f")
    echo "$f"
}

# ---------------------------------------------------------------------
# Create a hermetic git repo with N commits on `main` plus a synthetic
# origin/main + origin/HEAD pointing to it. The path is auto-registered
# for cleanup at script exit. Echoes the repo path on stdout.
# ---------------------------------------------------------------------
make_repo() {
    local n="$1"
    local dir
    dir=$(mktemp -d)
    TMP_PATHS+=("$dir")
    git -C "$dir" init -q -b main
    git -C "$dir" config user.email "test@example.com"
    git -C "$dir" config user.name "test"
    git -C "$dir" config commit.gpgsign false 2>/dev/null || true
    local i
    for i in $(seq 1 "$n"); do
        printf '%s\n' "$i" > "$dir/file-$i.txt"
        git -C "$dir" add "file-$i.txt"
        git -C "$dir" commit -q -m "commit $i"
    done
    local sha
    sha=$(git -C "$dir" rev-parse HEAD)
    git -C "$dir" update-ref refs/remotes/origin/main "$sha"
    git -C "$dir" symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
    echo "$dir"
}

# ---------------------------------------------------------------------
# Run the hook inside a given repo with a controlled env. Stdout from
# the hook is discarded; stderr is captured to $stderr_file. Echoes
# the hook's exit code.
# ---------------------------------------------------------------------
run_hook_in() {
    local repo="$1"
    local stderr_file="$2"
    shift 2
    (cd "$repo" && env -i HOME="$HOME" PATH="$PATH" "$@" bash "$HOOK") \
        2> "$stderr_file" > /dev/null
    echo $?
}

echo "Running check-single-commit.sh tests (hermetic)"
echo

# ---- Test 1: missing env vars ----
stderr=$(tmpfile)
code=$(env -i HOME="$HOME" PATH="$PATH" bash "$HOOK" 2> "$stderr" > /dev/null; echo $?)
expect_exit "missing env vars" 2 "$code" "$stderr" "PRE_COMMIT_FROM_REF/TO_REF not set"

# ---- Test 2: 1-commit push ----
repo=$(make_repo 2)
from=$(git -C "$repo" rev-parse HEAD~1)
to=$(git -C "$repo" rev-parse HEAD)
stderr=$(tmpfile)
code=$(run_hook_in "$repo" "$stderr" PRE_COMMIT_FROM_REF="$from" PRE_COMMIT_TO_REF="$to")
expect_exit "1-commit push" 0 "$code" "$stderr"

# ---- Test 3: 2-commit push ----
repo=$(make_repo 3)
from=$(git -C "$repo" rev-parse HEAD~2)
to=$(git -C "$repo" rev-parse HEAD)
stderr=$(tmpfile)
code=$(run_hook_in "$repo" "$stderr" PRE_COMMIT_FROM_REF="$from" PRE_COMMIT_TO_REF="$to")
expect_exit "2-commit push" 1 "$code" "$stderr" "2 commits would be pushed"

# ---- Test 4: ZERO_SHA + unresolvable remote ----
repo=$(make_repo 1)
to=$(git -C "$repo" rev-parse HEAD)
stderr=$(tmpfile)
code=$(run_hook_in "$repo" "$stderr" \
    PRE_COMMIT_FROM_REF="$ZERO_SHA" \
    PRE_COMMIT_TO_REF="$to" \
    PRE_COMMIT_REMOTE_NAME=nonexistent-test-remote)
expect_exit "ZERO_SHA + invalid remote (fail closed)" 1 "$code" "$stderr" \
    "cannot resolve default branch"

# ---- Test 5: ZERO_SHA + valid origin/HEAD, new branch 1 commit ahead ----
repo=$(make_repo 1)
git -C "$repo" checkout -q -b feature
printf 'feature\n' > "$repo/feature.txt"
git -C "$repo" add feature.txt
git -C "$repo" commit -q -m "feature commit"
to=$(git -C "$repo" rev-parse HEAD)
stderr=$(tmpfile)
code=$(run_hook_in "$repo" "$stderr" \
    PRE_COMMIT_FROM_REF="$ZERO_SHA" \
    PRE_COMMIT_TO_REF="$to")
expect_exit "ZERO_SHA + valid remote, 1 commit ahead" 0 "$code" "$stderr"

# ---- Test 6: ZERO_SHA + valid origin/HEAD, new branch 2 commits ahead ----
repo=$(make_repo 1)
git -C "$repo" checkout -q -b feature
for i in 1 2; do
    printf 'feature %s\n' "$i" > "$repo/feature-$i.txt"
    git -C "$repo" add "feature-$i.txt"
    git -C "$repo" commit -q -m "feature commit $i"
done
to=$(git -C "$repo" rev-parse HEAD)
stderr=$(tmpfile)
code=$(run_hook_in "$repo" "$stderr" \
    PRE_COMMIT_FROM_REF="$ZERO_SHA" \
    PRE_COMMIT_TO_REF="$to")
expect_exit "ZERO_SHA + valid remote, 2 commits ahead (blocked)" 1 "$code" "$stderr" \
    "2 commits would be pushed"

# ---- Test 7: invalid rev-list range (bad SHA) ----
repo=$(make_repo 1)
to=$(git -C "$repo" rev-parse HEAD)
fake_sha="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
stderr=$(tmpfile)
code=$(run_hook_in "$repo" "$stderr" \
    PRE_COMMIT_FROM_REF="$fake_sha" PRE_COMMIT_TO_REF="$to")
expect_exit "invalid rev-list range (fail closed)" 1 "$code" "$stderr" \
    "git rev-list --count"

# ---- Summary ----
echo
echo "Results: $PASS pass / $FAIL fail"
if [ "$FAIL" -gt 0 ]; then
    echo "Failed tests:"
    printf '  - %s\n' "${FAILED_NAMES[@]}"
    exit 1
fi
exit 0
