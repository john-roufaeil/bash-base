#!/bin/bash
source ./entry-mgmt/find_PK.sh

colNames=()
while IFS="|" read -r colName _; do
	colNames+=("$colName")
done < "$CONNECTED_DB_PATH/.$TABLE"

# Prompt user to choose column(s) to select
colsChoice=""
while [[ -z "$colsChoice" ]]; do
	printf "\nChoose column(s) to select (comma-separated for multiple):\n"
  for i in "${!colNames[@]}"; do printf "%d) %s\n" "$((i+1))" "${colNames[$i]}"; done
	read -r -p "Choice(s): " input || {
		printf "\n"; info "Selection cancelled."; return 1;
	}
  # Validate input format
  if ! [[ "$input" =~ ^[0-9]+(,[0-9]+)*$ ]]; then
    error "Invalid format. Please enter numbers separated by commas."
    continue
  fi
  # Validate each choice is in range
  IFS=',' read -r -a choices <<< "$input"
  for choice in "${choices[@]}"; do
    if [[ "$choice" -lt 1 ]] || [[ "$choice" -gt "${#colNames[@]}" ]]; then
      error "Invalid choice: $choice. Please choose between 1 and ${#colNames[@]}."
      continue 2
    fi
  done
  colsChoice="$input"
done

bypass=true source ./entry-mgmt/select.sh "$inputPK" "$colsChoice"