#!/bin/bash
# Usage: ./database-mgmt/drop.sh <dbname>

source database-mgmt/choose.sh drop
if [[ $? -ne 0 ]]; then
  return 1
fi

dbname="${DB_INPUT:-$1}"

if [[ -z "$dbname" ]]; then
  error "No database name provided."
  return 1
fi

printf "\n"
warn "You are about to drop database '$dbname'."
read -r -p "Confirm? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  info "Database drop cancelled."
  return 1
fi

rm -rf "../data/$dbname" && success "Database '$dbname' dropped."
