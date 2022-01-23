. lib_test_utils.sh

local_amt_dir=/data/dji/amt

tmp_dir=$local_amt_dir/aging_test_tmp
need_copy_log_dir=$local_amt_dir/blackbox
fail_cnt=$local_amt_dir/fail_cnt
success_cnt=$local_amt_dir/success_cnt

fail_postfix=fail_result__
success_postfix=success_result__

tmp_counter=0
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
    elif [ $1 == 14 ]; then
        aging_fail_reason="fc_esc"
    elif [ $1 == 15 ]; then
        aging_fail_reason="fc_bat"
    elif [ $1 == 16 ]; then
        aging_fail_reason="fc_ofdm"
    elif [ $1 == 17 ]; then
        aging_fail_reason="fc_rc"
    elif [ $1 == 18 ]; then
        aging_fail_reason="fc_vo"
    else
        aging_fail_reason="unknown"
    fi

    echo $aging_fail_reason
}

add_date()
{
    while IFS= read -r line; do
        echo "[$(date)] $line"
    done
}

## log type: flyctrl gimbal ofdm system perception navigation camera
set_log_copy_flag()
{
    local test_name=$1
    local module_name=$2
    echo "test_name=$test_name module_name=$module_name"
    local need_to_copy_log=$need_copy_log_dir/need_to_copy_${test_name}_${module_name}_log
    echo "set_log_copy_flag: touch $need_to_copy_log"
    touch $need_to_copy_log
    sync
    return 0
}

clear_log_copy_flag()
{
    local test_name=$1
    local module_name=$2
    local need_to_copy_log=$need_copy_log_dir/need_to_copy_${test_name}_${module_name}_log
    rm -rf $need_to_copy_log
    return 0
}

get_log_copy_flag()
{
    local test_name=$1
    local module_name=$2
    #echo "test_name=$test_name module_name=$module_name"
    local need_to_copy_log=$need_copy_log_dir/need_to_copy_${test_name}_${module_name}_log
    #echo "get_log_copy_flag: judge $need_to_copy_log is exist or not"
    if [ ! -f $need_to_copy_log ]; then
        return 0
    else
        return 1
    fi
}

# link path test cases
#

linked_to_camera()
{
    cmd_check_ver camera 1 0
}

linked_to_flyctl()
{
    cmd_check_ver fc 3 6
}

linked_to_gimbal()
{
    cmd_check_ver gimbal 4 0
}

linked_to_battery()
{
    return 0
#    cmd_check_ver battery 11 0
}

linked_to_esc()
{
    cmd_check_ver esc 12 $1
}

# 0x1707(dji_vision) is local channel of 1860
# so no need for AMT aging_test
linked_to_mvision()
{
    cmd_check_ver mvision 17 7
}

# ma2100 version is got from the log,
# so we check the USB to decide whether everything works
linked_to_bvision()
{
    test_perception_status.sh all
}

linked_to_cpld()
{
    cmd_check_ver cpld 18 3
}

linked_to_tof()
{
    cmd_check_ver tof 18 2
}

check_ultrasonic_reset_pin()
{
    gpio_write $ULTRA_RESET 0
    sleep 1
    cmd_check_ver ultrasonic_rst 8 4 1>/dev/null
    if [ $? == 0 ];then
        echo "FAILED: Still can got version after ultrasonic reset!, perception __fail"
        return 1
    fi

    gpio_write $ULTRA_RESET 1
    sleep 3
    cmd_check_ver ultrasonic_rst 8 4 || return $?
}

linked_to_perception()
{
    linked_to_bvision || return $?
}

linked_to_ofdm()
{
    cmd_check_ver ofdm 9 0 && test_fc_status.sh ofdm
    if [ $? -ne 0 ]; then
        echo "#### fc ofdm failed! i will sleep 5 min"
        si = 0
        while [ true ]; do
            echo "#### sleep round $si s"
            sleep 1
            let si=si+1
            if [ $si -gt 300 ]; then
                echo "#### finish sleep, return fail"
                return 1
            fi
        done
    fi
    echo "#### test pass, continue"
    return 0
}

linked_to_adsb()
{
	echo "linked to adsb"
	cmd_check_ver adsb 8 6 || return $?
}

