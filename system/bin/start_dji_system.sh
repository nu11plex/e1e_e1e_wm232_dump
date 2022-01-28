#!/system/bin/sh
# Check partitions, try format it and reboot when failed
#/system/bin/part_check.sh

boot_debug_echo()
{
    if [ -f /data/boot_debug ]; then
        echo "###BOOT DEBUG: $1" > /dev/kmsg
    fi
}

# usb gadget enable is based on cali partition, so mount cali first
# check if cali partition is formated, or format it.
mount_dev=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/cali
mkdir /cali
e2fsck -fy $mount_dev > /tmp/cali.fsck
if [ $? -eq 4 -o $? -eq 8 ]; then
# 4: File system errors left uncorrected
# 8: Operational error
    echo "#### fscheck cali partition failed, will do format!" > /dev/kmsg
    busybox blkdiscard $mount_dev
    busybox mke2fs -b 4096 -T ext4 $mount_dev
fi
mount -t ext4 -o discard $mount_dev /cali

ret=$?
echo $ret
if [ $ret -ne 0 ];then
    echo "Start format $mount_dev" > /dev/kmsg
    busybox blkdiscard $mount_dev
    busybox mke2fs -b 4096 -T ext4 $mount_dev
    mount -t ext4 -o discard $mount_dev /cali
    echo "Format & mount $mount_dev success" > /dev/kmsg
fi
mkdir -p /cali/firmware/wlan/ath6k
setprop selinux.restorecon_recursive /cali
check_camera_fs.sh &

umount /data
mount_dev=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/userdata
e2fsck -fy $mount_dev
if [ $? -eq 4 -o $? -eq 8 ]; then
# 4: File system errors left uncorrected
# 8: Operational error
    echo "#### fscheck data partition failed, will do format!" > /dev/kmsg
    echo "Start format $mount_dev"
    busybox blkdiscard $mount_dev
    busybox mke2fs -F -b 4096 -T ext4 $mount_dev
    echo "Format $mount_dev success"
fi
mount -t ext4 -o rw,noatime,nosuid,nodev,discard,barrier=1,noauto_da_alloc $mount_dev /data
mount | grep "/by-name/userdata /data ext4" | grep rw
if [ $? != 0 ]; then
    echo "Partition userdata (mount to data) mount check fail, format it..."
    umount /data
    busybox blkdiscard $mount_dev
    busybox mke2fs -F -b 4096 -T ext4 $mount_dev
    mount -t ext4 -o rw,noatime,nosuid,nodev,discard,barrier=1,noauto_da_alloc $mount_dev /data
fi
boot_debug_echo "after format data directory"
setprop selinux.restorecon_recursive /data
#create_wifi_file

mkdir -p /data/dji/log/

boot_debug_echo "before insmod icc_chnl/eagle_dsp.ko"
# share modules
insmod /system/lib/modules/icc_chnl.ko
insmod /system/lib/modules/eagle_dsp.ko

# add fc standalone/fullfunction mode switch trigger
# TODO: this flow should be add to icc probe flow later
echo "send 3.0" > /proc/driver/icc
echo "log warn" > /proc/driver/icc

# codec modules
boot_debug_echo "before insmod other kos"
insmod /system/lib/modules/proresenc_mod.ko
insmod /system/lib/modules/e5010_mod.ko
insmod /system/lib/modules/imgtec/imgvideo.ko
insmod /system/lib/modules/imgtec/vxekm.ko
insmod /system/lib/modules/imgtec/img_mem.ko
insmod /system/lib/modules/imgtec/vxd.ko fw_select=2

# camera module
insmod /system/lib/modules/rcam_dji.ko
insmod /system/lib/modules/gdc_eagle.ko
insmod /system/lib/modules/dji_gdc_eagle.ko
insmod /system/lib/modules/camecg_drv.ko

# perception modules
insmod /system/lib/modules/vision_acc.ko acc_camera_expose_mode=2
insmod /system/lib/modules/dji_csi_host.ko
insmod /system/lib/modules/vision_cnn.ko

# display modules
insmod /system/lib/modules/hdmi_lt9611.ko

# ocusync modules
insmod /system/lib/modules/gpio_keys.ko
# correct system time before services start
sync_time &

