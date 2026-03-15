#!/bin/bash
source ./table-mgmt/choose.sh select
if [[ $? -ne 0 ]]; then
  return 1
fi

header=$(awk -F'|' '{printf "%s|", $1} END{printf ""}' "$CONNECTED_DB_PATH/.$TABLE" | sed 's/|$//')

(printf "%s\n" "$header"; cat "$CONNECTED_DB_PATH/$TABLE") | 
  sed 's/|/\t/g' | unescape_string | column -t -s $'\t'
printf "\n"
return
