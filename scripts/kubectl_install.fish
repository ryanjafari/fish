#!/usr/bin/env fish

printf "=> Installing config made by kubeadm for kubectl...\n"
mkdir -p "$HOME/.kube"
cp "/etc/kubernetes/admin.conf" "$HOME/.kube/config"
own "$HOME/.kube/config"
printf "=> Done.\n"
