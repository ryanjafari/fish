function get_port_listeners --description 'Get a list of all processes listening for a connection on a port.'

    set -l listeners (lsof -iTCP -sTCP:LISTEN -P -n | string split "\n")
    set -l results $listeners[2..-1]
    set -l number (count $results)
    # printf %b "$number\n"

    # TODO: print line-by-line
    # so this is useful itself
    echo $results
end
