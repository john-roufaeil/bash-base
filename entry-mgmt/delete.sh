#!/bin/bash

source lib/helpers.sh
source ./table-mgmt/choose.sh

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
success "Deleting from table '$TABLE' in database '$CURRENT_DB'\n"
info "Type 'back!' to cancel"
printf "\n"

if [[ ! -s "$DB_PATH/$TABLE" ]]; then
  warn "Table is empty. Nothing to delete."
  return
fi

pkToDelete=""
while true; do
    read -r -p "Enter primary key of the row to delete: " pk < /dev/tty

    # Cancel option
    if [[ "$pk" == "back!" ]]; then
        warn "Deletion cancelled. Returning to database menu."
        return
    fi

    # Check PK exists
    if ! validate_pk "$pk" "$DB_PATH/$TABLE"; then
      pkToDelete=$pk
      break
    else
      error "Primary key not found. Please try again."
      continue
    fi
done

existingData=$(cat "$DB_PATH/$TABLE")
awk -v pk="$pkToDelete" -F'|' '$1 != pk {print}' "$DB_PATH/$TABLE" > "$existingData.tmp"
mv "$existingData.tmp" "$DB_PATH/$TABLE"

success "Row with primary key '$pkToDelete' deleted successfully!"
return
