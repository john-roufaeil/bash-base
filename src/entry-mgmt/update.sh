#!/bin/bash
targetTable=$1
pk=$2
col=$3
val=$4

if [[ "$bypass" != "true" ]]; then
  colCount=$(wc -l < "$CONNECTED_DB_PATH/.$targetTable")
  colType=$(sed -n "${col}p" "$CONNECTED_DB_PATH/.$targetTable" | cut -d'|' -f2)
  
  if [[ ! -f "$CONNECTED_DB_PATH/$targetTable" ]]; then
    error "Table missing."
    return 1
  elif validate_pk "$pk" "$CONNECTED_DB_PATH/$targetTable"; then
    error "PK not found."
    return 1
  elif ! [[ "$col" =~ ^[0-9]+$ ]] || [[ "$col" -lt 1 ]] || [[ "$col" -gt "$colCount" ]]; then
    error "Column out of range."
    return 1
  elif ! validate_type "$val" "$colType" ; then
    error "Type mismatch."
    return 1
  fi
fi

awk -v pk="$pk" -v col="$col" -v val="$(escape_string "$val")" -F'|' 'BEGIN{OFS=FS} $1==pk {$col=val} {print}' "$CONNECTED_DB_PATH/$targetTable" > "$CONNECTED_DB_PATH/$targetTable.tmp"
mv "$CONNECTED_DB_PATH/$targetTable.tmp" "$CONNECTED_DB_PATH/$targetTable"
success "Updated successfully!"