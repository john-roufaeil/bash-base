#!/bin/bash
if [[ -z "$CURRENT_DB" ]]; then
  error "No database selected."
  return 1
fi

source ./table-mgmt/list.sh
printf "\n"

tableName=""
while [[ -z "$tableName" ]]; do
  read -r -p "Enter table name to DROP: " input
  if [[ "$input" == "back!" ]]; then
    return 1
  elif ! validate_identifier "$input"; then
    error "Invalid table identifier."
  elif [[ ! -f "$DB_PATH/$input" ]]; then
    error "Table '$input' does not exist."
  else
    tableName="$input"
  fi
done

warn "WARNING: You are about to permanently delete table '$tableName' and all its data."
read -r -p "Type 'CONFIRM' to proceed: " confirmation

if [[ "$confirmation" != "CONFIRM" ]]; then
  info "Drop cancelled."
  return 0
fi

bypass=true source ./table-mgmt/drop.sh "$tableName"