#!/system/bin/sh

set -x

usb_state=`busybox awk '{print $1}' /sys/class/udc/f0000000.usb/state`

if [ $usb_state = "configured" ]; then
	echo "usb state is correct"
	echo 0
else
	echo "usb state is not correct"
	exit 1
fi