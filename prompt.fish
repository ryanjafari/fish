log4f --type=i "Loading 🚸 cross-OS prompt..."

# TODO: --on-event fish_prompt
function fish_prompt
    set cmd powerline-go \
        -alternate-ssh-icon \
        -colorize-hostname \
        -condensed \
        #-cwd-max-depth int \
        #-cwd-max-dir-size int \
        -error $status \
        -eval \
        # TODO: decide if i want this. what is it?
        #-jobs (jobs -p | wc -l) \
        -max-width 75 \
        # TODO: module customization?
        # I can do whatever. See powerline-go docs.
        # TODO: available modules? all used?
        -modules "root,user,shell-var,dotenv,ssh,host,cwd,git,docker,docker-context,kube,terraform-workspace,time,exit" \
        #-modules "venv,perms,jobs,load,shenv" \
        #-modules-right \
        #-path-aliases \
        # TODO: available priorities? all used?
        -priority "root,user,shell-var,dotenv,ssh,host,cwd,cwd-path,git,git-branch,git-status,docker,docker-context,kube,terraform-workspace,time,exit" \
        #-priority "perms,jobs" \
        -shell bare \
        -shell-var MF_FISH_VERSION \
        #-static-prompt-indicator \
        -truncate-segment-width 8
    eval $cmd
end
funcsave fish_prompt
