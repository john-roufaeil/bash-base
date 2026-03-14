#!/bin/bash
source ./entry-mgmt/find_PK.sh

# Show the row to be deleted
header=$(awk -F'|' '{printf "%s|", $1}' "$CONNECTED_DB_PATH/.$TABLE" | sed 's/|$//')
row=$(awk -v pk="$inputPK" -F'|' '$1 == pk' "$CONNECTED_DB_PATH/$TABLE")

printf "\n"
warn "You are about to delete this row."
(printf "%s\n" "$header"; printf "%s\n" "$row") |
  sed 's/|/\t/g' |
  unescape_string |
  column -t -s $'\t'
printf "\n"

read -r -p "Confirm? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  info "Row deletion cancelled."
  return 1
fi

bypass=true source ./entry-mgmt/delete.sh "$TABLE" "$inputPK"