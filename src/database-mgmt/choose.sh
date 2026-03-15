#!/bin/bash
# Usage: database-mgmt/choose.sh operation

info "Press Ctrl+D to cancel"
dbName=""
while [[ -z "$dbName" ]]; do
  read -r -p "Enter Database Name: " input || { 
    printf "\n"; info "Operation cancelled."; return 1; 
  }
  input=$(space_to_underscore "$input")

  if ! validate_identifier "$input"; then
    error "Invalid database identifier."
  elif [[ $1 == "create" && -d "../data/$input" ]]; then
    error "Database '$input' already exists. Try again."
  elif [[ $1 != "create" && ! -d "../data/$input" ]]; then
    error "Database '$input' does not exist. Try again."
  else
    # substitute space for underscore
    dbName="$input"
  fi
done

export DB_INPUT="$dbName"

if [[ "$1" == "create" || "$1" == "drop" ]]; then
  return 0
elif [[ "$1" == "select" ]]; then
  printf "\n"
  return 0
else
  info "Press Ctrl+D to cancel"
  printf "\n"
fi