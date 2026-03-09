#!/bin/bash
targetTable=$1
pk=$2

if [[ "$bypass" != "true" ]]; then
  if [[ ! -s "$DB_PATH/$targetTable" ]]; then
    error "Table is empty or missing."
    return 1
  elif validate_pk "$pk" "$DB_PATH/$targetTable"; then
    error "Primary key '$pk' does not exist."
    return 1
  fi
fi

awk -v pk="$pk" -F'|' '$1 != pk {print}' "$DB_PATH/$targetTable" > "$DB_PATH/$targetTable.tmp"
mv "$DB_PATH/$targetTable.tmp" "$DB_PATH/$targetTable"

success "Row with primary key '$pk' deleted successfully!"