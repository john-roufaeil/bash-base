#!/bin/bash
source ./table-mgmt/choose.sh
if [[ $? -ne 0 ]]; then
  return 1
fi

if [[ ! -s "$CONNECTED_DB_PATH/$TABLE" ]]; then
  warn "Table is empty."
	return 1
fi

inputPK=""
while [[ -z "$inputPK" ]]; do
	read -r -p "Enter primary key: " input || {
		printf "\n"; info "Operation cancelled."; return 1;
	}
	if validate_pk "$input" "$CONNECTED_DB_PATH/$TABLE"; then
		error "Primary key not found. Please try again."
	else
		inputPK="$input"
	fi
done