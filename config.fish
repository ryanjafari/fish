# TODO: check permissions on and under ~/.config/fish
# TODO: check what files are executable
# TODO: non-exported variables should be lowercase
# TODO: set more env vars with (set --show) and https://bit.ly/3zopgVF

# Set the location of our Fish files:
# TODO: --local?
set --global --unpath __FSH_PATH "$HOME/.config/fish"
set --global --unpath __FNC_PATH "$__FSH_PATH/ffunctions"
set --global --unpath __COM_PATH "$__FNC_PATH/common"

# Need to load the logger before anything else:
set --global --unpath __LOG4F_PATH "$__FSH_PATH/logs"
source "$__COM_PATH/strings.fish"
source "$__COM_PATH/utility.fish"
source "$__COM_PATH/log4f/log4f.fish"

# We're going to use a function (get_os) soon, so:
source "$__COM_PATH/_import.fish"

# Load stuff common to any OS:
source "$__FSH_PATH/environment/environment.fish"
source "$__FSH_PATH/aliases.fish"
source "$__FSH_PATH/prompt.fish"

# Get the current OS:
set --global __OS (get_os)

set --local int
if is_terminal
    set int interactively
else
    set int non-interactively
end

# TODO: -d/--debug, -i/--info...
# TODO: what happens when --type=i and --var
log4f --type=i "Setting up 🐟 for $__OS, $int"

source "$__FSH_PATH/environment/environment_$__OS.fish"
source "$__FSH_PATH/commands/commands_$__OS.fish"

log4f --type=i "Done setting up 🐟 for $__OS, $int"

# log4f --var PATH # order preserved i think
# log4f --var (env | sort) # order not important
