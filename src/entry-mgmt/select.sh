#!/bin/bash

source ./table-mgmt/choose.sh select
if [[ $? -ne 0 ]]; then
  return 1
fi

header=$(awk -F'|' '{printf "%s|", $1} END{printf ""}' "$DB_PATH/.$TABLE" | sed 's/|$//')

# Print header + data as an aligned table
(printf "%s\n" "$header"; cat "$DB_PATH/$TABLE") | column -t -s '|'
printf "\n"

return