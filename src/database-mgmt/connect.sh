#!/bin/bash

# Note we are using returns here because this is intended to be used with source

dbname="$1"

if [[ -z "$dbname" ]]; then
  error "Usage: connect <database_name>"
  return 1
fi

# substitute space for underscore
dbname="${dbname// /_}"

if ! validate_identifier "$dbname"; then
  error "Database name must be a valid identifier"
  return 1
fi

if [[ ! -d "../data/$dbname" ]]; then
  error "Database '$dbname' not found."
  return 1
fi

export CURRENT_DB="$dbname"
export DB_PATH="../data/$CURRENT_DB"
clear
success "Connected to $dbname"
source menus/db_menu.sh
show_db_menu