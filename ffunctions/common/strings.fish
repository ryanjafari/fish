# TODO: remove --
alias --save strc "string collect --"
alias --save stre "string escape --"
alias --save strm "string trim"
alias --save strj "string join --"
alias --save strr "string repeat"
alias --save strs "string split $argv --"
alias --save strp "string pad" # OK
alias --save strl "string length"

# TODO: fish vendor folder?
# TODO: https://bit.ly/3rsbRcx
# function str --wraps=string
#     if set -q argv[1]; and [ $argv[1] = is ]
#         if not set -q argv[2]
#             echo "error: usage..." >&2
#             return
#         end
#         set -l pattern
#         switch $argv[2]
#             case int integer
#                 set pattern '^[+-]?\d+$'
#             case hex hexadecimal xdigit
#                 set pattern '^[[:xdigit:]]+$'
#             case oct octal
#                 set pattern '^[0-7]+$'
#             case bin binary
#                 set pattern '^[01]+$'
#             case float double
#                 set pattern '^[+-]?(?:\d+(\.\d+)?|\.\d+)$'
#             case alpha
#                 set pattern '^[[:alpha:]]+$'
#             case alnum
#                 set pattern '^[[:alnum:]]+$'
#             case '*'
#                 echo "unknown class..." >&2
#                 return
#         end
#         set argv match --quiet --regex -- $pattern $argv[3]
#     end
#     builtin string $argv
# end
# funcsave str
