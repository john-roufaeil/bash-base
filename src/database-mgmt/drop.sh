#!/bin/bash
# Usage: ./database-mgmt/drop.sh <dbname>

dbname="$1"

if [[ -z "$dbname" ]]; then
  error "No database name provided."
  exit 1
fi

# substitute space for underscore
dbname="${dbname// /_}"

if ! validate_identifier "$dbname"; then
  error "Not a valid identifier"
  exit 1
fi

if [[ ! -d "../data/$dbname" ]]; then
  error "Database '$dbname' does not exist."
  exit 1
fi

rm -rf "../data/$dbname" && success "Database '$dbname' deleted."