boot_debug_echo "before start tee-supplicant"
# start optee client daemon
tee-supplicant &

# record fsck log
fsck_dir=/data/fsck
mkdir -p $fsck_dir
time_record=/data/dji/time_record

boot_debug_echo "before format blackbox"
# judge blackbox is formated or not. if not, format it.
mount_dev=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/blackbox
mkdir /blackbox
e2fsck -fy $mount_dev > $fsck_dir/blackbox.fsck
if [ $? -eq 4 -o $? -eq 8 ]; then
# 4: File system errors left uncorrected
# 8: Operational error
    echo "#### fscheck blackbox partition failed, will do format!" > /dev/kmsg
    cat $time_record > /data/dji/blackbox.fmt
    make_ext4fs -w -b 4096 $mount_dev
fi

# judge if need to format blackbox, this is used to format blackbox actively.
cfg_file=/data/dji/cfg/blackbox_format.cfg
cfg_value=`cat $cfg_file`
if [ "$cfg_value" == "1"  ]; then
    echo "Detect format cfg file, start format $mount_dev" > /dev/kmsg
    make_ext4fs -w -b 4096 $mount_dev
    echo "Clear blackbox format cfg" > /dev/kmsg
    echo 0 > $cfg_file
fi
mount -t ext4 -o discard $mount_dev /blackbox

ret=$?
echo $ret
# check blackbox size, if < 50M, then format
check_blackbox.sh > $fsck_dir/blackbox_format.log
ret_bb=$?
if [ $ret -ne 0 ];then
    boot_debug_echo "blackbox mount failed, start format"
    echo "Mount failed, start format $mount_dev" > /dev/kmsg
    make_ext4fs -w -b 4096 $mount_dev
    mount -t ext4 -o discard $mount_dev /blackbox
    echo "Format & mount $mount_dev success" > /dev/kmsg
else
    if [ $ret_bb -ne 0 ];then
        boot_debug_echo "blackbox mount success"
        # record current status of blackbox partiton
        ls -l /blackbox >> $fsck_dir/blackbox_format.log
        du -h /blackbox >> $fsck_dir/blackbox_format.log

        # clear other log except log in white list
        echo "Clear other logs except logs in white list" > /dev/kmsg
        cd /blackbox
        rm -rf !(block_upgrade|block_info|system|flyctrl|upgrade|info|dji_perception|navigation|sdrs_log|dji_app_agent)
        cd -

#        echo "Start format $mount_dev"
#        umount /blackbox
#        make_ext4fs -w -b 4096 $mount_dev
#        mount -t ext4 -o discard $mount_dev /blackbox
#        echo "Format & mount $mount_dev success"
        mkdir -p /blackbox/system
        cp $fsck_dir/blackbox_format.log /blackbox/system/blackbox_format.log
    fi
fi

create_independent_log_partition()
{
    target_dir=$1
    target_block=$2
    target_size=$3
    target_loop=$4
    file_size=`ls -l $target_block | busybox awk '{ print $4 }'`

    rm -rf $target_dir
    mkdir -p $target_dir

    # check if file exist, and check if file size is correct
    if [ -f $target_block ] && [ $file_size -eq $target_size ]; then
        # check file system format
        e2fsck -fy $target_block
        if [ $? -eq 4 -o $? -eq 8 ]; then
            echo "#### DPS $target_block file broken, format it" > /dev/kmsg
            busybox mke2fs -F -T ext4 -b 4096 $target_block
        fi
        echo "DPS start mount $target_dir partition" > /dev/kmsg
        mount -t ext4 -o loop=$target_loop $target_block $target_dir
    else
        rm -f $target_block
        echo "DPS start create $target_block file" > /dev/kmsg
        fallocate -l $target_size $target_block
        echo "fallocate -l $target_size $target_block"
        if [ $? -eq 0 ]; then
            echo "DPS start format $target_block" > /dev/kmsg
            busybox mke2fs -F -T ext4 -b 4096 $target_block
            echo "DPS start mount $target_dir partition" > /dev/kmsg
            mount -t ext4 -o loop=$target_loop $target_block $target_dir
        fi
    fi

    if [ $? -ne 0 ]; then
        echo "DPS mount $target_dir partition failure" > /dev/kmsg
        # mount failed, detach loop device and remove block file
        busybox losetup -d $target_loop
        rm -f $target_block
    else
        setprop selinux.restorecon_recursive $target_dir
        echo "DPS mount $target_dir partition success" > /dev/kmsg
    fi
}

