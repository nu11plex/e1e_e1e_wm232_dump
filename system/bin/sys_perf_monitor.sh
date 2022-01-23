#! /system/bin/sh

LOG_PATH="/blackbox/system/sys_perf"

log_max_index=10

if [ -e $LOG_PATH ];then
	if [ -e $LOG_PATH/emmc_index ];then
		data=`cat $LOG_PATH/emmc_index`

		# compress old data
		let old_data=$((($data+0)%$log_max_index))
		cur_dir=`pwd`
		cd $LOG_PATH/$old_data
		tar -zcvf log.tar.gz *
		sync
		rm *.log
		cd $cur_dir

		let data=$((($data+1)%$log_max_index))
		rm -rf $LOG_PATH/$data 2>/dev/null
		mkdir $LOG_PATH/$data
		echo $data > $LOG_PATH/emmc_index
	fi
else
	mkdir $LOG_PATH
	data=0
	echo $data > $LOG_PATH/emmc_index
	mkdir $LOG_PATH/$data
fi


if [ -e $LOG_PATH/$data/mem_cpu_irq.log ];then
    rm $LOG_PATH/$data/mem_cpu_irq.log
fi

if [ -e $LOG_PATH/$data/procmem.log ];then
    rm $LOG_PATH/$data/procmem.log
fi

if [ -e $LOG_PATH/$data/pidstat.log ];then
    rm $LOG_PATH/$data/pidstat.log
fi

if [ ! -d /data/dji/cfg/ ];then
	mkdir /data/dji/cfg
fi

if [ ! -e /data/dji/cfg/proc_mem.cfg ];then
	echo "/system/bin/dji_sys" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_amt" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_flight" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_navigation" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_perception" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_blackbox" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_sdrs_agent" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/vold" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_sec" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_monitor" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_camera2" >> /data/dji/cfg/proc_mem.cfg
	echo "/system/bin/dji_rcam" >> /data/dji/cfg/proc_mem.cfg
	sync
fi

sync

echo "------record perf info start------"

#nohup mem_frag_monitor.sh $LOG_PATH/$data 11 &

#nohup sar -I SUM -r ALL -u ALL -B 5 > $LOG_PATH/$data/mem_cpu_irq.log &
#nohup sar -r ALL 5 > $LOG_PATH/$data/mem_cpu_irq.log &

#nohup proc_mem 6  $LOG_PATH/$data/procmem.log /data/dji/cfg/proc_mem.cfg &

nohup busybox top -d 3 >> $LOG_PATH/$data/top.log &

# simpletop only records blackbox/camera writes speed, not monitor cpu current time
nohup simpletop -x -d 1000 -c /system/etc/top.cfg -o $LOG_PATH/$data/simpletop.log -s &

