log4f --type=i "Loading 📶 network commands..."

# sudo ip route add 172.16.0.0/24 dev br-$(sudo docker network inspect pi-hole_default |jq -r '.[0].Id[0:12]') table lan_routable
# sudo ip route add 172.16.0.0/24 dev br-$(sudo docker network inspect pi-hole_default |jq -r '.[0].Id[0:12]') table wan_routable

# TODO: handle traps sigterm, etc., and cleanup

function net \
    --argument-names argv
    # --inherit-variable $_ \
    # --description ""
    handle_subcommand net $argv
end
funcsave net

function _net_get_port \
    --description "Get a random port."
    log4f --type=n "Getting a random port..."

    # TODO: wipe the linux-specific portion?
    switch $__OS
        case macos
            set --local first (sysctl -n net.inet.ip.portrange.first)
            set --local last (sysctl -n net.inet.ip.portrange.last)
            set --local port

            log4f --type=i "Getting a random port between: \"$first\" and \"$last\"..."

            while true
                set port (shuf -i $first-$last -n 1)
                set --local listeners (get_port_listeners)
                e $listeners | grep --quiet ":$port " || break
            end

            log4f --type=n "Got random port: \"$port\""

            e $port
        case linux
            "$HOME/.config/fish/scripts/bash/get_random_port.bash"
        case '*'
    end
end
funcsave _net_get_port

# TODO: create TCP tunnel
# TODO: use tun interface; see: https://bit.ly/3zPzj6F
# TODO: make as fast as we can with ssh & smb, see: https://bit.ly/373ZI4f
# TODO: remove all passwords!
# TODO: ssh audit...
function _net_open_tunnel \
    --argument-names argv
    set --local func_name (status current-function)

    log4f --type=d "Running function: \"$func_name\"..."

    argparse \
        --stop-nonopt \
        --name _net_open_tunnel \
        "h/host=" "p/port=" "u/user=" "s/success=" \
        -- $argv

    set --local host_locl localhost
    set --local port_locl (net get port)
    set --local host_remo $_flag_host
    set --local port_remo $_flag_port
    # set --local host_core (sys get cores $host_remo) # lazy load?

    log4f --type=n "Opening tunnel between \"$host_locl\":\"$port_locl\" and \"$host_remo\":\"$port_remo\"..."

    set --local ssh_bin (which ssh)

    log4f --type=d "Binary for SSH is: \"$ssh_bin\"..."

    set --local ssh_fwd_lcl "$host_locl:$port_locl"
    set --local ssh_fwd_rem "mac-mini-eth.lan:$port_remo"

    log4f --type=d "Trying to est. tunnel b/w: \"$ssh_fwd_lcl\" <=> \"$ssh_fwd_rem\"..."

    set --local user_remo $_flag_user
    set --local ssh_user_and_host "$user_remo@mac-mini-eth-tun"

    log4f --type=d "Connecting with username: \"$user_remo\" at host: \"mac-mini-eth-tun\"..."

    # TODO: host key alias (%k) and tun/tap interface (%T)?
    set --local local_command_tokens "%n %h %L %l" # TODO: %k ... %T
    set --local success_cmd $_flag_success

    set --local ssh_base_options "-tt -vvv -N" # -vvv -tt -p 22 -f
    set --local ssh_internal_success_cmd "_net_open_tunnel_success $local_command_tokens"
    set --local ssh_user_success_cmd "$success_cmd --port=$port_locl"

    log4f --type=d "Will use these options for SSH:" \
        "Base options: \"$ssh_base_options\"" \
        "LocalCommand: \"$ssh_internal_success_cmd\"" \
        "LocalCommand: \"$ssh_user_success_cmd\""

    set --local ssh_local_cmd "-o LocalCommand=\"$ssh_user_success_cmd\""
    set --local ssh_local_fwd_spec "-L $ssh_fwd_lcl:$ssh_fwd_rem"

    set --local ssh_opt $ssh_base_options
    set --append ssh_opt $ssh_local_cmd
    set --append ssh_opt $ssh_local_fwd_spec

    log4f --type=d "Trying to run command:" \
        "\"$ssh_bin\"" \
        "\"$ssh_base_options\"" \
        "\"$ssh_local_cmd\"" \
        "\"$ssh_local_fwd_spec\"" \
        "\"$ssh_user_and_host\""

    # TODO: if we're successful, bg the shit with `bg` or &
    # TODO: no eval/exec possible?
    # TODO: jobs print
    set --local ssh_cmd $ssh_bin $ssh_opt $ssh_user_and_host

    eval $ssh_cmd # \& &>>"$__LOG4F_PATH/network.log"
end
funcsave _net_open_tunnel

function _net_open_tunnel_success \
    # TODO: host key alias (%k) and tun/tap interface (%T)?
    --argument-names n h L l # TODO: k ... T

    log4f --type=n "Opened tunnel from:" \
        "hostname: \"$n\" at: \"$h\"" \
        "<=>" \
        "hostname: \"$L\" at: \"$l\""

    # TODO: host key alias (%k) and tun/tap interface (%T)?
    # set --local args n h L l # TODO: k ... T
    #
    # for arg in $args
    #     log4f --var $arg
    # end
end
funcsave _net_open_tunnel_success
# alias --save _net-open-tunnel-success _net_open_tunnel_success

