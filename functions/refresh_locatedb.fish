function refresh_locatedb --description 'Refresh the locate database.'

    printf %b "=> Refreshing the locate database...\n"
    printf %b "=> Looking for the \$LOCATE_PATH environment variable...\n"

    # TODO: need quotes around variable?
    if test -n "$LOCATE_PATH"
        printf %b "=> Found the \$LOCATE_PATH environment variable: $LOCATE_PATH\n"
        printf %b "=> Looking for the locate database: $LOCATE_PATH\n"

        if test -e $LOCATE_PATH
            printf %b "=> Found the locate database: $LOCATE_PATH\n"
            _update_locatedb
        else
            printf %b "=> Missing the locate database: $LOCATE_PATH\n"
            _create_locatedb
        end
    else
        printf %b "=> Missing the \$LOCATE_PATH environment variable!\n"
        printf %b "=> Please define the \$LOCATE_PATH! environment variable\n"
        return 1
    end
end
