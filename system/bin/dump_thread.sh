#!/system/bin/sh
# This script is used to dump cpu usage of each threads

let sample_interval=2
let sample_count=3

save_dic=/blackbox/system/performance_dump
time_prefix=`date +%Y%m%d%H%M%S`
time_prefix2=`cat /proc/uptime | busybox awk '{print $1}' | busybox awk -F "." '{print $1}'`
file_name="$time_prefix"_"$time_prefix2"_threads.data

if [ $# -eq 2 ]; then
	let sample_interval=$1
	let sample_count=$2
elif [ $# -eq 3 ]; then
	let sample_interval=$1
	let sample_count=$2
	file_name="$time_prefix"_"$time_prefix2"_threads_$3.data
fi

echo "Begin dump thread statistics"
echo "sample_interval=$sample_interval s, sample_count=$sample_count s"
app_echo "dump_thread_cpu: begin: sample_interval=$sample_interval s, sample_count=$sample_count s"

if [ ! -d /blackbox/system/performance_dump ]; then
	mkdir -p /blackbox/system/performance_dump
fi

pidstat -t $sample_interval $sample_count > $save_dic/$file_name

echo "Saving thread statistics to $save_dic/$file_name"
app_echo "dump_thread_cpu: finish: sample_interval=$sample_interval s, sample_count=$sample_count s"
