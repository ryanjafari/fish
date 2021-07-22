#!/Users/ryanjafari/.local/bin/env /Users/ryanjafari/.local/bin/fish

# set -l host_locl localhost
# set -l port_locl 6001
# set -l host_remo mac-mini-wifi
# set -l port_remo 445
# set -l user_remo ryanjafari
# set -l host_core (get_num_cores $host_remo)

# log4f "Setting up SMB over SSH..."
# log4f "\t\$host_locl: $host_locl"
# log4f "\t\$port_locl: $port_locl"
# log4f "\t\$host_remo: $host_remo"
# log4f "\t\$port_remo: $port_remo"
# log4f "\t\$user_remo: $user_remo"
# log4f "\t\$host_core: $host_core"

# # TODO: trap
# # TODO: env_parallel?
# # TODO: PARALLEL_SSH_* vars

# parallel -S $host_core/mac-mini-wifi.lan echo force {} cpus on server ::: $host_core

# TODO: open_ssh_tunnel_from_to
# parallel -S $SERVER1 echo running on ::: $SERVER1
# parallel ::: "ssh -vvv -N -L $host_locl:$port_locl:$host_remo:$port_remo $user_remo@$host_remo"

# set -l $path scripts
# set -l $strt $path/smb_over_ssh_start.fish

# env_parallel is a shell function that exports
# the current environment to GNU parallel
# SEE: https://bit.ly/3wAf0I3
# env_parallel

# TOOD: stop trying to set vars
# TODO: progress w/ ssh? parallel & progress?
# TODO: null here? count?
# TODO: ssh special cmds ~
# TODO: where is ssh debug output?
# on cmd not found!!! on exit!!!funcs
# parallel ./scripts/smb_over_ssh_{}.fish ::: start
# /opt/homebrew/bin/ssh -tt -vvv -p 22 -N -L localhost:9999:mac-mini-eth.lan:445 ryanjafari@mac-mini-eth-ssh-tun
# /opt/homebrew/bin/ssh -tt -vvv -p 22 -N -L localhost:9999:mac-mini-eth.lan:445 ryanjafari@mac-mini-eth-ssh-tun


# echo "all processes complete"
