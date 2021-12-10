#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

# separate modifications from additions

function _k8s_cfg_yq \
    --argument-names argv
    set -l query $argv[1]
    set -l cfg $argv[2]

    log4f --type=d "Running $query..."
    yq -i eval \
        $query \
        $cfg
end
funcsave _k8s_cfg_yq

set --global def_cfg "$HOME/.k8s/kubeadm/defaults.yaml"

function _k8s_cfg_init
    touch $def_cfg

    log4f --type=n "Setting ownership for $def_cfg"
    own $def_cfg

    log4f --type=n "Printing default init configuration for kubeadm"
    kubeadm config print init-defaults \
        --component-configs="KubeProxyConfiguration,KubeletConfiguration" \
        --kubeconfig="/etc/kubernetes/admin.conf" \
        # --v=5 \
        --rootfs="/" >$def_cfg

    log4f --type=n "Applying changes to InitConfig"
    k8s cfg yq "select(.localAPIEndpoint.advertiseAddress) |= .localAPIEndpoint.advertiseAddress = \"$KUBEADM_ADV_ADDR\"" $def_cfg
    k8s cfg yq "select(.nodeRegistration.criSocket) |= .nodeRegistration.criSocket = \"$CONTAINER_RUNTIME_ENDPOINT\"" $def_cfg
    k8s cfg yq "select(.nodeRegistration.imagePullPolicy) |= .nodeRegistration.imagePullPolicy = \"Always\"" $def_cfg
    k8s cfg yq "select(.nodeRegistration.name) |= .nodeRegistration.name = \"$KUBEADM_NODE_NAME\"" $def_cfg

    # use a list for kubeletExtraArgs
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.cgroup-driver = \"$CONTAINER_CGROUP_MANAGER\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.cloud-config = \"\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.cloud-provider = \"\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.provider-id = \"\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.cluster-dns = \"10.96.0.10\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.cluster-domain = \"$KUBEADM_CLUSTER_DOMAIN\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.cni-bin-dir = \"/opt/cni/bin\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.cni-cache-dir = \"/var/lib/cni/cache\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.cni-conf-dir = \"/etc/cni/net.d\"" $def_cfg
    # k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.config = \"/tmp/InitConfig.yaml\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.container-runtime = \"$CONTAINER_RUNTIME\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.container-runtime-endpoint = \"$CONTAINER_RUNTIME_ENDPOINT\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.enable-server = \"true\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.hostname-override = \"$KUBEADM_NODE_NAME\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.network-plugin = \"crio\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.node-ip = \"$KUBEADM_NODE_IP\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.address = \"$KUBEADM_NODE_IP\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.pod-cidr = \"$KUBEADM_POD_NETWORK_CIDR\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.port = \"10250\"" $def_cfg
    k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.register-node = \"true\"" $def_cfg
    # k8s cfg yq "select(di == 0) |= .nodeRegistration.kubeletExtraArgs.service-dns-domain = \"local\"" $def_cfg
end
funcsave _k8s_cfg_init

function _k8s_cfg_cluster
    log4f --type=n "Applying changes to ClusterConfig"

    k8s cfg yq "select(di == 1) |= .controlPlaneEndpoint = \"$KUBEADM_CTRL_PLN_ENDPT\"" $def_cfg
    k8s cfg yq "select(di == 1) |= .kubernetesVersion = \"$KUBEADM_KUBE_VER\"" $def_cfg
    k8s cfg yq "select(di == 1) |= .networking.dnsDomain = \"$KUBEADM_CLUSTER_DOMAIN\"" $def_cfg
    k8s cfg yq "select(di == 1) |= .networking.podSubnet = \"$KUBEADM_POD_NETWORK_CIDR\"" $def_cfg
    k8s cfg yq "select(di == 1) |= .networking.serviceSubnet = \"$KUBEADM_SERVICE_NETWORK_CIDR\"" $def_cfg
    # k8s cfg yq "select(di == 1) |= .networking.serviceDnsDomain = \"local\"" $def_cfg
