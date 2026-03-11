#!/bin/bash
source ./entry-mgmt/find_PK.sh

printf "\nChoose the column to update:\n"
colNames=()
colTypes=()
while IFS="|" read -r colName colType; do
	colNames+=("$colName")
	colTypes+=("$colType")
done < "$CONNECTED_DB_PATH/.$TABLE"

colChoice=""
while [[ -z "$colChoice" ]]; do
	for i in "${!colNames[@]}"; do printf "%d: %s (%s)\n" "$((i+1))" "${colNames[$i]}" "${colTypes[$i]}"; done
	read -r -p "Choice [1-${#colNames[@]}]: " input || {
		printf "\n"; info "Update cancelled."; return 1;
	}
	if ! [[ "$input" =~ ^[0-9]+$ ]] || [[ "$input" -lt 1 ]] || [[ "$input" -gt "${#colNames[@]}" ]]; then
		error "Invalid choice."
	else
		colChoice="$input"
	fi
done

newValue=""
while [[ -z "$newValue" ]]; do
	read -r -p "Enter new value: " input || {
		printf "\n"; info "Update cancelled."; return 1;
	}
	if ! validate_type "$input" "${colTypes[$((colChoice-1))]}"; then
		error "Invalid type."
	elif [[ "$colChoice" -eq 1 ]] && ! validate_pk "$input" "$CONNECTED_DB_PATH/$TABLE" && [[ "$input" != "$inputPK" ]]; then
		error "Primary key '$input' already exists."
	else
		newValue="$input"
	fi
done

bypass=true source ./entry-mgmt/update.sh "$TABLE" "$inputPK" "$colChoice" "$newValue"