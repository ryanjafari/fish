log4f --type=i "Loading 🔎 search commands..."

# TODO: progress & parallelize
# SEE: https://bit.ly/3AsuEIV
function search_at_for \
    --argument-names path text \
    --description "Search starting at: \$path for: \$text."

    log4f "Searching starting at: $path for: $text"

    sudo grep \
        --with-filename \
        --color="always" \
        --line-number \
        --initial-tab \
        --only-matching \
        --no-messages \
        --binary-files="text" \
        # TODO: difference between "read", "recurse", and "skip"?
        --directories="recurse" \
        --dereference-recursive \
        --exclude-dir="timemachine" \
        --ignore-case \
        --devices="read" \
        --regexp $text \
        $path 2>/dev/null # TODO: 2>&-

    log4f "Done: sudo grep --regexp $text $path"
end
funcsave search_at_for

# TODO: try using find?
# TODO: macOS Spotlight CLI? locate database legacy on macOS?
function search_fs_for \
    --argument-names resource \
    --description "Search the filesystem for the given resource (file or folder)."

    # Create/update the locate database:
    # refresh_locatedb

    # Search the locate database for the resource:
    log4f "Searching for resource: $resource"
    locate $resource
end
funcsave search_fs_for

# TODO: cron job
function refresh_locatedb \
    --description "Refresh the locate database."

    log4f "Refreshing the locate database..."
    log4f "Looking for the \$LOCATE_PATH environment variable..."

    # TODO: need quotes around variable?
    if test -n "$LOCATE_PATH"
        log4f "Found the \$LOCATE_PATH environment variable: $LOCATE_PATH"
        log4f "Looking for the locate database: $LOCATE_PATH"

        if test -e $LOCATE_PATH
            log4f "Found the locate database: $LOCATE_PATH"
            _update_locatedb
        else
            log4f "Missing the locate database: $LOCATE_PATH"
            _create_locatedb
        end
    else
        log4f "Missing the \$LOCATE_PATH environment variable!"
        log4f "Please define the \$LOCATE_PATH! environment variable"
        return 1
    end
end
funcsave refresh_locatedb

function _update_locatedb \
    --description="Update the locate database."

    log4f "Updating the locate database: $LOCATE_PATH"

    # TODO: do we need separate blocks for each os?
    switch $__OS
        case macos
            log4f "Updating the macOS locate database: $LOCATE_PATH"
            set -l cwd (pwd)
            cd /
            sudo updatedb
            cd $cwd
            log4f "Done: sudo updatedb"
        case linux
            log4f "Updating the Linux locate database: $LOCATE_PATH"
            sudo updatedb # TODO: or locate -u?
            log4f "Done: sudo updatedb"
        case '*'
            log4f "Warning: Unknown OS!"
    end
end
funcsave _update_locatedb

function _create_locatedb \
    --description="Create the locate database."

    log4f "Creating the locate database: $LOCATE_PATH"

    switch $__OS
        case macos
            log4f "Creating the macOS locate database: $LOCATE_PATH"
            set -l locate_plist "/System/Library/LaunchDaemons/com.apple.locate.plist"
            sudo launchctl load -w $locate_plist
            log4f "Done: sudo launchctl load -w $locate_plist"
        case linux
            log4f "Creating the Linux locate database: $LOCATE_PATH"
            sudo updatedb # TODO: or locate -u?
            log4f "Done: sudo updatedb"
        case '*'
            log4f "Warning: Unknown OS!"
    end
end
funcsave _create_locatedb
