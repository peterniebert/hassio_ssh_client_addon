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
    privkey=$(bashio::config 'ssh_private_key')
    echo  $privkey > /root/.ssh/mykey
    servkey=$(bashio::config 'ssh_server_public_key')
    echo  $servkey > /root/.ssh/known_hosts
    chmod 600 /root/.ssh/mykey
    chmod 600 /root/.ssh/known_hosts

    more_args=$(bashio::config 'ssh_more_args')
    server_url=$(bashio::config 'ssh_remote_url')
    server_port=$(bashio::config 'ssh_remote_port')
    while true; do
        bashio::log.info "starting ssh client"
        echo /usr/bin/ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o ExitOnForwardFailure=yes   $more_args $server_url -N -p $server_port -i /root/.ssh/mykey
        sleep 5
    done
}
main "$@"
