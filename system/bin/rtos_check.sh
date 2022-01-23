#!/system/bin/sh

#set -x

e1e_rtos_seq0=`busybox devmem 0x65200008 | busybox sed -e 's/0x//'`
sleep 1
e1e_rtos_seq1=`busybox devmem 0x65200008 | busybox sed -e 's/0x//'`

e1e_rtos_seq0=`echo $((16#${e1e_rtos_seq0}))`
e1e_rtos_seq1=`echo $((16#${e1e_rtos_seq1}))`

if [ ${e1e_rtos_seq1} -ne ${e1e_rtos_seq0} ]; then
	echo "e1e rtos boot success"
else
	echo "e1e rtos boot fail"
	exit 1
fi

p1_rtos_seq0=`adb shell "modem_info.sh cps" | grep seq | busybox awk '{print $10}' | busybox sed -e 's/0x//'`
sleep 1
p1_rtos_seq1=`adb shell "modem_info.sh cps" | grep seq | busybox awk '{print $10}' | busybox sed -e 's/0x//'`

p1_rtos_seq0=`echo $((16#${p1_rtos_seq0}))`
p1_rtos_seq1=`echo $((16#${p1_rtos_seq1}))`

if [ ${p1_rtos_seq1} -ne ${p1_rtos_seq0} ]; then
	echo "p1 rtos boot success"
else
	echo "p1 rtos boot fail"
	exit 1
fi

exit 0