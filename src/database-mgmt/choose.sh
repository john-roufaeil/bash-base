#!/bin/bash
# Usage: database-mgmt/choose.sh operation

info "Type 'back!' to cancel"
dbName=""
while [[ -z "$dbName" ]]; do
  read -r -p "Enter Database Name: " input
  if [[ "$input" == "back!" ]]; then
    info "Operation cancelled."; return 1
  elif ! validate_identifier "$input"; then
    error "Invalid database identifier."
  elif [[ $1 == "create" && -d "../data/$input" ]]; then
    error "Database '$input' already exists. Try again."
  elif [[ $1 != "create" && ! -d "../data/$input" ]]; then
    error "Database '$input' does not exist. Try again."
  else
    # substitute space for underscore
    dbName="${input// /_}"
  fi
done

export DB_INPUT="$dbName"

if [[ "$1" == "create" || "$1" == "drop" ]]; then
  return 0
elif [[ "$1" == "select" ]]; then
  printf "\n"
  return 0
else
  info "Type 'back!' to cancel"
  printf "\n"
fi