#!/system/bin/sh
# This script is used to dump cpu usage of each threads

let time=30

save_dic=/blackbox/system/performance_dump
time_prefix=`date +%Y%m%d%H%M%S`
time_prefix2=`cat /proc/uptime | busybox awk '{print $1}' | busybox awk -F "." '{print $1}'`
file_name="$time_prefix"_"$time_prefix2"_flamegraph.data
file_name2="$time_prefix"_"$time_prefix2"_flamegraph_raw.data

if [ $# -eq 1 ]; then
	let time=$1
elif [ $# -eq 2 ]; then
	let time=$1
	file_name="$time_prefix"_"$time_prefix2"_flamegraph_$2.data
	file_name2="$time_prefix"_"$time_prefix2"_flamegraph_raw_$2.data
fi

echo "Begin dump flame graph"
echo "sample time=$time s"

if [ ! -d /blackbox/system/performance_dump ]; then
	mkdir -p /blackbox/system/performance_dump
fi

perf record -a -o $save_dic/perf.data -g -F 99 -- sleep $time
perf script -i $save_dic/perf.data > $save_dic/$file_name
cp $save_dic/perf.data $save_dic/$file_name2

echo "Saving flamegraph to $save_dic/$file_name"
