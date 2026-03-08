#!/bin/bash

# TODO: I didn't add the ability to select with words yet, not sure aobut it
PS_MAIN="DBMS-Main> "

show_main_menu() {
  PS3="$PS_MAIN"
  options=("Create Database" "Drop Database" "List Databases" "Connect to Database" "Exit")
  
  select opt in "${options[@]}"; do
    case $opt in
      "Create Database")
        read -r -p "Enter Database Name: " dbname
        ./database-mgmt/create.sh "$dbname"
        ;;
      "Drop Database")
        read -r -p "Enter Database Name to DROP: " dbname
        ./database-mgmt/drop.sh "$dbname"
        ;;
      "List Databases")
        ./database-mgmt/list.sh
        ;;
      "Connect to Database")
        ./database-mgmt/list.sh
        read -r -p "Enter Database Name: " dbname
        source ./database-mgmt/connect.sh "$dbname"
        ;;
      "Exit")
        info "Goodbye!"
        exit 0
        ;;
      *) 
        error "Invalid option $REPLY"
        ;;
    esac
    PS3="$PS_MAIN"
  done
}