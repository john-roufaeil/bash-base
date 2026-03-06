#!/bin/bash

# Entry point, main menu loop

source lib/helpers.sh
source lib/validate.sh

info "=== Validate Types ==="
validate_type "42"    "int"    && success "int valid"   || error "int FAIL"
validate_type "3.14"  "float"  && success "float valid" || error "float FAIL"
validate_type "hello" "int"    && error   "should fail" || success "int reject works"
validate_type ""      "string" && error   "should fail" || warn "empty string reject"
validate_type "asdf"      "int" && success   "should fail" || error "int reject works"
info "=== All tests done ==="