#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

function _k8s_update_configmap \
    --argument-names argv
    k create cm configmap \
        --from-file="$argv" \
        --dry-run="client" \
        -o yaml | k apply -f -
end
funcsave _k8s_update_configmap
