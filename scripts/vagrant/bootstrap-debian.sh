#!/usr/bin/env bash
set -e
me=`basename "$0"`

function log {
    echo "[$(date --rfc-3339=seconds)] $me: $*"
}

# Running Install Scripts
SCRIPTS=$(find /vagrant/scripts/vagrant/provision/debian/install-* -type f)
log " >>>>> Running install scripts"
for SCRIPT in ${SCRIPTS}; do
  log
  log
  log
  log "--------------------------------------------"
  SCRIPT_NAME=$(basename ${SCRIPT})
  log "Running ${SCRIPT}"

  ${SCRIPT}

  log "Finished ${SCRIPT}"
  log "--------------------------------------------"
done

log "Adding paths to /etc/profile.d/exports.sh"
echo "# Variables set by Vagrant provisioning script" > /etc/profile.d/exports.sh
echo "# !!! DO NOT EDIT !!!"  >> /etc/profile.d/exports.sh
echo "export PATH=\"/usr/local/sbin:${PATH}\""  >> /etc/profile.d/exports.sh
echo "export LD_LIBRARY_PATH=\"/usr/local/lib:${LD_LIBRARY_PATH}\""  >> /etc/profile.d/exports.sh
