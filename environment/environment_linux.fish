log4f --type=i "Loading 🐧 Linux-specific environment variables..."

# Coding language locations:
# set --export GOPATH $HOME/go

# Setup $PATH:
# TODO: --prepend, --path
fish_add_path --prepend $HOME/.local/bin
fish_add_path --prepend /usr/local/bin
fish_add_path --prepend $HOME/go/bin

# Setup kubeconfig files for kubectl:
set --export KUBECONFIG /etc/kubernetes/admin.conf
# set --export KUBECONFIG \
#     /root/kubeconfig/Config.yaml \
#     /root/kubeconfig/Cluster.yaml \
#     /root/kubeconfig/Kubelet.yaml
# set --export KUBE_CONFIG_ROOT "$HOME/.kube"

# Container env vars:
# TODO: more
set --export CONTAINER_RUNTIME remote
set --export CONTAINER_RUNTIME_ENDPOINT "unix:///var/run/crio/crio.sock"
set --export CONTAINER_CNI_PLUGIN_DIR /usr/libexec/cni
set --export CONTAINER_CNI_DEFAULT_NETWORK crio
set --export CONTAINER_CNI_CONFIG_DIR "/etc/cni/net.d"
set --export CONTAINER_CGROUP_MANAGER cgroupfs
set --export CONTAINER_CONFIG "/etc/crio/crio.conf"
set --export CONTAINER_CONFIG_DIR "/etc/crio/crio.conf.d"
set --export CONTAINER_CONMON_CGROUP pod

#
# InitConfiguration
#

set --export KUBEADM_ADV_ADDR (get_local_ip)
set --export KUBEADM_NODE_NAME (hostname)
set --export KUBEADM_NODE_IP (get_local_ip)

# set --export KUBELET_KUBECONFIG_ARGS "\
#   --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf \
#   --kubeconfig=/etc/kubernetes/kubelet.conf"
# set --export KUBELET_CONFIG_ARGS "\
#   --config=/var/lib/kubelet/config.yaml"
# set --export KUBELET_EXTRA_ARGS "\
# --container-runtime=$CONTAINER_RUNTIME \
# --container-runtime-endpoint=$CONTAINER_RUNTIME_ENDPOINT \
# --cgroup-driver=$CONTAINER_CGROUP_MANAGER" # system.slice
#--feature-gates='AllAlpha=false,RunAsGroup=true'
# set --export KUBELET_KUBEADM_ARGS # populated dynamically at runtime

#
# ClusterConfiguration
#

# Setup vars for kubeadm init/join:
set --local crio_bridge_cni_cidr "10.85.0.0/16"
set --local flan_netwrk_cni_cidr "10.244.0.0/16"
# set --export KUBEADM_CLUSTER_CIDR "10.96.0.0/12"
# set --export KUBEADM_CLUSTER_DNS "10.96.0.10"
set --export KUBEADM_KUBE_VER "1.22.4"
set --export KUBEADM_CLUSTER_DOMAIN k8s
set --export KUBEADM_POD_NETWORK_CIDR $crio_bridge_cni_cidr
set --export KUBEADM_SERVICE_NETWORK_CIDR "10.96.0.0/12"
set --export KUBEADM_CTRL_PLN_ENDPT "cluster.k8s"

#
# KubeProxyConfiguration
#

set --export KUBE_PROXY_MODE ipvs

# ??? as editor when terminal needs one:
# set -x EDITOR /path/to/preferred/editor
