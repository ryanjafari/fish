function find_quarantined_at --description 'Find all files & folders quarantined under the given path, inclusive.' --argument path

    set -l xattr "com.apple.quarantine"

    # TODO: find -X
    find $path -print0 | xargs -0 xattr | sed -n "s/:\x20$xattr// p"
end
