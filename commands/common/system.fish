log4f --type=i "Loading ⚙️ system commands..."

# TODO: model => sudo dmidecode | grep -A3 '^System Information'
# TODO: os version

function sys \
    --argument-names argv
    # --inherit-variable $_ \
    # --description ""
    handle_subcommand $argv
end
funcsave sys

function _sys_get_cores \
    --argument-names host \
    --description "Get the number of cores for the specified host."
    log4f --type=n "Getting the number of cores for host: \"$host\"..."

    set --local phys_cpus 1
    set --local logi_cpus
    set --local sysct_cmd "sysctl -n machdep.cpu.core_count"

    if [ -z "$host" -o "$host" = localhost ]
        set host localhost
        log4f --type=i "Either localhost or no host was specificed: \"$host\""
        set logi_cpus ($sysct_cmd)
    else
        log4f "A host was specified: $host"
        set logi_cpus (ssh $host $sysct_cmd)
        # if the above fails...
        # if test ! $status -eq 0
        #     echo "Previous command failed"
        # end
        # if test $status -ne 0
        #     echo "Previous command failed"
        # end
    end

    log4f --type=i "Number of physical CPUs: $phys_cpus"
    log4f --type=n "Number of logical CPUs: $logi_cpus"

    set -l num_cores (math "$phys_cpus * $logi_cpus")

    log4f "Number of cores: $num_cores"
    log4f --type=e "Host $host has $num_cores cores"
    log4f --type=f "Host $host has $num_cores cores"

    echo $num_cores
end
funcsave _sys_get_cores

function _sys_get_tasks \
    --description "Gets the optimal number of tasks that can be run in parallel on the machine."
    # Formula: num_of_cpu * cores_per_cpu * threads_per_core
    set -l cpu_count 1
    set -l core_count (sysctl -n machdep.cpu.core_count)
    set -l thread_count (sysctl -n machdep.cpu.thread_count)
    set -l threads_per_core (math "$thread_count / $core_count")
    set -l tasks_count (math "$cpu_count * $core_count * $threads_per_core")

    echo $tasks_count
end
funcsave _sys_get_tasks

function _sys_get_proc \
    --argument-names process
    # --description ""
    log4f --type=n "Getting process: \"$process\"..."

    set --local proc (ps -ecx -o "pid,command" | grep $process)
    set proc (strm $proc)
    set proc (strs " " $proc)

    log4f --var proc

    set --local pid $proc[1]
    set --local prc $proc[2]

    log4f --type=n "Retrieved process: \"$prc\", with pid: \"$pid\""

    echo $pid
    echo $prc
end
funcsave _sys_get_proc

# TODO: _sys_get_pid
# 1: start job
# 2: get pid with above or %last or $last_pid
# function _sys_get_pid
#     # set PID (jobs -l | awk '{print $2}') # just get the pid
#     # jobs -l | read jobid pid cpu state cmd # get all the things
# end
# funcsave _sys_get_pid

function _sys_kill_proc \
    --argument-names process
    # --description ""

    # TODO: rename for clarity
    set --local proc (_sys_get_proc $process)
    set --local pid $proc[1]
    set --local prc $proc[2]

    log4f --type=n "Killing process: \"$prc\", with pid :\"$pid\"..."

    # TODO: maybe there sometimes is a job and sometimes isn't?
    # TODO: wait pid (requires a job)
    # TODO: if job, wait, if not don't
    kill --signal KILL $pid # &

    # TODO: when run any command, something like this should run
    if [ $status -eq 0 ]
        log4f --type=n "Successfully killed process: \"$prc\", with pid :\"$pid\""
        set --local wait_secs 3
        log4f --type=n "Waiting $wait_secs seconds for death of process: \"$prc\", with pid :\"$pid\""
        sleepp $wait_secs
    else
        log4f --type=e "Failed killing process: \"$prc\", with pid :\"$pid\""
    end

    set proc (_sys_get_proc $prc)

    # TODO: if respawned
    set pid $proc[1]
    set prc $proc[2]

    log4f --type=n "Process: \"$prc\" respawned, with pid: \"$pid\""
end
funcsave _sys_kill_proc
