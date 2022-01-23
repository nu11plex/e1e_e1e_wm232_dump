#! /system/bin/sh

LOG_PATH="/blackbox/system/perf_data"

if [ -e $LOG_PATH ];then
    if [ -e $LOG_PATH/emmc_index ];then
        data=`cat $LOG_PATH/emmc_index`
        let data=data+1
        echo $data > $LOG_PATH/emmc_index
        mkdir $LOG_PATH/$data
        if [ $data -ge 20 ];then
            perf_rm=$(($data-20))
            echo $perf_rm > $LOG_PATH/emmc_index
            rm -rf $LOG_PATH/$perf_rm/*
        fi
    fi
else
    mkdir $LOG_PATH
    data=1
    echo $data > $LOG_PATH/emmc_index
    mkdir $LOG_PATH/$data
fi

if [ -e $LOG_PATH/$data/meminfo.log ];then
    rm $LOG_PATH/$data/meminfo.log
fi

if [ -e $LOG_PATH/$data/cpu.log ];then
    rm $LOG_PATH/$data/cpu.log
fi

if [ -e $LOG_PATH/$data/procmem.log ];then
    rm $LOG_PATH/$data/procmem.log
fi

if [ -e $LOG_PATH/$data/top.log ];then
    rm $LOG_PATH/$data/top.log
fi

if [ -e $LOG_PATH/$data/mpstat.log ];then
    rm $LOG_PATH/$data/mpstat.log
fi

if [ -e $LOG_PATH/$data/irq.log ];then
    rm $LOG_PATH/$data/irq.log
fi

sync

echo "------record perf info start------"

nohup dump_meminfo 1 $LOG_PATH/$data/meminfo.log &

nohup cpu_usage 1 $LOG_PATH/$data/cpu.log &

nohup proc_mem 1 $LOG_PATH/$data/procmem.log &

nohup busybox top -d 2 >> $LOG_PATH/$data/top.log &

nohup busybox mpstat -A 5 >> $LOG_PATH/$data/mpstat.log &

