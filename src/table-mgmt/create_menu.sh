#!/bin/bash
source ./table-mgmt/choose.sh create
if [[ $? -ne 0 ]]; then
  return 1
fi

colCount=""
while [[ -z "$colCount" ]]; do
  read -r -p "Number of columns: " input
    if [[ "$input" == "back!" ]]; then 
      info "Table creation cancelled"
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
      info "Table creation cancelled"
      return 1;
    elif validate_identifier "$input"; then colName="$input";
    else error "Invalid column name."; fi
  done

  colType=""
  options=("int" "float" "string" "bool" "date" "email")
  while [[ -z "$colType" ]]; do
    printf "  Select Type for '%s': \n" "$colName"
    select opt in "${options[@]}"; do
      if [[ "$REPLY" == "back!" ]]; then 
        info "Table creation cancelled"
        return 1;
      elif [[ -n "$opt" ]]; then colType="$opt";
      else error "Invalid choice."; fi
      break # What to replace this with?
    done
  done
  metadata+="$colName|$colType"$'\n'
done

bypass=true source ./table-mgmt/create.sh "$TABLE" "$metadata"