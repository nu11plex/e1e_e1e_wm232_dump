# include the script lib
. lib_test.sh
. lib_test_cases.sh

#aging work flow
aging_npi_ctrl=18
# test for 2 hours (7200s)
timeout=7200
amt=/data/dji/amt
dir=$amt/aging_test
headtitle=unknown
no_sdcard=0

rm -rf $dir
rm -rf $amt/codec/
mkdir -p $dir
mkdir -p $amt/codec/
mkdir -p $amt/codec/out/
cp -f /data/dji/sample.data /data/dji/amt/
cp -rf /data/dji/codec/ /data/dji/amt/

sd_dir=/storage/sdcard0
fc_dir=/blackbox/flyctrl
gimbal_dir=/blackbox/gimbal
perception_dir=/blackbox/dji_perception
navigation_dir=/blackbox/navigation

# err flag
check_link_err=0
fc_aging_err=0
camera_err=0
ddr_aging_err=0
codec_aging_err=0

# camera store flag in camera partition or sdcard
stored_camera=1

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

copy_syslog()
{
    busybox cp /blackbox/dji_perception  $dir/ -rf
    busybox cp /blackbox/navigation/ $dir/ -rf
}

copy_fc_gimbal_result()
{
    if [[ ! -f $need_to_copy_flyctl_log  && ! -f $need_to_copy_gimbal_log ]]; then
        return 0
    fi
    index=`cat $fc_dir/latest`
    echo "fc index is $index"
    if [ $index -lt 10 ];then
        cur_file=FLY00$index.DAT
    else
        cur_file=FLY0$index.DAT
    fi

    if [ $no_sdcard -eq 0 ]; then
        mkdir -p $sd_dir/blackbox/flyctrl
        busybox cp $fc_dir/$cur_file $sd_dir/blackbox/flyctrl -rf
    fi
    mkdir -p $amt/blackbox/flyctrl
    touch $amt/blackbox/flyctrl/$index
}
copy_perception_result()
{
	index=`cat $perception_dir/emmc_index`
	echo "perception index is $index"
	cur_dir=$index
	mkdir $sd_dir/aging_test/perception
	busybox cp $perception_dir/$cur_dir $sd_dir/aging_test/perception -rf
}
copy_navigation_result()
{
	index=`cat $navigation_dir/emmc_index`
	echo "navigation index is $index"
	cur_dir=$index
	mkdir $sd_dir/aging_test/navigation
	busybox cp $navigation_dir/$cur_dir $sd_dir/aging_test/navigation -rf
}
copy_result()
{
    echo try2 copy result for: $1 $2
    link_str="aging_test_check_link"
    fc_str="fc_aging_test"
    bsp_cpu_str="bsp_cpu_aging_test"
    bsp_ddr_str="bsp_ddr_aging_test"
    bsp_emmc_sd_str="bsp_emmc_sd_aging_test"
    perception_str="vp_log_check.sh"
    navigation_str="nav_log_check.sh"
    camera_str="camera_aging_test"
    codec_str="codec_aging_test"

    if [ $2 != 0 ]; then
        if [[ $1 == *$link_str* ]]; then
            if [ $2 == 1 -o $2 == 2 ];then
                echo "to get gimbal result $2 if link test"
                copy_fc_gimbal_result
            fi
            sleep 0.1
            busybox cp /blackbox/system/kmsg.log $sd_dir/aging_test/kmsg-link.log
            busybox cp /blackbox/system/kmsg.log $dir/kmsg-link.log
        elif [[ $1 == *$fc_str* ]]; then
            echo "to get result of fc"
            copy_fc_gimbal_result
            sleep 0.1
            busybox cp /blackbox/system/kmsg.log $sd_dir/aging_test/kmsg-fc.log
            busybox cp /blackbox/system/kmsg.log $dir/kmsg-fc.log
        elif [[ $1 == *$perception_str* ]]; then
            echo "to get result of perception"
            copy_perception_result
            sleep 0.1
            busybox cp /blackbox/system/kmsg.log $sd_dir/aging_test/kmsg-perception.log
            busybox cp /blackbox/system/kmsg.log $dir/kmsg-perception.log
        elif [[ $1 == *$navigation_str* ]]; then
            echo "to get result of navigation"
            copy_navigation_result
            sleep 0.1
            busybox cp /blackbox/system/kmsg.log $sd_dir/aging_test/kmsg-nav.log
            busybox cp /blackbox/system/kmsg.log $dir/kmsg-nav.log
        elif [[ $1 == *$codec_str* ]]; then
            echo "to get codec data"
            cp -r /data/dji/amt/codec $sd_dir/aging_test
            sleep 0.1
            busybox cp /blackbox/system/kmsg.log $sd_dir/aging_test/kmsg-codec.log
            busybox cp /blackbox/system/kmsg.log $dir/kmsg-codec.log
        elif [[ $1 == *$camera_str* ]]; then
            echo "to get camera data"
            busybox cp -r /blackbox/camera $sd_dir/aging_test
            sleep 0.1
            busybox cp /blackbox/system/kmsg.log $sd_dir/aging_test/kmsg-camera.log
            busybox cp /blackbox/system/kmsg.log $dir/kmsg-camera.log
        elif [[ $1 == *$bsp_emmc_sd_str* ]]; then
            echo "to get emmc sd data"
            busybox cp /blackbox/system/kmsg.log $sd_dir/aging_test/kmsg-emmc-sd.log
            busybox cp /blackbox/system/kmsg.log $dir/kmsg-emmc-sd.log
        elif [[ $1 == *$bsp_ddr_str* ]]; then
            echo "to get ddr data"
            busybox cp /blackbox/system/kmsg.log $sd_dir/aging_test/kmsg-ddr.log
            busybox cp /blackbox/system/kmsg.log $dir/kmsg-ddr.log
        else
            echo "no need to get result of $1 "
        fi
    fi

    # always update the aging_test log
    busybox cp $dir/ $sd_dir/aging_test -rf
    busybox cp /blackbox/system $sd_dir/aging_test -rf
    busybox cp /data/tombstones $sd_dir/aging_test -rf
    busybox cp /data/dji/log $sd_dir/aging_test/djilog -rf
}

