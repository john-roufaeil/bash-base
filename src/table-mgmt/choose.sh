#!/bin/bash

source ./table-mgmt/list.sh
read -r -p "Enter table name: " tableName
export TABLE="$tableName"

if [[ -z "$CURRENT_DB" ]]; then
  error "No database selected."
  exit
fi

if [[ -z "$TABLE" ]]; then
  error "No table selected."
  exit
fi

if [[ ! -f "$DB_PATH/$TABLE" || ! -f "$DB_PATH/.$TABLE" ]]; then
  error "Table '$TABLE' not found in database '$CURRENT_DB'."
  return 1
fi

clear
success "Table '$TABLE' in database '$CURRENT_DB'\n"
info "Type 'back!' to cancel\n"
