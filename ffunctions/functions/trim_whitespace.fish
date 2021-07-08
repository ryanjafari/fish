function trim_whitespace
    sed -i 's/[ \t]*$//' "$argv"
    # TODO: string trim
end