get_link_fail_reason()
{
    if [ $1 == 1 ]; then
        aging_fail_reason="link2gimbal"
    elif [ $1 == 2 ]; then
        aging_fail_reason="gimbal_aging"
    elif [ $1 == 3 ]; then
        aging_fail_reason="link2flyctl"
    elif [ $1 == 4 ]; then
        aging_fail_reason="link2esc0"
    elif [ $1 == 5 ]; then
        aging_fail_reason="link2esc1"
    elif [ $1 == 6 ]; then
        aging_fail_reason="link2esc2"
    elif [ $1 == 7 ]; then
        aging_fail_reason="link2esc3"
    else
        aging_fail_reason="unknown"
    fi
}

get_fc_fail_reason()
{
    if [ $1 == 8 ]; then
        aging_fail_reason="fc_acc"
    elif [ $1 == 9 ]; then
        aging_fail_reason="fc_gypo"
    elif [ $1 == 10 ]; then
        aging_fail_reason="fc_baro"
    elif [ $1 == 11 ]; then
        aging_fail_reason="fc_compass"
    elif [ $1 == 12 ]; then
        aging_fail_reason="fc_gps"
    elif [ $1 == 13 ]; then
        aging_fail_reason="fc_recorder"
    elif [ $1 == 16 ]; then
        aging_fail_reason="fc_ofdm"
    elif [ $1 == 18 ]; then
        aging_fail_reason="fc_vo"
    else
        aging_fail_reason="unknown"
    fi
}

