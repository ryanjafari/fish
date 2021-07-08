#!/usr/bin/env fish

kube-vip manifest pod \
  --interface $KUBEVIP_INTERFACE \
  --vip $KUBEVIP_VIP \
  --controlplane \
  --services \
  --arp \
  --leaderElection | tee /etc/kubernetes/manifests/kube-vip.yaml
