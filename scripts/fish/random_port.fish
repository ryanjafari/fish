#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

read lower_port upper_port </proc/sys/net/ipv4/ip_local_port_range

while :
    set PORT (shuf -i $lower_port-$upper_port -n 1)
    ss -lpn | grep -q ":$PORT " || break
end

echo $PORT