function _net_mount_share \
    --argument-names random_local_port
    set --local func_name (status current-function)

    log4f --type=d "Running function: \"$func_name\"..."

    # TODO: explore various ways of setting smb passwords
    set --local user ryanjafari
    set --local pass hashish6agape8linoleum
    set --local host localhost
    set --local port $random_local_port

    log4f --type=n "Mounting share at: \"://$user:*****@$host:$port\"..."

    set --local autofs_share_file /etc/auto_smb
    set --local autofs_share_regex "://[^/]*"
    set --local autofs_share_address "://$user:$pass@$host:$port"

    log4f --type=d "Trying to configure autofs file for automount with sed:" \
        \"(which sed)\" \
        "\"$autofs_share_file\"" \
        "\"$autofs_share_regex\"" \
        "\"://$user:*****@$host:$port\""

    # TODO: separate function
    # TODO: no password
    sudo sed \
        --in-place \
        --follow-symlinks \
        --expression "s|$autofs_share_regex|$autofs_share_address|" \
        $autofs_share_file

    log4f --type=d "Configured autofs file for automount: \"$autofs_share_file\""

    set --local autofs_automount_cmd "sudo automount -vc" # -vcu?

    log4f --type=d "Trying to run command: \"$autofs_automount_cmd\"..."

    # TODO: remove eval/exec?
    eval $autofs_automount_cmd

    # TODO: if successful... log it
end
funcsave _net_mount_share
# alias --save net-mount-share _net_mount_share

function get_local_ip \
    --description "Gets current local IP address."
    ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
end
funcsave get_local_ip

function is_port_used \
    --argument-names port \
    --description "Find out if a port is in use."
    #netstat -tulpn | grep :$port
    ss -tulpn | grep ":$port"
end
funcsave is_port_used

function ports_used \
    --description "Find all ports in use."
    #netstat -tulpn | grep LISTEN
    # TODO: needs fix for macos
    ss -tulpn | grep LISTEN
end
funcsave ports_used

function get_port_listeners \
    --description "Get a list of all processes listening for a connection on a port."
    set -l listeners (lsof -iTCP -sTCP:LISTEN -P -n)
    set -l results $listeners[2..-1]
    #set -l number (count $results)
    # log4f "$number\n"

    # TODO: print line-by-line
    # so this is useful itself
    string collect $results
end
funcsave get_port_listeners

function get_num_port_listeners \
    --description "Gets the number of processes listening on ports."

end
funcsave get_num_port_listeners

# set --local port (get_port_for_process "ssh")
function get_port_for_process \
    --argument-names proc \
    --description "Get the port(s) the given process \$proc is listening on."

    set -l procs (get_port_listeners | grep \
        #--invert-match \
        #--fixed-strings \
        #--no-ignore-case \
        #--only-matching \
        #--initial-tab \
        #--color=always \
        $proc)

    set -l regexp "[^:]+\(LISTEN\)"
    set -l listen (echo $procs | grep \
        --extended-regexp \
        --only-matching \
        $regexp)

    #string collect $listen

    set -l listenx (string collect $listen | sed "s | (LISTEN) || g")

    #string collect $listenx

    set -l s (string collect $listenx | uniq)

    string collect $s

    #string join \n $listen
    #echo {\b$listen}\n

    # string collect $unique
end
funcsave get_port_for_process

# TODO: abbreviation
function open_ssh_tunnel_from_to \
    --argument-names host_locl port_locl host_real port_remo host_ssh \
    --description "Opens an SSH tunnel from a random port on localhost to the specified \$host and \$port."
    # log4f "Setting up SSH tunnel from localhost to $host:$port..."

    # if [ $port_locl = random ]
    #     # log4f "Getting random port for local side of SSH tunnel..."
    #     set port_locl (get_random_port)
    # else
    #     # log4f "Not getting a random port for local side of SSH tunnel"
    #     # log4f "\t$port_local was specified"
    # end

    set -l ssh /opt/homebrew/bin/ssh
    # set -l user_remo ryanjafari
    # set -l tty -tt
    # set -l vvv -vvv
    # set -l prt -p 22
    # set -l cmd_remo ""
    # set -l cmd_remo "/bin/sh -O huponexit -c 'sleep 5'"
    # set -l cmd_remo "/bin/zsh setopt HUP"

    # TODO: do i need to tunnel more ports from smbd to localhost?
    # TODO: more ssh options
    $ssh -tt -vvv -p 22 -N -L localhost:9999:mac-mini-eth.lan:445 ryanjafari@mac-mini-eth-ssh-tun

    # log4f "Setting up SSH tunnel..."
    # log4f "\tusing SSH: $ssh"
    # log4f "\tfrom $host_locl:$port_locl to $host_real:$port_remo"
    # log4f "\twith $user_remo@$host_ssh"
    # log4f "\tby running cmd: $ssh_cmd"

    # set -xU RAND_PORT $port_rand
    # set -xU SSH_JOB ($ssh_cmd)
    # $ssh_cmd

    # log4f "Exported universal environment variables:"
    # log4f "\trandom port \$RAND_PORT: $RAND_PORT"
    # log4f "\tSSH job return code \$SSH_JOB: $SSH_JOB"

    if [ -z "$SSH_JOB" ]
        log4f "Command failed"
    end

    # $status in play
    # log4f "Reached the end!"
    # log4f "Done: open_ssh_tunnel_to $host_ssh $port_smb"
    # echo $rand_port
end
funcsave open_ssh_tunnel_from_to

# TODO: function on_process_exit
# TODO: function on_process_ssh_exit
# TODO: function on_process_sshd_exit
# SEE: https://git.io/JCqM4

# NOTES: for below to-be-defined functions
# sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
# pgrep ssh
# pkill -P PPID # or kill?
# sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

# TODO:
# function flush_ssh
#
# end
# funcsave flush_ssh

# TODO:
# function flush_sshd
#
# end
# funcsave flush_sshd
