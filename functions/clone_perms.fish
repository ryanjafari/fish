function clone_perms --description 'Copies permissions from the $ref resource over to the $dest resource.' --argument ref dest
    printf %b "=> Cloning permissions from $ref to $dest...\n"
    chmod --reference=$ref $dest
    sudo chown --reference=$ref $dest
    printf %b "=> Done: chmod --reference=$ref $dest\n"
end
