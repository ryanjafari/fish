log4f --type=i "Loading 🐧 Linux-specific environment variables..."

# Coding language locations:
set --export GOPATH $HOME/go

# Point to the stuff saved on our network drive:
# set --export __SYS_ROOT /
# set --export MOUNT_ROOT /media
# set --export U2_ROOT $MOUNT_ROOT/u2
# set --export KUBE_CONFIG_ROOT "$U2_ROOT/kube"

# Setup $PATH:
# TODO: --prepend, --path
fish_add_path --prepend $HOME/.local/bin
fish_add_path --prepend /usr/local/bin
fish_add_path --prepend $HOME/go/bin

# Setup kubeconfig files for kubectl:
# set --export KUBECONFIG \
#     /root/kubeconfig/Config.yaml \
#     /root/kubeconfig/Cluster.yaml \
#     /root/kubeconfig/Kubelet.yaml

# Setup vars for kubeadm init/join:
set --local crio_bridge_cni_cidr "10.85.0.0/16"
set --local flan_netwrk_cni_cidr "10.244.0.0/16"
set --export KUBEADM_POD_NETWORK_CIDR $crio_bridge_cni_cidr
set --export KUBEADM_NODE_NAME (hostname)
set --export KUBEADM_KUBE_VER "1.21.2"
set --export KUBEADM_ADV_ADDR (get_local_ip)
set --export KUBEADM_CTRL_PLN_ENDPT "k8s-cluster.lan"
set --export KUBELET_EXTRA_ARGS "--cgroup-driver=cgroupfs"
set --export KUBE_PROXY_MODE ipvs

# Container env vars:
# TODO: more
set --export CONTAINER_RUNTIME_ENDPOINT "unix:///var/run/crio/crio.sock"
set --export CONTAINER_CNI_PLUGIN_DIR /usr/libexec/cni
set --export CONTAINER_CNI_DEFAULT_NETWORK crio
set --export CONTAINER_CNI_CONFIG_DIR "/etc/cni/net.d"
set --export CONTAINER_CGROUP_MANAGER cgroupfs
set --export CONTAINER_CONFIG "/etc/crio/crio.conf"
set --export CONTAINER_CONFIG_DIR "/etc/crio/crio.conf.d"
set --export CONTAINER_CONMON_CGROUP pod

# ??? as editor when terminal needs one:
# set -x EDITOR /path/to/preferred/editor
