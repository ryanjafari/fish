log4f --type=i "Loading 💻 macOS-specific environment variables..."

set --local homebrew /opt/homebrew

# Coding language locations:
# TODO: separate files for each lang?
# TODO: more variables for each lang.
# SEE: https://bit.ly/3e4G5wU
set --export GOPATH "$HOME/Code/go"
set --export PYTHON "$homebrew/opt/python/libexec/bin/python"
set --export PERL5LIB "$HOME/perl5"
set --export PERL_ARCH_INSTALL_DIR "$HOME/perl5"
set --export PERL_LIB_INSTALL_DIR "$HOME/perl5"

# Be able to reference our network drives for
# configs & Time Machine backups:
set --export __SYS_ROOT /System/Volumes/Data
# set --export MOUNT_ROOT "$SYS_ROOT/mount"
# set --export U2_ROOT "$MOUNT_ROOT/u2"
# set --export TM_ROOT "$MOUNT_ROOT/tm-ryans-macbook"
# set --export KUBE_CONFIG_ROOT "$U2_ROOT/kube"

# Binaries I'm behind:
fish_add_path --prepend "$HOME/.local/bin"

# Prioritize Homebrew installed binaries in Path:
fish_add_path --prepend "$homebrew/bin"
fish_add_path --prepend "$homebrew/sbin"

set homebrew "$homebrew/opt"

# TODO: loop through all libexecs and add to path?
# TODO: separate file?
# Override $PATH with binaries from Homebrew not
# made available in the above folders due to
# naming collisions:
# fish_add_path --prepend $homebrew/llvm/bin
fish_add_path --prepend "$homebrew/ssh-copy-id/bin"
fish_add_path --prepend "$homebrew/libressl/bin"
fish_add_path --prepend "$homebrew/openssl@1.1/bin"
fish_add_path --prepend "$homebrew/flex/bin"
fish_add_path --prepend "$homebrew/bzip2/bin"
fish_add_path --prepend "$homebrew/unzip/bin"
fish_add_path --prepend "$homebrew/python/libexec/bin"
fish_add_path --prepend "$homebrew/grep/libexec/gnubin"
fish_add_path --prepend "$homebrew/make/libexec/gnubin"
fish_add_path --prepend "$homebrew/gnu-tar/libexec/gnubin"
fish_add_path --prepend "$homebrew/gnu-sed/libexec/gnubin"
fish_add_path --prepend "$homebrew/curl/bin"

# Warning: Putting non-prefixed coreutils in your path can cause GMP builds to fail.
fish_add_path --prepend "$homebrew/coreutils/libexec/gnubin"

# TODO: decide if i need to have these as well
# and if so what order they should be in
fish_add_path --prepend "$homebrew/e2fsprogs/bin"
fish_add_path --prepend "$homebrew/e2fsprogs/sbin"
fish_add_path --prepend "$homebrew/icu4c/bin"
fish_add_path --prepend "$homebrew/icu4c/sbin"
fish_add_path --prepend "$homebrew/libiconv/bin"

# Add iMazing CLI to $PATH:
fish_add_path --prepend "/Applications/iMazing.app/Contents/MacOS"

# VS Code as editor when terminal needs one:
set --export EDITOR /opt/homebrew/bin/code

# SSH Config Editor.app config:
# set --export SSH_AUTH_SOCK "$HOME/Library/Containers/org.hejki.osx.sshce.agent/Data/socket.ssh"

# Secretive.app:
# set --export SSH_AUTH_SOCK "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"

# SeKey.app:
# set --export SSH_AUTH_SOCK "$HOME/.sekey/ssh-agent.ssh"

# TODO: move to common environment variables?
# Set the license key for Cloudflare WARP+ / 1.1.1.1 app:
# TODO: https://bit.ly/3luEoNM, https://git.io/JReiJ
# TODO: https://git.io/JRei0
# TODO: malware block?
set --export WGCF_LICENSE_KEY 25QX1r7B-Lbv6581U-9yE34g2O
and wgcf update --config "$HOME/.wgcf-account.toml"

# log4f --type=i "Setting up 🔑 1Password..."

# set --local op_session_token $OP_SESSION_ploy_and_crit
# set --local op_sign_in_address "ploy-and-crit.1password.com"
# set --local op_account_shorthand ploy_and_crit

# # TODO: make entire debug statements muted gray
# if set --query op_session_token; and [ -n "$op_session_token" ]
#     log4f --type=d "Testing current 1Password session token..."

#     eval (op signin \
#         $op_sign_in_address \
#         --account $op_account_shorthand \
#         --cache \
#         --session $op_session_token)

#     if [ $status -ne 0 ]
#         log4f --type=e "1Password setup failed."
#     else
#         log4f --type=i "1Password setup complete."
#     end
# else
#     log4f --type=e "1Password session token is not defined!"

#     eval (op signin \
#         $op_sign_in_address \
#         --account $op_account_shorthand \
#         --cache)
# end
