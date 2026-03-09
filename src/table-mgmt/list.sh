#!/bin/bash

info "Available tables in database '$CURRENT_DB':"
ls -F "$DB_PATH" | grep -v '/$' | sed 's/^/  - /'