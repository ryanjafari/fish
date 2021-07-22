#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

#set -l kube_flan_man_url \
#  https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

set -l kubeadm_config "/tmp/InitConfig.yaml"

printf "=> Pulling required images for kubeadm...\n"
kubeadm config images pull
printf "=> Done: kubeadm config images pull\n"

printf "=> Configuring kubeadm for cri-o...\n"
crio_kubeadm_configure.fish
printf "=> Done: crio_kubeadm_configure.fish\n"

printf "=> Running kubeadm init...\n"
kubeadm init \
    --config $kubeadm_config \
    --upload-certs \
    --v=5
printf "=> Done: kubeadm init\n"

#printf "=> Storing config made by kubeadm for kubectl...\n"
#mkdir -p "$HOME/.kube"
#cp -i "/etc/kubernetes/admin.conf" "$HOME/.kube/config"
#own "$HOME/.kube/config"
#printf "=> Done.\n"

#printf "=> Cleaning up $kubeadm_config...\n"
#rm -f $kubeadm_config
#printf "=> Done: rm -f $kubeadm_config\n"

#kubectl apply -f $kube_flan_man_url

#kubectl taint nodes --all node-role.kubernetes.io/master-
