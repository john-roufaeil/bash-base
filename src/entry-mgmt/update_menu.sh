#!/bin/bash
source ./table-mgmt/choose.sh
if [[ $? -ne 0 ]]; then
  return 1
fi

if [[ ! -s "$CONNECTED_DB_PATH/$TABLE" ]]; then
  warn "Table is empty. Nothing to update."
	return 1
fi

primaryKey=""
while [[ -z "$primaryKey" ]]; do
	read -r -p "Enter primary key of the row to update: " input
	if [[ "$input" == "back!" ]]; then
		info "Update cancelled."
		return 1
	elif ! validate_pk "$input" "$CONNECTED_DB_PATH/$TABLE"; then
		primaryKey="$input"
	else
		error "Primary key not found."
	fi
done

colNames=()
colTypes=()
while IFS="|" read -r colName colType; do
	colNames+=("$colName")
	colTypes+=("$colType")
done < "$CONNECTED_DB_PATH/.$TABLE"

colChoice=""
while [[ -z "$colChoice" ]]; do
	for i in "${!colNames[@]}"; do printf "%d: %s (%s)\n" "$((i+1))" "${colNames[$i]}" "${colTypes[$i]}"; done
	read -r -p "Choice [1-${#colNames[@]}]: " input
	if [[ "$input" == "back!" ]]; then
		return
	elif [[ "$input" == 1 ]]; then
		error "Primary key cannot be updated."
	elif ! [[ "$input" =~ ^[0-9]+$ ]] || [[ "$input" -lt 1 ]] || [[ "$input" -gt "${#colNames[@]}" ]]; then
		error "Invalid choice."
	else
		colChoice="$input"
	fi
done

newValue=""
while [[ -z "$newValue" ]]; do
	read -r -p "Enter new value: " input
	if [[ "$input" == "back!" ]]; then
		return
	elif validate_type "$input" "${colTypes[$((colChoice-1))]}"; then
		newValue="$input"
	else
		error "Invalid type."
	fi
done

bypass=true source ./entry-mgmt/update.sh "$TABLE" "$primaryKey" "$colChoice" "$newValue"