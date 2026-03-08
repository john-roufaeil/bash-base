#!/bin/bash
# Usage: ./database-mgmt/create.sh <dbname>

dbname="$1"

if [[ -z "$dbname" ]]; then
  error "Usage: create <database_name>"
  exit 1
fi

# substitute space for underscore
dbname="${dbname// /_}"

if ! validate_identifier "$dbname"; then
  error "Database name must be a valid identifier"
  exit 1
fi

if [[ -d "../data/$dbname" ]]; then
  warn "Database '$dbname' already exists."
  exit 1
fi

mkdir -p "../data/$dbname" && success "Database '$dbname' created."
