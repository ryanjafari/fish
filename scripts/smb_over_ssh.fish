#!/usr/bin/env /opt/homebrew/bin/fish
# echo $SSH_AUTH_SOCK
# echo cool
# set -x RAND (get_port)
echo "====> $RAND_PORT"
# TODO: pass variable to config file?
/usr/bin/ssh -vvv mac-mini-eth-ssh-tun
#/usr/bin/ssh -vvv -N -L localhost:$port:mac-mini-eth.lan:445 ryanjafari@mac-mini-eth.lan -p 22 -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes
# TODO: automount unmount time?
sudo automount -vc
