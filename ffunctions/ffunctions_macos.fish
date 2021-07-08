#!/usr/bin/env fish

printf %b "=> Loading macOS-specific functions...\n"

function get_bundleid_for \
    --argument-names macos_app \
    --description "Get the bundle identifier of a macOS application."

    osascript -e "id of app \"$macos_app\""
end

funcsave get_bundleid_for

# TODO: make this into a microservice
# SEE: https://apple.co/3wa8tDR
function search_itunes_for \
    # kind: ios | ipados | macos
    --argument-names app kind \
    --description "Search the iTunes Search API for software matching the app and software kind specified."

    set -l entity ""

    switch $kind
        case ios
            set entity software
        case ipados
            set entity iPadSoftware
        case macos
            set entity macSoftware
        case '*'
            printf %b "=> Unknown software kind, defaulting to iOS...\n"
            set kind ios
            set entity software
    end

    printf %b "=> Searching for software with name: \"$app\" and of type: \"$kind\"\n"
    printf %b "=> Constructing API request...\n"

    set -l itunes_api_endpoint "https://itunes.apple.com/search"
    set -l media software
    set -l country US
    set -l lang en_us
    set -l explicit No
    set -l limit 3
    set -l url "$itunes_api_endpoint?term=$app&entity=$entity&media=$media&country=$country&lang=$lang&explicit=$explicit&limit=$limit"

    printf %b "=> Constructed API request: \$url\n"
    printf %b "=> Making API request...\n"

    set -l json (curl \
      --silent \
      --header "Accept: application/json" \
      $url)

    printf %b "=> Done: curl --silent --header \$url\n"
    printf %b "=> Parsing API response...\n"

    set -l filter_top ".results[0].bundleId"
    set -l filter_all ".results[] | { trackId: .trackId, trackName: .trackName, trackViewUrl: .trackViewUrl, bundleId: .bundleId }"
    set -l result_count (echo $json | jq ".resultCount")
    set -l result_top (echo $json | jq $filter_top | string trim --chars="\"")
    set -l results_all (echo $json | jq $filter_all | string join "\n")

    printf %b "=> Done: jq \$filter_top\n"
    printf %b "=> Done: jq \$filter_all\n\n"

    printf %b "API request: $url\n\n"
    printf %b "# of results: $result_count\n"
    printf %b "top result: app://$result_top\n\n"
    printf %b "$results_all\n\n"

    printf %b "=> Done: search_itunes_for \"$app\" \"$kind\"\n"
end

funcsave search_itunes_for

function find_quarantined_at \
    --argument-names path \
    --description "Find all files & folders quarantined under the given path, inclusive."

    set -l xattr "com.apple.quarantine"

    # TODO: find -X
    find $path -print0 | xargs -0 xattr | sed -n "s/:\x20$xattr// p"
end

funcsave find_quarantined_at

# SEE: https://git.io/Jc9vp
# function nerd_font_patch_with \
#     --argument-names regex \
#     --description "Nerd Font patch the fonts under the given directory."
#     # ./font-patcher $f
# end

# funcsave nerd_font_patch_with

function ligaturize_fonts_at \
    --argument-names path \
    --description "Ligaturize the fonts under the given directory."

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

funcsave ligaturize_fonts_at

# TODO: refactor into more utility functions:
# function rename \
#     --argument-names app to \
#     --description "Rename an application \$app to the name specified \$to."

#     set -l curr_app_path "/Applications/$app.app"
#     set -l new_app_path "/Applications/$to.app"

#     # Search for app:

#     printf %b "=> Searching for app: $curr_app_path\n"

#     if test -e $curr_app_path
#         # Move app:
#         printf %b "=> Found app: $curr_app_path\n"
#         printf %b "=> Renaming $app.app to $to.app...\n"
#         mv $curr_app_path $new_app_path
#         printf %b "=> Renamed $app.app to $to.app\n"
#         printf %b "=> Done: mv $curr_app_path $new_app_path\n"
#     else
#         printf %b "=> Couldn't find app: $curr_app_path!\n"
#         printf %b "=> Exiting...\n"
#         return 1
#     end

#     set -l contents_path "$new_app_path/Contents"
#     set -l plist_path "$contents_path/Info.plist"
#     set -l PlistBuddy /usr/libexec/PlistBuddy
#     set -l curr_name ($PlistBuddy $plist_path -c "Print :CFBundleName")

#     # Find name:

#     printf %b "=> Finding current name: $curr_name\n"

#     if test -n "$curr_name"
#         # Set name:
#         printf %b "=> Found current name: $curr_name\n"
#         printf %b "=> Setting new name: $to\n"
#         $PlistBuddy $plist_path -c "Set :CFBundleName $to"
#         printf %b "=> Set new name: $to\n"
#         printf %b "=> Done: $PlistBuddy <path> -c \"Set :CFBundleName $to\"\n"
#     else
#         printf %b "=> Couldn't find current name!\n"
#         printf %b "=> Exiting...\n"
#         return 1
#     end

#     set -l curr_url ($PlistBuddy $plist_path -c "Print :CFBundleURLTypes:0:CFBundleURLSchemes:0")
#     set -l new_url (echo $to | string lower | string split ' ' | string join -)

#     # Find URL scheme:

#     printf %b "=> Finding current URL scheme: $curr_url\n"

#     if test -n "$curr_url"
#         # Set URL scheme:
#         printf %b "=> Found current URL scheme: $curr_url\n"
#         printf %b "=> Setting new URL scheme: $new_url\n"
#         $PlistBuddy $plist_path -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $new_url"
#         printf %b "=> Set new URL scheme: $new_url\n"
#         printf %b "=> Done: $PlistBuddy <path> -c \"Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $new_url\"\n"
#     else
#         printf %b "=> Couldn't find current URL scheme!\n"
#         printf %b "=> Non-fatal. Continuing...\n"
#     end

#     set -l strings_path "$contents_path/Resources/en.lproj/InfoPlist.strings"
#     set -l curr_name ($PlistBuddy $strings_path -c "Print :CFBundleName")

#     # Find (localized) name:

#     printf %b "=> Finding current (localized) name...\n"

#     if test -n "$curr_name"
#         # Set (localized) name:
#         printf %b "=> Found current (localized) name: $curr_name\n"
#         printf %b "=> Setting new (localized) name: $to\n"
#         $PlistBuddy $strings_path -c "Set :CFBundleName $to"
#         printf %b "=> Set new (localized) name: $to\n"
#         printf %b "=> Done: $PlistBuddy <path> -c \"Set :CFBundleName $to\"\n"
#     else
#         printf %b "=> Couldn't find current (localized) name!\n"
#         printf %b "=> Non-fatal. Continuing...\n"
#     end

#     # Make sure nothing weird happened with permissions:
#     own $new_app_path

#     # Editing the above files causes macOS to quarantine
#     # the app, rendering it unusable. Remove all its files
#     # from quarantine so we can launch the app again:
#     set -l quarantined (find_quarantined_at $new_app_path)

#     printf %b "=> Done: $app.app fully renamed to $to.app\n"
# end

# funcsave rename

# function unset_hostname
#     # TODO: delete data from:
#     # /Library/Preferences/SystemConfiguration/preferences.plist
#     # dscacheutil -flushcache
#     # reboot
# end

# funcsave unset_hostname
