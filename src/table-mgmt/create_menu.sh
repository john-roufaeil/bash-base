#!/bin/bash
source ./table-mgmt/choose.sh create
if [[ $? -ne 0 ]]; then
  return 1
fi

colCount=""
while [[ -z "$colCount" ]]; do
  read -r -p "Number of columns: " input || {
    printf "\n"; info "Table creation cancelled"; return 1;
  }
  if [[ "$input" =~ ^[0-9]+$ ]] && [[ "$input" -gt 0 ]]; then
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
    read -r -p "  Column Name: " input || {
      printf "\n"; info "Table creation cancelled"; return 1;
    }
    if validate_identifier "$input"; then colName="$input";
    else error "Invalid column name."; fi
  done

  colType=""
  options=("int" "float" "string" "bool" "date" "email")
  while [[ -z "$colType" ]]; do
    printf "  Select Type for '%s': \n" "$colName"
    select opt in "${options[@]}"; do
      if [[ -n "$opt" ]]; then colType="$opt";
      else error "Invalid choice."; fi
      break
    done
    # Ctrl+D exits select without setting opt
    if [[ -z "$colType" && -z "$REPLY" ]]; then
      printf "\n"; info "Table creation cancelled"; return 1
    fi
  done
  metadata+="$colName|$colType"$'\n'
done

bypass=true source ./table-mgmt/create.sh "$TABLE" "$metadata"