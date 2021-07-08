function ligaturize_fonts_with --description 'Ligaturize the user fonts matching the specified regex.' --argument regex

    set -l fonts (find "$HOME/Library/Fonts" -name $regex)
    set -l root "$HOME/Code/Ligaturizer"
    set -l script "ligaturize.py"
    set -l cwd (pwd)

    cd $root
    for f in $fonts
        set -l name (basename $f | string split '.')[1]
        set -l trim (echo $name | string replace --all '-' ' ')

        fontforge \
            -lang py \
            -script $script $f 2>&1 \
            --output-dir "$root/fonts/output" \
            --output-name $trim
        # TODO: filter the above
        # | fgrep -v 'This contextual rule applies no lookups.'
        # | fgrep -v 'Bad device table'
    end
    cd $cwd
end
