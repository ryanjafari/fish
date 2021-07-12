#!/usr/bin/env fish

if status is-interactive
    printf %b "=> Loading Linux-specific environment variables...\n"
end

# Blank out Fish greeting:
set -g fish_greeting ""

# Terminal colors & language:
set -x TERM xterm-256color
set -x LANG "en_US.UTF-8"

# Point to the stuff saved on our network drive:
set -x U2_ROOT /media/u2
set -x FISH_CONFIG_ROOT "$U2_ROOT/fish"
set -x KUBE_CONFIG_ROOT "$U2_ROOT/kube"

# Setup paths:
# TODO: $PATH is not clean!
set -x GOPATH $HOME/go
set -x PATH /media/u2/fish/scripts ~/.bin /usr/local/bin $PATH
set -x PATH $PATH $HOME/.krew/bin $HOME/go/bin

# Setup kubeconfig files for kubectl:
#set -x KUBECONFIG \
#  /root/kubeconfig/Config.yaml \
#  /root/kubeconfig/Cluster.yaml \
#  /root/kubeconfig/Kubelet.yaml

# Setup vars for kubeadm init/join:
set -l crio_bridge_cni_cidr "10.85.0.0/16"
set -l flan_netwrk_cni_cidr "10.244.0.0/16"
set -x KUBEADM_POD_NETWORK_CIDR $crio_bridge_cni_cidr
set -x KUBEADM_NODE_NAME (hostname)
set -x KUBEADM_KUBE_VER "1.21.2"
set -x KUBEADM_ADV_ADDR (get_local_ip)
set -x KUBEADM_CTRL_PLN_ENDPT "k8s-cluster.lan"
set -x KUBELET_EXTRA_ARGS "--cgroup-driver=cgroupfs"
set -x KUBE_PROXY_MODE ipvs

# Container env vars:
# TODO: more
set -x CONTAINER_RUNTIME_ENDPOINT "unix:///var/run/crio/crio.sock"
set -x CONTAINER_CNI_PLUGIN_DIR /usr/libexec/cni
set -x CONTAINER_CNI_DEFAULT_NETWORK crio
set -x CONTAINER_CNI_CONFIG_DIR "/etc/cni/net.d"
set -x CONTAINER_CGROUP_MANAGER cgroupfs
set -x CONTAINER_CONFIG "/etc/crio/crio.conf"
set -x CONTAINER_CONFIG_DIR "/etc/crio/crio.conf.d"
set -x CONTAINER_CONMON_CGROUP pod

# Setup FISH shell variable for powerline-go:
set -l fish_version (get_version (fish -v))
set -x FISH "🐟$fish_version"
