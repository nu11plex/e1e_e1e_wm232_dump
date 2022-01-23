#!/system/bin/sh

value=`busybox devmem 0xf0a09050`
value=`echo $value | busybox awk -F 0x '{print $2}'`
is_insert=$(((16#$value>>14) & 1))

if [ $is_insert -eq 1 ]; then
	echo "sd_cd signal is high, this means sdcard is inserted"
	echo "sd_cd gpio link test __success"
else
	echo "sd_cd signal is  low, this means sdcard is not inserted"
	echo "sd_cd gpio link test __fail !!!"
fi