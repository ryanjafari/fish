#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

function _k8s_reset_system
    k8s drain nodes

    log4f --type=n "Resetting kubeadm..."
    kubeadm reset \
        --cert-dir /etc/kubernetes/pki \
        --cri-socket $CONTAINER_RUNTIME_ENDPOINT \
        --force true \
        --kubeconfig $KUBECONFIG \
        --rootfs / >/dev/null 2>&1 # experimental!

    log4f --type=n "Resetting etcd..."
    rm -rf "/var/lib/etcd/*"

    log4f --type=i "Ensuring kubernetes config is cleared..."
    rm -rf "/etc/kubernetes/*"

    log4f --type=i "Ensuring stateful directories are cleared..."
    rm -rf "/var/lib/kubelet/*"
    rm -rf "/var/lib/dockershim/*"
    rm -rf "/var/run/kubernetes/*"
    rm -rf "/var/lib/cni/*"

    log4f --type=i "Cleaning CNI config..."
    rm -rf "/etc/cni/net.d/*"

    net reset iptables

    log4f --type=i "Cleaning kubeconfig files (config & cache)..."
    rm -rf "$HOME/.kube/*"

    log4f --type=i "Force wiping cri-o images & containers..."
    set -l pid (pidof (crio wipe --force 2>/dev/null))
    rm -rf "/var/run/containers/*"
    rm -rf "/var/lib/containers/*" # "/var/lib/containers/storage/*"

    log4f --type=n "Restarting cri-o..."
    service --quiet crio restart

    log4f --type=n "Restarting networking..."
    service --quiet networking restart 2>/dev/null

    log4f --type=i "Ensure defaults.yaml is wiped out..."
    rm -rf "$HOME/.k8s/kubeadm/defaults.yaml"

    # reboot
end
funcsave _k8s_reset_system
