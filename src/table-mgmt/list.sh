#!/bin/bash

info "Available tables in database '$CONNECTED_DB':"
ls -F "$CONNECTED_DB_PATH" | grep -v '/$' | sed 's/^/  - /'