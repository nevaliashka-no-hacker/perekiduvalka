#!/bin/bash

# Enhanced Test Suite for s21_cat and s21_grep
# Edge cases and comprehensive testing

PASS=0
FAIL=0
TOTAL=0

# Colors for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo "=============================================="
    echo -e "${YELLOW}$1${NC}"
    echo "=============================================="
}

print_test() {
    TOTAL=$((TOTAL + 1))
    echo -e "${YELLOW}[Test $TOTAL]${NC} $1"
}

print_pass() {
    PASS=$((PASS + 1))
    echo -e "${GREEN}✓ PASS${NC}: $1"
}

print_fail() {
    FAIL=$((FAIL + 1))
    echo -e "${RED}✗ FAIL${NC}: $1"
}

# ============================================================================
# Setup: Compile binaries and prepare test files
# ============================================================================
print_header "SETUP: Building and preparing test files"

PROJECT_DIR="/home/fatimach/C2_SimpleBashUtils.ID_353513-1"
SRC_CAT="${PROJECT_DIR}/src/cat"
SRC_GREP="${PROJECT_DIR}/src/grep"

# Build s21_cat
echo "Building s21_cat..."
cd "$SRC_CAT" && make > /dev/null 2>&1
CAT_BIN="${SRC_CAT}/s21_cat"

# Build s21_grep  
echo "Building s21_grep..."
cd "$SRC_GREP" && make > /dev/null 2>&1
GREP_BIN="${SRC_GREP}/s21_grep"

# Verify binaries exist
if [ ! -f "$CAT_BIN" ] || [ ! -f "$GREP_BIN" ]; then
    echo -e "${RED}Error: build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}Build complete!${NC}"

# Create test files
echo "test content" > /tmp/test_cat_file.txt
echo "line1" > /tmp/test_grep_file.txt
echo "line2" > /tmp/test_grep_file2.txt
echo "line3" > /tmp/test_grep_file3.txt
echo -e "line1\nline2\nline3" > /tmp/test_grep_multi.txt
echo -e "test line with hello world" > /tmp/test_grep_hello.txt
echo "hello" > /tmp/patterns.txt
echo "HELLO" > /tmp/patterns_upper.txt

echo -e "line1\n\nline2\n\nline3" > /tmp/test_empty_lines.txt
echo "" > /tmp/test_one_empty.txt
echo "pattern1" > /tmp/patterns1.txt
echo -e "pattern1\n\npattern2" > /tmp/patterns_empty.txt

# ============================================================================
# s21_cat TESTS
# ============================================================================
print_header "TESTING s21_cat"

# Test 1: basic cat
print_test "cat - basic file output"
"$CAT_BIN" /tmp/test_cat_file.txt > /tmp/my_output.txt
cat /tmp/test_cat_file.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "Basic cat works" || print_fail "Basic cat"

# Test 2: cat -n
print_test "cat -n - line numbering"
echo -e "line1\nline2" > /tmp/test_cat_n.txt
"$CAT_BIN" -n /tmp/test_cat_n.txt > /tmp/my_output.txt
cat -n /tmp/test_cat_n.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-n flag works" || print_fail "-n flag"

# Test 3: cat -b (number non-empty lines)
print_test "cat -b - number non-empty lines"
echo -e "line1\n\nline2" > /tmp/test_cat_b.txt
"$CAT_BIN" -b /tmp/test_cat_b.txt > /tmp/my_output.txt
cat -b /tmp/test_cat_b.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-b flag works" || print_fail "-b flag"

# Test 4: cat -e (show $ at end of line)
print_test "cat -e - show end of lines"
echo "test" > /tmp/test_cat_e.txt
"$CAT_BIN" -e /tmp/test_cat_e.txt > /tmp/my_output.txt
cat -e /tmp/test_cat_e.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-e flag works" || print_fail "-e flag"

# Test 5: cat -s (squeeze blank lines)
print_test "cat -s - squeeze blank lines"
echo -e "line1\n\n\nline2" > /tmp/test_cat_s.txt
"$CAT_BIN" -s /tmp/test_cat_s.txt > /tmp/my_output.txt
cat -s /tmp/test_cat_s.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-s flag works" || print_fail "-s flag"

# Test 6: cat -t (show tabs)
print_test "cat -t - show tabs"
echo -e "line1\tline2" > /tmp/test_cat_t.txt
"$CAT_BIN" -t /tmp/test_cat_t.txt > /tmp/my_output.txt
cat -t /tmp/test_cat_t.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-t flag works" || print_fail "-t flag"

# ============================================================================
# s21_grep TESTS - BASIC
# ============================================================================
print_header "TESTING s21_grep - BASIC FLAGS"

# Test 7: Simple grep
print_test "grep - basic pattern"
"$GREP_BIN" hello /tmp/test_grep_hello.txt > /tmp/my_output.txt
grep hello /tmp/test_grep_hello.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "Basic grep works" || print_fail "Basic grep"

# Test 8: grep -i (case insensitive)
print_test "grep -i - case insensitive"
"$GREP_BIN" -i HELLO /tmp/test_grep_hello.txt > /tmp/my_output.txt
grep -i HELLO /tmp/test_grep_hello.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-i flag works" || print_fail "-i flag"

