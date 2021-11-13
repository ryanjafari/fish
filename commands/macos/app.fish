# log4f --type=i "Loading 💻 macOS-specific app functions..."

# function app \
#     --argument-names argv
#     # --inherit-variable $_ \
#     # --description ""
#     handle_subcommand app $argv
# end
# funcsave app

# function app
#     # --argument-names argv
#     #--description
#     # argparse \
#     #     --stop-nonopt \
#     #     --name app \
#     #     # "t/tab=?" v/var \
#     #     -- $argv

#     # log4f_var "argv[1]"

#     if set -q argv[1]
#         if not set -q argv[2]
#             # TODO: research >&2, etc.
#             # echo "error: usage..." >&2
#             return 2
#         else
#             # log4f "second argument is: $argv[2]"
#         end

#         set --local sub $argv[1]
#         # log4f_var sub
#         switch $sub
#             case is
#                 # log4f "subcommand: is"
#             case get
#                 # log4f "subcommand: get"
#                 # log4f_var argv
#                 if set -q argv[2]
#                     # log4f exists
#                     set --local prop $argv[2]
#                     switch $prop
#                         case src source
#                             # log4f "property: $prop"
#                             if set -q argv[3]
#                                 set --local app $argv[3]
#                                 # log $app
#                                 _app_get_source $app
#                             else
#                             end
#                         case '*'
#                             # log4f "property: $prop unknown"
#                     end
#                 end
#             case '*'
#                 # log4f "subcommand: $sub unknown"
#         end
#     end
# end
# funcsave app

# function _app_get_source \
#     --argument-names app \
#     --no-scope-shadowing
#     # log4f "func: _app_get_source"
#     # logv app
#     # TODO: if requisites are not installed?
#     # brew, mas, setapp, internet (downloaded)
#     _app_is_from_homebrew\?
#     # _app_is_from_setapp
#     # _app_is_from_appstore
#     # _app_is_from_internet
# end
# funcsave _app_get_source

# function _app_is_from_homebrew\?
#     # log4f "func: _app_is_from_homebrew?"
#     set --local casks (brew list --cask)
#     # log4f --var casks
# end
# funcsave _app_is_from_homebrew\?

# function get_bundleid_for \
#     --argument-names macos_app \
#     --description "Get the bundle identifier of a macOS application."
#     osascript -e "id of app \"$macos_app\""
# end
# funcsave get_bundleid_for
