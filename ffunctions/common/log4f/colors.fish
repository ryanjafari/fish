# SEE: https://apple.co/2W30U5F

function _get_color_seq
    # set --local color_seq (set_color $argv)
    # TODO: what happens if just set_color?
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

    for line in $argv
        set --local message

        set --local map (string split ": " $line)
        set --local var_key $map[1]
        set --local var_val $map[2]

        set --local var_key_color $__COLOR_CYAN
        set --local var_val_color $__COLOR_PINK
        set var_key $var_key_color$var_key
        set var_val $var_val_color$var_val

        set --local var_key_val "$var_key: $var_val"
        set --append message "$var_key_val"

        if [ "$line" = "$argv[-1]" ]
            set message $message$__COLOR_NORMAL
        end

        echo $message
    end
end
funcsave _color_vars

set --global __COLOR_NORMAL (_get_color_seq "normal")
set --global __COLOR_WHITE (_get_color_seq "#e8e8e8")
set --global __COLOR_BLUE (_get_color_seq "#0b84ff")
set --global __COLOR_RED (_get_color_seq "#fe453a")
set --global __COLOR_CYAN (_get_color_seq "#5ac8f5")
set --global __COLOR_GRAY (_get_color_seq "#98989d")
set --global __COLOR_PINK (_get_color_seq "#fe375f")
set --global __COLOR_YELLOW (_get_color_seq "#fed709")
