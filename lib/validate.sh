#!/bin/bash

function validate_type() {
  local value="$1"
  local type="$2"

  case "$type" in
    "int")
      [[ "$value" =~ ^-?[0-9]+$ ]] && return 0 || return 1
      ;;
    "float")
      [[ "$value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] && return 0 || return 1
      ;;
    "string")
      [[ -n "$value" ]] && return 0 || return 1
      ;;
    "bool")
      [[ "$value" == "true" || "$value" == "false" ]] && return 0 || return 1
      ;;
    "date")
      [[ "$value" =~ ^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/[0-9]{4}$ ]] && return 0 || return 1
      ;;
    *)
      echo "Unsupported data type: $type"
      exit 1
      ;;
  esac
}