#!/usr/bin/env fish

printf %b "=> Loading cross-OS environment variables...\n"

# Set the path to the locate database:
set -x LOCATE_PATH "/var/db/locate.database"