get_bsp_fail_reason()
{
    if [ $1 == 1 ]; then
        aging_fail_reason="bsp_cpu"
    elif [ $1 == 2 ]; then
        aging_fail_reason="bsp_ddr"
    elif [ $1 == 3 ]; then
        aging_fail_reason="bsp_emmc_dd"
    elif [ $1 == 4 ]; then
        aging_fail_reason="bsp_emmc_write"
    elif [ $1 == 5 ]; then
        aging_fail_reason="bsp_sd_dd"
    elif [ $1 == 6 ]; then
        aging_fail_reason="bsp_sd_write"
    elif [ $1 == 7 ]; then
        aging_fail_reason="bsp_sd_not_found"
    elif [ $1 == 8 ]; then
        aging_fail_reason="bsp_no_sample_data"
    else
        aging_fail_reason="unknown"
    fi

}

get_perception_fail_reason()
{
    if [ $1 == 1 ]; then
        aging_fail_reason="syslog contains error"
    elif [ $1 == 2 ]; then
        aging_fail_reason="load image fail"
    elif [ $1 == 3 ]; then
        aging_fail_reason="usb init fail"
    elif [ $1 == 4 ]; then
        aging_fail_reason="fname file not exist"
    elif [ $1 == 5 ]; then
        aging_fail_reason="connection.log file not exist"
    elif [ $1 == 6 ]; then
        aging_fail_reason="syslog overflow"
    elif [ $1 == 7 ]; then
        aging_fail_reason="reset"
    else
        aging_fail_reason="unknown"
    fi
}

get_navigation_fail_reason()
{
    if [ $1 == 2 ]; then
        aging_fail_reason="nav_dsp2_fail"
    elif [ $1 == 3 ]; then
        aging_fail_reason="nav_dsp3_fail"
    else
        aging_fail_reason="unknown"
    fi

}

get_camera_fail_reason()
{
    if [ $1 == 1 ]; then
        aging_fail_reason="set capture workmode"
    elif [ $1 == 2 ]; then
        aging_fail_reason="set record workmode"
    elif [ $1 == 3 ]; then
        aging_fail_reason="set playback workmode"
    elif [ $1 == 4 ]; then
        aging_fail_reason="start record"
    elif [ $1 == 5 ]; then
        aging_fail_reason="check recording status"
    elif [ $1 == 6 ]; then
        aging_fail_reason="start video playback"
    elif [ $1 == 7 ]; then
        aging_fail_reason="stop video playback"
    elif [ $1 == 8 ]; then
        aging_fail_reason="stop record"
    elif [ $1 == 9 ]; then
        aging_fail_reason="single capture"
    elif [ $1 == 10 ]; then
        aging_fail_reason="burst capture"
    elif [ $1 == 11 ]; then
        aging_fail_reason="AEB capture"
    elif [ $1 == 12 ]; then
        aging_fail_reason="formart sd card"
    elif [ $1 == 13 ]; then
        aging_fail_reason="get video dcf info"
    elif [ $1 == 14 ]; then
        aging_fail_reason="input argument"
    elif [ $1 == 15 ]; then
        aging_fail_reason="set record video format"
    elif [ $1 == 16 ]; then
        aging_fail_reason="lens drop step"
    elif [ $1 == 17 ]; then
        aging_fail_reason="set MF"
    elif [ $1 == 18 ]; then
        aging_fail_reason="set set expo mode"
    else
        aging_fail_reason="unknown"
    fi
}

get_codec_fail_reason()
{
    if [ $1 == 10 ]; then
        aging_fail_reason="input_video_not_exist"
    elif [ $1 == 11 ]; then
        aging_fail_reason="input_video_md5_error"
    elif [ $1 == 21 ]; then
        aging_fail_reason="vdec_output_not_exist"
    elif [ $1 == 22 ]; then
        aging_fail_reason="vdec_output_md5_error"
    elif [ $1 == 50 ]; then
        aging_fail_reason="input_jpg_not_exist"
    elif [ $1 == 51 ]; then
        aging_fail_reason="input_jpg_md5_error"
    elif [ $1 == 61 ]; then
        aging_fail_reason="jdec_output_not_exist"
    elif [ $1 == 62 ]; then
        aging_fail_reason="jdec_output_md5_errorargument"
    else
        aging_fail_reason="unknown"
    fi
}

