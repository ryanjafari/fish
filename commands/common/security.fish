log4f --type=i "Loading 🔒 security commands..."

# TODO: virustotal-cli, virustotaluploader
# TODO: make environment variables use dotenv instead of fish files

set --export SSH_ENV "$HOME/.ssh/environment.env"

function sec \
    --argument-names argv
    # --inherit-variable $_ \
    # --description ""
    handle_subcommand sec $argv
end
funcsave sec

# TODO: jobs?
# TODO: SSH_ENV file is ready

# TODO: kill other agents - only one
# TODO: check if others before starting
function __sec_start_sshagent
    __sec_status_sshagent

    if test $status -eq 0
        log4f --type=n "SSH agent is already running"
        set --local pgrep (pgrep ssh-agent)
        log4f --type=v pgrep

        true
        return 0
    else
        log4f --type=n "Testing if starting the SSH agent is necessary..."

        # TODO:
        # test -z "$SSH_AGENT_PID"; and
        if test -z "$SSH_TTY"
            log4f --type=i "Neither the SSH agent pid nor the SSH tty vars are set"

            log4f --type=n "Need to start the SSH agent, trying..."

            # status job-control full # move to config
            set --local environment_env (ssh-agent -c | sed 's/^echo/# echo/')
            eval $environment_env

            true >$SSH_ENV
            set --local environment_lines (string split '\n' $environment_env)
            for line in $environment_lines
                echo $line >>$SSH_ENV
            end

            log4f --type=s "SSH agent env vars set:"
            set --local ssh_vars (set --names | grep -e "SSH_*")
            for var in $ssh_vars
                log4f --type=v $var
            end

            #>/dev/ttys004 # TODO: remove the echo?
            # eval `ssh-agent -s` >/dev/null

            # >$SSH_ENV
            # sed 's/^echo/# echo/'
            # jobs

            # TODO erase old ssh vars

            # echo $SSH_AGENT_PID
            # echo %1
            # echo %ssh-agent
            # echo %last
            # echo $last_pid

            log4f --type=n "Started the SSH agent and wrote to the SSH env file:"
            log4f --type=v SSH_ENV

            log4f --type=i "Tweak permissions for the SSH env file..."
            chmod 600 $SSH_ENV
            log4f --type=i "Adjusted permissions for the SSH env file"

            log4f --type=i "Loading the SSH env file:"
            log4f --type=v SSH_ENV
            source $SSH_ENV >/dev/null
            log4f --type=i "Loaded the SSH env file"

            log4f --type=s "SSH agent has been started:"
            set --local pgrep (pgrep ssh-agent)
            log4f --type=v pgrep
            # TODO: proof?

            true # suppress errors from setenv, i.e. set -gx (what does this mean?)
            return 0
        else
            log4f --type=i "Either the SSH agent pid or the SSH tty var is set"
            log4f --type=i "Don't need to start the SSH agent"
        end
    end
end
funcsave __sec_start_sshagent

# TODO: test for socket using -S
function __sec_status_sshagent
    log4f --type=n "Retrieving status of ssh-agent..."

    set --query SSH_ENV; and test -n "$SSH_ENV"
    set --local has_ssh_env $status

    # TODO: fish_indent options so i can make this one line?
    if begin
            test $has_ssh_env -eq 0; and test -f "$SSH_ENV"; and test -s "$SSH_ENV"
        end
        log4f --type=i "SSH env file seems ready:"
        log4f --type=v SSH_ENV

        if begin
                test -z "$SSH_AGENT_PID"
            end
            log4f --type=i "SSH agent pid is not set yet:"
            # log4f --type=v SSH_AGENT_PID
            log4f --type=i "SSH env will be loaded from file"
            # log4f --type=v SSH_ENV

            # Set SSH_AUTH_SOCK and SSH_AGENT_PID:
            source $SSH_ENV >/dev/null

            log4f --type=i "SSH env was loaded from file"
            # log4f --type=v SSH_ENV
            log4f --type=v SSH_AGENT_PID
            # TODO: other vars?
        else
            log4f --type=i "SSH agent pid is already set:"
            log4f --type=v SSH_AGENT_PID
            # log4f --type=s "SSH agent is already loaded"
            # validate the process and pump out the config?
            # true
            # return 0
        end
    else
        # TODO: color the yes and nos
        # TODO: conditional tips
        log4f --type=e "SSH env file isn't ready, check:"
        log4f --type=i (test $has_ssh_env -eq 0; and echo '✔'; or echo '✘')" \$SSH_ENV is defined and non-empty"
        log4f --type=i (test -f "$SSH_ENV"; and echo '✔'; or echo '✘')" \$SSH_ENV points to a file that exists"
        log4f --type=i (test -s "$SSH_ENV"; and echo '✔'; or echo '✘')" \$SSH_ENV is a non-blank file"

        log4f --type=i "💡 Ensure you've specified an SSH env file:"
        log4f --type=i "`set --export SSH_ENV \"\$HOME/.ssh/environment.env\"`"
        log4f --type=i "💡 Try starting the agent:"
        log4f --type=i "`sec start sshagent`"

        log4f --type=f "Failed to get the status of the SSH agent!!"

        false
        return 1
    end

    if begin
            test -z "$SSH_AGENT_PID"
        end
        log4f --type=e "SSH agent pid was not set:"
        log4f --type=v SSH_AGENT_PID

        if begin
                test -z "$SSH_CONNECTION"
            end
            log4f --type=e "SSH connection was not set:"
            log4f --type=v SSH_CONNECTION
        else
            log4f --type=e "SSH connection was set:"
            log4f --type=v SSH_CONNECTION
        end

        log4f --type=f "SSH agent could not be found!!"

        false
        return 1
    else
        log4f --type=i "SSH agent pid was set:"
        log4f --type=v SSH_AGENT_PID

        if begin
                test -z "$SSH_CONNECTION"
            end
            log4f --type=e "SSH connection was not set:"
            log4f --type=v SSH_CONNECTION
        else
            log4f --type=e "SSH connection was set:"
            log4f --type=v SSH_CONNECTION
        end
    end

    # TODO: check SSH agent environment variables method
    log4f --type=s "SSH agent env vars set:"

    set --local ssh_vars (set --names | grep -e "SSH_*")

    for v in $ssh_vars
        log4f --type=v $v
    end

    # TODO: is-ssh-agent-running?
    # TODO: use all of these?
    # ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
    # ssh-add -l >/dev/null 2>&1
    pgrep ssh-agent | grep -q $SSH_AGENT_PID
    set --local ssh_agent_status $status

    if test $ssh_agent_status -eq 0
        log4f --type=s "SSH agent is running, status:"
        log4f --type=v ssh_agent_status

        true
        return 0
    else
        log4f --type=e "SSH agent wasn't found, status:"
        log4f --type=v ssh_agent_status
        log4f --type=f "SSH agent is not running!!"

        false
        return 1
    end
