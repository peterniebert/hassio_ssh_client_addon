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

    bashio::log.info "Install private key from config"

    echo  $(bashio::config 'ssh_private_key') > /etc/ssh/private_key


    while true; do
        bashio::log.info "starting ssh client"
        /usr/bin/ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o ExitOnForwardFailure=yes   $(bashio::config 'ssh_more_args') $(bashio::config 'ssh_remote_url') -N -p $(bashio::config 'ssh_remote_port') -i /etc/ssh/private_key
    done
}
main "$@"
