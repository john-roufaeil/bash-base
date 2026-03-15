#!/bin/bash

source database-mgmt/choose.sh "connect"
if [[ $? -ne 0 ]]; then
  return 1
fi

dbname="${DB_INPUT:-$1}"

if [[ -z "$dbname" ]]; then
  error "Usage: connect <database_name>"
  return 1
fi

export CONNECTED_DB="$DB_INPUT"
export CONNECTED_DB_PATH="../data/$CONNECTED_DB"
clear
success "Connected to $CONNECTED_DB"
source menus/db_menu.sh
show_db_menu