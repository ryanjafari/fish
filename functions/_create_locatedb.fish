function _create_locatedb --description 'Create the locate database.'

    printf %b "=> Creating the locate database: $LOCATE_PATH\n"

    switch $os
        case macos
            printf %b "=> Creating the macOS locate database: $LOCATE_PATH\n"
            set -l locate_plist "/System/Library/LaunchDaemons/com.apple.locate.plist"
            sudo launchctl load -w $locate_plist
            printf %b "=> Done: sudo launchctl load -w $locate_plist\n"
        case linux
            printf %b "=> Creating the Linux locate database: $LOCATE_PATH\n"
            sudo updatedb # TODO: or locate -u?
            printf %b "=> Done: sudo updatedb\n"
        case '*'
            printf %b "=> Warning: Unknown OS!\n"
    end
end
