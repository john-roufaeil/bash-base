#!/bin/bash
source ./table-mgmt/choose.sh
if [[ $? -ne 0 ]]; then
  return 1
fi

if [[ ! -s "$CONNECTED_DB_PATH/$TABLE" ]]; then
  warn "Table is empty. Nothing to delete."
	return 1
fi

pkToDelete=""
while [[ -z "$pkToDelete" ]]; do
	read -r -p "Enter primary key of the row to delete: " input
	if [[ "$input" == "back!" ]]; then
		info "Deletion cancelled."
		return 1
	elif validate_pk "$input" "$CONNECTED_DB_PATH/$TABLE"; then
		error "Primary key not found. Please try again."
	else
		pkToDelete="$input"
	fi
done

# Show the row to be deleted
header=$(awk -F'|' '{printf "%s|", $1}' "$CONNECTED_DB_PATH/.$TABLE" | sed 's/|$//')
row=$(awk -v pk="$pkToDelete" -F'|' '$1 == pk' "$CONNECTED_DB_PATH/$TABLE")

printf "\n"
warn "You are about to delete this row."
(printf "%s\n" "$header"; printf "%s\n" "$row") | column -t -s '|'
printf "\n"

read -r -p "Confirm? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  info "Row deletion cancelled."
  return 1
fi

bypass=true source ./entry-mgmt/delete.sh "$TABLE" "$pkToDelete"