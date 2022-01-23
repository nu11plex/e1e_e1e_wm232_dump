#!/system/bin/sh
log_dir="/blackbox/system"
log_prefix="system.log"
max_exist_compress_allowed=10

local_log="/blackbox/system/compress.log"
debug_echo()
{
    echo $1
    echo `date` $1 >> $local_log
}

cd $log_dir

echo "system_log_starter start! this will compress system log" > /dev/kmsg
debug_echo "\n\n!!! new compress check at `date` , boot time:`cat /proc/uptime`!!!"
# 1. check how many $log_prefix need to be add into compress
#    must be $log_prefix.x for compress
debug_echo "===================== Step 1: check how many logs need to compress ====================="
let input_start_index=0
let need_compress_num=0
for i in `seq 1 $max_exist_compress_allowed`; do
    let j=max_exist_compress_allowed-i+1
    if [ -e $log_prefix.$j ]; then
        let input_start_index=j
        let need_compress_num=input_start_index
        debug_echo "the largest index of raw file is $log_prefix.$input_start_index"
        break
    fi
done
debug_echo "we got $need_compress_num new files to add into tar-zips, will run $need_compress_num iters of rotate"

# 2. remove old compressed files with the number of $need_compress_num
debug_echo "\n\n===================== Step 2: remove old compressed log ====================="
debug_echo "before remove old compress files:"
ls -al  >> $local_log

for iter_loop in `seq 1 $need_compress_num`; do
    debug_echo "remove iter_loop $iter_loop"
    for i in `seq 1 $((max_exist_compress_allowed-1))`; do
        let j=max_exist_compress_allowed-i
        if [ -e $log_prefix.tar.gz.$j ]; then
            debug_echo "mv $log_prefix.tar.gz.$j $log_prefix.tar.gz.$((j+1))"
            mv $log_prefix.tar.gz.$j $log_prefix.tar.gz.$((j+1))
        elif [ -e $log_prefix.tar.gz.$((j+1)) ]; then
            debug_echo "rm -rf $log_prefix.tar.gz.$((j+1))"
            rm -rf $log_prefix.tar.gz.$((j+1))
        fi
    done
done
debug_echo "after remove old compress files:"
ls -al >> $local_log

# 3. compress old raw log files
debug_echo "\n\n===================== Step 3: compress raw log ====================="
let output_start_index=1
for i in `seq 1 $max_exist_compress_allowed`; do
    if [ -e $log_prefix.tar.gz.$i ]; then
        let output_start_index=i-1
        debug_echo "the start available index of compressed is $log_prefix.tar.gz.$output_start_index"
        break
    fi
done
debug_echo "output_start_index=$output_start_index"

if [ $input_start_index -lt 1 ]; then
    debug_echo "no need to compress, as the largest system log name is $log_prefix"
else
    debug_echo "begin do compress, input_start_index=$input_start_index"
    for i in `seq 1 $input_start_index`; do
        let j=input_start_index-i+1
        input_file_name=$log_prefix.$j
        output_file_name=$log_prefix.tar.gz.$j
        debug_echo "nice -n 19 busybox tar -zcvf $output_file_name $input_file_name"
        nice -n 19 busybox tar -zcvf $output_file_name $input_file_name
        debug_echo "rm -rf $input_file_name"
        debug_echo ""
        rm -rf $input_file_name
    done
fi

debug_echo "\n\n===================== Step 4: check and delete remain uncompressed files ====================="
ls -al >> $local_log
let remain=`ls $log_prefix.[0-9]* | wc -l`
if [ $remain -ne 0 ]; then
    debug_echo "need to delete those uncompressed remain logs"
    ls $log_prefix.[0-9]* >> $local_log
    rm -rf `ls $log_prefix.[0-9]*` 2>/dev/null
fi
debug_echo "after delete"
ls -al >> $local_log

# 50M * 6
debug_echo "\n\n===================== Step 5: start logcat ====================="
debug_echo "logcat -f /blackbox/system/$log_prefix -r25600 -n$max_exist_compress_allowed DUSS6C:I DUSS51:I DUSS4A:I DUSS01:I *:E &"
logcat -f /blackbox/system/$log_prefix -r25600 -n$max_exist_compress_allowed DUSS6C:I DUSS51:I DUSS4A:I DUSS01:I *:E &

debug_echo "\n\n===================== Step 6: check if need to truncate local log ====================="
let filesize=`ls -al $local_log | busybox awk '{print $4}'`
if [ $filesize -gt 1048576 ]; then
    echo "rotate compress log" > /dev/kmsg
    cp $local_log $local_log.1
    echo > $local_log
fi
echo "system_log_starter finish!" > /dev/kmsg