end
funcsave _k8s_cfg_cluster

function _k8s_cfg_proxy
    log4f --type=n "Applying changes to KubeProxyConfig"

    k8s cfg yq "select(di == 2) |= .clusterCIDR = \"$KUBEADM_CLUSTER_CIDR\"" $def_cfg
    k8s cfg yq "select(di == 2) |= .hostnameOverride = \"$KUBEADM_NODE_NAME\"" $def_cfg
    k8s cfg yq "select(di == 2) |= .ipvs.strictARP = true" $def_cfg
    k8s cfg yq "select(di == 2) |= .mode = \"$KUBE_PROXY_MODE\"" $def_cfg
    k8s cfg yq "select(di == 2) |= .nodePortAddresses = - 192.168.4.0/24" $def_cfg
end
funcsave _k8s_cfg_proxy

function _k8s_cfg_kube
    log4f --type=n "Applying changes to KubeConfig"

    k8s cfg yq "select(di == 3) |= .cgroupDriver = \"$CONTAINER_CGROUP_MANAGER\"" $def_cfg
    # k8s cfg yq "select(di == 3) |= .cloudConfig = \"\"" $def_cfg # doesn't exist
    # k8s cfg yq "select(di == 3) |= .cloudProvider = \"\"" $def_cfg # doesn't exist
    k8s cfg yq "select(di == 3) |= .providerID = \"\"" $def_cfg
    k8s cfg yq "select(di == 3) |= .clusterDNS = - 10.96.0.10" $def_cfg
    k8s cfg yq "select(di == 3) |= .clusterDomain = \"$KUBEADM_CLUSTER_DOMAIN\"" $def_cfg
    # k8s cfg yq "select(di == 3) |= .cniBinDir = \"/opt/cni/bin\"" $def_cfg # doesn't exist
    # k8s cfg yq "select(di == 3) |= .cniCacheDir = \"/var/lib/cni/cache\"" $def_cfg
    # k8s cfg yq "select(di == 3) |= .cniConfDir = \"/etc/cni/net.d\"" $def_cfg
    # k8s cfg yq "select(di == 3) |= .config = \"/tmp/KubeletConfiguration.yaml\"" $def_cfg
    # k8s cfg yq "select(di == 3) |= .containerRuntime = \"$CONTAINER_RUNTIME\"" $def_cfg
    # k8s cfg yq "select(di == 3) |= .containerRuntimeEndpoint = \"$CONTAINER_RUNTIME_ENDPOINT\"" $def_cfg
    k8s cfg yq "select(di == 3) |= .enableServer = true" $def_cfg
    # k8s cfg yq "select(di == 3) |= .hostnameOverride = \"$KUBEADM_NODE_NAME\"" $def_cfg
    # k8s cfg yq "select(di == 3) |= .networkPlugin = \"crio\"" $def_cfg
    # k8s cfg yq "select(di == 3) |= .nodeIP = \"$KUBEADM_NODE_IP\"" $def_cfg
    k8s cfg yq "select(di == 3) |= .address = \"$KUBEADM_NODE_IP\"" $def_cfg
    k8s cfg yq "select(di == 3) |= .podCIDR = \"$KUBEADM_POD_NETWORK_CIDR\"" $def_cfg
    k8s cfg yq "select(di == 3) |= .port = 10250" $def_cfg
    # k8s cfg yq "select(di == 3) |= .registerNode = true" $def_cfg
end
funcsave _k8s_cfg_kube

function _k8s_cfg_system
    set -l kubeadm_dir "$HOME/.k8s/kubeadm"
    rm -rf "$kubeadm_dir/*"

    k8s cfg init
    k8s cfg cluster
    k8s cfg proxy
    k8s cfg kube

    # edit to add mac address dynamically w/ jq

    log4f --type=n "Copying CNI configs"
    set -l cni_cfg_files $HOME/.k8s/cni/net.d/$CONTAINER_CNI_DEFAULT_NETWORK/*
    cp $cni_cfg_files "/etc/cni/net.d"
end
funcsave _k8s_cfg_system