end
funcsave __sec_status_sshagent

function __sec_get_sshagent
    getopts $argv | while read -l key value
        switch $key
            case a all-sockets
                log4f --type=n "Getting all existing sockets, live or dead..."
                # TODO: /tmp on linux?
                set --local all_sockets \
                    (find /var/* -uid (id -u) -type s -name agent.\* 2>&1 \
                        | grep -v "Operation not permitted" \
                        | grep -v "Permission denied")
                echo $all_sockets
                return $status

            case c curent-socket
                log4f --type=n "Getting currently set socket..."

                if var\? SSH_AUTH_SOCK
                    log4f --type=i "The SSH auth socket env var exists:"
                    log4f --type=v SSH_AUTH_SOCK

                    if file\? -e $SSH_AUTH_SOCK

                    else

                    end
                else
                    log4f --type=e "The SSH auth socket env var does not exist"
                    log4f --type=v SSH_AUTH_SOCK
                    log4f --type=f "Cannot get current SSH auth socket!!"

                    false
                    return 1
                end

            case l live-socket
                # TODO:

            case '*'
                log4f --type=e "Unknown option for "(status "current-function")":" # last called cmd?
                log4f --type=v key
                log4f --type=f "Cannot continue!!"

                false
                return 1
        end
    end
end
funcsave __sec_get_sshagent

# TODO: helpers/utility
function var\? \
    --argument-names var_name
    # --no-scope-shadowing
    set --query $var_name
    set --local var_defined $status

    if test $var_defined -eq 0
        log4f --type=d "The var \$$var_name is defined:"
        log4f --type=v var_name

        if test -n "$var_name"
            log4f --type=d "The var \$$var_name is assigned a value:"
            log4f --type=v var_name

            # true
            # echo 0
            return 0
        else
            log4f --type=d "The var \$$var_name is not assigned a value:"
            log4f --type=v var_name

            # false
            # echo 1
            return 1
        end
    else
        log4f --type=d "The var \$$var_name is not defined"

        # false
        # echo 1
        return 1
    end
end
funcsave var\?

function file\?
    # --argument-names file_path

    set --local file_path $argv[-1]
    set --local file_name (basename $file_path)
    set --local test_opts $argv[1..-2]

    log4f --type=i "The function: \""(status current-function)"\" was invoked with options:"
    log4f --type=v test_opts

    log4f --type=d "File: \"$file_name\" test results using options:"
    # log4f --type=v test_opts

    # log4f --type=v file_path
    for opt in $test_opts
        if test $opt "$file_path"
            set --local test_result "✔ test $opt succeeded"
            log4f --type=d $test_result # TODO: match with text descriptions of each option w/ `read`
        else
            set --local test_result "✘ test $opt failed"
            log4f --type=d $test_result # TODO: match with text descriptions of each option w/ `read`
        end
    end

    # if test -efOrsSx "$file_path"
    #     log4f --type=d "The file $file_name exists:"
    #     log4f --type=v file_path

    #     true
    #     return 0
    # else
    #     log4f --type=d "The file $file_name does not exist:"
    #     log4f --type=v file_name

    #     false
    #     return 1
    # end
end
funcsave file\?
