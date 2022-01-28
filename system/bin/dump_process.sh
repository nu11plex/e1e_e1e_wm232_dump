#!/system/bin/sh
# This script is used to dump cpu usage of each process

let sample_interval=1
let sample_count=20

save_dic=/blackbox/system/performance_dump
time_prefix=`date +%Y%m%d%H%M%S`
time_prefix2=`cat /proc/uptime | busybox awk '{print $1}' | busybox awk -F "." '{print $1}'`
file_name="$time_prefix"_"$time_prefix2"_process.data

if [ $# -eq 2 ]; then
	let sample_interval=$1
	let sample_count=$2
elif [ $# -eq 3 ]; then
	let sample_interval=$1
	let sample_count=$2
	file_name="$time_prefix"_"$time_prefix2"_process_$3.data
fi

echo "Begin dump thread statistics"
echo "sample_interval=$sample_interval s, sample_count=$sample_count s, name=$3"
app_echo "dump_process_cpu: begin: interval $sample_interval s, cnt $sample_count"

if [ ! -d /blackbox/system/performance_dump ]; then
	mkdir -p /blackbox/system/performance_dump
fi

busybox top -d $sample_interval -n $sample_count > $save_dic/$file_name

echo "Saving thread statistics to $save_dic/$file_name"
app_echo "dump_process_cpu: finish: interval $sample_interval s, cnt $sample_count"
