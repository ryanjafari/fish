function d-reset --wraps='d system prune -a' --description 'alias d-reset=d system prune -a'

    printf "=> Resetting docker...\n\n"
    d system prune -a $argv
end
