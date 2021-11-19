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
    log4f --type=n "Draining node: \"$argv\"..."
    k drain $argv \
        --ignore-daemonsets="true" \
        --delete-emptydir-data="true" \
        --force="true"
end
funcsave _k8s_drain_node

function _k8s_drain_nodes \
    --description "Drain all nodes."
    log4f --type=n "Draining all nodes..."
    for node in (k get nodes -o name)
        _k8s_drain $node
    end
end
funcsave _k8s_drain_nodes
