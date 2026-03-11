#!/bin/bash
# shellcheck disable=SC1091

PS_DB="$CONNECTED_DB> "

show_db_menu() {
  PS3="$PS_DB"
  options=("Create Table" "List Tables" "Drop Table" "Display Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Back to Main Menu")

  select opt in "${options[@]}"; do
    case $opt in
      "Create Table")       source ./table-mgmt/create_menu.sh ;;
      "List Tables")        source ./table-mgmt/list.sh ;;
      "Drop Table")         source ./table-mgmt/drop_menu.sh ;;
      "Display Table")      source ./table-mgmt/display.sh ;;
      "Insert into Table")  source ./entry-mgmt/insert_menu.sh ;;
      "Select From Table")  source ./entry-mgmt/select_menu.sh ;;
      "Delete From Table")  source ./entry-mgmt/delete_menu.sh ;;
      "Update Table")       source ./entry-mgmt/update_menu.sh ;;
      "Back to Main Menu")  return 0 ;;
      *)                    error "Invalid option $REPLY" ;;
    esac

    read -r -n 1 -p "Press enter to return to menu"
    clear
    PS3="$PS_DB"
  done
}