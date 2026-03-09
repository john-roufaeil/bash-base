#!/bin/bash
info "Type 'back!' to cancel"

if [[ -z "$CURRENT_DB" ]]; then
  error "No database selected."
  return 1
fi

tableName=""
while [[ -z "$tableName" ]]; do
  read -r -p "Table Name: " input
    if [[ "$input" == "back!" ]]; then 
      warn "Table creation cancelled"
      return 1;
  elif ! validate_identifier "$input"; then error "Invalid name.";
  elif [[ -f "$DB_PATH/$input" ]]; then error "Table exists.";
  else
    tableName="$input"
  fi
done

colCount=""
while [[ -z "$colCount" ]]; do
  read -r -p "Number of columns: " input
    if [[ "$input" == "back!" ]]; then 
      warn "Table creation cancelled"
      return 1;
  elif [[ "$input" =~ ^[0-9]+$ ]] && [[ "$input" -gt 0 ]]; then
    colCount="$input"
  else
    error "Invalid count. Must be a positive integer."
  fi
done

metadata=""
for (( i=1; i<="$colCount"; i++ )); do
  success "Configuring Column #$i"
  colName=""
  while [[ -z "$colName" ]]; do
    read -p "  Column Name: " input
    if [[ "$input" == "back!" ]]; then 
      warn "Table creation cancelled"
      return 1;
    elif validate_identifier "$input"; then colName="$input";
    else error "  Invalid column name."; fi
  done

  colType=""
  options=("int" "float" "string" "bool" "date" "email")
  while [[ -z "$colType" ]]; do
    echo "  Select Type for '$colName':"
    select opt in "${options[@]}"; do
      if [[ -n "$opt" ]]; then colType="$opt";
      else error "  Invalid choice."; fi
      break
    done
  done
  metadata+="$colName|$colType"$'\n'
done

bypass=true source ./table-mgmt/create.sh "$tableName" "$metadata"