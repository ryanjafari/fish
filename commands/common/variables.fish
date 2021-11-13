# log4f --type=e "Loading 𝒙 'setv' variable function..."

# alias --save setl "set --local"

# function setv \
#     --argument-names argv \
#     # --no-scope-shadowing \
#     --description "Sets a variable with a custom prefix."
#     # log4f "Setting variable with prefix (if needed)."

#     # TODO: fish_opt
#     argparse \
#         --stop-nonopt \
#         --name setv \
#         g/global l/local x/export unpath \
#         -- $argv

#     # if args exist

#     set --local prefix usr
#     set --local g $_flag_g || $_flag_global
#     set --local l $_flag_l || $_flag_local
#     set --local x $_flag_x || $_flag_export
#     set --local u $_flag_unpath
#     set --local n $argv[1]
#     set --local v $argv[2]

#     if [ -n "$x" ]
#         set n (string join '_' $prefix $n)
#         # log4f -t "joined: $n"
#         set n (string upper $n)
#         # log4f -t "upper: $n"
#     end

#     set --local opts (strc $g $l $x $u $n $v)
#     # log4f --tab "Collected options for set: $opts"

#     set --local cmd "set $opts"
#     # log4f --tab "Final set command is: $cmd"
#     # log4f --tab "Setting variable with: $cmd"
#     set $g $l $x $u -- $n $v
#     # log4f_var "$n"
#     # $cmd
# end
# funcsave setv

# TODO: set local variable shortcut?
# function setl

# end
# funcsave setl

# TODO: retrieve var functions

# function ifv \
#     --argument-names cool \
#     --no-scope-shadowing \
#     --description "Will return the value of the variable iff it exists."
#     # set --local retvar

#     if set -q cool
#         set --local a (set --show cool)
#         if [ -n "$cool" ]
#             # log4f "var is defined and expands to a non-empty string"
#             # log4f "~~~> $a"
#             #echo -s option
#             echo -ns (trim "$cool")
#         else
#             # log4f "var is defined BUT is an empty string"
#             # log4f "xxxx >$a"
#             # set retvar ''
#         end
#         # log4f "var is defined and value is: $var"

#         #set --local trimmed (string trim )
#     else
#         # log4f "!!!!!! var is not defined"
#     end

#     # echo $retvar
# end
# funcsave ifv
