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
    input=$(space_to_underscore "$input")
    if validate_identifier "$input"; then
      colName="$input"
    else
      error "Invalid column name."
    fi
  done

  # we don't use select because it is infinite by design & need to break 
  colType=""
  while [[ -z "$colType" ]]; do
    printf "  Select Type for '%s': \n" "$colName"
    printf "  1) int  2) float  3) string  4) bool  5) date  6) email\n"
    read -r -p "  Type [1-6]: " input || {
      printf "\n"; info "Table creation cancelled"; return 1
    }
    case "$input" in
      1) colType="int" ;; 2) colType="float" ;; 3) colType="string" ;;
      4) colType="bool" ;; 5) colType="date" ;; 6) colType="email" ;;
      *) error "Invalid choice." ;;
    esac
  done
  metadata+="$colName|$colType"$'\n'
done

bypass=true source ./table-mgmt/create.sh "$TABLE" "$metadata"