function own --description 'Take ownership of a file or folder (and its contents).' --argument resource
    set -l file (basename $resource)
    printf %b "=> Taking ownership of $file...\n"
    sudo chown -R (id -u):(id -g) $resource
    printf %b "=> Done: sudo chown -R (id -u):(id -g) $file\n"
end
