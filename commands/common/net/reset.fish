#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

function _net_reset_iptables
    # candidates to reload:
    # ip6tables
    # iptables
    # ipvsadm

    # TODO: convert to iptables-nft

    log4f --type=n "Resetting iptables..."
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -t nat -F
    iptables -t mangle -F
    iptables -F
    iptables -X

    log4f --type=n "Resetting ip6tables..."
    ip6tables -P INPUT ACCEPT
    ip6tables -P FORWARD ACCEPT
    ip6tables -P OUTPUT ACCEPT
    ip6tables -t nat -F
    ip6tables -t mangle -F
    ip6tables -F
    ip6tables -X

    log4f --type=n "Resetting ipvs..."
    ipvsadm --clear
end
funcsave _net_reset_iptables
