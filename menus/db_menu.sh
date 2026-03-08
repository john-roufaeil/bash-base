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
        source ./entry-mgmt/insert.sh
        read -n 1 -p "Press enter to return to menu"
        clear
        ;;
      "Select From Table")
        source ./entry-mgmt/select.sh
        read -n 1 -p "Press enter to return to menu"
        clear
        ;;
      "Delete From Table")
        source ./entry-mgmt/delete.sh
        read -n 1 -p "Press enter to return to menu"
        clear
        ;;
      "Update Table")
        source ./entry-mgmt/update.sh
        read -n 1 -p "Press enter to return to menu"
        clear
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