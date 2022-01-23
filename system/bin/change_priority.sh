#!/system/bin/sh

if [ $# -lt 3 ]; then
	echo "Usage:	 change_priority.sh process_name sched_class priority"
	echo "	     sched_class : rr / fifo / normal"
	echo "	     priority	 : rr / fifo => [  1, 99], larger number means higher priority"
	echo "			   normal    => [-20, 19], larger number means lower  priority"
	exit 0
fi

process_subname=$1
sched_class=$2
priority=$3

pid=`ps -t | grep $process_subname | busybox awk 'NR=1 {print $2}'`

let count=0
for pid_num in $pid; do
	target_name=`ps -t | busybox awk '$2'==$pid_num | busybox awk '{print $9}'`
	echo "#### Change [$target_name] pid=$pid_num priority to $priority [$sched_class] ####"

	if [ "$sched_class"x = "normal"x ]; then
		schedtool -N -n $priority $pid_num
	elif [ "$sched_class"x = "rr"x ]; then
		echo "schedtool -R -p $priority $pid_num"
		schedtool -R -p $priority $pid_num
	elif [ "$sched_class"x = "fifo"x ]; then
		schedtool -F -p $priority $pid_num
	fi
	echo ""
	let count=count+1
done

if [ $count -eq 0 ]; then
	echo "Can't find process, which name contains $process_subname"
	exit 1
fi
