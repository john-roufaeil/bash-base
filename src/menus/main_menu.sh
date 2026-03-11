#!/bin/bash

PS_DBMS="bash-base> "

show_main_menu() {
  info "Welcome to Bash-Base DBMS"
  options=("Create Database" "Drop Database" "List Databases" "Connect to Database" "Exit")
  printf "\n"
  PS3="$PS_DBMS"
  
  select opt in "${options[@]}"; do
    case $opt in
      "Create Database")      source ./database-mgmt/create.sh ;;
      "Drop Database")        source ./database-mgmt/drop.sh ;;
      "List Databases")       source ./database-mgmt/list.sh ;;
      "Connect to Database")  source ./database-mgmt/connect.sh ;;
      "Exit")                 info "Goodbye!" ; exit 0 ;;
      *)                      error "Invalid option $REPLY" ;;
    esac

    read -r -n 1 -p "Press enter to return to menu"
    clear
    PS3="$PS_DBMS"
  done
}