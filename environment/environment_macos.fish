#!/usr/bin/env fish

printf %b "=> Loading macOS-specific environment variables...\n"

# Blank out Fish greeting:
set -g fish_greeting ""

# Terminal colors & language:
set -x TERM xterm-256color
set -x LANG "en_US.UTF-8"

# TODO: common

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
fish_add_path /opt/homebrew/opt/ssh-copy-id/bin
fish_add_path /opt/homebrew/opt/grep/libexec/gnubin
fish_add_path /opt/homebrew/opt/python/libexec/bin

# SSH Config Editor config:
set -x SSH_AUTH_SOCK "/Users/ryanjafari/Library/Containers/org.hejki.osx.sshce.agent/Data/socket.ssh"

# VS Code as editor when terminal needs one:
set -x EDITOR /usr/local/bin/code

# Setup FISH shell variable for powerline-go:
set -l fish_version (get_version (fish -v))
set -x FISH "🐟$fish_version"