try2_get_fail_reason()
{
    echo try2 get fail reason. $1 $2
    headtitle=$1
    link_str="aging_test_check_link"
    fc_str="fc_aging_test"
    bsp_cpu_str="bsp_cpu_aging_test"
    bsp_ddr_str="bsp_ddr_aging_test"
    bsp_emmc_sd_str="bsp_emmc_sd_aging_test"
    perception_str="vp_log_check.sh"
    navigation_str="nav_log_check.sh"
    camera_str="camera_aging_test"
    codec_str="codec_aging_test"

    if [[ $1 == *$link_str* ]]; then
        echo "to get fail reason of link test"
        get_link_fail_reason $2
        headtitle="aging_link"
    elif [[ $1 == *$fc_str* ]]; then
        echo "to get fail reason of fc"
        get_fc_fail_reason $2
        headtitle="fc"
    elif [[ $1 == *$bsp_cpu_str* ]]||[[ $1 == *$bsp_ddr_str ]]||[[ $1 == *$bsp_emmc_sd_str ]]; then
        echo "to get fail reason of bsp or codec"
        get_bsp_fail_reason $2
        headtitle="bsp"
    elif [[ $1 == *$perception_str* ]]; then
        echo "to get fail reason of perception"
        get_perception_fail_reason $2
        headtitle="perception"
    elif [[ $1 == *$navigation_str* ]]; then
        echo "to get fail reason of navigation"
        get_navigation_fail_reason $2
        headtitle="navigation"
    elif [[ $1 == *$camera_str* ]]; then
        echo "to get fail reason of camera"
        get_camera_fail_reason $2
        headtitle="camera"
    elif [[ $1 == *$codec_str* ]]; then
        echo "to get fail reason of codec"
        get_codec_fail_reason $2
        headtitle="codec"
    else
        echo "fail to get fail reason"
        aging_fail_reason="unknown"
    fi
}

try2_delete_data()
{
    echo try2 delete. $1 $2
    bsp_emmc_sd_str="bsp_emmc_sd_aging_test"
    codec_str="bsp_ddr_codec_aging_test"
    all_str="all"

    if [[ $1 == *$bsp_emmc_sd_str ]]; then
        echo "to delete bsp data"
        rm -rf /data/dji/amt/sample.data
        if [ -f $dir/eMMC.data ]; then
            rm -f $dir/eMMC.data
        fi
        if [ -f /storage/sdcard0/sd.data ]; then
            rm -f /storage/sdcard0/sd.data
        fi
    elif [[ $1 == *$codec_str* ]]; then
        echo "to delete codec data"
        rm -rf /data/dji/amt/codec/in/b3.h264
        rm -rf /data/dji/amt/codec/in/1.jpg
        rm -rf /data/dji/amt/codec/out/b3
        rm -rf /data/dji/amt/codec/out/j
    elif [[ $1 == *$all_str* ]]; then
        echo "to delete all related data"
        rm -f $dir/eMMC.data
        rm -f /storage/sdcard0/sd.data
        rm -rf /data/dji/amt/codec/in/b3.h264
        rm -rf /data/dji/amt/codec/in/1.jpg
        rm -rf /data/dji/amt/codec/out/b3
        rm -rf /data/dji/amt/codec/out/j
    else
        echo "to delete unknow data"
    fi
}

