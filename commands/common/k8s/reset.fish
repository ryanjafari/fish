#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

function _k8s_reset_system
    k8s drain nodes

    log4f --type=n "Resetting kubeadm..."
    kubeadm reset

    log4f --type=n "Removing /etc/cni/net.d..."
    rm -rf /etc/cni/net.d

    net reset iptables

    log4f --type=n "Stopping kubelet..."
    service --ifstarted --quiet kubelet stop

    log4f --type=n "Removing $HOME/.kube (config & cache)..."
    rm -rf $HOME/.kube

    log4f --type=n "Stopping cri-o..."
    service --ifstarted --quiet crio stop

    log4f --type=n "Force wiping cri-o images & containers..."
    crio wipe --force

    # log4f --type=n "Starting cri-o..."
    # service --ifstopped --quiet crio start

    # TODO: restart cri-o, but too soon
    # sleep(), restart()

    # log4f --type=n "Removing leftover directories..."
    # rm -rf /etc/kubernetes
    # rm -rf /var/run/kubernetes
    # rm -rf /var/lib/kubelet >/dev/null 2>&1
    # rm -rf /var/lib/etcd
    # rm -rf /var/lib/cni
    # rm -rf /var/lib/dockershim
    # rm -rf /var/lib/containers >/dev/null 2>&1
end
funcsave _k8s_reset
