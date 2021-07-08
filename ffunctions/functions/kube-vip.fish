function kube-vip --wraps='docker run --network host --rm plndr/kube-vip:latest' --description 'alias kube-vip=docker run --network host --rm plndr/kube-vip:latest'
  docker run --network host --rm plndr/kube-vip:latest $argv; 
end
