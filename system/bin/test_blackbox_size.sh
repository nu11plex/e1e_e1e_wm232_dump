#!/system/bin/sh

base_dir=$1
target_file=$1/df00.log

#check log file size, if up to limit 2MB remove old file to a new file
log_size=`busybox wc -c < /blackbox/system/df00.log`
if [ $log_size -gt 2097152 ]; then
    rm ${base_dir}/df01.log
    mv ${base_dir}/df00.log ${base_dir}/df01.log
fi

#record this when system startup
echo "****************** start record ****************" >> $target_file

#record blackbox folder size every 30s
while true
do

#check log file size, if up to limit 2MB remove old file to a new file
log_size=`busybox wc -c < /blackbox/system/df00.log`
if [ $log_size -gt 2097152 ]; then
    rm ${base_dir}/df01.log
    mv ${base_dir}/df00.log ${base_dir}/df01.log
fi

#record time, blackbox block size and folder size
date >> $target_file
echo "------------------------------------------------" >> $target_file
df >> $target_file
echo "------------------------------------------------" >> $target_file
du -h /blackbox >> $target_file
echo "================================================" >> $target_file

#The command 'du' need some CPU resources, frequent scheduling is not recommended.
#Here, we record the info above every 30 seconds.
sleep 30

done
