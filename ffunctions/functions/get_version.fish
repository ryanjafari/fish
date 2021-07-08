function get_version --description 'Gets a version number from the command output passed as input.' --argument output

    echo -s $output | sed 's/[^0-9\.]//g'
end
