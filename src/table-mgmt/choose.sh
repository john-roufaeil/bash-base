#!/bin/bash
# Usage: table-mgmt/choose.sh operation

if [[ -z "$CURRENT_DB" ]]; then
  error "No database selected."
  exit
fi

info "Type 'back!' to cancel"
tableName=""
while [[ -z "$tableName" ]]; do
  read -r -p "Enter table name: " input
  if [[ "$input" == "back!" ]]; then
    warn "Operation cancelled."
    return 1
  elif ! validate_identifier "$input"; then
    error "Invalid table identifier."
  elif [[ ! -f "$DB_PATH/$input" || ! -f "$DB_PATH/.$input" ]]; then
    error "Table '$input' does not exist. Try again."
  else
    tableName="$input"
  fi
done

export TABLE="$tableName"
clear
success "Table '$TABLE' in database '$CURRENT_DB'"

if [[ "$1" == "select" ]]; then
  printf "\n"
  return 0
else
  info "Type 'back!' to cancel"
  printf "\n"
fi