# error action
error_action()
{
	echo error_action: \"$2\", error=$1
	if [ -f $dir/finished ]; then
		return $1
	else
		# mark as finished
		if [ $1 -eq 0 ]; then
			touch $dir/finished
			sync
		fi
	fi

	# stop blinking, LEDs off
	sync
	sleep 2		# ensure no conflict with led_blink

	if [ $1 -ne 0 ]; then
		#save test result to file

		#$2 is test cmd, $1 is return value
		try2_get_fail_reason $2 $1
		echo aging_test failed, error at case: \"$2\"
		echo $headtitle: FAIL,"reason: $aging_fail_reason", at $(aging_elapsed) seconds, \
			error code:$1 >> $dir/result

		sync
		echo factory > $amt/state
		sync
		led_red_blink
		copy_result $2 $1
		try2_delete_data $2 $1
		sync
	else
		# already get error
		if [ -f $dir/result ]; then
			echo result has been exsisted
			copy_result $2 $1
			try2_delete_data $2 $1
		else
			echo PASSED > $dir/result
			echo aging test passed ---------------------
			led_green_on
			echo normal > $amt/state
			busybox cp $dir/ $sd_dir/aging_test -rf
			try2_delete_data all all
			touch /data/dji/autotest_on
		fi
		sync
		exit $1
	fi
}

fc_aging_test()
{

    # test acc
    test_fc_status.sh 8 aging_test
    local r=$?
    if [ $r != 0 ]; then
        return 8
    fi
    sleep 1
    # test gypo
    test_fc_status.sh 9 aging_test
    r=$?
    if [ $r != 0 ]; then
        return 9
    fi
    sleep 1
    # test baro
    test_fc_status.sh 10 aging_test
    r=$?
    if [ $r != 0 ]; then
        return 10
    fi
    sleep 1
    # test compass
    test_fc_status.sh 11 aging_test
    r=$?
    if [ $r != 0 ]; then
        return 11
    fi
    sleep 1
    # test gps
    test_fc_status.sh 12 aging_test
    r=$?
    if [ $r != 0 ]; then
        return 12
    fi
    sleep 1

    # test tf card
    test_fc_status.sh 13 aging_test
    r=$?
    if [ $r != 0 ]; then
        return 13
    fi
    sleep 1
    # test ofdm
    test_fc_status.sh 16 aging_test
    r=$?
    if [ $r != 0 ]; then
        return 16
    fi
    # test vision odometry(vo)
    test_fc_status.sh 18 aging_test
    r=$?
    if [ $r != 0 ]; then
        return 18
    fi
    sleep 1
    return 0

}


bsp_cpu_aging_test()
{

    #CPU compression test
    echo "BSP CPU Aging Test Start"
    dd if=/dev/urandom of=/tmp/testimage bs=524288 count=10
    local r=$?
    if [ $r != 0 ]; then
        echo "CPU aging fail"
        return 1
    fi
    gzip -9 -c /tmp/testimage | gzip -d -c > /dev/null
    r=$?
    if [ $r != 0 ]; then
        echo "CPU aging fail in gzip"
        return 1
    fi
    echo "BSP CPU Aging test End"
    return 0
}

bsp_ddr_codec_aging_test()
{
    ddr_str="bsp_ddr_aging_test"
    codec_str="codec_aging_test"

    echo "enter ddr and codec serialize test"
    local link_ret=0
    # communication test
    if [ $ddr_aging_err -eq 0 ];then
        bsp_ddr_aging_test
        link_ret=$?
        if [ $link_ret != 0 ]; then
            echo "test_mem __fail ..."
            error_action $link_ret $link_str
            ddr_aging_err=1
        fi
        sleep 1
    fi
    if [ $codec_aging_err -eq 0 ];then
        codec_aging_test
        link_ret=$?
        if [ $link_ret != 0 ]; then
            error_action $link_ret $codec_str
            codec_aging_err=1
        fi
        sleep 1
    fi
    echo "seialize ddr and codec finished"
    return 0
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
        echo "mount sdcard __fail ..."
        return 7
    fi

    #eMMC
    if [ ! -f $amt/sample.data ];then
        echo "no /data/dji/sample.data, please check data partition!"
        return 8
    fi
    dd if=$amt/sample.data of=$dir/eMMC.data bs=1024 count=1024
    local r=$?
    if [ $r != 0 ]; then
        echo "eMMC aging fail, fail to write eMMC"
        return 4
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
        return 6
    fi
    SD_MD5=`md5sum /storage/sdcard0/sd.data | busybox awk '{print $1}'`
    if [ $SD_MD5 != $std_md5 ]; then
        echo "SD aging fail MD5 is $SD_MD5"
        return 6
    fi

    echo "BSP eMMC Aging test End"

    return 0
}

