function is_port_used --description 'Find out if a port is in use.' --argument port

    #netstat -tulpn | grep :$port
    ss -tulpn | grep ":$port"
end
