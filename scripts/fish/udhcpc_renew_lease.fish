#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

# get pid of udhcpc
set PID (pidof udhcpc)

# renew dhcp lease
/bin/kill -SIGUSR1 $PID
