#!/bin/bash

# Get the absolute path of the directory where main.sh is located
# Note here we went back using ../ before running
PROJECT_ROOT="$(cd ../"$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change the working directory to that root
cd "$PROJECT_ROOT" || exit 1
source lib/helpers.sh
source lib/validate.sh

TEST_CASES="../tests/test_cases.sh"
TEST_META="../tests/test_meta.txt"

passed=0
failed=0

exec 3< <(grep -vE '^\s*(#|$)' "$TEST_CASES")
exec 4< <(grep -vE '^\s*(#|$)' "$TEST_META")

info "=== Starting Test Suite ==="

# Read from FD 3 (commands) and FD 4 (metadata) in parallel
while read -r cmd <&3 && IFS='|' read -r label expected err_msg <&4; do
  
  # 1. Clean up Tabs/Spaces: Use xargs to trim leading/trailing whitespace & tabs
  label=$(printf "%s" "$label" | xargs)
  expected=$(printf "%s" "$expected" | xargs)
  err_msg=$(printf "%s" "$err_msg" | xargs)

  # 2. Execute the command
  # We use a subshell ( ) to prevent 'exit' calls in tests from killing the runner
  ( eval "$cmd" ) > /dev/null 2>&1
  actual_status=$?

  # 3. Logic Check
  if [[ "$expected" == "success" && $actual_status -eq 0 ]] || \
     [[ "$expected" == "fail" && $actual_status -ne 0 ]]; then
    success "[PASS] $label"
    ((passed++))
  else
    error "[FAIL] $label"
    warn "  -> Reason: $err_msg"
    ((failed++))
  fi

done

# Close file descriptors
exec 3<&-
exec 4<&-

printf "--------------------------------"
if [ $failed -eq 0 ]; then
  success "All $passed tests passed!"
else
  info "Tests Completed: $((passed + failed)) | Passed: $passed | Failed: $failed"
fi