bsp_aging_test()
{
    local std_md5=1386d2e6f153f79a954e65b0f60326bf

    if [ -f /data/amt/aging_test/eMMC.data ]; then
        rm -f /data/amt/aging_test/eMMC.data
    fi

    if [ -f /storage/sdcard0/sd.data ]; then
        rm -f /storage/sdcard0/sd.data
    fi

    #CPU compression test
    dd if=/dev/urandom of=/tmp/testimage bs=524288 count=10
    gzip -9 -c /tmp/testimage | gzip -d -c > /dev/null
    r=$?
    if [ $r != 0 ]; then
        echo "CPU aging fail MD5 is $eMMC_MD5"
        return 1
    fi

    # memory test
    test_mem -s 0x200000 -l 1
    local r=$?
    if [ $r != 0 ]; then
        echo "DDR aging fail MD5 is $eMMC_MD5"
        return 2
    fi

    #eMMC
    dd if=/data/amt/aging_test/sample.data of=/data/amt/aging_test/eMMC.data bs=1024 count=1024*50
    r=$?
    if [ $r != 0 ]; then
        echo "eMMC aging fail, fail to write eMMC"
        return 3
    fi
    eMMC_MD5=`md5sum /data/amt/aging_test/eMMC.data | busybox awk '{print $1}'`
    if [ $eMMC_MD5 != $std_md5 ]; then
        echo "eMMC aging fail MD5 is $eMMC_MD5"
        return 4
    fi

    #SD
    dd if=/data/amt/aging_test/sample.data of=/storage/sdcard0/sd.data bs=1024 count=1024*50
    r=$?
    if [ $r != 0 ]; then
        echo "SD aging fail, fail to write SD"
        return 5
    fi
    SD_MD5=`md5sum /storage/sdcard0/sd.data | busybox awk '{print $1}'`
    if [ $SD_MD5 != $std_md5 ]; then
        echo "SD aging fail MD5 is $SD_MD5"
        return 6
    fi
    return 0

}

perception_aging_test()
{
	# perception aging test
	vp_log_check.sh
}

navigation_aging_test()
{
	# navigation aging test
	nav_log_check.sh
}

camera_aging_test()
{
    # camera test
    # dji_camera_aging.sh
    #  stored_camera=$((!$stored_camera))
    dji_wm232_camera_aging_full_test.sh 450 $stored_camera
}

codec_aging_test()
{
    # codec test
    dji_codec_aging.sh
}


check_link_ctrlbit()
{
    if [ -f /data/dji/cfg/aging_no_chk_ctrlbit ]; then
        echo "in debug mode. no need check ctrlbit"
        return 0
    fi
    val=`/system/bin/test_npi_script/get_ctrl_bit.sh $aging_npi_ctrl | busybox awk '{print $2}'`
    echo "ctrlbit value: $val"
    if [ $val -eq 1 ]; then
        echo "check ctrlbit passed"
        return 0
    else
        echo "check ctrlbit fail"
        return 1
    fi
}

aging_checkin_test()
{
    check_link_ctrlbit
    if [ $? != 0 ]; then
        error_action 6 $lc1860_str
        exit
    fi
    do_1860_util_test
}

run_timeout_serialize()
{
	echo run_timeout_error_stop: $*
	while [ $(elapsed) -le $timeout ]
	do
		eval $*
		local r=$?
		if [ $r != 0 ]; then
			echo chip $chip_id run \"$*\" get error $r
			return $r
		fi
	done
	error_action $? \"$*\"
}

