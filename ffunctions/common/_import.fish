log4f --type=i "Loading 🚸 cross-OS functions..."

source "$__COM_PATH/docker.fish"
source "$__COM_PATH/kubernetes.fish"
source "$__COM_PATH/search.fish"
source "$__COM_PATH/network.fish"
source "$__COM_PATH/filesystem.fish"
source "$__COM_PATH/cleanup.fish"
source (which env_parallel.fish)
