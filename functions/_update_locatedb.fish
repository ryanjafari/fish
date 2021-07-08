function _update_locatedb --description 'Update the locate database.'

    printf %b "=> Updating the locate database: $LOCATE_PATH\n"

    # TODO: do we need separate blocks for each os?
    switch $os
        case macos
            printf %b "=> Updating the macOS locate database: $LOCATE_PATH\n"
            set -l cwd (pwd)
            cd /
            sudo updatedb
            cd $cwd
            printf %b "=> Done: sudo updatedb\n"
        case linux
            printf %b "=> Updating the Linux locate database: $LOCATE_PATH\n"
            sudo updatedb # TODO: or locate -u?
            printf %b "=> Done: sudo updatedb\n"
        case '*'
            printf %b "=> Warning: Unknown OS!\n"
    end
end
