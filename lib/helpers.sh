#!/bin/bash

RESET='\033[0m'

success() { printf "\033[0;32m● $1 %s ${RESET}\n" ""; }
error()   { printf "\033[0;31m● $1 %s ${RESET}\n" >&2; }
warn()    { printf "\033[1;33m● $1 %s ${RESET}\n"; }
info()    { printf "\033[1m● $1 %s ${RESET}\n"; }
