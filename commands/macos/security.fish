log4f --type=i "Loading 🔒 macOS security commands..."

function _sec_copy_ssh-id \
    --argument-names argv
    argparse \
        --stop-nonopt \
        --name _sec_copy_ssh-id \
        "i/identity-file=" "h/hostname=" \
        -- $argv

    set --local ssh_copy_id (which ssh-copy-id)
    set --local ssh_copy_id_opts -f
    set --local ssh_copy_id_prefix "$HOME/.ssh/sce"
    set --local ssh_copy_id_identity_file "$ssh_copy_id_prefix/$_flag_identity_file"
    set --local ssh_copy_id_hostname $_flag_hostname

    log4f --type=d "Copying SSH id:" \
        $ssh_copy_id \
        $ssh_copy_id_opts \
        $ssh_copy_id_prefix \
        $ssh_copy_id_identity_file \
        $ssh_copy_id_hostname

    ssh-copy-id -f -i "$ssh_copy_id_identity_file" -p 22 $ssh_copy_id_hostname
end
funcsave _sec_copy_ssh-id

function _sec_test_password \
    --argument-names password_sha1_hash
    echo $password_sha1_hash
end
funcsave _sec_test_password

# TODO: fish_prexec function
# set --local func_name (status current-function)
# log4f --type=d "Running function: \"$func_name\"..."

function _sec_list_op-passwords
    set --local op (which op)

    set --local op_items_json ($op list items \
        # global flags:
        --account ploy_and_crit \
        # --session $token \
        # flags:
        --categories Login \
        # --include-archive \
        # --tags tags \
        --vault Personal)

    # set --local op_items_count (echo $op_items_json | jq length) # more accurate -> 470
    # set --local op_items_count (count (echo $op_items_json | jq -ceM ".[]")) # &>"$__LOG4F_PATH/security.log"

    set --local op_passwords_json (echo $op_items_json | $op get item \
        # global flags:
        --account ploy_and_crit \
        # --session $token \
        # flags:
        - --fields password \
        --format JSON)
    # --include-archive \
    # --vault vault

    for op_password_json in $op_passwords_json
        # TODO: rename strm => strt
        set --local op_password (stru \
            (echo $op_password_json | jq ".password"))
        set --local op_password_hash ("sha1-hash" $op_password)
        echo $op_password



        # last password:
        # 6hcFqwtxYTdCy4Rp
    end

    # set --local count_1 (echo $op_items_json | jq '[.[]|tojson|fromjson]')



    # set --local op_passwords_count (count $op_json)
    # echo $op_json
end
funcsave _sec_list_op-passwords

function _sec_get_op-password \
    --argument-names argv
    argparse \
        --stop-nonopt \
        --name _sec_get_op-password \
        "u/item-uuid=" "f/password-field=" \
        -- $argv

    set --local op (which op)
    set --local op_account_shorthand ploy_and_crit
    set --local op_vault Personal

    set --local op_list_items_json \
        ($op list items \
            --account $op_account_shorthand \
            --vault $op_vault)
    # --categories "API Credential" | \
    # --tags Servers | \

    # TODO: success/failure? generic method --on-job-exit?

    set --local op_item_uuid $_flag_item_uuid
    set --local op_item_password_field $_flag_password_field

    set --local op_get_item_json \
        ($op get item $op_item_uuid - \
            --fields $op_item_password_field \
            --format "JSON")

    # TODO: success/failure? generic method --on-job-exit?

    set --local op_password (stru \
        (echo $op_get_item_json | \
        jq ".$op_item_password_field"))

    # TODO: success/failure? generic method --on-job-exit?

    echo $op_password

    set --erase op_password
end
funcsave _sec_get_op-password

function _sec_get_password \
    --argument-names password_label
    set --local security (which security)
    set --local security_subcmd find-internet-password
    set --local security_options -l $password_label

    log4f --type=n "Getting password:" \
        "\$security: \"$security\"" \
        "\$security_subcmd: \"$security_subcmd\"" \
        "\$security_options: \"$security_options\""

    $security \
        $security_subcmd \
        $security_options &>>"$__LOG4F_PATH/security.log"

    # TODO: actually retrieve and send back the password?
    if [ $status -eq 0 ]
        log4f --type=d "A password with label: \"$password_label\" already exists"
        echo 0
        true
    else
        log4f --type=d "A password with label: \"$password_label\" does not exist"
        echo 1
        false
    end
