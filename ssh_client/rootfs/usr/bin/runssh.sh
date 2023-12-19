#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: SSH Client
#
# ==============================================================================



# ==============================================================================
# RUN LOGIC
# ------------------------------------------------------------------------------
main() {
    export HOME=/root
    bashio::log.info "Install private key from config"
    mkdir -p /root/.ssh
    cp /addons/ssh-client/* /root/.ssh/
    chmod 600 /root/.ssh/*
    privkey=/root/.ssh/$(bashio::config 'ssh_private_key')

    more_args=$(bashio::config 'ssh_more_args')
    server_url=$(bashio::config 'ssh_remote_url')
    server_port=$(bashio::config 'ssh_remote_port')
    bashio::log.info "starting ssh client"
    echo /usr/bin/ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o ExitOnForwardFailure=yes   $more_args $server_url -p $server_port -i /root/.ssh/mykey
    /usr/bin/ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o ExitOnForwardFailure=yes   $more_args $server_url -p $server_port -i /root/.ssh/mykey
}
main "$@"
