#!/usr/bin/env bash
me=`basename "$0"`

function log {
    echo "[$(date --rfc-3339=seconds)] $me: $*"
}

log "Cleaning up ..."
