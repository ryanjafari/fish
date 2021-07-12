function get_random_port --description 'Get a random port.'

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
