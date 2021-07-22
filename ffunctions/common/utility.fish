# log4f --type=i "Loading 🛠 utility functions..."

function trim_whitespace
    sed -i 's/[ \t]*$//' "$argv"
    # TODO: string trim
    # TODO: remember this is for files too
end
funcsave trim_whitespace

function get_version \
    --argument-names output \
    --description "Gets a version number from the command output passed as input."
    echo -s $output | sed 's/[^0-9\.]//g'
end
funcsave get_version

function get_os \
    --description "Get the current OS." \
    --no-scope-shadowing

    #log4f --type=e "get os logging"
    # set --local os ($HOME/.config/fish/scripts/bash/get_os.bash)
    echo macos
end
funcsave get_os

function sorted \
    --argument-names argv \
    --description "Sorts an array."
    for a in $argv
        echo $a
    end | sort
end
funcsave sorted

# TODO: name like isatty
# TODO: problem with SSH Config Editor.app
function is_terminal
    isatty
    # isatty stdout
    # status is-interactive
end
funcsave is_terminal

# TODO: use this in places that need it
function has_arg\? \
    --argument-names arg \
    --description "Returns true (exit status = 0) if the argument \
      is declared and not empty and false (exit status = 1) if it isn't"
    set --query arg; and [ -n "$arg" ]
end
funcsave has_arg\?
