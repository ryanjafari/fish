log4f --type=i "Loading 💻 macOS-specific macOS functions..."

function macos \
    --argument-names argv
    # --inherit-variable $_ \
    # --description ""
    handle_subcommand macos $argv
end
funcsave macos

function _macos_get_tm
    set --local tmutil (which tmutil)
    set --local tmutil_subcmd destinationinfo
    set --local grep_bin (which grep)
    set --local grep_expression ID
    set --local sed_bin (which sed)
    set --local sed_expression "s|ID            : ||"

    log4f --type=d "Getting Time Machine backup:" \
        "\$tmutil: \"$tmutil\"" \
        "\$tmutil_subcmd: \"$tmutil_subcmd\"" \
        "\$grep_bin: \"$grep_bin\"" \
        "\$grep_expression: \"$grep_expression\"" \
        "\$sed_bin: \"$sed_bin\"" \
        "\$sed_expression: \"$sed_expression\""

    set --local tmutil_out ($tmutil $tmutil_subcmd)
    log4f --type=d $tmutil_out # TODO: --var: remove $; also a split bug here

    set --local tmutil_id
    log4f --type=d $tmutil_id

    for line in $tmutil_out
        set --local id_line (echo $line | $grep_bin $grep_expression)
        log4f --type=d $id_line

        if [ $status -eq 0 ]
            set --local tmutil_id_line $id_line
            log4f --type=d $tmutil_id_line

            set tmutil_id (echo $tmutil_id_line | $sed_bin --expression $sed_expression)
            log4f --type=d $tmutil_id
        end
    end

    set --local tmutil_err
    log4f --type=d $tmutil_err

    if [ -z "$tmutil_id" ]
        set tmutil_err (strs ": " $tmutil_out)[-1]
        log4f --type=d $tmutil_err
    end

    if set --query tmutil_err
        if [ -n "$tmutil_err" -a "$tmutil_err" = "No destinations configured." ]
            log4f --type=e "There are no Time Machine backups to get!"
            echo 1
            false
        end
    else if set --query tmutil_id
        if [ -n "$tmutil_id" ]
            log4f --type=i "Time Machine backups found!"
            echo $tmutil_id
            true
        end
    else
        log4f --var tmutil_err_msg
    end
end
funcsave _macos_get_tm

function _macos_del_tm \
    --argument-names tmutil_id
    log4f --type=n "Deleting Time Machine backup:" \
        "\$tmutil_id: \"$tmutil_id\""

    # TODO: validation of the ID
    if [ -n "$tmutil_id" ]
        log4f --type=i "Specified Time Machine backup ID is valid"

        set --local tmutil (which tmutil)
        set --local tmutil_subcmd removedestination

        log4f --type=d "Deleting Time Machine backup:" \
            "\$tmutil: \"$tmutil\"" \
            "\$tmutil_subcmd: \"$tmutil_subcmd\"" \
            "\$tmutil_id: \"$tmutil_id\""

        sudo $tmutil \
            $tmutil_subcmd \
            $tmutil_id &>>"$__LOG4F_PATH/macos.log"

        if [ $status -eq 0 ]
            log4f --type=n "Time Machine backup deleted!"
            echo 0
            true
        else
            log4f --type=e "Time Machine backup deletion failed!"
            echo 1
            false
        end
    else
        log4f --type=e "Must specify a valid Time Machine backup ID!"
        echo 1
        false
    end
end
funcsave _macos_del_tm

function _macos_set_tm \
    --argument-names share_url
    set --local tmutil (which tmutil)
    set --local tmutil_subcmd setdestination
    set --local tmutil_options -a $share_url

    log4f --type=d "Setting Time Machine backup using:" \
        "\"$tmutil\"" \
        "\"$tmutil_subcmd\"" \
        "\"$tmutil_options\""

    sudo $tmutil \
        $tmutil_subcmd \
        $tmutil_options &>>"$__LOG4F_PATH/macos.log" &

    if [ $status -eq 0 ]
        log4f --type=i "Set Time Machine backup using:" \
            "\"$tmutil\"" \
            "\"$tmutil_subcmd\"" \
            "\"$tmutil_options\""
    else
        log4f --type=e "Failed to set Time Machine backup using:" \
            "\"$tmutil\"" \
            "\"$tmutil_subcmd\"" \
            "\"$tmutil_options\""
    end
end
funcsave _macos_set_tm

function _macos_convert_passwords \
    --argument-names argv
    # TODO: 1password, macos
    argparse \
        --stop-nonopt \
        --name _macos_convert_passwords \
        "f/from-file=" "t/to-file=" \
        -- $argv

    set --local func_name (status current-function)
    set --local from_file $_flag_from_file
    set --local to_file $_flag_to_file

    log4f --type=d "Running function: \"$func_name\"..."

    log4f --type=d "Trying to convert passwords from:" \
        "\"$from_file\" =>" \
        "\"$to_file\"..."

    log4f --type=i "Note the first line in \"--from-file\" needs to be exactly:" \
        "Title,Url,Username,Password"

    log4f --type=d "Trying to read file: \"$from_file\"..."

    set --local to_file_buffer

    # TODO: stdin redirection?
    # TODO: --list?
    cat $from_file | while read \
            --silent \
            --delimiter="," \
            --local \
            title url username password
        if not [ \
                -z $title -o \
                -z $url -o \
                -z $username -o \
                -z $password ]
            # log4f --type=d "Entry: $title is a login, adding..."

            # set title (strm --chars '"' $title)
            # set url (strm --chars '"' $url)
            # set username (strm --chars '"' $username)
            set password (strm --right --chars ',' "$password") # trim trailing ,
            set password (string unescape $password) # interpret escapes

            set --append to_file_buffer $title,$url,$username,$password
            set --append to_file_buffer '\n'

            # log4f --type=d "Added entry: $title to: \"\$to_file_buffer\""
        else
            # log4f --type=d "Entry: $title has an empty column!"

            if [ -z $title ]
                log4f --type=e "The \"Title\" column cannot be empty!"
                echo 1
                false
            else
                # [ -z $url ]; and log4f --type=e "The \"Url\" column for entry: $title is empty!"
                # [ -z $username ]; and log4f --type=e "The \"Username\" column for entry: $title is empty!"
                # [ -z $password ]; and log4f --type=e "The \"Password\" column for entry: $title is empty!"

                # log4f --type=d "Entry: $title is likely not a login, ignoring..."
            end
        end
    end

    log4f --type=i "Flushing \"\$to_file_buffer\" to disk at file:" \
        "=> \"$to_file\"..."

    e $to_file_buffer >?$to_file

    log4f --type=n "Converted password dump is ready at:" \
        "=> \"$to_file\""

    # echo 0
    # true
end
funcsave _macos_convert_passwords