# create partition for info, size: 10MB
boot_debug_echo "before create info partiton"
input_dir=/blackbox/info
input_block=/blackbox/block_info
input_size=10485760
input_loop=/dev/block/loop1
create_independent_log_partition $input_dir $input_block $input_size $input_loop

boot_debug_echo "before check clean_factory_log_en"
# factory log clean check: if clean log flag is set, we clean the log
if [ -f /data/dji/cfg/clean_factory_log_en ]; then
    boot_debug_echo "in clean_factory_log_en"
    echo "i will clean factory log" > /dev/kmsg
    logType=`cat /data/dji/cfg/clean_factory_log_en`
    mkdir -p /data/dji/log/
    rm -rf /data/dji/log/clean_factory.log
    clr_factory_dat.sh $logType > /data/dji/log/clean_factory.log
    rm -rf /data/dji/cfg/clean_factory_log_en
    cp /data/dji/log/clean_factory.log /blackbox/system/clean_factory.log
    echo "finish clean factory log" > /dev/kmsg
fi

boot_debug_echo "before check clean_user_log_en"
# user log clean check: if clean log flag is set, we clean the log
if [ -f /data/dji/cfg/clean_user_log_en ]; then
    boot_debug_echo "in clean_user_log_en"
    echo "i will clean user log" > /dev/kmsg
    logType=`cat /data/dji/cfg/clean_user_log_en`
    mkdir -p /data/dji/log/
    rm -rf /data/dji/log/clean_user.log
    clr_user_dat.sh $logType > /data/dji/log/clean_user.log
    rm -rf /data/dji/cfg/clean_user_log_en
    cp /data/dji/log/clean_user.log /blackbox/system/clean_user.log
    echo "finish clean user log" > /dev/kmsg
fi

if [ ! -d /data/dji/cfg ]; then
    mkdir -p /data/dji/cfg
fi

if [ ! -e /blackbox/system ];then
    mkdir -p /blackbox/system
fi

boot_debug_echo "before start dji_kmsg"
# do kmsg collection
dji_kmsg -l 10M -d /blackbox/system/ -n 8 -S &

# configuration file of detached log partition subsystem
cfg_dir=/cali/cfg
cfg_file=$cfg_dir/log_partition_on
cur_version=6
cur_cfg_file=$cfg_file$cur_version
version_change=0

