# TODO: check permissions on and under ~/.config/fish
# TODO: check what files are executable
# TODO: non-exported variables should be lowercase
# TODO: set more env vars with (set --show) and https://bit.ly/3zopgVF
# TODO: completions, see: https://git.io/JB8Gs
# TODO: colorizer
# TODO: fundle & plugins for it?
# TODO: fish in docker under alpine linux
# TODO: auto update plugins
# TODO: https://git.io/JBFF8
# TODO: https://git.io/JJSzo
# TODO: https://git.io/JBFbJ
# TODO: https://git.io/gitnow
# TODO: getopts https://git.io/JBFbE
# TODO: fishtape https://git.io/JBFb6
# TODO: fish-async-prompt https://git.io/JBFNi
# TODO: fish-abbreviation-tips https://git.io/JBFAm

# Allow notifications to be sent on systems without graphical capabilities.
# Note this requires you to also set __done_notification_command.
# SEE: https://git.io/JsqRn
# set -U __done_allow_nongraphical 1

source ~/.config/fish/paths.fish

# Need to load the logger before anything else:
# TODO: glob these
source "$mf_commands_common_path/core/strings.fish"
source "$mf_commands_common_path/core/utility.fish"
source "$mf_commands_common_path/log4f/log4f.fish"

# Get the current OS:
# TODO: move to system (sys)
set --global mf_os (get-os)

sources (glob ~/.config/fish/initializers/* --except os_\*.fish)
source ~/.config/fish/initializers/os_$mf_os.fish

log4f --type=i "Loading 🚸 cross-OS functions..."

source "$mf_commands_common_path/security.fish"
source "$mf_commands_common_path/network.fish"
source "$mf_commands_common_path/kubernetes.fish"

# sources (glob $mf_commands_common_path/*)
# source (which env_parallel.fish)

# Load stuff common to any OS:
source "$mf_fish_path/environment/environment.fish"
source "$mf_fish_path/environment/environment_$mf_os.fish"

source "$mf_fish_path/aliases.fish"

# set --local int
# if [ (is_terminal\?) -eq 0 ]
#     set int interactively
# else
#     set int non-interactively
# end

# TODO: -d/--debug, -i/--info...
# TODO: what happens when --type=i and --var
# log4f --type=i "Setting up 🐟 for $__OS, $int"

# source "$__FSH_PATH/environment/environment_$__OS.fish"
# source "$__FSH_PATH/commands/commands_$__OS.fish"

# set --global --unpath __OS_PATH "$__FNC_PATH/$__OS"

# source "$__OS_PATH/_import.fish"

# log4f --type=i "Done setting up 🐟 for $__OS, $int"

# log4f --var PATH # order preserved i think
# log4f --var (env | sort) # order not important

# function fish_prompt_loading_indicator -a last_prompt
#     echo -n "$last_prompt" | sed -r 's/\x1B\[[0-9;]*[JKmsu]//g' | read -zl uncolored_last_prompt
#     echo -n (set_color brblack)"$uncolored_last_prompt"(set_color normal)
# end
