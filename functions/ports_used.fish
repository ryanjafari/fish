function ports_used --description 'Find all ports in use.'

    #netstat -tulpn | grep LISTEN
    # TODO: needs fix for macos
    ss -tulpn | grep LISTEN
end
