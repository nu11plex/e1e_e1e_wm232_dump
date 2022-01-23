timeout=5000

stop dji_sdrs_agent

busybox devmem 0xf0a410f0 32 0x18
echo "reset_pigeon.sh is called!" > /dev/kmsg
echo 60 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio60/direction
echo 0 > /sys/class/gpio/gpio60/value
sleep 1
echo 1 > /sys/class/gpio/gpio60/value
echo "Reset pigeon done!"

/system/bin/brload /tmp/encrypt/bootarea.img
[ $? -ne 0 ] && echo "loading bootarea failed" && exit 1

/tmp/encrypt/fastboot flash cmpu_kdr /tmp/encrypt/pro_prak.pub.mon
[ $? -ne 0 ] && echo "flash kdr failed" && exit 2

/tmp/encrypt/fastboot get /tmp/encrypt/upload.bin
[ $? -ne 0 ] && echo "get upload.bin failed" && exit 3

exit 0