boot_debug_echo "before check cur_cfg_file"
# check cur_cfg_file exist, if version change, need to clean blackbox
if [ ! -f $cur_cfg_file ]; then
    boot_debug_echo "cur_cfg_file does not exist, do init"
    # run first time, clean blackbox partition to make sure there is
    # enough space for independent log partition
    echo "DPS version $cur_cfg_file, clean blackbox" > /dev/kmsg

    # copy the upgrade cfg file to backup path
    echo "DPS copy upgrade cfg file to /cali/temp_cfg/" > /dev/kmsg
    mount -t ext4 -o loop=/dev/block/loop0 /blackbox/block_upgrade /blackbox/upgrade
    rm -rf /cali/temp_cfg/*
    mkdir -p /cali/temp_cfg
    cp /blackbox/upgrade/signimgs/*.cfg.sig /cali/temp_cfg/
    umount /blackbox/upgrade
    version_change=1

    umount /blackbox
    make_ext4fs -w -b 4096 $mount_dev
    mount -t ext4 -o discard $mount_dev /blackbox

    #remove old cfg_file and create new one
    mkdir -p $cfg_dir
    rm -f ${cfg_file}*
    touch $cur_cfg_file
fi

setprop selinux.restorecon_recursive /blackbox

# create partition for upgrade, size: 400MB
boot_debug_echo "before create upgrade partiton"
input_dir=/blackbox/upgrade
input_block=/blackbox/block_upgrade
input_size=419430400
input_loop=/dev/block/loop0
create_independent_log_partition $input_dir $input_block $input_size $input_loop

# create 150M space taken file for emmc performance improve
if [ ! -f /blackbox/fallocate_file ]; then
    echo "generate fallocate file to take space in /blackbox" > /dev/kmsg
    dji_fallocate -l 157286400 -n /blackbox/fallocate_file
else
    echo "fallocate file already exists in blackbox" > /dev/kmsg
fi

# update boot index
prop_boot_index=persist.sys.boot_index
last_boot_index=`getprop $prop_boot_index`
if [ "$last_boot_index" == "" ]; then
    # record boot index for the first time
    setprop $prop_boot_index 1
    echo "record '$prop_boot_index' for the first time" > /dev/kmsg
else
    # if property exist, update boot index
    boot_index=`busybox expr $last_boot_index + 1`
    setprop $prop_boot_index $boot_index
    echo "update '$prop_boot_index': '$last_boot_index' -> '$boot_index'" > /dev/kmsg
fi

setprop dji.blackbox_service 1

# create partition for navigation, size: 1200MB
# input_dir=/blackbox/navigation
# input_block=/blackbox/block_navigation
# input_size=1258291200
# input_loop=/dev/block/loop2
# create_independent_log_partition $input_dir $input_block $input_size $input_loop
rm -rf /blackbox/block_navigation
mkdir /blackbox/navigation

# create partition for perception, size: 800MB
# input_dir=/blackbox/dji_perception
# input_block=/blackbox/block_perception
# input_size=838860800
# input_loop=/dev/block/loop3
# create_independent_log_partition $input_dir $input_block $input_size $input_loop
rm -rf /blackbox/block_perception
mkdir /blackbox/dji_perception

if [ $version_change -eq 1 ]; then
    boot_debug_echo "before copy temp cfg to upgrade folder"
    # copy the temp cfg to upgrade folder
    echo "DPS remove the upgrade temp cfg file to /blackbox/upgrade/signimgs" > /dev/kmsg
    mkdir -p /blackbox/upgrade/signimgs
    cp /cali/temp_cfg/*.cfg.sig /blackbox/upgrade/signimgs/
fi

setprop selinux.restorecon_recursive /nfz_data
setprop selinux.restorecon_recursive /blackbox

# save blackbox.fmt to blackbox/system
if [ ! -e /blackbox/system/blackbox.fmt -a -e /data/dji/blackbox.fmt ];then
    mkdir -p /blackbox/system
    cp /data/dji/blackbox.fmt /blackbox/system/blackbox.fmt
fi

boot_debug_echo "before check cache partition"
# judge cache partition is formated or not. if not, format it.
mount_dev=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/cache
e2fsck -fy $mount_dev > $fsck_dir/cache.fsck
if [ $? -eq 4 -o $? -eq 8 ]; then
# 4: File system errors left uncorrected
# 8: Operational error
    echo "#### fscheck cache partition failed, will do format!" > /dev/kmsg
    cat $time_record > /blackbox/system/cache.fmt
    busybox blkdiscard $mount_dev
    busybox mke2fs -b 4096 -T ext4 $mount_dev
fi
mount -t ext4 -o discard $mount_dev /cache
mkdir -p /cache/recovery

ret=$?
echo $ret
if [ $ret -ne 0 ];then
    boot_debug_echo "before format cache partition"
    echo "Start format $mount_dev"
    busybox blkdiscard $mount_dev
    busybox mke2fs -b 4096 -T ext4 $mount_dev
    mount -t ext4 -o discard $mount_dev /cache
    echo "Format & mount $mount_dev success"
fi
setprop selinux.restorecon_recursive /cache

boot_debug_echo "before check factory partition"
# judge factory partition is formated or not. if not, format it.
mount_dev=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/factory
e2fsck -fy $mount_dev > $fsck_dir/factory.fsck
if [ $? -eq 4 -o $? -eq 8 ]; then
# 4: File system errors left uncorrected
# 8: Operational error
    boot_debug_echo "before format factory partition"
    echo "#### fscheck factory partition failed, will do format!" > /dev/kmsg
    cat $time_record > /blackbox/system/factory.fmt
    busybox blkdiscard $mount_dev
    busybox mke2fs -b 4096 -T ext4 $mount_dev
fi

mount -t ext4 -o discard $mount_dev /factory_data

ret=$?
echo $ret
if [ $ret -ne 0 ];then
    echo "Start format $mount_dev"
    busybox blkdiscard $mount_dev
    busybox mke2fs -b 4096 -T ext4 $mount_dev
    mount -t ext4 -o discard $mount_dev /factory_data
    echo "Format & mount $mount_dev success"
fi
setprop selinux.restorecon_recursive /factory_data

boot_debug_echo "before check ssd_en"
##Here we change it to 15s to avoid ssd probe fail issue##
if [ -f /data/dji/cfg/ssd_en ]; then # Disabled by default
	boot_debug_echo "ssd_en flag is set"
	i=0
	while [ $i -lt 25 ]; do
		boot_debug_echo "ssd_en loop $i"
		if [ -b /dev/block/sda1 ]
		then
			mkdir -p /data/image
			mount -t ext4 /dev/block/sda1 /data/image
			break
		fi
		if [ -b /dev/block/sdc1 ]
		then
			mkdir -p /data/image
			mount -t ext4 /dev/block/sdc1 /data/image
			break
		fi
		i=`busybox expr $i + 1`
		sleep 1
	done
	echo 1 > /sys/class/typec_usb/vbus_state
	setprop selinux.restorecon_recursive /data/image
fi

boot_debug_echo "before check cc_en"
if [ -f /data/dji/cfg/cc_en ]; then # Disabled by default
	boot_debug_echo "before set vbus_state"
	echo 1 > /sys/class/typec_usb/vbus_state
fi

mkdir -p /blackbox/system/coredump
boot_debug_echo "before enable coredump"
setprop coredump.enable 1

mkdir -p /data/upgrade/backup
mkdir -p /data/upgrade/signimgs
mkdir -p /data/upgrade/unsignimgs
mkdir -p /data/upgrade/debugimgs
mkdir -p /data/upgrade/incomptb
mkdir -p /blackbox/upgrade
mkdir -p /blackbox/upgrade/backup
mkdir -p /blackbox/upgrade/signimgs
# clean bb .tmp file
boot_debug_echo "before find blackbox tmp"
find /blackbox -name "*.tmp" -print0 | xargs -0 rm

# check and do fc_dump
get_fc_dump.sh &

# clean liveview dump_enable
rm -rf /data/venc_dump

boot_debug_echo "before interrupt affinity setting"
# put perception's irq to cpu1 to avoid irq resp delay
cat /proc/interrupts | grep acc_ \
| busybox awk 'sub(/:/,"") {print $1,$9}' \
| while read vision_irq_num vision_irq_name
do
echo 8 > /proc/irq/$vision_irq_num/smp_affinity
echo "set $vision_irq_num irq to cpu 3, name: $vision_irq_name"
done

boot_debug_echo "before persis.dji.storage setting"
exportable=`getprop persist.dji.storage.exportable`
mp_state=`cat /proc/cmdline | busybox awk -F "mp_state=" '{print $2}' | busybox awk '{print $1}'`
secure_debug_state=`getprop ro.boot.secure_debug`
if [ $exportable -eq 0 -a "$mp_state"x == "production"x -a "$secure_debug_state"x == "0"x ]; then
    boot_debug_echo "into persis.dji.storage setting"
    echo "detect exportable set to 0 and production state" > /dev/kmsg
    setprop persist.dji.storage.exportable 1
    sync
fi

#wifi_mode="normal"
#if [ -f /data/misc/wifi/wifi_factory ]; then
#    wifi_mode="tx99"
#fi

#test_hal_storage -c '0 volume detach_pc'

if [ ! -d "/cali/dji_perception" ];then
mkdir -p /cali/dji_perception
fi

# set mmc/sdcard trace those latency larger than 15ms
echo 15000000 > /sys/kernel/debug/mmc0/trace_thres_ns
echo 15000000 > /sys/kernel/debug/mmc1/trace_thres_ns

boot_debug_echo "before start services routine 1"
# Start services
export HOME=/data
setprop dji.sdrs_agent_service 1
setprop dji.ftpd_service 0
setprop dji.monitor_service 1
setprop dji.system_service 1
setprop dji.vtwo_sdk_service 1
setprop ss_dsp_manager_service 1
setprop dji.perception_service 1
setprop dji.navigation_service 1
setprop dji.autoflight_service 0

setup_cam_env.sh

boot_debug_echo "before start services routine 2"
mkdir -p /blackbox/camera/log
#cam_log_dump.sh 134217728 &
setprop dji.camera_service 1
setprop dji.rcam_service 1
setprop dji.flight_service 1
setprop dji.amt_service 1
setprop dji.sec_service 1
setprop dji.v1_events 1
setprop dji.app_agent_service 1
setprop dji.camera_upgrade_service 1
setprop dji.hms_service 1

echo 'p:detectrm do_unlinkat filename=+0(%r1):string' >> /sys/kernel/debug/tracing/kprobe_events
echo 'r:detectrm_finish do_unlinkat' >> /sys/kernel/debug/tracing/kprobe_events

boot_debug_echo "before enable sync ftrace"
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_fdatasync/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_msync/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_sync/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_sync_file_range2/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_syncfs/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_exit_fdatasync/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_exit_msync/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_exit_sync/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_exit_sync_file_range2/enable
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_exit_syncfs/enable

echo 1 > /sys/kernel/debug/tracing/tracing_on
echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
echo 1 > /sys/kernel/debug/tracing/events/kprobes/detectrm/enable

boot_debug_echo "before rotate rmdetect.log"
for i in `seq 1 10`; do
    let j=11-i
    mv /blackbox/system/rmdetect.log.$j /blackbox/system/rmdetect.log.$((j+1))
done
mv /blackbox/system/rmdetect.log /blackbox/system/rmdetect.log.1
boot_debug_echo "before start trace_pipe redirect"
cat /sys/kernel/debug/tracing/trace_pipe > /blackbox/system/rmdetect.log &


boot_debug_echo "before start save_lk_log.sh"
# save log of lk
/system/bin/save_lk_log.sh

unrd > /dev/kmsg

#if [ $wifi_mode == "tx99" ]; then
#    /system/bin/test_wifi_art.sh &
#fi

# Here we update recovery.img since all the service should be started.
# We could make the recovery.img work before this script exit for some
# service not startup.
boot_debug_echo "before start recovery_update.sh"
/system/bin/recovery_update.sh

# For debug
#debuggerd&
### CONFIG_DYNAMIC_FTRACE is set when CONFIG_FUNCTION_TRACER is set.
echo 1 > /proc/sys/kernel/ftrace_enabled
echo 1 > /sys/kernel/debug/tracing/tracing_on

boot_debug_echo "before move recovery logs"
recovery_logfile_size=`busybox wc -c < /cache/recovery/log`
if [ $recovery_logfile_size -gt 4194304 ]; then
    mv /cache/recovery/log3 /cache/recovery/log4
    mv /cache/recovery/log2 /cache/recovery/log3
    mv /cache/recovery/log1 /cache/recovery/log2
    mv /cache/recovery/log  /cache/recovery/log1
else
    echo -e "\n\n!!!new file start!!!\n\n" >> /cache/recovery/log
fi

boot_debug_echo "before start logcat"
# for fatal errors, up to 100MB*3
logcat -f /blackbox/system/system.log -r102400 -n2 DUSS6C:I DUSS51:I DUSS4A:I DUSS01:I *:E &
# for wifi log
#logcat -v time -b radio -f /blackbox/system/wifi.log -r10240 -n10 *:W &
# dump system/upgrade log to a special file
rm /data/dji/upgrade_log.tar.gz
upgrade_file_size=`busybox wc -c < /blackbox/system/upgrade00.log`
if [ $upgrade_file_size -gt 2097152 ]; then
	mv /blackbox/system/upgrade07.log /blackbox/system/upgrade08.log
	mv /blackbox/system/upgrade06.log /blackbox/system/upgrade07.log
	mv /blackbox/system/upgrade05.log /blackbox/system/upgrade06.log
	mv /blackbox/system/upgrade04.log /blackbox/system/upgrade05.log
	mv /blackbox/system/upgrade03.log /blackbox/system/upgrade04.log
	mv /blackbox/system/upgrade02.log /blackbox/system/upgrade03.log
	mv /blackbox/system/upgrade01.log /blackbox/system/upgrade02.log
	mv /blackbox/system/upgrade00.log /blackbox/system/upgrade01.log
else
	echo -e "\n\n!!!new file start!!!\n">> /blackbox/system/upgrade00.log
fi
boot_debug_echo "before start logcat2"
logcat -v threadtime -f /blackbox/system/upgrade00.log DUSS63:I DUSS4A:I DUSS01:I OMX*:I *:S &

# The script test_blackbox_size.sh is used to check blackbox folder size every 30 second
test_blackbox_size.sh /blackbox/system/ &

# USB drive is ready within 2S. adb and bulk will be ready in next 2 seconds.
# so wait 5 second for rndis configuration.
sleep 5
# rndis
ifconfig rndis0 192.168.42.2

boot_debug_echo "before start udhcpd"
busybox udhcpd /etc/udhcpd_rndis.conf

# ftp server on rndis0 interface
# busybox tcpsvd -vE 0 21 busybox ftpd -w /blackbox &

# no need to run setup_usb_serial.sh to set adb serial number
# setprop dji.usb_serial 1
if [ -f /data/dji/autotest_on ]; then
    boot_debug_echo "before start autotest"
    setprop dji.autotest_service 1
fi

if [ -f /data/dji/autoflight_on ]; then
    boot_debug_echo "before start autoflight"
    setprop dji.autoflight_service 1
else
    setprop dji.autoflight_service 0
fi

# check system service status and clean up crash counter.
ps | busybox grep dji_sys
if [ $? != 0 ];then
	boot_debug_echo "dji_sys is not on!"
	echo "crash_counter: dji_sys not exist" > /data/dji/log/crash_counter.log
	sync
	exit -1
fi

ps | busybox grep dji_monitor
if [ $? != 0 ];then
	boot_debug_echo "dji_monitor is not on!"
	echo "crash_counter: dji_monitor not exist" > /data/dji/log/crash_counter.log
	sync
	exit -1
fi

unrd -s wipe_counter 0
unrd -s crash_counter 0
unrd -d slot_switched
boot_control -m

boot_debug_echo "before check fulldump"
# enable full ramdump
if [ -f /data/dji/cfg/fulldump ]; then
	echo 1 > /sys/kernel/debug/fulldump_enable
fi

boot_debug_echo "before check reboot"
# Check whether do auto reboot test
if [ -f /data/dji/cfg/test/reboot ]; then
	sleep 20
	reboot
fi

boot_debug_echo "before check ota"
# Check whether do auto OTA upgrade test
if [ -f /data/dji/cfg/test/ota ]; then
	sleep 10
	/system/bin/ota.sh
fi

boot_debug_echo "before check aging_test"
if [ -f /data/dji/amt/state ]; then
    amt_state=`cat /data/dji/amt/state`
    rm /data/dji/amt/state
    sync
fi

boot_debug_echo "before check tz_bug_on"
if [ -f /data/dji/tz_bug_on ]; then
    echo 1 > ./sys/devices/platform/f0480000.tzasc/tzasc_bug_on
else
    echo 0 > ./sys/devices/platform/f0480000.tzasc/tzasc_bug_on
fi

# to collect crash dump info
dji_crashdump.sh

# to set irq affinity
setup_irq_affinity.sh &

# to collect tombstone
dji_tombstone.sh

# add bwl change
BWL_Change.sh&

touch /data/dji/cfg/ion_daemon_disable
touch /data/dji/cfg/coredump_daemon_disable

sys_perf_monitor.sh &

# larger the min_free_kbytes for more free pages
echo 8380 > /proc/sys/vm/min_free_kbytes
trace_mmc.sh &

boot_debug_echo "before start aging_test2"
if [ "$amt_state"x == "aging_test"x ]; then
    nice -n 10 /system/bin/aging_test.sh
elif [ "$amt_state"x == "aging_test_local"x ]; then
    nice -n 10 /system/bin/aging_test_local.sh
elif [ "$amt_state"x == "aging_test_full_cam"x ]; then
    nice -n 10 /system/bin/aging_test_full_cam.sh
else
    if [ -f /data/dji/cfg/temp_save_en ]; then
        test_temperature.sh 5 save &
    fi
    if [ ! -f /data/dji/cfg/ion_daemon_disable ]; then
        ion_daemon_test.sh &
    fi
    if [ ! -f /data/dji/cfg/coredump_daemon_disable ]; then
        coredump_daemon_test.sh &
    fi
fi
boot_debug_echo "finish all of start_dji_system.sh"
