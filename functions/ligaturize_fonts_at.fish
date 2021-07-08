function ligaturize_fonts_at --description 'Ligaturize the fonts under the given directory.' --argument path

    printf %b "=> Ligaturizing fonts at: $path\n\n"

    set -l fonts (find $path -name "*.otf" -o -name "*.ttf")
    set -l root "$HOME/Code/Ligaturizer"
    set -l script "$root/ligaturize.py"
    set -l out "$path/ligaturized"

    mkdir -p $out

    for f in $fonts
        fontforge \
            -lang py \
            -script $script $f 2>&1 \
            --out-dir $out \
            | grep \
            --fixed-strings \
            --invert-match "This contextual rule applies no lookups." \
            | grep \
            --fixed-strings \
            --invert-match "Bad device table"
    end

    printf %b "=> Done ligaturizing fonts to: $out\n"
end
