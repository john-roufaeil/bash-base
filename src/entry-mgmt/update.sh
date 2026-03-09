#!/bin/bash

# 1. Choose table
source ./table-mgmt/choose.sh

if [[ ! -s "$DB_PATH/$TABLE" ]]; then
  warn "Table is empty. Nothing to update."
  return
fi

# input PK
primaryKey=""
while [[ -z "$primaryKey" ]]; do
  read -r -p "Enter primary key of the row to update: " input

  if [[ "$input" == "back!" ]]; then
    warn "Update cancelled. Returning to database menu."
    return 1
  fi

  if ! validate_pk "$input" "$DB_PATH/$TABLE"; then
    primaryKey=$input
  else
    error "Primary key not found. Please try again."
  fi
done

# show columns and select one
colNames=()
colTypes=()
while IFS="|" read -r colName colType; do
  colNames+=("$colName")
  colTypes+=("$colType")
done < "$DB_PATH/.$TABLE"

printf "Select column to edit:\n"
for i in "${!colNames[@]}"; do
  printf "%d: %s (%s)\n" "$((i+1))" "${colNames[$i]}" "${colTypes[$i]}"
done

colChoice=""
while [[ -z "$colChoice" ]]; do
  read -r -p "Choice [1-${#colNames[@]}]: " input
  
  if [[ "$input" == "back!" ]]; then
    warn "Update cancelled. Returning to database menu."
    return
  fi

  if [[ "$input" == 1 ]]; then
    warn "Primary key cannot be updated. Please select a different column."
  elif ! [[ "$input" =~ ^[0-9]+$ ]] || [[ "$input" -lt 1 ]] || [[ "$input" -gt "${#colNames[@]}" ]]; then
    error "Invalid column choice. Please enter a number between 1 and ${#colNames[@]}."
  fi
  colChoice="$input"
done

# input new Value & validate
inputValue=""
while [[ -z "$inputValue" ]]; do
  read -r -p "Enter new value for '${colNames[$((colChoice-1))]}': " inputValue

  if [[ "$inputValue" == "back!" ]]; then
    warn "Update cancelled. Returning to database menu."
    return
  fi

  if ! validate_type "$inputValue" "${colTypes[$((colChoice-1))]}"; then
    error "Invalid value for type '${colTypes[$((colChoice-1))]}'. Please try again."
    inputValue=""
  fi
done

# update row
awk -v pk="$primaryKey" -v col="$colChoice" -v val="$inputValue" -F'|' \
  'BEGIN{OFS=FS} $1==pk {$col=val} {print}' "$DB_PATH/$TABLE" > "$DB_PATH/$TABLE.tmp"
mv "$DB_PATH/$TABLE.tmp" "$DB_PATH/$TABLE"
success "Row with primary key '$primaryKey' updated successfully!"
return