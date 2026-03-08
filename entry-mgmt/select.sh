#!/bin/bash

source lib/helpers.sh
source ./table-mgmt/choose.sh

if [[ -z "$CURRENT_DB" ]]; then
  error "No database selected."
  return 1
fi

if [[ -z "$TABLE" ]]; then
  error "No table selected."
  return 1
fi

if [[ ! -f "$DB_PATH/$TABLE" || ! -f "$DB_PATH/.$TABLE" ]]; then
  error "Table '$TABLE' not found in database '$CURRENT_DB'."
  return 1
fi

clear
success "Viewing table '$TABLE' in database '$CURRENT_DB'\n"

columns=()
while IFS="|" read -r colName; do
    columns+=("$colName")
done < "$DB_PATH/.$TABLE"

# Compute column widths for formatting
# Initialize with column name lengths
colWidths=()
for col in "${columns[@]}"; do
    colWidths+=("${#col}")
done

# Update widths based on data
while IFS="|" read -r -a row; do
    for i in "${!row[@]}"; do
        [[ ${#row[i]} -gt ${colWidths[i]} ]] && colWidths[i]=${#row[i]}
    done
done < "$DB_PATH/$TABLE"

print_separator() {
    for w in "${colWidths[@]}"; do
        printf "+-%-${w}s" "$(printf '%.0s-' $(seq 1 $w))"
    done
    echo "+"
}

# Print header
print_separator
for i in "${!columns[@]}"; do
    printf "| %-${colWidths[i]}s" "${columns[i]}"
done
echo "|"
print_separator

# Print rows
while IFS="|" read -r -a row; do
    for i in "${!columns[@]}"; do
        printf "| %-${colWidths[i]}s" "${row[i]}"
    done
    echo "|"
done < "$DB_PATH/$TABLE"

print_separator

return