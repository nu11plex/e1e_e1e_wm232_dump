#!/system/bin/sh
cmp_str1=`adb shell "cat /proc/driver/timesync | grep 'irq num' | busybox awk 'NR==2'"`
usleep 1500000
cmp_str2=`adb shell "cat /proc/driver/timesync | grep 'irq num' | busybox awk 'NR==2'"`
echo cmp_str1 is $cmp_str1
echo cmp_str2 is $cmp_str2

if [ "$cmp_str1"x == "$cmp_str2"x ]; then
	adb devices
	adb shell cat /proc/driver/timesync
	echo "link_to_pps __fail"
	exit 1
else
	echo "link_to_pps success"
	exit 0
fi