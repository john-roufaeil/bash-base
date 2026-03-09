#!/bin/bash
targetTable=$1
pk=$2

if [[ "$bypass" != "true" ]]; then
  if [[ ! -s "$CONNECTED_DB_PATH/$targetTable" ]]; then
    error "Table is empty or missing."
    return 1
  elif validate_pk "$pk" "$CONNECTED_DB_PATH/$targetTable"; then
    error "Primary key '$pk' does not exist."
    return 1
  fi
fi

awk -v pk="$pk" -F'|' '$1 != pk {print}' "$CONNECTED_DB_PATH/$targetTable" > "$CONNECTED_DB_PATH/$targetTable.tmp"
mv "$CONNECTED_DB_PATH/$targetTable.tmp" "$CONNECTED_DB_PATH/$targetTable"

success "Row with primary key '$pk' deleted successfully!"