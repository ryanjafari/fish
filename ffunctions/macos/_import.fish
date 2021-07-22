# log4f --type=i "Loading 💻 macOS-specific functions..."

# set --local --unpath macos_path "$ffs_path/macos"

# source "$macos_path/app.fish"

# TODO: command not installed hook?

# # TODO: make this into a microservice
# # SEE: https://apple.co/3wa8tDR
# function search_itunes_for \
#     # kind: ios | ipados | macos
#     --argument-names app kind \
#     --description "Search the iTunes Search API for software matching the app and software kind specified."

#     set -l entity ""

#     switch $kind
#         case ios
#             set entity software
#         case ipados
#             set entity iPadSoftware
#         case macos
#             set entity macSoftware
#         case '*'
#             log4f "=> Unknown software kind, defaulting to iOS...\n"
#             set kind ios
#             set entity software
#     end

#     log4f "Searching for software with name: \"$app\" and of type: \"$kind\""
#     log4f "Constructing API request..."

#     set -l itunes_api_endpoint "https://itunes.apple.com/search"
#     set -l media software
#     set -l country US
#     set -l lang en_us
#     set -l explicit No
#     set -l limit 3
#     set -l url "$itunes_api_endpoint?term=$app&entity=$entity&media=$media&country=$country&lang=$lang&explicit=$explicit&limit=$limit"

#     log4f "Constructed API request: \$url"
#     log4f "Making API request..."

#     set -l json (curl \
#       --silent \
#       --header "Accept: application/json" \
#       $url)

#     log4f "Done: curl --silent --header \$url"
#     log4f "Parsing API response..."

#     set -l filter_top ".results[0].bundleId"
#     set -l filter_all ".results[] | { trackId: .trackId, trackName: .trackName, trackViewUrl: .trackViewUrl, bundleId: .bundleId }"
#     set -l result_count (echo $json | jq ".resultCount")
#     set -l result_top (echo $json | jq $filter_top | string trim --chars="\"")
#     set -l results_all (echo $json | jq $filter_all | string join "\n")

#     log4f "Done: jq \$filter_top"
#     log4f "Done: jq \$filter_all\n"

#     log4f "API request: $url\n"
#     log4f "# of results: $result_count\n"
#     log4f "top result: app://$result_top\n"
#     log4f "$results_all\n"

#     log4f "Done: search_itunes_for \"$app\" \"$kind\""
# end
# funcsave search_itunes_for

# function find_quarantined_at \
#     --argument-names path \
#     --description "Find all files & folders quarantined under the given path, inclusive."
#     set -l xattr "com.apple.quarantine"
#     # TODO: find -X
#     find $path -print0 | xargs -0 xattr | sed -n "s/:\x20$xattr// p"
# end
# funcsave find_quarantined_at

# function ligaturize_fonts_at \
#     --argument-names path \
#     --description "Ligaturize the fonts under the given directory."

#     log4f "Ligaturizing fonts at: $path\n"

#     set -l fonts (find $path -name "*.otf" -o -name "*.ttf")
#     set -l root "$HOME/Code/Ligaturizer"
#     set -l script "$root/ligaturize.py"
#     set -l out "$path/ligaturized"

#     mkdir -p $out

#     for f in $fonts
#         fontforge \
#             -lang py \
#             -script $script $f 2>&1 \
#             --out-dir $out \
#             | grep \
#             --fixed-strings \
#             --invert-match "This contextual rule applies no lookups." \
#             | grep \
#             --fixed-strings \
#             --invert-match "Bad device table"
#     end

#     log4f "Done ligaturizing fonts to: $out"
# end
# funcsave ligaturize_fonts_at

# # SEE: https://git.io/Jc9vp
# # function nerd_font_patch_with \
# #     --argument-names regex \
# #     --description "Nerd Font patch the fonts under the given directory."
# #     # ./font-patcher $f
# # end
# # funcsave nerd_font_patch_with

