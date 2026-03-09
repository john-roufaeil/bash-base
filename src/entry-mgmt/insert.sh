#!/bin/bash
targetTable=$1
rowData=$2

if [[ "$bypass" != "true" ]]; then
  IFS='|' read -r -a values <<< "$rowData"
  schemaFile="$CONNECTED_DB_PATH/.$targetTable"
  expectedCols=$(wc -l < "$schemaFile")
  
  if [[ "${#values[@]}" -ne "$expectedCols" ]]; then
    error "Column count mismatch."
    return 1
  elif ! validate_pk "${values[0]}" "$CONNECTED_DB_PATH/$targetTable"; then
    error "PK already exists."
    return 1
  else
    idx=0
    while read -r line; do
      currentType=$(echo "$line" | cut -d'|' -f2)
      if ! validate_type "${values[$idx]}" "$currentType"; then
        error "Type mismatch at col $((idx+1))."
        return 1
      fi
      ((idx++))
    done < "$schemaFile"
  fi
fi

echo "$rowData" >> "$CONNECTED_DB_PATH/$targetTable"
success "Inserted successfully!"