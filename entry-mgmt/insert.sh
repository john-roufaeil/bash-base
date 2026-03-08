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
  exit
fi

clear
success "Inserting into table '$TABLE' in database '$CURRENT_DB'\n"

# 2. Construct new entry: read metadata, prompt for input, validate types
newEntry=""

# Outer loop reads metadata file lines
while IFS="|" read -r colName colType; do
  while true; do
    read -r -p "Enter '$colName' ($colType): " value < /dev/tty # Read from terminal
    if validate_type "$value" "$colType"; then
      newEntry+="$value|"
      break
    else
      error "Invalid value for type '$colType'. Please try again."
    fi
  done
done < "$DB_PATH/.$TABLE"

newEntry=$(echo "$newEntry" | sed 's/|$/\n/') # Substitute last pipe with newline


# 3. Append new entry to the table file
existingData=$(cat "$DB_PATH/$TABLE")
echo -n -e "$existingData\n$newEntry" > "$DB_PATH/$TABLE"
success "Entry inserted successfully!"
exit 0