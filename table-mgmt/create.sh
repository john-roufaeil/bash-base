#!/bin/bash


if [[ -z "$CURRENT_DB" ]]; then
  error "No database selected."
  return 1
fi

info "Creating a new table in '$CURRENT_DB'"
read -r -p "Table Name: " tableName

# 1. Validate Table Name (Prevents path injection like ../../etc/passwd)
if ! validate_identifier "$tableName"; then
  error "Invalid table name. Use letters, numbers, and underscores only (must start with a letter)."
  return 1
fi

if [[ -f "$DB_PATH/$tableName" ]]; then
  error "Table '$tableName' already exists."
  return 1
fi

read -r -p "Number of columns: " colCount
if ! [[ "$colCount" =~ ^[0-9]+$ ]] || [[ "$colCount" -le 0 ]]; then
  error "Invalid number of columns. Must be a positive integer."
  return 1
fi

# 2. Collect Metadata
metadata=""
for (( i=1; i<="$colCount"; i++ )); do
  success "Configuring Column #$i"
  
  read -p "  Column Name: " colName
  if ! validate_identifier "$colName"; then
    error "  Invalid column name. Skipping table creation."
    return 1
  fi

  echo "  Select Type for '$colName':"
  echo "  1) int   2) float   3) string   4) bool   5) date   6) email"
  read -r -p "  Choice [1-6]: " typeChoice
  
  case $typeChoice in
    1) colType="int" ;;
    2) colType="float" ;;
    3) colType="string" ;;
    4) colType="bool" ;;
    5) colType="date" ;;
    6) colType="email" ;;
    *) error "  Invalid choice."; return 1 ;;
  esac

  metadata+="$colName|$colType"$'\n'
done

# 3. Atomic File Creation
# Create hidden metadata first, then the empty data file
printf "%s" "$metadata" > "$DB_PATH/.$tableName"
touch "$DB_PATH/$tableName"

success "Table '$tableName' created successfully."
return 0