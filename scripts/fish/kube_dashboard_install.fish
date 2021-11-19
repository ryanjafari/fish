#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

# Add kubernetes-dashboard repository:
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart:
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --set protocolHttp=true,ingress.enabled=true,rbac.create=true,serviceAccount.create=true,service.externalPort=9090,networkPolicy.enabled=true,podLabels.app=dashboard

kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=default:kubernetes-dashboard
