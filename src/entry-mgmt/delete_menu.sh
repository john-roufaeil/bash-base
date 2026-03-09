#!/bin/bash
source ./table-mgmt/choose.sh

if [[ ! -s "$DB_PATH/$TABLE" ]]; then
  warn "Table is empty. Nothing to delete."
	return 1
fi

pkToDelete=""
while [[ -z "$pkToDelete" ]]; do
	read -r -p "Enter primary key of the row to delete: " input
	if [[ "$input" == "back!" ]]; then
		warn "Deletion cancelled."
		return 1
	elif validate_pk "$input" "$DB_PATH/$TABLE"; then
		error "Primary key not found. Please try again."
	else
		pkToDelete="$input"
	fi
done

bypass=true source ./entry-mgmt/delete.sh "$TABLE" "$pkToDelete"