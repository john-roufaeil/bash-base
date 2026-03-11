#!/bin/bash

source ./table-mgmt/choose.sh select
if [[ $? -ne 0 ]]; then
  return 1
fi

header=$(awk -F'|' '{printf "%s|", $1} END{printf ""}' "$CONNECTED_DB_PATH/.$TABLE" | sed 's/|$//')

# Print header + data as an aligned table
# 1. Combine header and table body
# 2. Swap structural '|' to a Tab (\t) so data pipes (\1) don't collide
# 3. Use our existing function to clean the data
# 4. Format based on the Tabs
(printf "%s\n" "$header"; cat "$CONNECTED_DB_PATH/$TABLE") | 
  sed 's/|/\t/g' | unescape_string | column -t -s $'\t'

printf "\n"

return