p1_enter_5G_mode()
{
    result=`dji_mb_ctrl -S test -R local4 -o 10000000 -g 9 -t 0 -s 7 -c 0x30 555300005553000001`
    if [ $? != 0 ];then
        echo "cmd error $?, please check p1 5G control version and connection!!!"
        sleep 10
        result=`dji_mb_ctrl -S test -R local4 -o 10000000 -g 9 -t 0 -s 7 -c 0x30 555300005553000001`
        if [ $? != 0 ]; then
            echo "cmd __fail $?, please check p1 5G control version and connection!!!"
            return 1
        fi
    fi
    echo $result
    raw_data=${result##*data:}

    result=`echo $raw_data | busybox awk '{printf $1}'`
    if [ $result != "00" ]; then
        echo "err $result, p1 5G return __fail."
        return 2
    fi

    return 0
}

p1_enter_amt_mode()
{
    result=`dji_mb_ctrl -S test -R local4 -o 10000000 -g 9 -t 0 -s 9 -c 0x2c 544d02060c000000010000000200020000000000`
    if [ $? != 0 ];then
        echo "cmd error $?, please check p1 amt control version and connection!!!"
        sleep 10
        result=`dji_mb_ctrl -S test -R local4 -o 10000000 -g 9 -t 0 -s 9 -c 0x2c 544d02060c000000010000000200020000000000`
        if [ $? != 0 ]; then
            echo "cmd __fail $?, please check p1 amt control version and connection!!!"
            return 1
        fi
    fi
    echo $result
    raw_data=${result##*data:}

    result=`echo $raw_data | busybox awk '{printf $9$10}'`
    if [ $result != "0100" ]; then
        echo "err $result, p1 amt return __fail."
        return 2
    fi

    return 0
}

p1_use_cp0_mode()
{
    result=`dji_mb_ctrl -S test -R local4 -o 10000000 -g 9 -t 0 -s 9 -c 0x2c 544d03061c00000000001b00140a040001000100ff7fff7fff7fff7fff7fff7fff7fff7f`
    if [ $? != 0 ];then
        echo "cmd error $?, please check p1 cp0 control version and connection!!!"
        sleep 10
        result=`dji_mb_ctrl -S test -R local4 -o 10000000 -g 9 -t 0 -s 9 -c 0x2c 544d03061c00000000001b00140a040001000100ff7fff7fff7fff7fff7fff7fff7fff7f`
        if [ $? != 0 ]; then
            echo "cmd __fail $?, please check p1 cp0 control version and connection!!!"
            return 1
        fi
    fi
    echo $result
    raw_data=${result##*data:}

    result=`echo $raw_data | busybox awk '{printf $9$10}'`
    if [ $result != "0100" ]; then
        echo "err $result, p1 cp0 return __fail."
        return 2
    fi

    return 0
}

p1_use_cp1_mode()
{
    result=`dji_mb_ctrl -S test -R local4 -o 10000000 -g 9 -t 0 -s 9 -c 0x2c 544d03061c00000000001b00140a040001000200ff7fff7fff7fff7fff7fff7fff7fff7f`
    if [ $? != 0 ];then
        echo "cmd error $?, please check p1 cp1 control version and connection!!!"
        sleep 10
        result=`dji_mb_ctrl -S test -R local4 -o 10000000 -g 9 -t 0 -s 9 -c 0x2c 544d03061c00000000001b00140a040001000200ff7fff7fff7fff7fff7fff7fff7fff7f`
        if [ $? != 0 ]; then
            echo "cmd __fail $?, please check p1 cp1 control version and connection!!!"
            return 1
        fi
    fi
    echo $result
    raw_data=${result##*data:}

    result=`echo $raw_data | busybox awk '{printf $9$10}'`
    if [ $result != "0100" ]; then
        echo "err $result, p1 cp1 return __fail."
        return 2
    fi

    return 0
}

s1_high_consump_test_main()
{
    amt0_amt1=$((!$amt0_amt1))
    if [ x"$amt0_amt1" == x"0" ]; then
        echo "use cp 0 to test..."
        p1_use_cp0_mode
        ret=$?
    else
        echo "use cp 1 to test..."
        p1_use_cp1_mode
        ret=$?
    fi
    if [ $ret -ne 0 ]; then
        echo "s1_high_consump_test: _fail"
        touch $need_to_copy_p1_log
        return $ret
    fi

    sleep 300
    return 0
}

s1_high_consump_test()
{
    s1_high_consump_test_log=$local_amt_dir/aging_test/s1_high_consump_test.log
    if [ ! -f $s1_high_consump_test_log ]; then
        touch $s1_high_consump_test_log
    fi

    s1_high_consump_test_main |add_date  >> $s1_high_consump_test_log
    result=${PIPESTATUS[0]}
    return $result
}

check_tomstones_valid()
{
    result=`busybox grep -rC 5  "SIGSEGV" /data/tombstones`
    if [ $? == 0 ];then
        echo "tomstones is valid"
        echo "$result"
        return 0
    else
        return 1
    fi
}

sys_check_tomstones()
{
    result=`ls -l /data/tombstones|busybox grep tombstone`
    if [ $? == 0 ];then
        check_tomstones_valid
        if [ $? == 0 ];then
            echo "tomstones data have exist: _fail"
            return 2
        else
            echo "tomstones data  unvalid. clear it."
            rm -rf /data/tombstones/*
        fi
    fi

    return 0
}

sys_check_coredump()
{
    result=`ls -l /data/coredump|busybox grep core`
    if [ $? == 0 ];then
        echo "coredump data have exist: _fail"
        return 2
    fi

    return 0
}

sys_error_status_check_main()
{
    sleep 10
    echo sys_error_status_check begin..., $BASHPID
    a=0
    b=0
    c=0
    d=0
    e=0
    f=0
    g=0
    h=0
    i=0
    j=0
    k=0
    l=0
    m=0
    n=0

    sys_check_tomstones
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "sys_check_tomstones __fail ..."
        echo
        a=1
    fi

    sys_check_coredump
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "sys_check_tomstones __fail ..."
        echo
        b=1
    fi

    echo sys_error_status_check ends...

    u=$a$b$c$d$e$f$g$h$i$j$k$l$m$n
    if [ 0x${u} != "0x00000000000000" ]; then
        echo "serialize: sys_error_status_check __fail result: $u"
        echo
        echo
        return 1
    fi

    return 0
}

sys_error_status_check()
{
    sys_error_status_check_log=$local_amt_dir/aging_test/sys_error_status_check.log
    if [ ! -f $sys_error_status_check_log ]; then
        touch $sys_error_status_check_log
    fi

    sys_error_status_check_main |add_date  >> $sys_error_status_check_log
    result=${PIPESTATUS[0]}
    return $result
}

gimbal_enter_aging_mode()
{
    local n=0
    local retry=3
    while [ $n -lt $retry ]; do
        let n+=1
        dji_mb_ctrl -S test -R local5 -g 4 -t 0 -s 0 -c 0xf4 -1 1
        if [ $? == 0 ]; then
            return 0
        fi
    done
    return 1
}

gimbal_exit_aging_mode()
{
    dji_mb_ctrl -S test -R local5 -g 4 -t 0 -s 0 -c 0xf5
}

gimbal_aging_check()
{
    local n=0
    local retry=2
    while [ $n -lt $retry ]; do
        let n+=1
        info=`dji_mb_ctrl -S test -R local5 -g 4 -t 0 -s 0 -c 0xf6`
        if [ $? != 0 ]; then
            sleep 1
            continue
        fi
        #echo $info
        echo $info
        resp_data=${info##*data:}
        result=`echo $resp_data | busybox awk '{print $1}'`
        val=`echo $resp_data | busybox awk '{print $2}'`
        err_reason="`echo $resp_data | busybox awk '{print $3}'`"
        if [ $result != "00" ]; then
            echo $resp_data
            echo "gimbal $err_reason __fail"
            return 1
        else
            if [[ $val == "00"  || $val == "02" ]]; then
                return 0
            else
                echo "gimbal $err_reason __fail"
                return 1
            fi
        fi
    done

    return 1
}

module_aging_test_result_check_main()
{
    sleep 5
    echo module aging test result check begin..., $BASHPID
    a=0
    b=0
    c=0
    d=0
    e=0
    f=0
    g=0
    h=0
    i=0
    j=0
    k=0
    l=0
    m=0
    n=0

    gimbal_aging_check
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "gimbal_aging_check __fail ..."
        echo
        set_log_copy_flag module_aging_test_result_check flyctrl
        a=1
    fi

    echo module aging test result check ends...

    u=$a$b$c$d$e$f$g$h$i$j$k$l$m$n
    if [ 0x${u} != "0x00000000000000" ]; then
        echo "serialize: module aging test result check __fail result: $u"
        echo
        echo
        return 1
    fi

    return 0
}

module_aging_test_result_check()
{
    module_aging_test_result_check_log=$local_amt_dir/aging_test/module_aging_test_result_check.log
    if [ ! -f $module_aging_test_result_check_log ]; then
        touch $module_aging_test_result_check_log
    fi

    module_aging_test_result_check_main |add_date  >> $module_aging_test_result_check_log
    result=${PIPESTATUS[0]}
    return $result
}

bsp_ddr_codec_aging_test_main()
{
    test_mem -s 0x200000 -l 1 || {
        ret=$?
        echo "test_mem __fail ..."
        return $ret
    }
    sleep 10
}

bsp_ddr_codec_aging_test()
{
    bsp_ddr_codec_aging_test_log=$local_amt_dir/aging_test/bsp_ddr_codec_aging_test.log
    if [ ! -f $bsp_ddr_codec_aging_test_log ]; then
        touch $bsp_ddr_codec_aging_test_log
    fi

    bsp_ddr_codec_aging_test_main |add_date  >> $bsp_ddr_codec_aging_test_log
    result=${PIPESTATUS[0]}
    return $result
}

fc_aging_test()
{
    #test_fc_status.sh all
    # TODO
    test_fc_status.sh main_card
}

sys_temp_check()
{
    monitor_temperature.sh
}

fan_control_check()
{
    test_fc_status.sh fan
}

init_bsp_emmc_sd()
{
    local amt=/data/dji/amt
    #eMMC
    if [ ! -f $amt/sample.data ]; then
        dd if=/dev/urandom of=$amt/sample.data bs=1024 count=1024 >> $amt/aging_test/log.txt 2>&1
        sync
    fi
    if [ ! -f $amt/sample.data ]; then
        echo "init_bsp_emmc __fail"
        return 1
    fi
    echo "init_bsp_emmc ok"
    return 0
}

bsp_emmc_sd_aging_test_main()
{
    echo "BSP eMMC Aging Test Start"
    local amt=/data/dji/amt
    local dir=$amt/aging_test

    rm -f $dir/eMMC.data
    sync
    cp -f $amt/sample.data $dir/eMMC.data
    sync
    local result=`busybox cmp $amt/sample.data $dir/eMMC.data`
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "emmc $ret __fail ..."
        return 2
    fi
    echo "emmc pass"

    return 0
}

bsp_emmc_sd_aging_test()
{
    bsp_emmc_sd_aging_test_log=$local_amt_dir/aging_test/bsp_emmc_sd_aging_test.log
    if [ ! -f $bsp_emmc_sd_aging_test_log ]; then
        touch $bsp_emmc_sd_aging_test_log
    fi

    bsp_emmc_sd_aging_test_main |add_date  >> $bsp_emmc_sd_aging_test_log
    result=${PIPESTATUS[0]}
    return $result
}

aging_test_check_link_main()
{
    sleep 5
    echo aging test check link begin..., $BASHPID
    a=0
    b=0
    c=0
    d=0
    e=0
    f=0
    g=0
    h=0
    i=0
    j=0
    k=0
    l=0
    m=0
    n=0
    o=0
    w=0

    linked_to_gimbal || {
        echo "linked_to_gimbal __fail ..."
        echo
        set_log_copy_flag aging_test_check_link gimbal
        a=1
    }
    linked_to_flyctl || {
        echo "linked_to_flyctl __fail ..."
        echo
        set_log_copy_flag aging_test_check_link flyctrl
        c=1
    }
    linked_to_esc 0 || {
        echo "linked_to_esc 0 __fail ..."
        echo
        d=1
    }
    linked_to_esc 1 || {
        echo "linked_to_esc 1 __fail ..."
        echo
        e=1
    }
    linked_to_esc 2 || {
        echo "linked_to_esc 2 __fail ..."
        echo
        f=1
    }
    linked_to_esc 3 || {
        echo "linked_to_esc 3 __fail ..."
        echo
        g=1
    }

    linked_to_ofdm
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "linked_to_ofdm __fail ..."
        echo
        set_log_copy_flag aging_test_check_link ofdm
        n=1
    fi

    # error number begins from 8, ends with 18 use it!!
    fc_aging_test
    ret=$?
    if [ $ret -ne 0 ]; then
        #reason=`get_fc_fail_reason $ret`
        echo "linked_to_flyctl __fail, aging_test"
        echo
        set_log_copy_flag aging_test_check_link flyctrl
        h=1
    fi

    sys_temp_check
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "sys_temp_check __fail ..."
        echo
        j=1
    fi

    fan_control_check
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "sys_fan_check __fail ..."
        echo
        j=1
    fi

    #linked_to_camera
    #ret=$?
    #if [ $ret -ne 0 ]; then
    #    echo "camera link __fail ..."
    #    echo
    #    touch $need_to_copy_camera_log
    #    j=1
    #fi

    linked_to_perception
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "linked_to_perception __fail ..."
        echo
        set_log_copy_flag aging_test_check_link perception
        k=1
    fi

    linked_to_adsb
    ret=$?
    if [ $ret -ne 0 ]; then
    	echo "linked_to_adsb __fail ..."
	echo
	#set_log_copy_flag aging_test_check_link adsb
	o=1
    fi

    linked_to_battery
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "linked_to_battery __fail ..."
        echo
        set_log_copy_flag aging_test_check_link flyctrl
        l=1
    fi

    echo aging test check link ends...

    u=$a$b$c$d$e$f$g$h$i$j$k$l$m$n$w$o
    if [ 0x${u} != "0x0000000000000000" ]; then
        echo "serialize: aging test __fail result: $u"
        echo
        echo
        return 1
    fi
    return 0
}

aging_test_check_link()
{
    aging_test_check_link_log=$local_amt_dir/aging_test/aging_test_check_link.log
    if [ ! -f $aging_test_check_link_log ]; then
        touch $aging_test_check_link_log
    fi

    aging_test_check_link_main |add_date  >> $aging_test_check_link_log
    result=${PIPESTATUS[0]}
    return $result
}

# program fpga
program_fpga()
{
    cpld_dir=/data/dji/amt/factory_out/cpld
    mkdir -p $cpld_dir
    rm -rf $cpld_dir/log.txt
    local r=0
    local n=0
    while [ $n -lt 3 ]; do
        let n+=1
        test_fpga /dev/i2c-1 /dev/i2c-1 64 400000 /vendor/firmware/cpld_v4a.fw >> $cpld_dir/log.txt
        r=$?
        if [ $r == 0 ]; then
            #boot.mode will be remove in the ENC step
            #env -d boot.mode
            #echo factory > /data/dji/amt/state
            break
        fi
    done
    echo $r > $cpld_dir/result
}

# check a9s LCD path
check_camera_data()
{
#test_encoding
}

# check flyctl USB
# can be ttyACM# or others

# factory test state control
switch_test_state()
{
    echo $1 > /data/dji/amt/state
}

perception_aging_test_main()
{
    # perception aging test
    vp_log_check.sh
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "perception aging test __fail ..."
        set_log_copy_flag perception_aging_test perception
    fi
}

perception_aging_test()
{
    perception_aging_test_log=$local_amt_dir/aging_test/perception_aging_test.log
    if [ ! -f $perception_aging_test_log ]; then
        touch $perception_aging_test_log
    fi

    perception_aging_test_main |add_date  >> $perception_aging_test_log
    result=${PIPESTATUS[0]}
    return $result
}

navigation_aging_test_main()
{
    # navigation aging test
    nav_log_check.sh
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "navigation aging test __fail ..."
        set_log_copy_flag navigation_aging_test navigation
    fi
    return $ret
}

navigation_aging_test()
{
    navigation_aging_test_log=$local_amt_dir/aging_test/navigation_aging_test.log
    if [ ! -f $navigation_aging_test_log ]; then
        touch $navigation_aging_test_log
    fi

    navigation_aging_test_main |add_date  >> $navigation_aging_test_log
    result=${PIPESTATUS[0]}
    return $result
}

camera_aging_test_main()
{
    echo start camera_aging_test_main
    # camera test
    #dji_camera_aging.sh
    local full_or_basic=$1
    stored_camera=$((!$stored_camera))
    #dji_wm230_camera_aging_test.sh 450 $stored_camera
    if [ x"$full_or_basic" == x"0" ]; then
        echo "start basic camera aging_test $stored_camera..."
        dji_wm232_camera_aging_test.sh 450 $stored_camera
        ret=$?
    else
        echo "start full camera aging_test $stored_camera ..."
        dji_wm232_camera_aging_full_test.sh 450 $stored_camera
        ret=$?
    fi
    echo stop camera_aging_test_main
    if [ $ret -ne 0 ]; then
        echo "camera test: `get_camera_fail_reason $ret` __fail..."
        ((tmp_counter=$tmp_counter+1))
        echo "now copy camera log as $tmp_counter ..."
        #mkdir -p $local_amt_dir/blackbox/camera_$tmp_counter
        #busybox cp $camera_dir $local_amt_dir/blackbox/camera_$tmp_counter -rf
        #mkdir -p $local_amt_dir/blackbox/camera_sys_$tmp_counter
        #busybox cp /blackbox/system $local_amt_dir/blackbox/camera_sys_$tmp_counter -rf
        set_log_copy_flag camera_aging_test camera
        return $ret
    fi

    sleep 10
    return 0
}

camera_aging_test()
{
    camera_aging_test_log=$local_amt_dir/aging_test/camera_aging_test.log
    if [ ! -f $camera_aging_test_log ]; then
        touch $camera_aging_test_log
    fi

    camera_aging_test_main $1 |add_date  >> $camera_aging_test_log
    result=${PIPESTATUS[0]}
    return $result
}

codec_aging_test_main()
{
    # codec test
    dji_codec_aging.sh
}

codec_aging_test()
{
    codec_aging_test_log=$local_amt_dir/aging_test/codec_aging_test.log
    if [ ! -f $codec_aging_test_log ]; then
        touch $codec_aging_test_log
    fi

    codec_aging_test_main |add_date  >> $codec_aging_test_log
    result=${PIPESTATUS[0]}
    return $result
}

check_aging_test_result_log()
{
    local log_file=$1
    local result_file=$2

    echo "check_aging_test_result_log $* at `date`"
    if [ -f $result_file ]; then
        grep "__fail" $result_file
        if [ $? = 0 ]; then
            return 1
        fi
        grep "FAILED" $result_file
        if [ $? = 0 ]; then
            return 2
        fi
    fi
    if [ -f $log_file ]; then
        grep "__fail" $log_file
        if [ $? = 0 ]; then
            return 3
        fi
    fi

    return 0
}

function set_ofdm_aging_timeout()
{
    let pigeon_aging_timeout=timeout-300
    echo "setting pigeon aging timeout: ${pigeon_aging_timeout}"
    # It's not a reliable way to write to a file in ram file system of pigeon
    adb -s ${pigeon_name} shell "setprop pigeon_aging_test_timeout ${pigeon_aging_timeout} "
    if [ $? -ne 0 ]; then
        echo "set pigeon aging test timeout __fail."
        return 2
    fi
}

function start_ofdm_aging_test()
{
    echo "starting pigeon aging test by adb"
    # It's not a reliable way to write to a file in ram file system of pigeon

    #adb -s ${pigeon_name} shell "aging_test_entry.sh"
    #if [ $? -ne 0 ]; then
    #    echo "start pigeon aging test by adb __fail."
    #    return 1
    #fi

    #sleep 2

    adb -s ${pigeon_name} shell "setprop start_pigeon_aging_test 1"
    if [ $? -ne 0 ]; then
        echo "start pigeon aging test by adb __fail."
        return 1
    fi

    return 0
}

readonly success_suffix=success_result__
readonly fail_suffix=fail_result__
function ofdm_aging_test_main()
{
    echo "checking pigeon aging test state by adb"
    local pigeon_success_cnt=$(adb -s ${pigeon_name} shell "ls ${tmp_dir} | grep -c ${success_suffix}")
    local pigeon_fail_cnt=$(adb -s ${pigeon_name} shell "ls ${tmp_dir} | grep -c ${fail_suffix}")
    echo ${pigeon_success_cnt} > ${local_amt_dir}/pigeon_success_cnt
    echo ${pigeon_fail_cnt} > ${local_amt_dir}/pigeon_fail_cnt
    if [ ${pigeon_fail_cnt} -gt 0 ]; then
        echo "there is something wrong with pigoen aging test"
        set_log_copy_flag ofdm_aging_test ofdm
        return 1
    fi

    return 0
}

function ofdm_aging_test()
{
    ofdm_aging_test_log=$local_amt_dir/aging_test/ofdm_aging_test.log
    if [ ! -f $ofdm_aging_test_log ]; then
        touch $ofdm_aging_test_log
    fi

    ofdm_aging_test_main |add_date  >> $ofdm_aging_test_log
    result=${PIPESTATUS[0]}
    return $result
}

function copy_ofdm_aging_test_log() {
    adb -s ${pigeon_name} pull /data/dji/amt/ $local_amt_dir/aging_test/ofdm/
    sync
}
