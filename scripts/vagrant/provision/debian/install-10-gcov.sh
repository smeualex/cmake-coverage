#!/usr/bin/env bash
me=`basename "$0"`

function log {
    echo "[$(date --rfc-3339=seconds)] $me: $*"
}

log "Install script started..."

log "Installing lcov..."
apt-get install -y lcov