function k-drain --wraps='k drain' --description 'shorcut for kubectl drain'

    printf "Draining node ($argv)...\n"

    k drain $argv \
        --ignore-daemonsets="true" \
        --delete-emptydir-data="true" \
        --force="true"
end
