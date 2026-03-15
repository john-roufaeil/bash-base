#!/bin/bash
# Usage: ./database-mgmt/create.sh <dbname>

source database-mgmt/choose.sh "create"
if [[ $? -ne 0 ]]; then
  return 1
fi

dbname="${DB_INPUT:-$1}"

if [[ -z "$dbname" ]]; then
  error "Usage: create <database_name>"
  return 1
fi

mkdir -p "../data/$dbname" && success "Database '$dbname' created."
