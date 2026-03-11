#!/bin/bash
pk=$1
cols=$2

# Filter selected columns of the header + the matching PK row
filteredHeader=$(cut -d'|' -f1 "$CONNECTED_DB_PATH/.$TABLE" | paste -sd'|' | cut -d'|' -f"$cols")
filteredRow=$(awk -v pk="$pk" -F'|' '$1 == pk' "$CONNECTED_DB_PATH/$TABLE" | cut -d'|' -f"$cols")

printf "\n"
success "Selected from '$TABLE' where PK = '$pk':"
(printf "%s\n" "$filteredHeader"; printf "%s\n" "$filteredRow") |
  sed 's/|/\t/g' |
  unescape_string |
  column -t -s $'\t'
printf "\n"

return 0