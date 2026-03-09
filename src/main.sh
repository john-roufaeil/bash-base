#!/bin/bash

# 1. Environment Setup
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT" || exit 1

# 2. Dependencies
source lib/helpers.sh
source lib/validate.sh

# 3. Handle Flags
case "$1" in
  -t|--test)
    if [[ -f "../tests/run_tests.sh" ]]; then
      info "Running Test Suite..."
      bash ../tests/run_tests.sh
      exit $?
    else
      error "Test runner not found at tests/run_tests.sh"
      exit 1
    fi
    ;;
  -x|--allow-execute)
    info "Setting executable permissions on all .sh files..."
    find "$PROJECT_ROOT" -name "*.sh" -exec chmod +x {} +
    success "Permissions updated. You can now run scripts directly."
    exit 0
    ;;
  -h|--help)
    printf "Usage: ./main.sh [options]"
    printf "Options:"
    printf "  -x, --allow-excute   Allow excute permissions on the scripts"
    printf "  -t, --test           Run the validation test suite"
    printf "  -h, --help           Show this help message"
    exit 0
    ;;
esac

# 4. Environment Check
if [[ ! -x "menus/main_menu.sh" ]]; then
  warn "Permissions are not set for script execution."
  info "Please run: ./main.sh --allow-execute"
  exit 1
fi

# 5. Normal Execution Flow
mkdir -p ../data
clear
info "Welcome to Bash-Base DBMS"

# Load and launch the menu
source menus/main_menu.sh
show_main_menu