#!/bin/bash

if [[ $# -ne 1 ]]; then
  printf "Insertion error.\nUsage: %s <database_name>\n" "$0"
  exit 1
fi
databaseName=$1

# Choose table to insert into
counter=1
tableNames=$(ls) # Placeholder: replace with actual command to list tables in the database
clear
printf "Available tables in database '%s':\n" "$databaseName"
for table in $tableNames; do
  printf "%i) %s\n" "$counter" "$table"
  ((counter++))
done

printf "\n"
read -p "Please choose a table to insert data into: " tableName

# Fetch metadata for the chosen table
# Loop through columns, prompt for input & validate
# Insert data into the table