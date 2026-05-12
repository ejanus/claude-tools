#!/usr/bin/env bash
# Tests for scripts/check-single-commit.sh.
#
# Exercises the six pre-push enforcement paths against the live repo:
#   1. Missing env vars                            → exit 2
#   2. 1-commit push (HEAD~1..HEAD)                → exit 0
#   3. 2-commit push (HEAD~2..HEAD)                → exit 1
#   4. ZERO_SHA + unresolvable remote default ref  → exit 1
#   5. ZERO_SHA + valid remote (uses merge-base)   → exit 0 or 1 (probed)
#   6. Invalid rev-list range (bad SHA)            → exit 1
#
# Run via: scripts/tests/test_check_single_commit.sh
# Or:      scripts/tests/run-all.sh

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
HOOK="$REPO_ROOT/scripts/check-single-commit.sh"

PASS=0
FAIL=0
FAILED_NAMES=()

# ---------------------------------------------------------------------
# Assertion helper. Pass the actual exit code and expected code.
# Captures stderr to a tmp file so a failure can show it.
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

# Each test runs in an isolated subshell so env-var unsets don't leak.
run_with_env() {
    local stderr_file="$1"
    shift
    # Run hook with the remaining args as env=value pairs
    env -i HOME="$HOME" PATH="$PATH" "$@" bash "$HOOK" 2> "$stderr_file" > /dev/null
    echo $?
}

echo "Running check-single-commit.sh tests against $REPO_ROOT"
echo

# ---- Test 1: missing env vars ----
stderr=$(mktemp)
code=$(env -i HOME="$HOME" PATH="$PATH" bash "$HOOK" 2> "$stderr" > /dev/null; echo $?)
expect_exit "missing env vars" 2 "$code" "$stderr" "PRE_COMMIT_FROM_REF/TO_REF not set"
rm -f "$stderr"

# ---- Test 2: 1-commit push ----
from=$(git -C "$REPO_ROOT" rev-parse HEAD~1 2>/dev/null || echo "")
to=$(git -C "$REPO_ROOT" rev-parse HEAD 2>/dev/null || echo "")
if [ -n "$from" ] && [ -n "$to" ]; then
    stderr=$(mktemp)
    code=$(run_with_env "$stderr" PRE_COMMIT_FROM_REF="$from" PRE_COMMIT_TO_REF="$to")
    expect_exit "1-commit push" 0 "$code" "$stderr"
    rm -f "$stderr"
else
    echo "  ⏭  1-commit push (skipped — repo has < 2 commits)"
fi

# ---- Test 3: 2-commit push ----
from2=$(git -C "$REPO_ROOT" rev-parse HEAD~2 2>/dev/null || echo "")
if [ -n "$from2" ] && [ -n "$to" ]; then
    stderr=$(mktemp)
    code=$(run_with_env "$stderr" PRE_COMMIT_FROM_REF="$from2" PRE_COMMIT_TO_REF="$to")
    expect_exit "2-commit push" 1 "$code" "$stderr" "2 commits would be pushed"
    rm -f "$stderr"
else
    echo "  ⏭  2-commit push (skipped — repo has < 3 commits)"
fi

# ---- Test 4: ZERO_SHA + unresolvable remote ----
stderr=$(mktemp)
code=$(run_with_env "$stderr" \
    PRE_COMMIT_FROM_REF=0000000000000000000000000000000000000000 \
    PRE_COMMIT_TO_REF="$to" \
    PRE_COMMIT_REMOTE_NAME=nonexistent-test-remote)
expect_exit "ZERO_SHA + invalid remote (fail closed)" 1 "$code" "$stderr" \
    "cannot resolve default branch"
rm -f "$stderr"

# ---- Test 5: ZERO_SHA + valid remote (probe) ----
# Result depends on commits-ahead-of-origin. We accept exit 0 or exit 1
# (both are "hook ran correctly"). What we verify is the script doesn't
# crash or exit 2 (infra error).
if git -C "$REPO_ROOT" symbolic-ref refs/remotes/origin/HEAD > /dev/null 2>&1; then
    stderr=$(mktemp)
    code=$(run_with_env "$stderr" \
        PRE_COMMIT_FROM_REF=0000000000000000000000000000000000000000 \
        PRE_COMMIT_TO_REF="$to")
    if [ "$code" = "0" ] || [ "$code" = "1" ]; then
        PASS=$((PASS+1))
        printf "  ✓ %s (exit %s)\n" "ZERO_SHA + valid remote (probe)" "$code"
    else
        FAIL=$((FAIL+1))
        FAILED_NAMES+=("ZERO_SHA + valid remote")
        printf "  ✗ %s — unexpected exit %s\n" "ZERO_SHA + valid remote (probe)" "$code"
        sed 's/^/      /' "$stderr"
    fi
    rm -f "$stderr"
else
    echo "  ⏭  ZERO_SHA + valid remote (skipped — origin/HEAD not set)"
fi

# ---- Test 6: invalid rev-list range ----
fake_sha="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
stderr=$(mktemp)
code=$(run_with_env "$stderr" PRE_COMMIT_FROM_REF="$fake_sha" PRE_COMMIT_TO_REF="$to")
expect_exit "invalid rev-list range (fail closed)" 1 "$code" "$stderr" \
    "git rev-list --count"
rm -f "$stderr"

# ---- Summary ----
echo
echo "Results: $PASS pass / $FAIL fail"
if [ "$FAIL" -gt 0 ]; then
    echo "Failed tests:"
    printf '  - %s\n' "${FAILED_NAMES[@]}"
    exit 1
fi
exit 0
