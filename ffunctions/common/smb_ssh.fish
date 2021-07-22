log4f --type=i "Loading 📂 SMB over SSH functions..."

function smb_ssh_init
    # --argument-names name \
    # --description ""
    log4f --type=i "Setting up SMB over SSH..."

    set --local host_locl localhost
    set --local port_locl 6001
    set --local host_remo mac-mini-wifi
    set --local port_remo 445
    set --local user_remo ryanjafari
    set --local host_core (sys get cores $host_remo)

    log4f --var host_locl
    log4f --var port_locl
    log4f --var host_remo
    log4f --var port_remo
    log4f --var user_remo
    log4f --var host_core

    parallel -S $host_core/$host_remo echo force {} cpus on server ::: $host_core
end
funcsave smb_ssh_init

# TODO: trap
# TODO: env_parallel?
# TODO: PARALLEL_SSH_* vars
# TODO: https://git.io/JlX92

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
