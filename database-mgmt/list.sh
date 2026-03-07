#!/bin/bash
info "Available Databases:"
ls -F "data/" | grep '/' | tr -d '/' | sed 's/^/  - /'