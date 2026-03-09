#!/bin/bash

if [[ -z "$CURRENT_DB" ]]; then
  error "No database selected."
  return 1
fi

# List tables so the user knows what they can drop
./table-mgmt/list.sh
printf "\n"
read -r -p "Enter table name to DROP: " tableName

# 1. Prevent Command/Path Injection
if ! validate_identifier "$tableName"; then
  error "Invalid table identifier."
  return 1
fi

# 2. Check Existence
if [[ ! -f "$DB_PATH/$tableName" ]]; then
  error "Table '$tableName' does not exist."
  return 1
fi

# 3. Confirmation Prompt
warn "WARNING: You are about to permanently delete table '$tableName' and all its data."
read -r -p "Type 'CONFIRM' to proceed: " confirmation

if [[ "$confirmation" != "CONFIRM" ]]; then
  info "Drop cancelled."
  return 0
fi

# 4. Secure Deletion
# Only delete the specific files within the DB_PATH
rm "$DB_PATH/$tableName"
rm "$DB_PATH/.$tableName"

success "Table '$tableName' has been dropped."
return 0