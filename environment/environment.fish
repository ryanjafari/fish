log4f --type=i "Loading 🚸 cross-OS environment variables..."

# Blank out Fish greeting:
set --global fish_greeting ""

# Terminal colors & language:
# TODO: implied --global
# TODO: debug when set variable
set --global --export TERM xterm-256color
set --export LANG "en_US.UTF-8"

# Set the path to the locate database:
set --global --export --unpath LOCATE_PATH "/var/db/locate.database"

# TODO: remember to enable these settings on macOS level:
# Setup traffic to go through surge on mac-mini-eth.lan:
# set --local proxy (true)
# if $proxy
#     set --export https_proxy "http://192.168.3.241:6152"
#     set --export http_proxy "http://192.168.3.241:6152"
#     set --export all_proxy "socks5://192.168.3.241:6153"
# else
#     set --erase https_proxy
#     set --export http_proxy
# end

# Docker CLI Access Token
# Not read by Docker CLI dynamically:
# set --export DOCKER_ACCESS_TOKEN (sec get op-password \
#  --item-uuid="4fq5lm2ufffbvjubhap6ynf5tm" \
#  --password-field="credential")

# Setup FISH shell variable for powerline-go:
# TODO: specify --global when --export
set --global --export MF_FISH_VERSION "🐟$FISH_VERSION"

# who needed this?
set --global --export FISH_CONFIG_ROOT "~/.config/fish"

set --export TALOS_EDITOR "/opt/homebrew/bin/code-insiders --wait"

#fish_add_path --prepend "/opt/homebrew/opt/ccache/libexec"

source $HOME/.config/fish/environment/homebrew.fish

