#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

function k8s \
    --argument-names argv
    # --inherit-variable $_ \
    # --description ""
    handle_subcommand k8s $argv
end
funcsave k8s

function _k8s_drain_node \
    --wraps "k drain" \
    --description "shorcut for kubectl drain"
    log4f --type=i "Draining node: \"$argv\"..."
    k drain $argv \
        --ignore-daemonsets="true" \
        --delete-emptydir-data="true" \
        --force="true" 2>/dev/null
end
funcsave _k8s_drain_node

function _k8s_drain_nodes \
    --description "Drain all nodes."
    log4f --type=i "Draining all nodes..."
    set -l nodes (k get nodes -o name 2>/dev/null)

    if test -n "$nodes"
        for node in nodes
            _k8s_drain_node $node
        end
    else
        log4f --type=e "There aren't any nodes to drain!"
    end
end
funcsave _k8s_drain_nodes