start_timeout_serialize()
{
	echo start_timeout_error_action: $*
	local n=0
	while [ $n -lt $1 ]; do
		let n+=1
		run_timeout_serialize $2 &
	done
}

serialize_dji_mb_ctrl()
{

    link_str="aging_test_check_link"
    fc_str="fc_aging_test"
    camera_str="camera_aging_test"

    echo "enter seialize mb_ctrl"
    # communication test
    if [ $check_link_err -eq 0 ];then
        aging_test_check_link
        local link_ret=$?
        if [ $link_ret != 0 ]; then
            echo "aging_test_check_link __fail ..."
            error_action $link_ret $link_str
            check_link_err=1
        fi
        sleep 1
    fi

    #fc aging test start, send v1 0x4c command
    if [ $fc_aging_err -eq 0 ];then
        fc_aging_test
        local fc_ret=$?
        if [ $fc_ret != 0 ]; then
            echo "fc_aging_test __fail $fc_ret ..."
            error_action $fc_ret $fc_str
            fc_aging_err=1
        fi
        sleep 1
    fi

    # camera aging test
    if [ $camera_err -eq 0 ];then
        camera_aging_test
        local cam_ret=$?
        if [ $cam_ret != 0 ]; then
            echo "camera_aging_test __fail ..."
            error_action $cam_ret $camera_str
            camera_err=1
        fi
        sleep 1
    fi

    echo "seialize mb_ctrl finished"
    return 0
}

aging_test()
{
    #####################################################################################################
    #              e1e Platform aging test
    #####################################################################################################

    echo "running aging_test_full_cam!!"
    ##gimbal aging test start, send v1 0xf4 command
    ##gimbal老化测试的检测结果是在aging_test_check_link函数里面检查
    gimbal_enter_aging_mode

    # bsp cpu aging test
    # TODO: add some suitable cpu test according to cpu load
    #start_timeout_error_action 1 "bsp_cpu_aging_test"

    # bsp ddr aging test
    start_timeout_error_action 1 "bsp_ddr_codec_aging_test"

    # bsp emmc sd aging test
    start_timeout_error_action 1 "bsp_emmc_sd_aging_test && sleep 15"

    # perception test
    start_timeout_error_action 1 "vp_log_check.sh"

    # navigation test
    start_timeout_error_action 1 "nav_log_check.sh && sleep 20"

    # codec aging test
    #start_timeout_error_action 1 "codec_aging_test"

    # camera aging test
    # communication test
    #fc aging test start, send v1 0x4c command
    start_timeout_serialize  1 "serialize_dji_mb_ctrl && sleep 5"

    # camera aging test
    #start_timeout_error_action 1 "camera_aging_test"
    # communication test
    #start_timeout_error_action 1 "aging_test_check_link && sleep 5"

    #fc aging test start, send v1 0x4c command
    #start_timeout_error_action 1 "fc_aging_test && sleep 5"

    #####################################################################################################
}

sleep 20
led_red_register > $amt/aging_test/log.txt
sleep 1
led_green_register >> $amt/aging_test/log.txt
sleep 1
led_yellow_register >> $amt/aging_test/log.txt
sleep 1

led_yellow_blink >> $amt/aging_test/log.txt
config_timeout >> $amt/aging_test/log.txt

#As sdcard need test, need to detach sdcard from PC
usb_conn=`cat /sys/class/android_usb/android0/state`
if [ $usb_conn = "CONFIGURED" ];then
    echo "detach sd from PC"
    test_hal_storage -c "0 volume detach_pc"
    sleep 6
fi

if [ -e $sd_dir ];then
    if [ -e $sd_dir/aging_test ];then
       # remove last aging test result
       rm -rf $sd_dir/aging_test
    fi
    mkdir $sd_dir/aging_test
    mkdir $sd_dir/aging_test/djilog
else
    echo "error: No sdcard to store aging result!!" >> $amt/aging_test/log.txt
    no_sdcard=1
fi

aging_test >> $amt/aging_test/log.txt
