#!/bin/bash
source ./table-mgmt/choose.sh
if [[ $? -ne 0 ]]; then
  return 1
fi

newRow=""
colIndex=1
while read -r line; do
  colName=$(echo "$line" | cut -d'|' -f1)
  colType=$(echo "$line" | cut -d'|' -f2)
  validatedVal=""
  while [[ -z "$validatedVal" ]]; do
    read -r -p "Enter $colName ($colType): " input || { 
      printf "\n"; info "Insertion cancelled."; return 1; 
    }
    if ! validate_type "$input" "$colType"; then
		  error "Invalid type.";
    elif [[ "$colIndex" -eq 1 ]] && ! validate_pk "$input" "$CONNECTED_DB_PATH/$TABLE"; then
		  error "PK exists.";
    else
      validatedVal="$input"
    fi

  done < /dev/tty
  newRow+="$validatedVal|"
  ((colIndex++))
done < "$CONNECTED_DB_PATH/.$TABLE"

newRow=$(echo "$newRow" | sed 's/|$//')
bypass=true source ./entry-mgmt/insert.sh "$TABLE" "$newRow"