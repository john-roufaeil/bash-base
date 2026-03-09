#!/bin/bash
source table-mgmt/choose.sh
if [[ $? -ne 0 ]]; then
  return 1
fi

warn "You are about to drop table '$TABLE' and all its data."
read -r -p "Confirm? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  info "Table drop cancelled."
  return 1
fi

bypass=true source ./table-mgmt/drop.sh "$TABLE"