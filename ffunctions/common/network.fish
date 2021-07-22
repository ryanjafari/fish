log4f --type=i "Loading 📶 network functions..."

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

function get_random_port \
    --description "Get a random port."
    log4f "Getting a random port..."

    # TODO: wipe the linux-specific portion?
    switch $__OS
        case macos
            set -l first (sysctl -n net.inet.ip.portrange.first)
            set -l last (sysctl -n net.inet.ip.portrange.last)
            set -l port -1

            log4f "\tbetween: $first - $last"

            while true
                set port (shuf -i $first-$last -n 1)
                set -l listeners (get_port_listeners)
                echo $listeners | grep --quiet ":$port " || break
            end

            log4f "Got random port: $port"

            echo $port
        case linux
            $HOME/.config/fish/scripts/bash/get_random_port.bash
        case '*'
    end
end
funcsave get_random_port

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

    set -l listenx (string collect $listen | sed "s| (LISTEN)||g")

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
