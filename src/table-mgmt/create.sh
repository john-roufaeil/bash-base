#!/bin/bash

info "Type 'back!' to cancel"
printf "\n"

if [[ -z "$CURRENT_DB" ]]; then
  error "No database selected."
  return 1
fi

info "Creating a new table in '$CURRENT_DB'"


# 1. Validate Table Name
tableName=""
while [[ -z "$tableName" ]]; do
  read -r -p "Table Name: " input
  [[ "$input" == "back!" ]] && return
  
  if ! validate_identifier "$input"; then
    error "Invalid name. Use letters, numbers, and underscores (start with a letter)."
  elif [[ -f "$DB_PATH/$input" ]]; then
    error "Table '$input' already exists."
  else
    tableName="$input"
  fi
done

# 2. Validate Column Count
colCount=""
while [[ -z "$colCount" ]]; do
  read -r -p "Number of columns: " input
  [[ "$input" == "back!" ]] && return
  
  if [[ "$input" =~ ^[0-9]+$ ]] && [[ "$input" -gt 0 ]]; then
    colCount="$input"
  else
    error "Invalid count. Must be a positive integer."
  fi
done

# 3. Collect Metadata
metadata=""
for (( i=1; i<="$colCount"; i++ )); do
  success "Configuring Column #$i"
  
  colName=""
  while [[ -z "$colName" ]]; do
    read -p "  Column Name: " input
    [[ "$input" == "back!" ]] && return
    
    if validate_identifier "$input"; then
      colName="$input"
    else
      error "  Invalid column name."
    fi
  done

  colType=""
  printf "  Select Type for '%s':\n" "$colName"
  PS3="  Choice [1-6]: "
  options=("int" "float" "string" "bool" "date" "email")
  
  while [[ -z "$colType" ]]; do
    select opt in "${options[@]}"; do
      if [[ -n "$opt" ]]; then
        colType="$opt"
      else
        error "  Invalid choice."
      fi
      break
    done
  done
  
  metadata+="$colName|$colType"$'\n'
done

# 4. Atomic File Creation
printf "%s" "$metadata" > "$DB_PATH/.$tableName"
touch "$DB_PATH/$tableName"

success "Table '$tableName' created successfully."
return 0