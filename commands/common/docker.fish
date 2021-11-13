log4f --type=i "Loading 🐳 Docker commands..."

# TODO: rename? subcommand?
function d-reset \
    --wraps 'd system prune -a' \
    --description 'alias d-reset=d system prune -a'
    log4f "Resetting docker...\n"
    d system prune -a $argv
end
funcsave d-reset

# TODO:
# sudo su -
# systemctl stop docker-compose@*
# systemctl stop docker
# cd /var/lib/docker/
# rm -rf overlay2/*
# systemctl start docker
# sudo docker system prune -a
# destroy volumes, containers, images, etc. volumes don't seem to be destroyed?
# exit

# TODO: when running a one-off command like brew
# docker-compose down
# docker-compose run --rm
# docker-compose rm -f

# TODO: docker-compose shortcuts
