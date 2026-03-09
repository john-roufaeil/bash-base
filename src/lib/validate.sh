#!/bin/bash

function validate_type() {
  local value="$1"
  local type="$2"

  case "$type" in
    "int") [[ "$value" =~ ^-?[0-9]+$ ]] ;;
    "float") [[ "$value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] ;;
    "string") [[ -n "$value" ]] ;;
    "bool") [[ "$value" == "true" || "$value" == "false" ]] ;;
    "date") [[ "$value" =~ ^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/[0-9]{4}$ ]] ;;
    "email") [[ "$value" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]] ;;
    *) printf "Unsupported data type: %s" "$type"; return 0 ;;
  esac
}

validate_pk() {
  local value="$1"
  local tablePath="$2"

  if [[ ! -f "$tablePath" ]]; then
    return 0
  fi
  
  while IFS="|" read -r pk _; do
    if [[ "$pk" == "$value" ]]; then
      return 1
    fi
  done < "$tablePath"

  return 0
}

validate_identifier() {
  local id="$1"
  # Only allow letters, numbers, and underscores; must start with a letter
  if [[ "$id" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    return 0
  else
    return 1
  fi
}

escape_string() {
  local input="$1"
  local escaped="$input"

  # 1. Escape the escape character first
  escaped="${escaped//\\/\\\\}"
  # 2. Escape the delimiter ('|' is our DB delimiter)
  escaped="${escaped//|/\\|}"
  # 3. Escape double quotes and dollar signs to prevent shell expansion
  escaped="${escaped//\"/\\\"}"
  escaped="${escaped//\$/\\\$}"
  escaped="${escaped//\`/\\\`}"

  printf "%s" "$escaped"
}

unescape_string() {
  local input="$1"
  # Use printf %b to interpret backslash escapes once
  # clearing the additional escapes added by escape string
  printf "%b" "$input"
}

strip_quotes() {
  local val="$1"
  # Remove leading/trailing ' or "
  val="${val#[\"\']}"
  val="${val%[\"\']}"
  printf "%s" "$val"
}

export -f validate_type
export -f validate_pk
export -f validate_identifier
export -f escape_string
export -f unescape_string
export -f strip_quotes