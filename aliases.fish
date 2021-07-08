#!/usr/bin/env fish

printf %b "=> Loading cross-OS aliases...\n"

alias --save kube-vip="docker run --network host --rm plndr/kube-vip:latest"
alias --save k="kubectl"
alias --save d="docker"
alias --save cls="clear"
alias --save v="vim"
alias --save m="micro"
alias --save s="source"
