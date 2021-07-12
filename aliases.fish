#!/usr/bin/env fish

if status is-interactive
    printf %b "=> Loading cross-OS aliases...\n"
end

alias --save kube-vip="docker run --network host --rm plndr/kube-vip:latest"
alias --save k="kubectl"
alias --save d="docker"
alias --save cls="clear"
alias --save v="vim"
alias --save m="micro"
alias --save s="source"
alias --save get_port="get_random_port"
