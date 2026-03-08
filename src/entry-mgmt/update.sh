#!/bin/bash

# 1. Choose table
source ./table-mgmt/choose.sh

if [[ ! -s "$DB_PATH/$TABLE" ]]; then
  warn "Table is empty. Nothing to update."
  return
fi

# input PK
pkToUpdate=""
while [[ -z "$pkToUpdate" ]]; do
  read -r -p "Enter primary key of the row to update: " pk

  if [[ "$pk" == "back!" ]]; then
    warn "Update cancelled. Returning to database menu."
    return
  fi

  if ! validate_pk "$pk" "$DB_PATH/$TABLE"; then
    pkToUpdate=$pk
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
while ! [[ "$colChoice" =~ ^[0-9]+$ ]] || [[ "$colChoice" -lt 1 ]] || [[ "$colChoice" -gt "${#colNames[@]}" ]]; do
  read -r -p "Choice [1-${#colNames[@]}]: " colChoice
  
  if [[ "$colChoice" == "back!" ]]; then
    warn "Update cancelled. Returning to database menu."
    return
  fi

  if [[ "$colChoice" == 1 ]]; then
    warn "Primary key cannot be updated. Please select a different column."
    colChoice=""
    continue
  fi

  if ! [[ "$colChoice" =~ ^[0-9]+$ ]] || [[ "$colChoice" -lt 1 ]] || [[ "$colChoice" -gt "${#colNames[@]}" ]]; then
    error "Invalid column choice. Please enter a number between 1 and ${#colNames[@]}."
  fi
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
awk -v pk="$pkToUpdate" -v col="$colChoice" -v val="$inputValue" -F'|' \
  'BEGIN{OFS=FS} $1==pk {$col=val} {print}' "$DB_PATH/$TABLE" > "$DB_PATH/$TABLE.tmp"
mv "$DB_PATH/$TABLE.tmp" "$DB_PATH/$TABLE"
success "Row with primary key '$pkToUpdate' updated successfully!"
return