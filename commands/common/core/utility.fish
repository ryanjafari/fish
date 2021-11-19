# log4f --type=i "Loading 🛠 utility functions..."

function sha1-hash \
    --argument-names string_to_hash
    if [ -n "$string_to_hash" ]
        echo "$string_to_hash" | sha1sum | head -c 40
    else
        echo ""
    end
    true
end
funcsave sha1-hash

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

function get-os \
    --description "Get the current OS." \
    --no-scope-shadowing
    $HOME/.config/fish/scripts/bash/get_os.bash
end
funcsave get-os

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
function is_terminal\?
    # isatty vs. isatty stdout
    set --local is_interactive 1
    set --local is_a_tty 1

    status is-interactive; and set is_interactive 0
    isatty; and set is_a_tty 0

    if set --query is_interactive; and set --query is_a_tty
        if [ $is_interactive -eq 0 -a $is_a_tty -eq 0 ]
            echo 0
            true
        else
            echo 1
            false
        end
    else
        echo "Either \$is_interactive or \$is_a_tty is not defined"
        false
    end
end
funcsave is_terminal\?

# TODO: use this in places that need it
# TODO: rename to has_var\?
function has_arg\? \
    --argument-names arg \
    --description "Returns true (exit status = 0) if the argument \
      is declared and not empty and false (exit status = 1) if it isn't"
    set --query arg; and [ -n "$arg" ]
end
funcsave has_arg\?

function handle_subcommand \
    --argument-names argv \
    --inherit-variable _
    # --description ""

    # log4f --var command
    # log4f --var arguments
    # log4f --type=d $argv
    # log4f --type=d $argv[1]
    # log4f --type=d $argv[2]

    # set --local cmd_cmd $command
    set --local cmd_cmd $argv[1]
    # log4f --var cmd_cmd
    set --local cmd_sub $argv[2]
    # log4f --var cmd_sub
    set --local cmd_obj $argv[3]
    # log4f --var cmd_obj
    set --local cmd_arg $argv[4..-1]
    # log4f --var cmd_arg

    # set --local cmd_evl $cmd_sub $cmd_obj
    # set --local cmd_shw $cmd_evl $cmd_arg
    # set --local cmd_coo $cmd_evl

    # log4f --type=i "Running command: \"$cmd_evl\""
    # log4f --type=d "Trying to invoke: \"$cmd_cmd\", action: \"$cmd_sub\", object: \"$cmd_obj\"..."
    # log4f --var cmd_shw

    # # TODO: better error handling
    log4f --type=d "Starting command: \"$cmd_cmd\"..."

    if has_arg\? $cmd_sub
        log4f --type=d "Performing action: \"$cmd_sub\"..."

        if has_arg\? $cmd_obj
            log4f --type=d "With object: \"$cmd_obj\"..."

            set --local cmd_coo _(strj '_' $cmd_cmd $cmd_sub $cmd_obj)

            log4f --type=d "Trying to call function: \"$cmd_coo\"..."

            if has_arg\? $cmd_arg
                log4f --type=d "And args:"
                log4f --type=v cmd_arg

                # TODO: don't need eval/exec?
                # TODO: exec?
                $cmd_coo $cmd_arg
            else
                log4f --type=i "No arguments were passed!"
                $cmd_coo
            end
        else
            # TODO: print help in this case (look for event
            # fish_usage_err or fish_err)
            log4f --type=e "Missing \"$cmd_cmd\" object for: \"$cmd_cmd\", \"$cmd_sub\"!"
            return 2
        end
    else
        echo we dont
    end
end
funcsave handle_subcommand

# TODO: be able to log commands
# like in this case for progress
function sleepp \
    --argument-names seconds
    # --description ""
    set --local size (math "$seconds * 10")
    set --local null /dev/null
    set --local ttys /dev/ttys002 # TODO: sys get ttys

    # TODO: bar command?
    # TODO: pv --line-mode? to count yes lines?
    # TODO: pv --prefix $padding and --width $col_message_size
    yes | pv \
        --stop-at-size \
        --progress \
        --timer \
        --eta \
        --fineta \
        --rate \
        --average-rate \
        --bytes \
        --buffer-percent \
        --rate-limit 10 \
        --interval 0.1 \
        --size $size >$null 2>$ttys
end
funcsave sleepp

function glob \
    --argument-names argv

    # TODO: fish_opt, getopts
    argparse --name log4f "e/except=" -- $argv

    # USAGE: glob ./initializers/* --except linux.fish

    # echo $_flag_except

    string match --invert \*$_flag_except -- $argv
end
funcsave glob

function sources \
    --argument-names argv
    for f in $argv
        source $f
    end
end
funcsave sources

function kind \
    --argument-names argv
    # --description "" \
    # --wraps=string

    if set --query argv[1]; and [ $argv[1] = is ]
        if not set --query argv[2]
            echo "error: usage..." >&2
            return 2
        end

        set --local pattern

        switch $argv[2]
            case int integer
                set pattern '^[+-]?\d+$'
            case hex hexadecimal xdigit
                set pattern '^[[:xdigit:]]+$'
            case oct octal
                set pattern '^[0-7]+$'
            case bin binary
                set pattern '^[01]+$'
            case float double
                set pattern '^[+-]?(?:\d+(\.\d+)?|\.\d+)$'
            case alpha
                set pattern '^[[:alpha:]]+$'
            case alnum
                set pattern '^[[:alnum:]]+$'
            case '*'
                echo "unknown class..." >&2
                return 1
        end

        set argv match --quiet --regex -- $pattern $argv[3]
    end

    builtin string $argv
end
funcsave kind

# while true
#     echo -n .
#     sleep 1
# end &
# TODO: save PID in file PV?
# set PID (jobs -l | awk '{print $2}')
# echo hi there

# sleep 10 # or do something else here
# kill $PID
# trap "kill $PID" SIGTERM
