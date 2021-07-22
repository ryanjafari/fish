#!/opt/home/.local/bin/env /opt/home/.local/bin/bash

tailf() (
    # args: <file> [<number-of-header-lines>]
    trap 'tput csr 0 "$((LINES-1))"' INT
    tput csr "$((1+${2-1}))" "$((LINES-1))"
    tput clear
    {
        head -n"${2-1}"
        printf "%${COLUMNS}s\n" "" | tr ' ' =
        tail -n "$((LINES-1-${2-1}))" -f
    } < "/Users/ryanjafari/Code/my-fish/scripts/bash/file.txt"
)