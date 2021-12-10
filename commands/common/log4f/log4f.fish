# log4f --type=i "Loading 🪵 log4f function..."

set --global --unpath mf_log4f_path "$mf_commands_common_path/log4f"

source "$mf_log4f_path/colors.fish"
source "$mf_log4f_path/helpers.fish"

set --global mf_log4f_header_shown 1 # TODO: does fish understand this? or just 0 or 1?

# TODO: either prefix functions or remove _
function log4f \
    --argument-names argv \
    --no-scope-shadowing \
    --description "Logs a message to STDOUT if interactive, and a file if non-interactive."

    # TODO: fish_opt
    # TODO: --exclusive or make var a type?
    argparse \
        --stop-nonopt \
        --name log4f \
        "t/type=" v/var \
        -- $argv

    if test $mf_log4f_header_shown -eq 1
        # TODO: rename process to command?
        set --local header (_log4f_columns "type" "time" "process" "message")

        # TODO: differentiate header with formatting
        _log4f_log "\n$header"
        set mf_log4f_header_shown 0
    end

    # TODO: is_var?
    set --local to_log $argv[1..-1]


    # TODO: has_var
    set --query _flag_var; and test -n "$_flag_var"
    set --local has_var_flag $status

    set --query _flag_type; and test -n "$_flag_type"; and test "$_flag_type" = v
    set --local has_type_flag $status

    if test $has_var_flag -eq 0 -o $has_type_flag -eq 0
        # TODO: add --type= here and make one method
        # instead of *_var and *_msg
        # _log4f_log_var $to_log
    else
        if [ $_flag_type != "d" ]
            _log4f_log_msg --type=$_flag_type $to_log
        end
    end
end
funcsave log4f
# aliasave log log4f
# aliasave logm log4f

function _log4f_log \
    --argument-names line
    if [ (is_terminal\?) -eq 0 ]
        _log4f_terminal "$line"
    else
        _log4f_file "$line"
    end
end
funcsave _log4f_log

function _log4f_log_var \
    --argument-names var_name \
    --no-scope-shadowing \
    --description "Prints information about the given \$variable."
    # TODO: possible here?
    # log4f "Inspecting variable..."

    set --local col_type (_get_type_display 'v' "● v")
    set --local col_time (_get_timestamp)
    set --local col_process (status current-command) # TODO: function also?
    set --local col_message "  "(_log4f_var_dump $var_name)

    set --local row (_log4f_columns \
      "$col_type" \
      "$col_time" \
      "$col_process" \
      "$col_message")

    _log4f_log "$row"
end
funcsave _log4f_log_var

function _log4f_log_msg \
    --argument-names argv \
    --description "Writes the given \$msg4log to the right output."

    # TODO: fish_opt
    argparse \
        --stop-nonopt \
        --name _log4f_log_msg \
        "t/type=" \
        -- $argv

    # TODO: proper has_flag
    [ $_flag_type ]; and set --local flag_type "$_flag_type"; or set --local flag_type n

    set --local col_type (_get_type_display $_flag_type "● $_flag_type")
    set --local col_time (_get_timestamp)
    set --local col_process (status current-command)
    set --local col_message (_log4f_msg_dump $_flag_type $argv) # TODO: truncate

    set --local row (_log4f_columns \
      "$col_type" \
      "$col_time" \
      "$col_process" \
      "$col_message")

    _log4f_log "$row"
end
funcsave _log4f_log_msg

function _log4f_msg_dump
    # --argument-names argv
    set --local flag_type $argv[1]
    set --local message $argv[2..-1]
    set --local message_formatted

    if test (count $message) -gt 1
        _get_type_display $flag_type $message[1]'\n' (_indent_message $message[2..-1])
    else
        _get_type_display $flag_type $message[1] (_indent_message $message[2..-1])
    end

    # echo $message_formatted
end
funcsave _log4f_msg_dump

function _log4f_terminal \
    --argument-names line \
    --description "Writes the given \$message to standard output (STDOUT)."
    # TODO: eval the message column here for a command?
    # TODO: redirect stderr to: 2>$mf_log4f_log_file
    printf %b\n $line
end
funcsave _log4f_terminal

function _log4f_file \
    --argument-names line \
    --description "Writes the given \$message to the log file."
    # TODO: append or rewrite, an option perhaps?
    printf %b\n $line >>"$HOME/.config/fish/logs/log4f.log"
end
funcsave _log4f_file

function _log4f_columns \
    --argument-names col_type col_time col_process col_message \
    --description "Prints formatted columns for each log4f row."

    set --local num_columns (count $argv)
    set --local num_spaces_per_col 1
    set --local num_delimiters_per_col 2

    set --local delimiter_cols (math "\
    ($num_columns * $num_spaces_per_col) + \
        ($num_columns * $num_delimiters_per_col) \
        + 1")

    # TODO: make dynamic => subtract w/ color from w/o
    set --local col_size_type 0
    set --local col_size_time (string length "%m/%d %H:%M:%S")
    set --local col_size_process (string length "get_num_cores")
    set --local _col_size_message (math "\
    $COLUMNS - \
        ($col_size_type + $col_size_time + $col_size_process) - \
        $delimiter_cols")

    set col_type (strp --right --width $col_size_type $col_type)
    set col_time (strp --right --width $col_size_time $col_time)
    set col_process (strp --right --width $col_size_process $col_process)
    set col_message $col_message
    # set col_message (strp --right --width $col_size_message $col_message)

    # TODO: Do we want to add to an array and then print
    # it all out when we are done (w/ fish_postexec)? The
    # benefit would be the ability to resize the entire
    # column based on the longest row in that column.
    # printf %b\n " | $col_type | | $col_time | | $col_process | | $col_message | "
    echo " | $col_type | "
    echo " | $col_time | "
    echo " | $col_process | "
    echo " | $col_message"
end
funcsave _log4f_columns

# Fish Events:
# fish_prompt
# fish_preexec
# fish_posterror
# fish_postexec
# fish_exit
# fish_cancel

# TODO: _on_var_change?
# TODO: inline or in function it is needed for?
function _on_fish_preexec \
    --on-event fish_preexec \
    --description ""
    set mf_log4f_header_shown 1
end
funcsave _on_fish_preexec

# TODO: inline or in function it is needed for?
function _on_fish_postexec \
    --on-event fish_postexec \
    --description ""
    # TODO: log4f --type=d "Command took $CMD_DURATION milliseconds"
    set mf_log4f_header_shown 1
end
funcsave _on_fish_postexec
