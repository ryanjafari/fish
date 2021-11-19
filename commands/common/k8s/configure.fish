#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

function _k8s_cfg_system
    set -l KUBEADM_CONFIG "/tmp/InitConfig.yaml"

    touch $KUBEADM_CONFIG

    log4f --type=n "Printing to $KUBEADM_CONFIG..."
    kubeadm config print init-defaults \
        --component-configs="KubeProxyConfiguration,KubeletConfiguration" >$KUBEADM_CONFIG

    log4f --type=n "Setting advertiseAddress: $KUBEADM_ADV_ADDR..."
    yq -i eval \
        "select(.localAPIEndpoint.advertiseAddress) |= .localAPIEndpoint.advertiseAddress = \"$KUBEADM_ADV_ADDR\"" \
        $KUBEADM_CONFIG

    log4f --type=n "Setting criSocket: $CONTAINER_RUNTIME_ENDPOINT..."
    yq -i eval \
        "select(.nodeRegistration.criSocket) |= .nodeRegistration.criSocket = \"$CONTAINER_RUNTIME_ENDPOINT\"" \
        $KUBEADM_CONFIG

    log4f --type=n "Setting node name: $KUBEADM_NODE_NAME..."
    yq -i eval \
        "select(.nodeRegistration.name) |= .nodeRegistration.name = \"$KUBEADM_NODE_NAME\"" \
        $KUBEADM_CONFIG

    log4f --type=n "Setting kubernetesVersion: $KUBEADM_KUBE_VER..."
    yq -i eval \
        "select(di == 1) |= .kubernetesVersion = \"$KUBEADM_KUBE_VER\"" \
        $KUBEADM_CONFIG

    log4f --type=n "Setting podSubnet: $KUBEADM_POD_NETWORK_CIDR..."
    yq -i eval \
        "select(di == 1) |= .networking.podSubnet = \"$KUBEADM_POD_NETWORK_CIDR\"" \
        $KUBEADM_CONFIG

    log4f --type=n "Setting controlPlaneEndpoint: $KUBEADM_CTRL_PLN_ENDPT..."
    yq -i eval \
        "select(di == 1) |= .controlPlaneEndpoint = \"$KUBEADM_CTRL_PLN_ENDPT\"" \
        $KUBEADM_CONFIG

    log4f --type=n "Setting kubeProxy mode: $KUBE_PROXY_MODE..."
    yq -i eval \
        "select(di == 2) |= .mode = \"$KUBE_PROXY_MODE\"" \
        $KUBEADM_CONFIG

    log4f --type=n "Setting cgroupDriver: $CONTAINER_CGROUP_MANAGER..."
    yq -i eval \
        "select(di == 3) |= .cgroupDriver = \"$CONTAINER_CGROUP_MANAGER\"" \
        $KUBEADM_CONFIG

    log4f --type=n "Setting ownership for $KUBEADM_CONFIG..."
    own $KUBEADM_CONFIG

    log4f --type=n "Copying CNI configs..."
    set -l cni_cfg_files $HOME/.kube_cfg/cni/net.d/$CONTAINER_CNI_DEFAULT_NETWORK/*
    cp $cni_cfg_files "/etc/cni/net.d"
end
funcsave _k8s_cfg_system
