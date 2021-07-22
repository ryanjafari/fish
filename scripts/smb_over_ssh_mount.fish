#!/Users/ryanjafari/.local/bin/env /Users/ryanjafari/.local/bin/fish

# TODO: we're successful, so bg the shit

# log4f "Successfully established SSH tunnel for SMB!"
# log4f "Arguments passed in from ssh_config: $argv"

# set -l full_env (string collect (env))

# log4f "Full environment: $full_env"
# log4f "\t\$PWD: $PWD"
# log4f "\t\$RAND_PORT: $RAND_PORT"
# log4f "\t\$SSH_JOB: $SSH_JOB"
# log4f "\t\$status: $status"

# jobs print

# log4f "Attempting to mount the SMB share..."

# # TODO: explore various ways of setting smb passwords
# set -l user ryanjafari
# set -l pass hashish6agape8linoleum
# set -l host localhost
# set -l port (get_port_for_process "ssh")

# log4f "Local port for the SSH tunnel is: $port"

# set -l regex "://[^/]*"
# set -l subst "://$user:$pass@$host:$port"
# set -l file /etc/auto_smb

# log4f "Configuring $file for automount..."

# sudo sed \
#     --in-place \
#     --follow-symlinks \
#     --expression "s|$regex|$subst|" \
#     $file

# log4f "Configured $file for automount"
# log4f "Done: sudo sed $file"
# log4f "Running automount..."

# sudo automount -vcu

# log4f "Successfully ran automount!"
# log4f "Done: sudo automount -vcu"
