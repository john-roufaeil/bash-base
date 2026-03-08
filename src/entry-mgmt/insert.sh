#!/bin/bash

# 1. Choose table
source ./table-mgmt/choose.sh

# 2. Construct new entry: read metadata, prompt for input, validate types
newEntry=""

# Outer loop reads metadata file lines
while IFS="|" read -r colName colType; do
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
if [[ -z "$existingData" ]]; then
  echo -n -e "$newEntry\n" > "$DB_PATH/$TABLE"
else
  echo -n -e "$existingData\n$newEntry\n" > "$DB_PATH/$TABLE"
fi
success "Entry inserted successfully!"
return
