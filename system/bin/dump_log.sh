#!/system/bin/sh
# This script is used to dump cpu usage of each process

let sample_count=20

save_dic=/blackbox/system/performance_dump
time_prefix=`date +%Y%m%d%H%M%S`
time_prefix2=`cat /proc/uptime | busybox awk '{print $1}' | busybox awk -F "." '{print $1}'`

if [ $# -eq 1 ]; then
	file_name="$time_prefix"_"$time_prefix2"_logcat.data
elif [ $# -eq 2 ]; then
	let sample_count=$1
	file_name="$time_prefix"_"$time_prefix2"_logcat_$2.data
fi



echo "Begin dump logcat"

if [ ! -d /blackbox/system/performance_dump ]; then
	mkdir -p /blackbox/system/performance_dump
fi

logcat -c
busybox timeout -t $sample_count -s 9 logcat > $save_dic/$file_name

echo "Saving logdump to $save_dic/$file_name"
