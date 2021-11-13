# TODO: refactor
function _get_type_display
    # --description ""

    set --local flag_type $argv[1]
    set --local col_type $argv[2..-1]

    if [ (is_terminal\?) -eq 0 ]
        switch $flag_type
            case d
                set col_type "$__COLOR_GRAY_DEFAULT$col_type"
            case i
                set col_type "$__COLOR_GRAY_VIBRANT$col_type"
            case n
                set col_type "$__COLOR_NORMAL$col_type"
            case e
                set col_type "$__COLOR_YELLOW$col_type"
            case f
                set col_type "$__COLOR_RED$col_type"
            case s
                set col_type "$__COLOR_GREEN$col_type"
            case v
                set col_type "$__COLOR_CYAN$col_type"
            case '*'
                # TODO: unknown type
        end

        set col_type "$col_type$__COLOR_NORMAL"
    else
        switch $flag_type
            case d
                set col_type "$col_type"
            case i
                set col_type "$col_type"
            case n
                set col_type "$col_type"
            case e
                set col_type "$col_type"
            case f
                set col_type "$col_type"
            case s
                set col_type "$col_type"
            case v
                set col_type "$col_type"
            case '*'
                # TODO: unknown type
        end
    end

    echo $col_type
end
funcsave _get_type_display

# TODO: should mirror tide prompt timestamp
# TODO: or apple timestamp
function _get_timestamp
    set --local timestamp (date +"%m/%d %H:%M:%S")
    echo $timestamp
end
funcsave _get_timestamp

function _log4f_var_dump \
    --argument-names var_name \
    --no-scope-shadowing

    # TODO: must have a value? or show all?
    # TODO: if no var name given show all
    # TODO: if var not found
    set --local lines

    if set --query $var_name
        set lines (set --show --long "$var_name")
        set lines (_color_vars $lines[2..-1]) # skip scope line
    else
        set lines "\$$var_name: undefined"
        set lines (_color_vars $lines[1..-1])
    end

    test (count $lines) -gt 1; and echo "$lines[1]\n"; or echo "$lines[1]"

    _indent_message $lines[2..-1]
end
funcsave _log4f_var_dump

function _indent_message \
    --argument-names argv
    for line in $argv
        set --local message

        set --append message (strr -n 53 ' ') # TODO: dynamic #
        set --append message $line
        test $line != $argv[-1]; and set --append message '\n'

        echo $message
    end
end
funcsave _indent_message

# TODO: PATH print out (order important)
# TODO: env print out (order less important) | sort
function _env_debug
    set --local cmds \
        isatty \
        status \
        "status is-login" \
        "status is-interactive" \
        "status is-block" \
        "status is-breakpoint" \
        "status is-command-substitution" \
        "status is-no-job-control" \
        "status is-full-job-control" \
        "status is-interactive-job-control" \
        "status current-command" \
        "status current-filename" \
        "status current-function" \
        "status current-line-number" \
        "status line-number" \
        "status filename" \
        "status basename" \
        "status dirname" \
        "status fish-path" \
        "status function" \
        "status print-stack-trace" \
        "status stack-trace" \
        "status features"

    set --local lines
    for c in $cmds
        # TODO: exec
        set --local cmd_name "$c"
        set --local cmd_value (eval "$c;")
        set --local cmd_status $status

        # TODO: cleanup
        if [ $cmd_status -ne 0 ]
            if [ -z "$cmd_value" ]
                set cmd_value no
            end
        else if [ $cmd_status -eq 0 ]
            if [ -z "$cmd_value" ]
                set cmd_value yes
            end
        end

        set --local cmd_debug "$cmd_name: $cmd_value"
        set --append lines "$cmd_debug"
    end

    set --local colored (_color_vars $lines)
    printf %b\n $colored
end
funcsave _env_debug

# function _truncate_message \
#     --argument-names message
#     set --local len_message (strl $message)
#     set --local len_column $col_size_message
#     set --local msg_trunced ""

#     # set len_with_color (strl $message)
#     # set len_without_color (strl (_remove_color_seq $message))
#     # set len_truncate_to (math "$len_with_color - $len_without_color")

#     # echo "len_with_color: $len_with_color"
#     # echo "len_without_color: $len_without_color"

#     if [ $len_message -gt $col_size_message ]
#         #printf %b "hey\n\n\n"
#         #printf %b\n $message
#         set msg_trunced (string sub --length $len_column $message)
#         # set --local nrm_color (_get_color_seq "normal")
#         # set msg_trunced $msg_trunced$nrm_color
#         #echo "'$msg_trunced'"
#     end

#     #printf %b "{$message}\n"
#     # printf %b\n hello
#     # printf %b "[$msg_trunced]\n"
#     # printf %b\n hellox
#     echo $msg_trunced
# end
# funcsave _truncate_message
