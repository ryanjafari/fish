#!/opt/home/.local/bin/env /opt/home/.local/bin/fish

# get pid of udhcpc
set PID (pidof udhcpc)

# release dhcp lease
/bin/kill -SIGUSR2 $PID
