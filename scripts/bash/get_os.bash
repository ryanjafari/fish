#!/opt/home/.local/bin/env /opt/home/.local/bin/bash

function get_os_bash() {
    local retval
    
    if [ "$(uname)" == "Darwin" ]; then
        local retval="macos"
        elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        local retval="linux"
        elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        local retval="win32"
        elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        local retval="win64"
    fi
    
    echo "$retval"
}

getval=$(get_os_bash)
echo $getval
