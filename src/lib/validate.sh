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

# allowed to use the PK in the table
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
  # If an argument is provided, echo it. 
  # Otherwise, read from stdin (the pipe).
  { [ -n "$1" ] && printf "%s" "$1" || cat; } | 
    sed 's/+/+0/g; s/\\/+1/g; s/|/+2/g; s/"/+3/g'
}

unescape_string() {
  # If an argument is provided, echo it. 
  # If not, it naturally reads from the pipe (stdin).
  { [ -n "$1" ] && echo "$1" || cat; } | sed 's/+3/"/g; s/+2/|/g; s/+1/\\/g; s/+0/+/g'
}

strip_quotes() {
  local val="$1"
  # Remove leading/trailing ' or "
  val="${val#[\"\']}"
  val="${val%[\"\']}"
  printf "%s" "$val"
}

space_to_underscore() {
  printf "%s" "${1// /_}"
}

export -f validate_type
export -f validate_pk
export -f validate_identifier
export -f escape_string
export -f unescape_string
export -f strip_quotes