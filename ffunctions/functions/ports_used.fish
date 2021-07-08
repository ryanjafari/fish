function ports_used --description 'Find all ports in use.'

    #netstat -tulpn | grep LISTEN
    ss -tulpn | grep LISTEN
end
