#!/system/bin/sh

let time_interval=500000
let total_time=20
let min_time_interval=50
let max_total_time=500

time_prefix=`date +%Y%m%d%H%M%S`
time_prefix2=`cat /proc/uptime | busybox awk '{print $1}' | busybox awk -F "." '{print $1}'`
file_name="$time_prefix"_"$time_prefix2"_ddr_bandwidth.data

if [ $# -eq 2 ]; then
	time_interval=$1
	total_time=$2
elif [ $# -eq 3 ]; then
	time_interval=$1
	total_time=$2
	file_name="$time_prefix"_"$time_prefix2"_ddr_bandwidth_$3.data
else
	#echo "Usage : dump_bw.sh time_interval total_sample_time"
	echo "Use default paramters"
fi

if [ $time_interval -lt $min_time_interval ]; then
	let time_interval=$min_time_interval
fi

if [ $total_time -gt $max_total_time ]; then
	let total_time=$max_total_time
fi

echo "Stop selinux"
setenforce 0
echo "Begin dumping ddr bandwidth"
echo "sample_interval is $time_interval us, total time is $total_time s"
app_echo "dump_bw: begin: interval $time_interval us, total $total_time s"
echo "perf_tool: dump_bw name:$filename, interval $time_interval us, total $total_time s" > /dev/kmsg

rm /blackbox/system/axi.data 2>/dev/null
echo $time_interval > /sys/devices/platform/soc/f0000000.ahb/f0450000.axi_pm/time_interval
echo 1 > /sys/devices/platform/soc/f0000000.ahb/f0450000.axi_pm/mode
echo 1 > /sys/devices/platform/soc/f0000000.ahb/f0450000.axi_pm/start
sleep $total_time

echo 0 > /sys/devices/platform/soc/f0000000.ahb/f0450000.axi_pm/start
echo "Finish dumping ddr bandwidth"

if [ ! -f /blackbox/system/axi.data ]; then
	echo "/blackbox/system/axi.data doesn't exist!"
	exit 1
else
	mkdir -p /blackbox/system/performance_dump
	echo save ddr bandwidth to $file_name
	mv /blackbox/system/axi.data /blackbox/system/performance_dump/$file_name
fi
app_echo "dump_bw: finish: interval $time_interval us, total $total_time s"
