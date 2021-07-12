#!/usr/bin/env fish

if status is-interactive
    printf %b "=> Loading macOS-specific environment variables...\n"
end

# TODO: what are the common env variables?
# TODO: adjust #!/usr/bin/env fish with absolute paths?


# Blank out Fish greeting:
set -g fish_greeting ""

# Terminal colors & language:
set -x TERM xterm-256color
set -x LANG "en_US.UTF-8"

# Coding language locations:
# TODO: separate files for each lang?
# TODO: more variables for each lang.
# SEE: https://bit.ly/3e4G5wU
set -x PYTHON /opt/homebrew/opt/python/libexec/bin/python
set -x GOPATH /opt/homebrew/bin/go
set -x PERL5LIB "$HOME/perl5"
set -x PERL_ARCH_INSTALL_DIR "$HOME/perl5"
set -x PERL_LIB_INSTALL_DIR "$HOME/perl5"

# Be able to reference our network drives for
# configs & Time Machine backups:
set -x MOUNT_ROOT /System/Volumes/Data/mount
set -x TM_ROOT "$MOUNT_ROOT/tm-ryans-macbook"
set -x U2_ROOT "$MOUNT_ROOT/u2"
set -x FISH_CONFIG_ROOT "$U2_ROOT/fish"
#set -x KUBE_CONFIG_ROOT "$U2_ROOT/kube"

# Prioritize Homebrew installed binaries in Path:
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# Override $PATH with binaries from Homebrew not
# made available in the above folders due to
# naming collisions:
# TODO: loop through all libexecs and add to path?
# TODO: separate file?
fish_add_path /opt/homebrew/opt/python/libexec/bin

fish_add_path /opt/homebrew/opt/grep/libexec/gnubin
fish_add_path /opt/homebrew/opt/make/libexec/gnubin
fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
fish_add_path /opt/homebrew/opt/gnu-tar/libexec/gnubin

fish_add_path /opt/homebrew/opt/ssh-copy-id/bin
# fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/opt/libressl/bin
fish_add_path /opt/homebrew/opt/openssl@1.1/bin
fish_add_path /opt/homebrew/opt/flex/bin
fish_add_path /opt/homebrew/opt/bzip2/bin
fish_add_path /opt/homebrew/opt/unzip/bin

# TODO: if i need to have these first in my PATH:
# echo 'fish_add_path /opt/homebrew/opt/e2fsprogs/bin' >>~/.config/fish/config.fish
# echo 'fish_add_path /opt/homebrew/opt/e2fsprogs/sbin' >>~/.config/fish/config.fish
# echo 'fish_add_path /opt/homebrew/opt/icu4c/bin' >>~/.config/fish/config.fish
# echo 'fish_add_path /opt/homebrew/opt/icu4c/sbin' >>~/.config/fish/config.fish
# echo 'fish_add_path /opt/homebrew/opt/libiconv/bin' >>~/.config/fish/config.fish

fish_add_path $HOME/samba/bin

# SSH Config Editor config:
# set -x SSH_AUTH_SOCK "/Users/ryanjafari/Library/Containers/org.hejki.osx.sshce.agent/Data/socket.ssh"

# VS Code as editor when terminal needs one:
set -x EDITOR /opt/homebrew/bin/code

# Setup FISH shell variable for powerline-go:
set -l fish_version (get_version (fish -v))
set -x FISH "🐟$fish_version"
