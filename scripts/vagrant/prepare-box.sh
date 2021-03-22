#!/bin/bash

###############################################################################
# Prepare the vagrant box to be packaged into a base box
#

function log {
    echo "[$(date --rfc-3339=seconds)]: $*"
}

function countdown {
    outMsg=" >> ${1}... "
    log "$outMsg"
    for i in {5..1}
    do
        log "$i..."
        sleep 1
    done
    log
}

function remove_dir {
    dir=$1
    log "Removing ${dir}"
    if [ -d ${dir} ]; then
        rm -rf ${dir}
    fi
}

function main {
    ###############################################################################
    # create the .ssh directory and set the required permission
    log "Setting up the .ssh directory"
    mkdir -p /home/vagrant/.ssh
    chmod 0700 /home/vagrant/.ssh
    # get the insecure public key from Vagrant's Git
    log "Getting the Vagrant insecure SSH key into ~/.ssh/authorized_keys"
    wget --no-check-certificate \
        https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
        -O /home/vagrant/.ssh/authorized_keys
    # set permissions
    chmod 0600 /home/vagrant/.ssh/authorized_keys
    # own it
    chown -R vagrant /home/vagrant/.ssh

    ###############################################################################
    # clean vagrant user's home
    remove_dir "/home/vagrant/*build*"
    remove_dir "/home/vagrant/.cache"
    remove_dir "/home/vagrant/.cmake"
    remove_dir "/home/vagrant/.local"
    rm -f "/home/vagrant/.tmux"
    rm -f "/home/vagrant/.wget-hsts"
    # clean root's home
    remove_dir "/home/root/.cache"
    remove_dir "/home/root/.config"
    remove_dir "/home/root/.local"
    rm -f "/home/root/.selected_editor"
    rm -f "/home/root/.wget-hsts"
    # remove logs
    find /var/log -type f -delete

    ###############################################################################
    # clean apt
    log "Cleaning apt"
    apt-get clean

    ###############################################################################
    # write 0 in all empty spaces to get better compression
    log "Zeroing the empty space"
    dd if=/dev/zero of=/EMPTY bs=1M
    rm -f /EMPTY

    ###############################################################################
    # clean bash history 
    countdown "Cleaning bash_history and exit"
    cat /dev/null > ~/.bash_history && history -c && exit
}

main