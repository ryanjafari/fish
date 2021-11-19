#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

#set -l kube_flan_man_url \
#  https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

function _k8s_init_system
    set -l kubeadm_config "/tmp/InitConfig.yaml"

    log4f --type=n "Pulling required images for kubeadm..."
    kubeadm config images pull

    log4f --type=n "Running kubeadm init..."
    kubeadm init \
        # --pod-network-cidr=$CIDR \
        --config $kubeadm_config \
        --upload-certs \
        --v=5
end
funcsave _k8s_init_system

#log4f --type=n "Storing config made by kubeadm for kubectl..."
#mkdir -p "$HOME/.kube"
#cp -i "/etc/kubernetes/admin.conf" "$HOME/.kube/config"
#own "$HOME/.kube/config"
#log4f --type=n "Done."

#log4f --type=n "Cleaning up $kubeadm_config..."
#rm -f $kubeadm_config
#log4f --type=n "Done: rm -f $kubeadm_config"

#kubectl apply -f $kube_flan_man_url

#kubectl taint nodes --all node-role.kubernetes.io/master-
