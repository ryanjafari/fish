#!/usr/bin/env fish

if status is-interactive
    printf %b "=> Loading cross-OS environment variables...\n"
end

# Set the path to the locate database:
set -x LOCATE_PATH "/var/db/locate.database"

# Get a random port (at the moment for use with SSH tunneling):
set -x RAND_PORT (get_port)

# Setup traffic to go through surge on mac-mini-eth.lan:
set -x https_proxy "http://192.168.3.241:6152"
set -x http_proxy "http://192.168.3.241:6152"
set -x all_proxy "socks5://192.168.3.241:6153"
