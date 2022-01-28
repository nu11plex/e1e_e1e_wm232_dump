#!/system/bin/sh

save_dic=/blackbox/system/performance_dump
let total_time=5
let max_total_time=5000
type=""
time_prefix=`date +%Y%m%d%H%M%S`
time_prefix2=`cat /proc/uptime | busybox awk '{print $1}' | busybox awk -F "." '{print $1}'`
file_name="$time_prefix"_"$time_prefix2"_irq.data

type=$1
if [ "$type"x = "oneshot"x ]; then
	total_time=$2
	if [ "$3"x != ""x ]; then
		file_name="$time_prefix"_"$time_prefix2"_irq_$3.data
	else
		file_name="$time_prefix"_"$time_prefix2"_irq.data
	fi
elif [ "$type"x = "start"x ]; then
	if [ "$2"x != ""x ]; then
		file_name="$time_prefix"_"$time_prefix2"_irq_$2.data
	else
		file_name="$time_prefix"_"$time_prefix2"_irq.data
	fi
elif [ "$type"x = "start"x ]; then
	if [ "$2"x != ""x ]; then
		file_name="$time_prefix"_"$time_prefix2"_irq_$2.data
	else
		file_name="$time_prefix"_"$time_prefix2"_irq.data
	fi
fi

if [ $total_time -gt $max_total_time ]; then
	let total_time=$max_total_time
fi

echo "Start monitor irq performance status"
echo "total time is $total_time s"

if [ ! -d /blackbox/system/performance_dump ]; then
	mkdir -p /blackbox/system/performance_dump
fi

if [ "$type"x = "oneshot"x ]; then
	echo "Start monitor irq performance status at $time_prefix, will continue $total_time" > /dev/kmsg

	# TODO: need to uncomment
	echo "echo 1 > /sys/kernel/debug/sched_monitor/start_all_monitor"

	# TODO: need to uncomment
	echo "echo 0 > /sys/kernel/debug/sched_monitor/start_all_monitor"
	time_prefix=`date +%Y%m%d%H%M%S`
	sar -I ALL 1 $total_time > $save_dic/$file_name
	cat /proc/interrupts >> $save_dic/$file_name
	echo "Stop monitor irq performance status at $time_prefix, lasted $total_time" > /dev/kmsg
	echo "Saved to file $save_dic/$file_name"
elif [ "$type"x = "start"x ]; then
	echo "Start monitor irq performance status at $time_prefix" > /dev/kmsg

	# TODO: need to uncomment
	echo "echo 1 > /sys/kernel/debug/sched_monitor/start_all_monitor"
elif [ "$type"x = "stop"x ]; then
	echo "Stop monitor irq performance status at $time_prefix" > /dev/kmsg

	# TODO: need to uncomment
	echo "echo 0 > /sys/kernel/debug/sched_monitor/start_all_monitor"
fi

echo "Finish monitor irq performance status"
