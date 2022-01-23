#!/system/bin/sh
busybox devmem 0xf0a410f0 32 0x18
echo "reset_pigeon.sh is called!" > /dev/kmsg
echo 60 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio60/direction
echo 0 > /sys/class/gpio/gpio60/value
sleep 1
echo 1 > /sys/class/gpio/gpio60/value
echo "Reset pigeon done!"
