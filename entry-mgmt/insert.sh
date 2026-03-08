#!/bin/bash

source lib/helpers.sh
source ./table-mgmt/choose.sh

# 1. Check DB & Table are selected & exist
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
success "Inserting into table '$TABLE' in database '$CURRENT_DB'\n"
info "Type 'back!' to cancel"
printf "\n"
# 2. Construct new entry: read metadata, prompt for input, validate types
newEntry=""

colIdx=0
# Outer loop reads metadata file lines
while IFS="|" read -r colName colType; do
  ((colIdx++))
  while true; do
    read -r -p "Enter '$colName' ($colType) : " value < /dev/tty # Read from terminal
    
    if [[ "$value" == "back!" ]]; then
      warn "Insertion cancelled. Returning to database menu."
      return
    fi

    if ! validate_type "$value" "$colType"; then
      error "Invalid value for type '$colType'. Please try again."
      continue
    fi

    if ! validate_pk "$value" "$DB_PATH/$TABLE"; then
      error "Primary key '$value' already exists. Please try again."
      continue
    fi

    newEntry+="$value|"
    break
  done
done < "$DB_PATH/.$TABLE"

newEntry=$(echo "$newEntry" | sed 's/|$/\n/') # Substitute last pipe with newline


# 3. Append new entry to the table file
existingData=$(cat "$DB_PATH/$TABLE")
echo -n -e "$existingData\n$newEntry\n" > "$DB_PATH/$TABLE"
success "Entry inserted successfully!"
return

