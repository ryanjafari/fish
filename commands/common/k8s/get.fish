#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

function _k8s_get_containers \
    --argument-names argv

    argparse \
        --stop-nonopt \
        --name _k8s_get_containers \
        p/pod "l/label=" \
        -- $argv

    if count $_flag_pod >/dev/null
        log4f --type=d "Getting all containers listed by pod..."
        kubectl get pods --all-namespaces \
            -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' \
            | sort
    else if count $_flag_label >/dev/null
        log4f --type=d "Getting all containers with pod label..."
        kubectl get pods --all-namespaces \
            -o=jsonpath="{.items[*].spec.containers[*].image}" \
            -l app=nginx
    else
        log4f --type=d "Getting all containers in all namespaces..."
        k get pods --all-namespaces \
            -o jsonpath="{.items[*].spec.containers[*].image}" \
            | tr -s '[[:space:]]' '\n' | sort | uniq -c
    end
end
funcsave _k8s_get_containers
