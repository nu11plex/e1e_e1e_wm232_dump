#!/system/bin/sh

log_path=$1
sleep_time=$2

echo > $log_path/mem_frag.log

function record_vmalloc()
{
	echo > $log_path/vmallocinfo.log
	while [ true ]; do
		date >> $log_path/vmallocinfo.log
		cat /proc/uptime >> $log_path/vmallocinfo.log
		cat /proc/vmallocinfo >> $log_path/vmallocinfo.log
		echo >> $log_path/vmallocinfo.log
		sleep 61
	done
}

record_vmalloc &

echo > $log_path/mem_frag.log

while [ true ]; do
	date >> $log_path/mem_frag.log
	cat /proc/uptime >> $log_path/mem_frag.log
	cat /proc/buddyinfo >> $log_path/mem_frag.log
	cat /sys/kernel/debug/extfrag/extfrag_index >> $log_path/mem_frag.log
	echo >> $log_path/mem_frag.log
	sleep $sleep_time
done
