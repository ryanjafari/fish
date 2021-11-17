#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

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

function _k_drain_all_nodes \
    --description "Drain all nodes."
    for node in (k get nodes -o name)
        k-drain $node
    end
end
funcsave _k_drain_all_nodes

function k-reset
    printf "=> Draining all nodes...\n"
    drain_all_nodes
    printf "=> Done: drain_all_nodes\n"

    printf "=> Resetting kubeadm...\n"
    kubeadm reset
    printf "=> Done: kubeadm reset\n"

    printf "=> Deleting /etc/cni/net.d...\n"
    rm -rf /etc/cni/net.d
    printf "=> Done: rm -rf /etc/cni/net.d\n"

    printf "=> Running iptables reset script...\n"
    net reset iptables
    printf "=> Done: iptables_reset.fish\n"

    printf "=> Deleting $HOME/.kube (config & cache)...\n"
    rm -rf $HOME/.kube
    printf "=> Done: rm -rf $HOME/.kube\n"

    printf "=> Wiping cri-o images & containers...\n"
    crio wipe --force
    printf "=> Done: crio wipe --force\n"

    # TODO: restart cri-o, but too soon
    # sleep(), restart()

    printf "=> Wiping leftover directories...\n"
    rm -rf /etc/kubernetes
    rm -rf /var/run/kubernetes
    rm -rf /var/lib/kubelet
    rm -rf /var/lib/etcd
    rm -rf /var/lib/cni
    rm -rf /var/lib/dockershim
    rm -rf /var/lib/containers
    printf "=> Done: rm -rf\n"
end
funcsave k-reset
