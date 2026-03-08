#!/bin/bash
# Usage: ./table-mgmt/choose.sh

./table-mgmt/list.sh
read -r -p "Enter table name: " tableName

export TABLE="$tableName"