log4f --type=i "Loading 🗂 filesystem functions..."

function own \
    --argument-names resource \
    --description "Take ownership of a file or folder (and its contents)."
    set -l file (basename $resource)
    log4f "Taking ownership of $file..."
    sudo chown -R (id -u):(id -g) $resource
    log4f "Done: sudo chown -R (id -u):(id -g) $file"
end
funcsave own

function clone_access \
    --argument-names ref dest \
    --description "Copies permissions from the \$ref resource over to the \$dest resource."
    log4f "Cloning permissions from $ref to $dest..."

    set -l savemod_pbits (stat --format "%a" $ref)
    set -l saveown_user (stat --format "%U" $ref)
    set -l saveown_group (stat --format "%G" $ref)

    # TODO: make this work for Linux
    sudo /bin/chmod -h $savemod_pbits $dest
    sudo /usr/sbin/chown -h $saveown_user:$saveown_group $dest
    log4f "Done: sudo chmod -h $savemod_pbits $dest"
    log4f "Done: sudo chown -h $saveown_user:$saveown_group $dest"
end
funcsave clone_access

# TODO: ssh_perms_fix function
# SEE: https://bit.ly/36cg4XT

# TODO: 'lsof' => https://bit.ly/3hdXpS1
#function get_open_files \
#  --argument-names program \
#  --description "Gets open files for the given program."

#  # TODO: improve this
#  $pid = ps aux | grep $program
#  ls -l /proc/($pid)/fd
#end
#funcsave get_open_files
