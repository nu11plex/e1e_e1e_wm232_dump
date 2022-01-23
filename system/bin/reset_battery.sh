#!/system/bin/sh
action="reboot"
if [ $# -eq 1 ]; then
    action=$1
fi

if [ "$action"x == "reboot"x ]; then
    dji_mb_ctrl -S test -R diag -g 11 -t 0 -s 0 -c b
elif [ "$action"x == "shutdown"x ]; then
    dji_mb_ctrl -S test -R diag -g 11 -t 0 -s 0 -c b 00020000000000000000000000
elif [ "$action"x == "-h"x ]; then
    echo "commands:"
    echo "        reset_battery.sh reboot"
    echo "        reset_battery.sh shutdown"
fi
