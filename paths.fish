# log4f --type=i "Setting 🚅 global path variables..."

set --global --unpath mf_fish_path "$HOME/.config/fish"

set --global --unpath mf_commands_path "$mf_fish_path/commands"
set --global --unpath mf_commands_common_path "$mf_commands_path/common"

set --global --unpath mf_log4f_log_path "$mf_fish_path/logs"

# Make sure log path is there:
mkdir -p $mf_log4f_log_path

set --global mf_log4f_log_file "$mf_log4f_log_path/log4f.log"

# Make sure log file is there:
# touch $mf_log4f_log_file

# Make sure log file has correct ownership:
# TODO: must use a particular version of chown... make common?
# chown --recursive (id --user):(id --group) $log_path # sudo?
