#!/bin/bash

# 1. Choose table
source ./table-mgmt/choose.sh

info "Type 'back!' to cancel"
printf "\n"

# 2. Construct new entry: read metadata, prompt for input, validate types
newEntry=""
# Outer loop reads metadata file lines
while IFS="|" read -r colName colType; do
  value=""
  while ! validate_type "$value" "$colType" || ! validate_pk "$value" "$DB_PATH/$TABLE"; do
    read -r -p "Enter '$colName' ($colType) : " value < /dev/tty

    if [[ "$value" == "back!" ]]; then
      warn "Insertion cancelled. Returning to database menu."
      return
    fi

    if ! validate_type "$value" "$colType"; then
      error "Invalid value for type '$colType'. Please try again."
    elif ! validate_pk "$value" "$DB_PATH/$TABLE"; then
      error "Primary key '$value' already exists. Please try again."
    fi
  done
  newEntry+="$value|"
done < "$DB_PATH/.$TABLE"

newEntry=$(printf "%s" "$newEntry" | sed 's/|$/\n/') # Substitute last pipe with newline

# 3. Append new entry to the table file
existingData=$(cat "$DB_PATH/$TABLE")
if [[ -z "$existingData" ]]; then
  printf "%s\n" "$newEntry" > "$DB_PATH/$TABLE"
else
  printf "%s\n" "$existingData" > "$DB_PATH/$TABLE"
  printf "%s\n" "$newEntry" >> "$DB_PATH/$TABLE"
fi
success "Entry inserted successfully!"
return
