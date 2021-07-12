#!/usr/bin/env fish

if status is-interactive
    printf %b "=> Loading cross-OS functions...\n"
end

# Docker:

function d-reset \
    --wraps 'd system prune -a' \
    --description 'alias d-reset=d system prune -a'

    printf "=> Resetting docker...\n\n"
    d system prune -a $argv
end

funcsave d-reset

# Kubernetes:

function k-drain \
    --wraps "k drain" \
    --description "shorcut for kubectl drain"

    printf "Draining node ($argv)...\n"

    k drain $argv \
        --ignore-daemonsets="true" \
        --delete-emptydir-data="true" \
        --force="true"
end

funcsave k-drain

function drain_all_nodes \
    --description "Drain all nodes."

    for node in (k get nodes -o name)
        k-drain $node
    end
end

funcsave drain_all_nodes

# Utility:

function trim_whitespace
    sed -i 's/[ \t]*$//' "$argv"
    # TODO: string trim
end

funcsave trim_whitespace

# TODO: progress & parallelize
# SEE: https://bit.ly/3AsuEIV
function search_at_for \
    --argument-names path text \
    --description "Search starting at: \$path for: \$text."

    printf %b "=> Searching starting at: $path for: $text\n"

    sudo grep \
        --with-filename \
        --color="always" \
        --line-number \
        --initial-tab \
        --only-matching \
        --no-messages \
        --binary-files="text" \
        # TODO: difference between "read", "recurse", and "skip"?
        --directories="recurse" \
        --dereference-recursive \
        --exclude-dir="timemachine" \
        --ignore-case \
        --devices="read" \
        --regexp $text \
        $path 2>/dev/null # TODO: 2>&-

    printf %b "=> Done: sudo grep --regexp $text $path\n"
end

funcsave search_at_for

# TODO: try using find?
# TODO: macOS Spotlight CLI? locate database legacy on macOS?
function search_fs_for \
    --argument-names resource \
    --description "Search the filesystem for the given resource (file or folder)."

    # Create/update the locate database:
    # refresh_locatedb

    # Search the locate database for the resource:
    printf %b "=> Searching for resource: $resource\n"
    locate $resource
end

funcsave search_fs_for

# TODO: cron job
function refresh_locatedb \
    --description "Refresh the locate database."

    printf %b "=> Refreshing the locate database...\n"
    printf %b "=> Looking for the \$LOCATE_PATH environment variable...\n"

    # TODO: need quotes around variable?
    if test -n "$LOCATE_PATH"
        printf %b "=> Found the \$LOCATE_PATH environment variable: $LOCATE_PATH\n"
        printf %b "=> Looking for the locate database: $LOCATE_PATH\n"

        if test -e $LOCATE_PATH
            printf %b "=> Found the locate database: $LOCATE_PATH\n"
            _update_locatedb
        else
            printf %b "=> Missing the locate database: $LOCATE_PATH\n"
            _create_locatedb
        end
    else
        printf %b "=> Missing the \$LOCATE_PATH environment variable!\n"
        printf %b "=> Please define the \$LOCATE_PATH! environment variable\n"
        return 1
    end
end

funcsave refresh_locatedb

function _update_locatedb \
    --description="Update the locate database."

    printf %b "=> Updating the locate database: $LOCATE_PATH\n"

    # TODO: do we need separate blocks for each os?
    switch $os
        case macos
            printf %b "=> Updating the macOS locate database: $LOCATE_PATH\n"
            set -l cwd (pwd)
            cd /
            sudo updatedb
            cd $cwd
            printf %b "=> Done: sudo updatedb\n"
        case linux
            printf %b "=> Updating the Linux locate database: $LOCATE_PATH\n"
            sudo updatedb # TODO: or locate -u?
            printf %b "=> Done: sudo updatedb\n"
        case '*'
            printf %b "=> Warning: Unknown OS!\n"
    end
end

funcsave _update_locatedb

function _create_locatedb \
    --description="Create the locate database."

    printf %b "=> Creating the locate database: $LOCATE_PATH\n"

    switch $os
        case macos
            printf %b "=> Creating the macOS locate database: $LOCATE_PATH\n"
            set -l locate_plist "/System/Library/LaunchDaemons/com.apple.locate.plist"
            sudo launchctl load -w $locate_plist
            printf %b "=> Done: sudo launchctl load -w $locate_plist\n"
        case linux
            printf %b "=> Creating the Linux locate database: $LOCATE_PATH\n"
            sudo updatedb # TODO: or locate -u?
            printf %b "=> Done: sudo updatedb\n"
        case '*'
            printf %b "=> Warning: Unknown OS!\n"
    end
end

funcsave _create_locatedb

function get_version \
    --argument-names output \
    --description "Gets a version number from the command output passed as input."

    echo -s $output | sed 's/[^0-9\.]//g'
end

funcsave get_version

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

    # printf %b "=> Getting a random port...\n"

    # TODO: wipe the linux-specific portion?
    switch $os
        case macos
            set -l first (sysctl -n net.inet.ip.portrange.first)
            set -l last (sysctl -n net.inet.ip.portrange.last)
            set -l port -1

            # printf %b "\t...between: $first - $last\n"

            while true
                set port (shuf -i $first-$last -n 1)
                set -l listeners (get_port_listeners)
                echo $listeners | grep --quiet ":$port " || break
            end

            echo $port
        case linux
            $HOME/.config/fish/bash/get_random_port.bash
        case '*'
    end
end

funcsave get_random_port

function get_port_listeners \
    --description "Get a list of all processes listening for a connection on a port."

    set -l listeners (lsof -iTCP -sTCP:LISTEN -P -n | string split "\n")
    set -l results $listeners[2..-1]
    set -l number (count $results)
    # printf %b "$number\n"

    # TODO: print line-by-line
    # so this is useful itself
    echo $results
end

funcsave get_port_listeners

function get_os \
    --description "Get the current OS."

    $HOME/.config/fish/bash/get_os.bash
end

funcsave get_os

function own \
    --argument-names resource \
    --description "Take ownership of a file or folder (and its contents)."

    set -l file (basename $resource)

    printf %b "=> Taking ownership of $file...\n"
    sudo chown -R (id -u):(id -g) $resource
    printf %b "=> Done: sudo chown -R (id -u):(id -g) $file\n"
end

funcsave own

function num_parallel_tasks
    # num_of_cpu * cores_per_cpu * threads_per_core
    set -l cpu_count 1
    set -l core_count (sysctl -n machdep.cpu.core_count)
    set -l thread_count (sysctl -n machdep.cpu.thread_count)
    set -l threads_per_core (math "$thread_count / $core_count")
    set -l tasks_count (math "$cpu_count * $core_count * $threads_per_core")

    echo $tasks_count
end

funcsave num_parallel_tasks

# TODO abbreviation
# function open_ssh_tun_to \
#     --argument-names host port \
#     --description "Opens an SSH tunnel from a random port on localhost to the specified \$host and \$port."

#     set -l rand (get_port)

#     echo ssh -N -L localhost:$rand:$host:$port $host
# end

# funcsave open_ssh_tun_to

# TODO: ssh_perms_fix function
# SEE: https://bit.ly/36cg4XT

# TODO: 'lsof' => https://bit.ly/3hdXpS1
#function get_open_files \
#  --argument-names program \
#  --description "Gets open files for the given program."

#  # TODO: improve this
#  $pid = ps aux | grep $program
#  ls -l /proc/($pid)/fd
#end
#
#funcsave get_open_files
