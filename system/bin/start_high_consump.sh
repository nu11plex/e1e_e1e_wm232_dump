# include the script lib
. lib_test.sh
. lib_test_cases.sh

#aging work flow
aging_npi_ctrl=18
# test for 2 hours (7200s)
timeout=50
amt=/data/dji/amt
dir=$amt/aging_test
headtitle=unknown

rm -rf $amt/codec/
mkdir -p $dir
mkdir -p $amt/codec/
mkdir -p $amt/codec/out/
rm -f $dir/high_consump_log.txt
cp -f /data/dji/sample.data /data/dji/amt/
cp -rf /data/dji/codec/ /data/dji/amt/

# aging_test_timeout configure
config_timeout()
{
	if [ -s $amt/aging_test_timeout ]; then
		time=($(cat  $amt/aging_test_timeout))
		if [ $time == 0 ];then
			echo "timeout value should not as 0"
		else
			timeout=$time
		fi
	fi
	echo "aging_test timeout: $timeout"
}

aging_start=`cat /proc/uptime | busybox awk -F. '{printf $1}'`
aging_elapsed()
{
	local now=`cat /proc/uptime | busybox awk -F. '{printf $1}'`
	local diff=$(($now-$aging_start))
	echo $diff
}

# error action
error_action()
{
	echo error_action: \"$2\", error=$1
	if [ -f $dir/finished ]; then
		return $1
	else
		# mark as finished
		touch $dir/finished
		sync
	fi
}

bsp_ddr_aging_test()
{

    echo "BSP DDR Aging Test Start"
    # memory test
    test_mem -s 0x200000 -l 1
    local r=$?
    if [ $r != 0 ]; then
        echo "DDR aging fail MD5 is $eMMC_MD5"
        return 2
    fi
    echo "BSP DDR Aging test End"
    return 0
}

bsp_emmc_sd_aging_test()
{
    echo "BSP eMMC Aging Test Start"
    local std_md5=1386d2e6f153f79a954e65b0f60326bf

    if [ -f $dir/eMMC.data ]; then
        rm -f $dir/eMMC.data
    fi

    if [ -f /storage/sdcard0/sd.data ]; then
        rm -f /storage/sdcard0/sd.data
    fi
    SDCARD_DIR=`df | busybox grep "/mnt/media_rw" | busybox awk '{print $1}'`
    SDCARD=`echo ${SDCARD_DIR:0:13}`
    echo $SDCARD
    if [ "$SDCARD" != "/mnt/media_rw" ]; then
        return 7
    fi

    #eMMC
    dd if=$amt/sample.data of=$dir/eMMC.data bs=1024 count=1024
    local r=$?
    if [ $r != 0 ]; then
        echo "eMMC aging fail, fail to write eMMC"
    fi
    eMMC_MD5=`md5sum $dir/eMMC.data | busybox awk '{print $1}'`
    if [ $eMMC_MD5 != $std_md5 ]; then
        echo "eMMC aging fail MD5 is $eMMC_MD5"
        return 4
    fi

    #SD
    dd if=$amt/sample.data of=/storage/sdcard0/sd.data bs=1024 count=1024
    r=$?
    if [ $r != 0 ]; then
        echo "SD aging fail, fail to write SD"
    fi
    SD_MD5=`md5sum /storage/sdcard0/sd.data | busybox awk '{print $1}'`
    if [ $SD_MD5 != $std_md5 ]; then
        echo "SD aging fail MD5 is $SD_MD5"
        return 6
    fi

    echo "BSP eMMC Aging test End"

    return 0
}

camera_aging_test()
{
    # camera test
    #dji_camera_aging.sh
    dji_wm230_camera_aging_test_gps.sh
}

codec_aging_test()
{
    # codec test
    dji_codec_aging.sh
}

aging_test()
{
	# clear previous result
	rm -rf $dir/finished

    #####################################################################################################
    #              Eagle Platform aging test
    #####################################################################################################
	# camera aging test
	start_timeout_error_action 1 "camera_aging_test"

	# bsp ddr aging test
	start_timeout_error_action 1 "bsp_ddr_aging_test && dji_codec_aging.sh"

	# bsp emmc sd aging test
	start_timeout_error_action 1 "bsp_emmc_sd_aging_test && sleep 17"

    #####################################################################################################
}

config_timeout >> $amt/aging_test/high_consump_log.txt

#As sdcard need test, need to detach sdcard from PC
usb_conn=`cat /sys/class/android_usb/android0/state`
if [ $usb_conn = "CONFIGURED" ];then
    echo "detach sd from PC"
    test_hal_storage -c "0 volume detach_pc"
fi
sleep 1

aging_test >> $amt/aging_test/high_consump_log.txt
