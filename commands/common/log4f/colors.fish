# SEE: https://apple.co/2W30U5F

function _get_color_seq
    # set --local color_seq (set_color $argv)
    # TODO: what happens if just set_color?
    # TODO: isatty stdout before using set_color
    echo (set_color $argv)
end
funcsave _get_color_seq

function _remove_color_seq \
    --argument-names string_with_color_seq
    set --local --unpath uncolor_path "./scripts/perl/uncolor.pl"
    set --local string_without_color_seq (echo "$string_with_color_seq" | $uncolor_path)
    echo $string_without_color_seq
end
funcsave _remove_color_seq

function _color_vars \
    --argument-names argv
    set --local lines $argv

    for line in $argv
        set --local message
        set --local map (string split ": " $line)
        set --local var_key $map[1]
        set --local var_val $map[2]

        # set --local var_key_val "$var_key: $var_val"


        # set --local var_key_count (string length $var_key)
        # set --local var_sep_count (string length ": ")
        # set --local var_val_count (string length $var_val)

        # set --local var_length (math "$var_key_count + $var_sep_count + $var_val_count")

        # TODO: this is weird; make dynamic
        # if test $var_length -gt 83
        #vset --local var_key_val "$var_key: $var_val"
        # set var_val (string sub --end=3 $var_key_val)"...|"
        # end

        if [ (is_terminal\?) -eq 0 ]
            set --local var_key_color $__COLOR_GRAY_DEFAULT
            set --local var_val_color $__COLOR_GRAY_DEFAULT

            set var_key $var_key_color$var_key
            set var_val $var_val_color$var_val
        end

        set --local var_key_val "$var_key: $var_val"
        set --append message "$var_key_val"
        # set message (string sub --start 1 --end 70 $var_key_val)

        set --local message_wrapped (echo $message | string sub --start 89)
        # echo $message_wrapped
        set message (echo $message | string replace $message_wrapped "...|" --)
        # set message $message' |'
        echo $message



        # if [ (is_terminal\?) -eq 0 ]
        #     if [ "$line" = "$argv[-1]" ]
        #         set message $message$__COLOR_NORMAL
        #     end
        # end

        # echo $message
    end
end
funcsave _color_vars

set --global __COLOR_NORMAL (_get_color_seq "normal")
# set --global __COLOR_WHITE (_get_color_seq "#e8e8e8")
# set --global __COLOR_BLUE (_get_color_seq "#0b84ff")
set --global __COLOR_RED (_get_color_seq "#fe453a")
set --global __COLOR_CYAN (_get_color_seq "#5ac8f5")
set --global __COLOR_GRAY_DEFAULT (_get_color_seq "#69696e")
set --global __COLOR_GRAY_VIBRANT (_get_color_seq "#a2a2a7")
set --global __COLOR_GREEN (_get_color_seq "#32d74b")
# set --global __COLOR_PINK (_get_color_seq "#fe375f")
set --global __COLOR_YELLOW (_get_color_seq "#fed709")
# set --global __COLOR_SUNGLO (_get_color_seq "#e06C75")
# set --global __COLOR_OLIVINE (_get_color_seq "#98c379")
