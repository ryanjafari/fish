function search_at_for --description 'Search starting at: $path for: $text.' --argument path text

    printf %b "=> Searching starting at: $path for: $text\n"

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

    printf %b "=> Done: sudo grep --regexp $text $path\n"
end
