log4f --type=i "Loading ⚙️ system functions..."

function sys
    # TODO: inherit variable $_
    log4f --type=i "Invoking system command..."

    # set --local sys_cmd (status current-function)
    set --local sys_sub $argv[1]
    set --local sys_obj $argv[2]
    set --local sys_arg $argv[3]

    if has_arg\? $sys_sub
        log4f --type=d "Invoking with subcommand: $sys_sub"
        if has_arg\? $sys_obj
            log4f --type=d "Invoking \"sys $sys_sub\" with system object: $sys_obj"
            set --local cmd "sys_$sys_sub\_$sys_obj"
            eval $cmd $sys_arg # TODO: exec?
            # TODO: error handling
        else
            # TODO: print help in this case (look for event
            # fish_usage_err or fish_err)
            log4f --type=e "Missing system object for \"sys $sys_sub\""
            return 2
        end
    else
        echo we dont
    end
end
funcsave sys

function sys_get_cores \
    --argument-names host \
    --description "Get the number of cores for the specified host."
    log4f --type=d "Getting the number of cores for host: \"$host\""

    set --local phys_cpus 1
    set --local logi_cpus
    set --local sysct_cmd "sysctl -n machdep.cpu.core_count"

    if [ -z "$host" -o "$host" = localhost ]
        set host localhost
        log4f "Either localhost or no host was specificed: \"$host\""
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
    set --local array tim steve bob joe
    log4f -v array

    echo $num_cores
end
funcsave sys_get_cores

function sys_get_tasks \
    --description "Gets the optimal number of tasks that can be run in parallel on the machine."
    # Formula: num_of_cpu * cores_per_cpu * threads_per_core
    set -l cpu_count 1
    set -l core_count (sysctl -n machdep.cpu.core_count)
    set -l thread_count (sysctl -n machdep.cpu.thread_count)
    set -l threads_per_core (math "$thread_count / $core_count")
    set -l tasks_count (math "$cpu_count * $core_count * $threads_per_core")

    echo $tasks_count
end
funcsave sys_get_tasks
