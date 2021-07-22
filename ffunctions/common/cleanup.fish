log4f --type=i "Loading 🧽 cleanup functions..."

function clear_fish_vars \
    --description "Wipes out all set variables (Fish and otherwise)."
    # TODO: collect vars seperately
    # set -l locls (set --local --names)
    # set -l globs (set --global --names)
    # set -l univs (set --universal --names)

    set --local vars_all (set --names)
    set --local vars_to_erase (\
        # fish:
        string match --invert "_" $vars_all | \
        string match --invert "*fish*" | \
        string match --invert "argv" | \
        string match --invert "umask" | \
        # apple:
        string match --invert "__CF*" | \
        string match --invert "XPC_*" | \
        # special:
        string match --invert "FISH_VERSION" | \
        string match --invert "PWD" | \
        string match --invert "SHLVL" | \
        string match --invert "history" | \
        string match --invert "hostname" | \
        string match --invert "pipestatus" | \
        string match --invert "status" | \
        string match --invert "status_generation" | \
        string match --invert "version" | \
        # terminal:
        string match --invert "USER" | \
        string match --invert "COLUMNS" | \
        string match --invert "LINES" | \
        string match --invert "IFS" | \
        # path:
        string match --invert "PATH" | \
        string match --invert "TERM" | \
        # mine:
        string match --invert "_log4f_header_shown" | \
        string match --invert "__*_PATH" | \
        string match --invert "__COLOR_*")

    set vars_to_erase (sorted $vars_to_erase)

    # TODO: erase shortcut?
    # set --erase $vars_to_erase

    for var in $vars_to_erase
        printf %b\n $var

        # TODO: need string?
        # set --erase "$var"
    end
end
funcsave clear_fish_vars

# function clear_fish_all \
#     --description "Wipes out all of Fish."
#     clear_fish_files
#     clear_fish_vars
# end
# funcsave clear_fish_all

# function clear_fish_files \
#     --description "Wipes out Fish generated files."
#     log4f "Cleaning up generated Fish files..."
#     rm -rf $fsh_path/functions
#     rm -rf $fsh_path/logs
#     rm -f $fsh_path/fish_variables
#     log4f "Done cleaning up generated Fish files!"
# end
# funcsave clear_fish_files
