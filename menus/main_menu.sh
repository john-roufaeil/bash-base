#!/bin/bash

# TODO: I didn't add the ability to select with words yet, not sure aobut it

show_main_menu() {
	PS3="DBMS-Main> "
	options=("Create Database" "Drop Database" "List Databases" "Connect to Database" "Exit")

	select opt in "${options[@]}"; do
		case $opt in
			"Create Database")
				read -p -r "Enter Database Name: " dbname
				./database-mgmt/create.sh "$dbname"
				;;
			"Drop Database")
				read -p -r "Enter Database Name to DROP: " dbname
				./database-mgmt/drop.sh "$dbname"
				;;
			"List Databases")
				./database-mgmt/list.sh
				;;
			"Connect to Database")
				read -p  -r "Enter Database Name: " dbname
				# source is important to pass context
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
	done
}