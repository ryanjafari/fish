# log4f --type=i "Loading 🛠 utility functions..."

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

function get_os \
    --description "Get the current OS." \
    --no-scope-shadowing

    #log4f --type=e "get os logging"
    # set --local os ($HOME/.config/fish/scripts/bash/get_os.bash)
    echo macos
end
funcsave get_os

function num_parallel_tasks \
    --description "Gets the optimal number of tasks that can be run in parallel on the machine."
    # Formula: num_of_cpu * cores_per_cpu * threads_per_core
    set -l cpu_count 1
    set -l core_count (sysctl -n machdep.cpu.core_count)
    set -l thread_count (sysctl -n machdep.cpu.thread_count)
    set -l threads_per_core (math "$thread_count / $core_count")
    set -l tasks_count (math "$cpu_count * $core_count * $threads_per_core")

    echo $tasks_count
end
funcsave num_parallel_tasks

function get_num_cores \
    --argument-names host \
    --description "Get the number of cores for the specified host."
    log4f --type=d "Getting the number of cores for host: $host"

    set -l phys_cpus 1
    set -l logi_cpus ""
    # set -l sysct_cmd ""

    if [ -z "$host" -o "$host" = localhost ]
        set host localhost
        log4f "Either localhost or no host was specificed: $host"
        set logi_cpus (sysctl -n machdep.cpu.core_count)
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
funcsave get_num_cores

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
function is_terminal
    isatty
    # isatty stdout
    # status is-interactive
end
funcsave is_terminal
