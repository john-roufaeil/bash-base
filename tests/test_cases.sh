#!/bin/bash

# Data Type Tests
validate_type "123" "int"
validate_type "abc" "int"
validate_type "3.14" "float"
validate_type "true" "bool"

# Identifier Tests
validate_identifier "users_table"
validate_identifier "123_bad_table"

# Escaping Tests
[[ "$(escape_string 'price|$10\"')" == 'price\1$10\0\2' ]]
[[ "$(unescape_string 'price\1$10\0\2' )" == 'price|$10\"' ]]
[[ "$(strip_quotes \"hello\")" == "hello" ]]