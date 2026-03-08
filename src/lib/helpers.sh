#!/bin/bash

RESET=$'\033[0m'
GRN=$'\033[0;32m'
RED=$'\033[0;31m'
YLW=$'\033[0;33m'
WHT=$'\033[0;1m'

# Internal helper: printclr "message" "color_code"
printclr() { printf "%s* %s %s\n" "$2" "$1" "$RESET"; }

# Wrappers
success() { printclr "$1" "$GRN"; }
warn()    { printclr "$1" "$YLW"; }
info()    { printclr "$1" "$WHT"; }
error()   { printclr "$1" "$RED" >&2; }

export -f printclr
export -f success
export -f warn
export -f info
export -f error