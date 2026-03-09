#!/bin/bash
targetTable=$1

if [[ "$bypass" != "true" ]]; then
  if [[ -z "$CURRENT_DB" ]]; then
    error "Database context missing."
    return 1
  elif ! validate_identifier "$targetTable"; then
    error "Invalid table identifier."
    return 1
  elif [[ ! -f "$DB_PATH/$targetTable" ]]; then
    error "Table '$targetTable' does not exist."
    return 1
  fi
fi

rm "$DB_PATH/$targetTable"
rm "$DB_PATH/.$targetTable"

success "Table '$targetTable' has been dropped."