# Test 9: grep -v (invert match)
print_test "grep -v - invert match"
"$GREP_BIN" -v hello /tmp/test_grep_hello.txt > /tmp/my_output.txt
grep -v hello /tmp/test_grep_hello.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-v flag works" || print_fail "-v flag"

# Test 10: grep -c (count matches)
print_test "grep -c - count matches"
echo -e "hello\nhello\nworld" > /tmp/test_grep_count.txt
"$GREP_BIN" -c hello /tmp/test_grep_count.txt > /tmp/my_output.txt
grep -c hello /tmp/test_grep_count.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-c flag works" || print_fail "-c flag"

# Test 11: grep -l (files with matches)
print_test "grep -l - list files with matches"
"$GREP_BIN" -l hello /tmp/test_grep_hello.txt > /tmp/my_output.txt
grep -l hello /tmp/test_grep_hello.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-l flag works" || print_fail "-l flag"

# Test 12: grep -n (show line numbers)
print_test "grep -n - show line numbers"
"$GREP_BIN" -n hello /tmp/test_grep_hello.txt > /tmp/my_output.txt
grep -n hello /tmp/test_grep_hello.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-n flag works" || print_fail "-n flag"

# ============================================================================
# s21_grep TESTS - PATTERNS
# ============================================================================
print_header "TESTING s21_grep - PATTERN FLAGS"

# Test 13: grep -e (pattern from argument)
print_test "grep -e - pattern from argument"
"$GREP_BIN" -e "hello" /tmp/test_grep_hello.txt > /tmp/my_output.txt
grep -e "hello" /tmp/test_grep_hello.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-e flag works" || print_fail "-e flag"

# Test 14: grep -f (patterns from file)
print_test "grep -f - patterns from file"
"$GREP_BIN" -f /tmp/patterns.txt /tmp/test_grep_hello.txt > /tmp/my_output.txt
grep -f /tmp/patterns.txt /tmp/test_grep_hello.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-f flag works" || print_fail "-f flag"

# Test 15: grep -e -e (multiple patterns)
print_test "grep -e -e - multiple patterns"
echo -e "hello\nworld\ntest" > /tmp/test_grep_multi2.txt
"$GREP_BIN" -e hello -e world /tmp/test_grep_multi2.txt > /tmp/my_output.txt
grep -e hello -e world /tmp/test_grep_multi2.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "Multiple -e works" || print_fail "Multiple -e"

# ============================================================================
# s21_grep EDGE CASES
# ============================================================================
print_header "TESTING s21_grep - EDGE CASES"

# Test 16: -v -c (count non-matching lines)
print_test "grep -v -c - count non-matching lines"
echo -e "hello\nhello\nworld\ntest" > /tmp/test_vc.txt
"$GREP_BIN" -v -c hello /tmp/test_vc.txt > /tmp/my_output.txt
grep -v -c hello /tmp/test_vc.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-v -c combination works" || print_fail "-v -c"

# Test 17: -f with empty lines in pattern file
print_test "grep -f with empty lines in pattern file"
echo -e "hello\n\nworld" > /tmp/patterns_with_empty.txt
echo -e "hello world\ntest line" > /tmp/test_grep_empty.txt
"$GREP_BIN" -f /tmp/patterns_with_empty.txt /tmp/test_grep_empty.txt > /tmp/my_output.txt
grep -f /tmp/patterns_with_empty.txt /tmp/test_grep_empty.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-f with empty patterns works" || print_fail "-f with empty patterns"

# Test 18: -s flag (suppress errors)
print_test "grep -s - suppress file errors"
OUTPUT=$("$GREP_BIN" -s nonexistent hello /tmp/test_grep_hello.txt 2>&1)
[ -z "$OUTPUT" ] && print_pass "-s suppresses errors" || print_fail "-s flag"

# Test 19: Multiple flags combined
print_test "grep -in - multiple flags"
"$GREP_BIN" -in HELLO /tmp/test_grep_hello.txt > /tmp/my_output.txt
grep -in HELLO /tmp/test_grep_hello.txt > /tmp/orig_output.txt
diff /tmp/my_output.txt /tmp/orig_output.txt > /dev/null && print_pass "-in combination works" || print_fail "-in combination"

# Test 20: No matches found
print_test "grep - returns nothing when no match"
echo "hello world" > /tmp/test_no_match.txt
OUTPUT=$("$GREP_BIN" nonexistent /tmp/test_no_match.txt 2>&1)
[ -z "$OUTPUT" ] && print_pass "No match returns empty" || print_fail "No match handling"

# ============================================================================
# SUMMARY
# ============================================================================
print_header "SUMMARY"
echo ""
echo -e "${GREEN}PASSED: ${PASS}${NC}"
echo -e "${RED}FAILED: ${FAIL}${NC}"
echo "TOTAL: $TOTAL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
else
    echo -e "${RED}✗ Some tests failed!${NC}"
fi

# Prevent console from closing - always wait for input
echo ""
echo "=============================================="
echo "Press Enter to exit..."
read
