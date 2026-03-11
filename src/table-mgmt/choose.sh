#!/bin/bash
# Usage: table-mgmt/choose.sh operation

if [[ -z "$CONNECTED_DB" ]]; then
  error "No database selected."
  return 1
fi

info "Press Ctrl+D to cancel"
tableName=""
while [[ -z "$tableName" ]]; do
  read -r -p "Enter table name: " input || {
    printf "\n"; info "Operation cancelled."; return 1;
  }

  input=$(space_to_underscore "$input")

  if ! validate_identifier "$input"; then
    error "Invalid table identifier."
  elif [[ $1 == "create" && (-f "$CONNECTED_DB_PATH/$input" || -f "$CONNECTED_DB_PATH/.$input") ]]; then
    error "Table '$input' already exists. Try again."
  elif [[ $1 != "create" && (! -f "$CONNECTED_DB_PATH/$input" || ! -f "$CONNECTED_DB_PATH/.$input") ]]; then
    error "Table '$input' does not exist. Try again."
  else
    tableName="$input"
  fi
done

export TABLE="$tableName"
clear
success "Table '$TABLE' in database '$CONNECTED_DB'"

if [[ "$1" == "select" ]]; then
  printf "\n"
  return 0
else
  info "Press Ctrl+D to cancel"
  printf "\n"
fi