#!/bin/bash

export RESET='\033[0m'
export GRN='\033[0;32m'
export RED='\033[0;31m'
export YLW='\033[0;33m'
export WHT='\033[0;1m'

# Internal helper: printclr "message" "color_code"
printclr() { printf "${2}* %s ${RESET}\n" "$1"; }

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