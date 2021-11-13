log4f --type=i "Loading ⎈ Kubernetes commands..."

function k-drain \
    --wraps "k drain" \
    --description "shorcut for kubectl drain"
    log4f "Draining node ($argv)..."
    k drain $argv \
        --ignore-daemonsets="true" \
        --delete-emptydir-data="true" \
        --force="true"
end
funcsave k-drain

function drain_all_nodes \
    --description "Drain all nodes."
    for node in (k get nodes -o name)
        k-drain $node
    end
end
funcsave drain_all_nodes