# # TODO: refactor into more utility functions:
# # function rename \
# #     --argument-names app to \
# #     --description "Rename an application \$app to the name specified \$to."

# #     set -l --unpath curr_app_path "/Applications/$app.app"
# #     set -l --unpath new_app_path "/Applications/$to.app"

# #     # Search for app:

# #     log4f "Searching for app: $curr_app_path"

# #     if test -e $curr_app_path
# #         # Move app:
# #         log4f "Found app: $curr_app_path"
# #         log4f "Renaming $app.app to $to.app..."
# #         mv $curr_app_path $new_app_path
# #         log4f "Renamed $app.app to $to.app"
# #         log4f "Done: mv $curr_app_path $new_app_path"
# #     else
# #         log4f "Couldn't find app: $curr_app_path!"
# #         log4f "Exiting..."
# #         return 1
# #     end

# #     set -l contents_path --unpath "$new_app_path/Contents"
# #     set -l plist_path --unpath "$contents_path/Info.plist"
# #     set -l PlistBuddy /usr/libexec/PlistBuddy
# #     set -l curr_name ($PlistBuddy $plist_path -c "Print :CFBundleName")

# #     # Find name:

# #     log4f "Finding current name: $curr_name"

# #     if test -n "$curr_name"
# #         # Set name:
# #         log4f "Found current name: $curr_name"
# #         log4f "Setting new name: $to"
# #         $PlistBuddy $plist_path -c "Set :CFBundleName $to"
# #         log4f "Set new name: $to"
# #         log4f "Done: $PlistBuddy <path> -c \"Set :CFBundleName $to\""
# #     else
# #         log4f "Couldn't find current name!"
# #         log4f "Exiting..."
# #         return 1
# #     end

# #     set -l curr_url ($PlistBuddy $plist_path -c "Print :CFBundleURLTypes:0:CFBundleURLSchemes:0")
# #     set -l new_url (echo $to | string lower | string split ' ' | string join -)

# #     # Find URL scheme:

# #     log4f "Finding current URL scheme: $curr_url"

# #     if test -n "$curr_url"
# #         # Set URL scheme:
# #         log4f "Found current URL scheme: $curr_url"
# #         log4f "Setting new URL scheme: $new_url"
# #         $PlistBuddy $plist_path -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $new_url"
# #         log4f "Set new URL scheme: $new_url"
# #         log4f "one: $PlistBuddy <path> -c \"Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $new_url\""
# #     else
# #         log4f "Couldn't find current URL scheme!"
# #         log4f "Non-fatal. Continuing..."
# #     end

# #     set -l strings_path --unpath "$contents_path/Resources/en.lproj/InfoPlist.strings"
# #     set -l curr_name ($PlistBuddy $strings_path -c "Print :CFBundleName")

# #     # Find (localized) name:

# #     log4f "Finding current (localized) name..."

# #     if test -n "$curr_name"
# #         # Set (localized) name:
# #         log4f "Found current (localized) name: $curr_name"
# #         log4f "Setting new (localized) name: $to"
# #         $PlistBuddy $strings_path -c "Set :CFBundleName $to"
# #         log4f "Set new (localized) name: $to"
# #         log4f "Done: $PlistBuddy <path> -c \"Set :CFBundleName $to\""
# #     else
# #         log4f "Couldn't find current (localized) name!"
# #         log4f "Non-fatal. Continuing..."
# #     end

# #     # Make sure nothing weird happened with permissions:
# #     own $new_app_path

# #     # Editing the above files causes macOS to quarantine
# #     # the app, rendering it unusable. Remove all its files
# #     # from quarantine so we can launch the app again:
# #     set -l quarantined (find_quarantined_at $new_app_path)

# #     log4f "Done: $app.app fully renamed to $to.app"
# # end
# # funcsave rename

# # function unset_hostname
# #     # TODO: delete data from:
# #     # /Library/Preferences/SystemConfiguration/preferences.plist
# #     # dscacheutil -flushcache
# #     # reboot
# # end
# # funcsave unset_hostname
