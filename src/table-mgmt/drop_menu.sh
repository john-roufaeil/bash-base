#!/bin/bash
source ./table-mgmt/choose.sh
if [[ $? -ne 0 ]]; then
  return 1
fi

info "Type 'back!' to cancel"
warn "WARNING: You are about to permanently delete table '$TABLE' and all its data."
read -r -p "Type 'CONFIRM' to proceed: " confirmation

if [[ "$confirmation" != "CONFIRM" ]]; then
  info "Table drop cancelled."
  return 0
fi

bypass=true source ./table-mgmt/drop.sh "$TABLE"