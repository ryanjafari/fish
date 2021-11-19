log4f --type=i "Loading 🚸 cross-OS aliases..."

# TODO: You can list alias-created functions by running alias without arguments.
# They must be erased using functions -e.
alias --save kube-vip "docker run --network host --rm plndr/kube-vip:latest"
alias --save k kubectl
alias --save d docker
alias --save cls clear
alias --save v vim
alias --save m micro
alias --save s source
alias --save e "echo -nse" # disable this?
# alias --save as "alias --save --"

# reset fish
alias --save exec-fish "exec fish"
alias --save clear-fish "rm -rf ./functions; and rm -rf ./logs; and rm -rf fish_variables"
alias --save clear-exec-fish "clear-fish; and exec-fish"

# third party
alias --save pjson "jq -S --unbuffered -C"
alias --save imazing iMazing
alias --save code code-insiders
