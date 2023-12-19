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
    echo  $(bashio::config 'ssh_private_key') > /root/.ssh/mykey
    echo  $(bashio::config 'ssh_server_public_key') > /root/.ssh/known_hosts
    chmod 600 /root/.ssh/mykey
    chmod 600 /root/.ssh/known_hosts

    while true; do
        bashio::log.info "starting ssh client"
        /usr/bin/ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o ExitOnForwardFailure=yes   $(bashio::config 'ssh_more_args') $(bashio::config 'ssh_remote_url') -N -p $(bashio::config 'ssh_remote_port') -i /root/.ssh/mykey
    done
}
main "$@"
