#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

set -l KUBEADM_CONFIG "/tmp/InitConfig.yaml"

touch $KUBEADM_CONFIG

printf "=> Printing to $KUBEADM_CONFIG...\n"
kubeadm config print init-defaults \
    --component-configs="KubeProxyConfiguration,KubeletConfiguration" >$KUBEADM_CONFIG
printf "=> Done: kubeadm config print init-defaults\n"

printf "=> Setting advertiseAddress: $KUBEADM_ADV_ADDR...\n"
yq -i eval \
    "select(.localAPIEndpoint.advertiseAddress) |= .localAPIEndpoint.advertiseAddress = \"$KUBEADM_ADV_ADDR\"" \
    $KUBEADM_CONFIG
printf "=> Done: yq -i eval\n"

printf "=> Setting criSocket: $CONTAINER_RUNTIME_ENDPOINT...\n"
yq -i eval \
    "select(.nodeRegistration.criSocket) |= .nodeRegistration.criSocket = \"$CONTAINER_RUNTIME_ENDPOINT\"" \
    $KUBEADM_CONFIG
printf "=> Done: yq -i eval\n"

printf "=> Setting node name: $KUBEADM_NODE_NAME...\n"
yq -i eval \
    "select(.nodeRegistration.name) |= .nodeRegistration.name = \"$KUBEADM_NODE_NAME\"" \
    $KUBEADM_CONFIG
printf "=> Done: yq -i eval\n"

printf "=> Setting kubernetesVersion: $KUBEADM_KUBE_VER...\n"
yq -i eval \
    "select(di == 1) |= .kubernetesVersion = \"$KUBEADM_KUBE_VER\"" \
    $KUBEADM_CONFIG
printf "=> Done: yq -i eval\n"

printf "=> Setting podSubnet: $KUBEADM_POD_NETWORK_CIDR...\n"
yq -i eval \
    "select(di == 1) |= .networking.podSubnet = \"$KUBEADM_POD_NETWORK_CIDR\"" \
    $KUBEADM_CONFIG
printf "=> Done: yq -i eval\n"

printf "=> Setting controlPlaneEndpoint: $KUBEADM_CTRL_PLN_ENDPT...\n"
yq -i eval \
    "select(di == 1) |= .controlPlaneEndpoint = \"$KUBEADM_CTRL_PLN_ENDPT\"" \
    $KUBEADM_CONFIG
printf "=> Done: yq -i eval\n"

printf "=> Setting kubeProxy mode: $KUBE_PROXY_MODE...\n"
yq -i eval \
    "select(di == 2) |= .mode = \"$KUBE_PROXY_MODE\"" \
    $KUBEADM_CONFIG
printf "=> Done: yq -i eval\n"

printf "=> Setting cgroupDriver: $CONTAINER_CGROUP_MANAGER...\n"
yq -i eval \
    "select(di == 3) |= .cgroupDriver = \"$CONTAINER_CGROUP_MANAGER\"" \
    $KUBEADM_CONFIG
printf "=> Done: yq -i eval\n"

printf "=> Setting ownership for $KUBEADM_CONFIG...\n"
own $KUBEADM_CONFIG
printf "=> Done: own $KUBEADM_CONFIG\n"

printf "=> Copying CNI configs...\n"
mkdir -p "/etc/cni/net.d"
cp $KUBE_CONFIG_ROOT/cni/net.d/$CONTAINER_CNI_DEFAULT_NETWORK/* "/etc/cni/net.d"
printf "=> Done.\n"
