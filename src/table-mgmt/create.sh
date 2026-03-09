#!/bin/bash
targetTable=$1
tableMetadata=$2

if [[ "$bypass" != "true" ]]; then
  if [[ -z "$CONNECTED_DB" ]]; then
    error "Database context missing."
    return 1
  elif ! validate_identifier "$targetTable" || [[ -f "$DB_PATH/$targetTable" ]]; then
    error "Invalid or existing table name."
    return 1
  elif [[ -z "$tableMetadata" ]]; then
    error "Metadata cannot be empty."
    return 1
  fi
  
  while IFS="|" read -r cName cType; do
    if ! validate_identifier "$cName"; then
      error "Invalid column name in metadata."
      return 1
    fi
  done <<< "$tableMetadata"
fi

printf "%s" "$tableMetadata" > "$DB_PATH/.$targetTable"
touch "$DB_PATH/$targetTable"

success "Table '$targetTable' created successfully."