#!/bin/bash

show_db_menu() {
  PS3="$CURRENT_DB> "
  options=("Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Exit")

  select opt in "${options[@]}"; do
    case $opt in
      "Create Table")
        ;;
      "List Tables")
        ./table-mgmt/list.sh
        ;;
      "Drop Table")
        ;;
      "Insert into Table")
        ./entry-mgmt/insert.sh
        ;;
      "Select From Table")
        ./entry-mgmt/select.sh
        ;;
      "Delete From Table")
        ./entry-mgmt/delete.sh
        ;;
      "Update Table")
        ./entry-mgmt/update.sh
        ;;
      "Exit")
        break
        ;;
      *) 
        error "Invalid option $REPLY"
        ;;
    esac
  done
}