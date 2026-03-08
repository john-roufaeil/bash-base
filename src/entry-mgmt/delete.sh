#!/bin/bash

source ./table-mgmt/choose.sh

if [[ ! -s "$DB_PATH/$TABLE" ]]; then
  warn "Table is empty. Nothing to delete."
  return
fi

pkToDelete=""
while [[ -z "$pkToDelete" ]]; do
  read -r -p "Enter primary key of the row to delete: " pk

  if [[ "$pk" == "back!" ]]; then
    warn "Deletion cancelled. Returning to database menu."
    return
  fi

  if ! validate_pk "$pk" "$DB_PATH/$TABLE"; then
    pkToDelete=$pk
  else
    error "Primary key not found. Please try again."
  fi
done

existingData=$(cat "$DB_PATH/$TABLE")
awk -v pk="$pkToDelete" -F'|' '$1 != pk {print}' "$DB_PATH/$TABLE" > "$existingData.tmp"
mv "$existingData.tmp" "$DB_PATH/$TABLE"

success "Row with primary key '$pkToDelete' deleted successfully!"
return