end
funcsave _sec_get_password

function _sec_add_password \
    --argument-names argv
    argparse \
        --stop-nonopt \
        --name _sec_add_password \
        "a/account-name=" "w/password=" "p/path=" "P/port=" \
        -- $argv

    # TODO: double quotes
    set --local security (which security)
    set --local username $_flag_account_name
    set --local domain system
    set --local password_kind "Time Machine Password"
    set --local comment "my comment"
    set --local password_label "smb://localhost/tm-ryans-macbook"
    set --local path $_flag_path
    set --local port $_flag_port
    set --local protocol "smb " # must be four characters
    set --local server localhost
    set --local auth_type "any "
    set --local password $_flag_password

    set --local system_keychain \
        (strm --chars="\"" \
        (strm --left ($security list-keychains -d $domain)))

    # TODO: sec del password
    if [ (_sec_get_password $password_label) -eq 0 ]
        set --local security_subcmd delete-internet-password
        set --local security_options -l $password_label

        # log4f --type=d "A password with label: \"$password_label\" already exists"
        log4f --type=d "Deleting password:" \
            "\$password_label: \"$password_label\"" \
            "\$system_keychain: \"$system_keychain\"" \
            "\$security: \"$security\"" \
            "\$security_subcmd: \"$security_subcmd\"" \
            "\$security_options: \"$security_options\""

        # TODO: specify additional options to match on (like domain=system)
        sudo $security \
            $security_subcmd \
            $security_options &>>"$__LOG4F_PATH/security.log"

        if [ $status -eq 0 ]
            log4f --type=n "Deleted password:" \
                "\$password_label: \"$password_label\"" \
                "\$system_keychain: \"$system_keychain\""
        else
            log4f --type=e "Failed to delete password with label: \"$password_label\" from keychain:"
        end
    end

    # TODO: more unpaths
    set --local --unpath net_auth_agent_app_path \
        "/System/Library/CoreServices/NetAuthAgent.app/Contents/MacOS"

    log4f --type=n "Adding password:" \
        "\$password_label: \"$password_label\"" \
        "\$system_keychain: \"$system_keychain\"" \
        "\"$security\"" \
        "\"-a $username\"" \
        "\"-d $domain\"" \
        "\"-D $password_kind\"" \
        "\"-j $comment\"" \
        "\"-l $password_label\"" \
        "\"-p $path\"" \
        "\"-P $port\"" \
        "\"-r $protocol\"" \
        "\"-s $server\"" \
        "\"-t $auth_type\"" \
        "\"-w *****\"" \
        "\"-T .../NetAuthSysAgent\"" \
        "\"-T .../NetAuthAgent\"" \
        "\"$system_keychain\""

    sudo $security add-internet-password \
        -a $username \
        -d $domain \
        -D $password_kind \
        -j $comment \
        -l $password_label \
        -p $path \
        -P $port \
        -r $protocol \
        -s $server \
        -t $auth_type \
        -w $password \
        -T "$net_auth_agent_app_path/NetAuthSysAgent" \
        -T "$net_auth_agent_app_path/NetAuthAgent" \
        "$system_keychain" &>>"$__LOG4F_PATH/security.log"

    if [ $status -eq 0 ]
        log4f --type=n "Added password:" \
            "\$password_label: \"$password_label\"" \
            "\$system_keychain: \"$system_keychain\""
    else
        log4f --type=e "Failed to add password with label: \"$password_label\" to keychain: \"$system_keychain\""
    end

    log4f --type=d "Cleanup: erasing password from memory..."

    set --erase password
end
funcsave _sec_add_password

function _sec_check_passwords \
    --argument-names argv
    for a in $argv

    end
end
funcsave _sec_check_passwords

# TODO:
# function _sec_convert_password
#
# end
# funcsave _sec_convert_password
