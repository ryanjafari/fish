log4f --type=i "Loading ☁️ WireGuard Cloudflare commands..."

set --local wgcf_model "--model \"FirewallaGold1,2\""
set --local wgcf_name "--name \"Firewalla\""
set --local wgcf_config "--config \"$HOME/.wgcf-account.toml\""
set --local wgcf_profile "--profile \"$HOME/.wgcf-account.toml\""

# TODO: abbreviation expansions instead?
alias --save wgcf-regsiter "wgcf register --accept-tos $wgcf_model $wgcf_name $wgcf_config"
alias --save wgcf-update "wgcf update $wgcf_name $wgcf_config"
alias --save wgcf-generate "wgcf generate $wgcf_profile $wgcf_config"
alias --save wgcf-status "wgcf status $wgcf_config"
alias --save wgcf-trace "wgcf trace $wgcf_config"
