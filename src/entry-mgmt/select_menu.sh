#!/bin/bash
source ./entry-mgmt/find_PK.sh
if [[ $? -ne 0 ]]; then
  return 1
fi

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
  else
    # Validate each choice is in range
    IFS=',' read -r -a choices <<< "$input"
    validCount=0
    for choice in "${choices[@]}"; do
      if [[ "$choice" -lt 1 ]] || [[ "$choice" -gt "${#colNames[@]}" ]]; then
        error "Invalid choice: $choice. Please choose between 1 and ${#colNames[@]}."
      else
        ((validCount++))
      fi
    done
    [[ "$validCount" -eq "${#choices[@]}" ]] && colsChoice="$input"
  fi
done

bypass=true source ./entry-mgmt/select.sh "$inputPK" "$colsChoice"