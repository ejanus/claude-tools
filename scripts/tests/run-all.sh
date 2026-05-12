#!/usr/bin/env bash
# Entry point for the test suite.
#
# Runs every test in scripts/tests/ and reports an aggregate result.
# Exits 0 if all suites pass, 1 if any fails.
#
# Usage:
#   scripts/tests/run-all.sh
#
# Wired into:
#   - .pre-commit-config.yaml (scoped to changes under scripts/)
#   - .github/workflows/prompt-scan.yml (runs in CI)

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OVERALL=0

echo "=========================================="
echo " test_scan_injection.py"
echo "=========================================="
if python3 "$SCRIPT_DIR/test_scan_injection.py"; then
    echo "  → scan-injection: PASS"
else
    echo "  → scan-injection: FAIL"
    OVERALL=1
fi

echo
echo "=========================================="
echo " test_check_single_commit.sh"
echo "=========================================="
if bash "$SCRIPT_DIR/test_check_single_commit.sh"; then
    echo "  → check-single-commit: PASS"
else
    echo "  → check-single-commit: FAIL"
    OVERALL=1
fi

echo
if [ "$OVERALL" = "0" ]; then
    echo "All test suites passed."
else
    echo "One or more test suites failed."
fi

exit "$OVERALL"
