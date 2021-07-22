#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

set -l api_resources (kubectl api-resources | tail +2 | awk '{ print $1 }')

echo $api_resources

for kind in $api_resources
    kubectl explain $kind | grep -e "KIND:" -e "VERSION:"
end
