#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

#set -l kube_flan_man_url \
#  https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

function _k8s_init_system \
    --argument-names argv

    if count $argv >/dev/null
        set -l def_cfg $argv[1]

        log4f --type=n "Pulling required images for kubeadm"

        kubeadm config images pull \
            --config=$def_cfg \
            --cri-socket=$CONTAINER_RUNTIME_ENDPOINT \
            # --feature-gates="Strategy=RollingUpdate" \
            --image-repository="k8s.gcr.io" \
            --kubernetes-version="stable-1" \
            --kubeconfig="/etc/kubernetes/admin.conf" \
            --rootfs="/" \
            --v=5

        log4f --type=n "Running kubeadm init"
        kubeadm init \
            # --apiserver-advertise-address=$KUBEADM_ADV_ADDR \
            # --apiserver-bind-port 6443 \
            # --cert-dir="/etc/kubernetes/pki" \
            --config $def_cfg \
            # --control-plane-endpoint=$KUBEADM_CTRL_PLN_ENDPT \
            # --cri-socket=$CONTAINER_RUNTIME_ENDPOINT \
            # --feature-gates="Strategy=RollingUpdate" \
            # --image-repository="k8s.gcr.io" \
            # --kubernetes-version="stable-1" \
            --node-name=$KUBEADM_NODE_NAME \
            # --pod-network-cidr=$KUBEADM_POD_NETWORK_CIDR \
            # --service-cidr=$KUBEADM_SERVICE_NETWORK_CIDR \
            # --service-dns-domain="local" \
            # --token="" \
            --upload-certs \
            --rootfs="/" \
            --v=5
    else
        log4f --type=e "You need to specify a config file"
        # set status code
    end
end
funcsave _k8s_init_system

#log4f --type=n "Storing config made by kubeadm for kubectl..."
#mkdir -p "$HOME/.kube"
#cp -i "/etc/kubernetes/admin.conf" "$HOME/.kube/config"
#own "$HOME/.kube/config"
#log4f --type=n "Done."

#log4f --type=n "Cleaning up $init_cfg..."
#rm -f $init_cfg
#log4f --type=n "Done: rm -f $init_cfg"

#kubectl apply -f $kube_flan_man_url

#kubectl taint nodes --all node-role.kubernetes.io/master-
