#!/usr/bin/env bash
me=`basename "$0"`

function log {
    echo "[$(date --rfc-3339=seconds)] $me: $*"
}

log "Install script started..."

log "Updating apt..."
apt-get update

log "Installing tmux..."
apt-get install tmux time

log "Install custom tmux configuration file..."
wget "https://raw.githubusercontent.com/smeualex/LinuxScriptsAndConfigs/master/dotfiles/.tmux.conf" -o "/home/vagrant/.tmux.conf"
chown vagrant .tmux.conf
chgrp vagrant .tmux.conf

cat > /home/vagrant/.bash_aliases <<EOF
alias l1='ls -1 --color'
alias ll='ls -la --color'
alias lh='ls -lah --color'
alias grep='egrep --color'
EOF

. /home/vagrant/.bash_aliases 