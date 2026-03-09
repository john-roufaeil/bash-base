#!/bin/bash
# Usage: table-mgmt/choose.sh operation

if [[ -z "$CONNECTED_DB" ]]; then
  error "No database selected."
  return 1
fi

info "Type 'back!' to cancel"
tableName=""
while [[ -z "$tableName" ]]; do
  read -r -p "Enter table name: " input
  if [[ "$input" == "back!" ]]; then
    info "Operation cancelled."
    return 1
  elif ! validate_identifier "$input"; then
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
  info "Type 'back!' to cancel"
  printf "\n"
fi