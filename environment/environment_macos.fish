log4f --type=i "Loading 💻 macOS-specific environment variables..."

set --local homebrew /opt/homebrew

# Coding language locations:
# TODO: separate files for each lang?
# TODO: more variables for each lang.
# SEE: https://bit.ly/3e4G5wU
set --export GOPATH "$HOME/go"
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
fish_add_path --prepend "$homebrew/coreutils/libexec/gnubin"
fish_add_path --prepend "$homebrew/gnu-tar/libexec/gnubin"
fish_add_path --prepend "$homebrew/gnu-sed/libexec/gnubin"

# TODO: decide if i need to have these as well
# and if so what order they should be in
fish_add_path --prepend "$homebrew/e2fsprogs/bin"
fish_add_path --prepend "$homebrew/e2fsprogs/sbin"
fish_add_path --prepend "$homebrew/icu4c/bin"
fish_add_path --prepend "$homebrew/icu4c/sbin"
fish_add_path --prepend "$homebrew/libiconv/bin"

# VS Code as editor when terminal needs one:
set --export EDITOR /opt/homebrew/bin/code

# SSH Config Editor.app config:
set --export SSH_AUTH_SOCK "$HOME/Library/Containers/org.hejki.osx.sshce.agent/Data/socket.ssh"
