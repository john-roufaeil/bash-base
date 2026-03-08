#!/bin/bash
# shellcheck disable=SC1091

show_db_menu() {
  PS3="$CURRENT_DB> "
  options=("Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Exit")

  select opt in "${options[@]}"; do
    case $opt in
      "Create Table")       source ./table-mgmt/create.sh ;;
      "List Tables")        source ./table-mgmt/list.sh ;;
      "Drop Table")         source ./table-mgmt/drop.sh ;;
      "Insert into Table")  source ./entry-mgmt/insert.sh ;;
      "Select From Table")  source ./entry-mgmt/select.sh ;;
      "Delete From Table")  source ./entry-mgmt/delete.sh ;;
      "Update Table")       source ./entry-mgmt/update.sh ;;
      "Exit")               break ;;
      *)                    error "Invalid option $REPLY" ;;
    esac
    read -r -n 1 -p "Press enter to return to menu"
    clear

    PS3="$CURRENT_DB> "
  done
}