log4f --type=i "Loading 🐳 Docker functions..."

# TODO: rename? subcommand?
function d-reset \
    --wraps 'd system prune -a' \
    --description 'alias d-reset=d system prune -a'
    log4f "Resetting docker...\n"
    d system prune -a $argv
end
funcsave d-reset
