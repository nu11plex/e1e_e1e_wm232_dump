#!/system/bin/sh

if [ ! -d /blackbox/system/ion_log ]; then
	mkdir /blackbox/system/ion_log
fi

if [ ! -e /blackbox/system/ion_log/index ]; then
	echo 0 > /blackbox/system/ion_log/index
fi

let index=`cat /blackbox/system/ion_log/index`
let new_index=$index+1
echo $new_index > /blackbox/system/ion_log/index

if [ index -ge 10 ]; then
	let delete_index=$index-10
	echo "rm old ion daemon log : $delete_index.log"
	rm /blackbox/system/ion_log/$delete_index.log 2>/dev/null
fi

while [ true ]
do
	uptime=`cat /proc/uptime | busybox awk '{print $1}'`
	echo "System time:$uptime s" >> /blackbox/system/ion_log/$index.log
	cat /sys/kernel/debug/ion/stat >> /blackbox/system/ion_log/$index.log
	echo >> /blackbox/system/ion_log/$index.log
	sleep 9
done

