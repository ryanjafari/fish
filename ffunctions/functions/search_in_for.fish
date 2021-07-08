function search_in_for --description 'Search starting at: $path for: $text.' --argument path text

    # TODO: ignore case with -i flag or no?
    # TODO: -s or 2> /dev/null?
    # TODO: long form flags
    # TODO: -H -i
    printf %b "=> Searching starting at: $path for: $text\n"
    sudo ggrep --color -rnw $path -e $text
    printf %b "=> Done: sudo ggrep --color -rnwi -H $path -e $text\n"
end
