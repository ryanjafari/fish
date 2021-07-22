#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

printf "=> Resetting ip(6)tables...\n"

# TODO: convert to iptables-nft

# Clear iptables rules:

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

# Clear ip6tables rules:

ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -t nat -F
ip6tables -t mangle -F
ip6tables -F
ip6tables -X

printf "=> Done.\n"

printf "=> Resetting ipvs...\n"
ipvsadm --clear
printf "=> Done.\n"
