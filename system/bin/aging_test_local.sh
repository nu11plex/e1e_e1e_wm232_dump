# include the script lib
. lib_test.sh
. lib_test_cases.sh
. parse_error_reason.sh

#aging work flow
aging_npi_ctrl=18
# test for 2 hours (7200s)
timeout=7200
amt=/data/dji/amt
dir=$amt/aging_test
headtitle=unknown
no_sdcard=0
with_camera=1

check_aging_test_result_log $dir/log.txt $dir/result >> /blackbox/system/check_aging.log
if [ $? != 0 ]; then
    echo "check_aging_test_result_log failed!" >> /blackbox/system/check_aging.log
    sync
    led_red_on
    exit 34
fi

rm -rf $dir
rm -rf $amt/codec/
mkdir -p $dir
mkdir -p $amt/codec/
mkdir -p $amt/codec/out/
cp -rf /data/dji/codec/ /data/dji/amt/

sd_dir=/storage/sdcard0
fc_dir=/blackbox/flyctrl
gimbal_dir=/blackbox/gimbal
perception_dir=/blackbox/dji_perception
navigation_dir=/blackbox/navigation
camera_dir=/blackbox/camera

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
    if [ ! -f $need_to_copy_perception_log ]; then
        return 0
    fi
    index=`cat $perception_dir/emmc_index`
    echo "perception index is $index"
    cur_dir=$index
    if [ $no_sdcard -eq 0 ]; then
        mkdir -p $sd_dir/blackbox/perception
        busybox cp $perception_dir/$cur_dir $sd_dir/blackbox/perception -rf
    fi

    mkdir -p $amt/blackbox/perception
    touch $amt/blackbox/perception/$index
}

copy_navigation_result()
{
    if [ ! -f $need_to_copy_navigation_log ]; then
        return 0
    fi
    index=`cat $navigation_dir/emmc_index`
    echo "navigation index is $index"
    cur_dir=$index
    if [ $no_sdcard -eq 0 ]; then
        mkdir -p $sd_dir/blackbox/navigation
        busybox cp $navigation_dir/$cur_dir $sd_dir/blackbox/navigation -rf
    fi

    mkdir -p $amt/blackbox/navigation
    touch $amt/blackbox/navigation/$index
}

copy_aging_log()
{
    if [ $no_sdcard -eq 0 ]; then
        mkdir -p $sd_dir
        busybox cp $amt/aging_test $sd_dir -rf
    fi
}

copy_camera_result()
{
    if [ ! -f $need_to_copy_camera_log ]; then
        return 0
    fi

    if [ $no_sdcard -eq 0 ]; then
        mkdir -p $sd_dir/blackbox/camera
        busybox cp $camera_dir $sd_dir/blackbox/camera -rf
    fi

    mkdir -p $amt/blackbox/camera
    busybox cp $camera_dir $amt/blackbox/camera -rf
}

copy_ofdm_result()
{
    if [ ! -f $need_to_copy_ofdm_log ]; then
        return 0
    fi

    if [ $no_sdcard -eq 0 ]; then
        mkdir -p $sd_dir/blackbox/lc1860_data_dji_log
        adb pull /data/dji/log $sd_dir/blackbox/lc1860_data_dji_log -rf
        #sdrsdump is too large,
        rm -rf $sd_dir/blackbox/lc1860_data_dji_log/sdrsdump
    fi
}

copy_system_result()
{
    if [ ! -f $need_to_copy_system_log ]; then
        return 0
    fi
    if [ $no_sdcard -eq 0 ]; then
        mkdir -p $sd_dir/blackbox/system
        busybox cp /blackbox/system $sd_dir/blackbox/system -rf
    fi
}

copy_result()
{
    # TODO: for debug, will remove later
#    touch $need_to_copy_gimbal_log
#    touch $need_to_copy_flyctl_log
#    touch $need_to_copy_perception_log
#    touch $need_to_copy_navigation_log
#    touch $need_to_copy_ofdm_log
#    touch $need_to_copy_camera_log
    sync
    copy_fc_gimbal_result
    copy_perception_result
    copy_navigation_result
    copy_camera_result
    copy_ofdm_result
    copy_system_result
    # always update the aging_test log
    copy_aging_log
}

# skip this step when fails
clean_up_in_success()
{
    echo "cleanup log files in success..."

    rm -rf /data/dji/amt/codec/in/b3.h264
    rm -rf /data/dji/amt/codec/in/1.jpg
    rm -rf /data/dji/amt/codec/out/b3
    rm -rf /data/dji/amt/codec/out/j
    rm -f /storage/sdcard0/sd.data
    rm -f $dir/eMMC.data
    rm -rf $need_to_copy_gimbal_log
    rm -rf $need_to_copy_flyctl_log
    rm -rf $need_to_copy_perception_log
    rm -rf $need_to_copy_navigation_log
    rm -rf $need_to_copy_ofdm_log
    rm -rf $need_to_copy_camera_log
    rm -rf $need_to_copy_system_log
}

# error action
error_action()
{
    echo error_action: \"$2\", error=$1
    echo $BASHPID
    echo

    me=$BASHPID
    case_name=$2
    orig_error_reason=$1

    if [ $1 -ne 0 ]; then
        echo $2 >> $fail_cnt
        touch $tmp_dir/${me}_${fail_postfix}

        #echo FAILED, \"$2\", error $1 >> $dir/result
        echo "$case_name: FAIL, error code: $orig_error_reason, at $(aging_elapsed) seconds __fail"
        echo
        echo
        #echo aging_test failed, error at case: \"$2\"

        # blinking the red led
        led_red_blink
        sync
    else
        # success in silent
        echo $2 >> $success_cnt
        touch $tmp_dir/${me}_${success_postfix}
    fi

    cnt_nok=`ls -l $tmp_dir | grep -c "${fail_postfix}"`
    cnt_ok=`ls -l $tmp_dir | grep -c "${success_postfix}"`
    cnt_sum=$(($cnt_nok+$cnt_ok))
    echo cnt_nok=$cnt_nok
    echo cnt_ok=$cnt_ok
    echo cnt_sum=$cnt_sum

    if [ $cnt_sum -ge $sum_num ]; then
        touch $dir/finished
        sync
        sleep 5

        if [ $cnt_nok -gt 0 ]; then
            echo FAILED > $dir/result
            echo >> $dir/result
            grep -n "__fail" $dir/log.txt >> $dir/result
            #echo aging_test failed, error at case: \"$2\"
            copy_result
            echo normal > $amt/state
            sync
            led_red_on
        else
            echo PASSED > $dir/result
            echo aging test passed ---------------------
            rm -rf $need_to_copy_system_log
            sync
            copy_result
            echo normal > $amt/state
            clean_up_in_success
            sync
            led_green_on
        fi
        echo "pid of me: $BASHPID, i am exiting."
        sync
        exit $cnt_nok
    fi
}

bsp_ddr_codec_aging_test()
{
    test_mem -s 0x200000 -l 1 || {
        ret=$?
        echo "test_mem __fail ..."
        return $ret
    }
    sleep 10
}

max_sys_pid=0
SYS_PROCS="/system/bin/dji_sys
                        /system/bin/dji_blackbox
                        /system/bin/dji_monitor
                        /system/bin/dji_perception
                        /system/bin/dji_camera2
                        /system/bin/dji_rcam
                        /system/bin/dji_flight
                        /system/bin/dji_navigation"
bsp_get_max_pid()
{
    # setup for max_proc_pid
    for c in $SYS_PROCS
    do
        r=`pidof $c`
        if [ $? -ne 0 ]; then
            echo "bsp_get_max_pid of $c __fail"
            ps | grep dji
            return 1
        fi
        if [ $r -ge $max_sys_pid ]; then
        ((max_sys_pid=$r))
        echo "bsp_get_max_pid of $c is $r, update max_sys_pid=$max_sys_pid"
        fi
    done
}

bsp_monnitor_aging_test()
{
    local cycle_duration=60
    local r

    sleep $cycle_duration
    for c in $SYS_PROCS
    do
        r=`pidof $c`
        if [ $? -ne 0 ]; then
            echo "check_sys_pid of $c __fail"
            ps | grep dji
            return 1
        fi
        if [ $r -gt $max_sys_pid ]; then
            echo "check_sys_pid of $c is $r, max_sys_pid=$max_sys_pid __fail"
            ps | grep dji
            return 2
        fi
        echo "check_sys_pid of $c is $r"
    done
    echo "check_sys_pid ok"
    return 0
}

perception_aging_test()
{
    vp_log_check.sh
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "perception test: `get_perception_fail_reason $ret` __fail..."
        touch $need_to_copy_perception_log
        return $ret
    fi

    return 0
}

navigation_aging_test()
{
    nav_log_check.sh
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "navigation test: `get_navigation_fail_reason $ret`__fail..."
        touch $need_to_copy_navigation_log
        return $ret
    fi
    return 0
}

codec_aging_test()
{
    dji_codec_aging.sh
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "codec test: `get_codec_fail_reason $ret` __fail..."
        return $ret
    fi

    return 0
}

aging_test()
{
    #####################################################################################################
    #              Eagle Platform aging test
    #####################################################################################################
    echo "running aging_test full version!!"
    echo "pid of me: $BASHPID"
    echo "interrupts stats :"
    cat /proc/interrupts | grep sd
    cat /proc/interrupts | grep usb
    echo "interrupts stat ends"
    sleep 1
    if [ -e $sd_dir ];then
        rm -rf $sd_dir/aging_test
        rm -rf $sd_dir/blackbox
        mkdir -p $sd_dir/aging_test
        mkdir -p $sd_dir/blackbox
    else
        echo "no sd card __fail"
        no_sdcard=1
    fi

    sleep 20
    led_green_blink
    config_timeout

    # prepare
    gimbal_enter_aging_mode
    init_bsp_emmc_sd

    bsp_get_max_pid
    if [ $max_sys_pid -lt 100 ]; then
        echo "prepare failed!"
        copy_result
        sync
        led_red_blink
        return 1
    fi

    # bsp ddr aging test
    start_timeout_error_action $mem_test_thread_num "bsp_ddr_codec_aging_test"
    # bsp emmc sd aging test
    start_timeout_error_action $bsp_mmc_sd_thread_num "bsp_emmc_sd_aging_test && sleep 15"
    # check camera aging_test
    start_timeout_error_action $check_camera_thread_num "camera_aging_test 1"
    # check perception aging_test
    start_timeout_error_action $check_perception_thread_num "perception_aging_test"
    # check navigation aging_test
    start_timeout_error_action $check_navigation_thread_num "navigation_aging_test"
    # check codec aging_test
    start_timeout_error_action $check_codec_thread_num "codec_aging_test"

    # bsp monitor aging test
    start_timeout_error_action $bsp_monitor_thread_num "bsp_monnitor_aging_test"

    echo "wait..."
    sleep 120

    # check kinds of components
    start_timeout_error_action $aging_test_thread_num "aging_test_check_link $with_camera"

    #####################################################################################################
    echo "I am the watcher for aging_test_local..."
    local elapsed=0
    ((total_watch_time=$timeout+1800))
    while [ $elapsed -lt $total_watch_time ]; do
        echo "$BASHPID waiting for aging_test..."
        if [ -f $dir/result ]; then
            echo "$dir/result has been generated, now exit!"
            break
        fi
        sleep 60
        ((elapsed=$elapsed+60))
    done
    echo "aging_test_local done. check result"
    if [ ! -f $dir/result ]; then
        if [ ! -f $amt/aging_test/log.txt ]; then
            echo "log.txt not exists"
            echo FAILED >> $dir/result
            copy_result
            echo normal > $amt/state
            sync
            led_red_on
        else
            cnt_nok=`ls -l $tmp_dir | grep -c "${fail_postfix}"`
            cnt_ok=`ls -l $tmp_dir | grep -c "${success_postfix}"`
            cnt_sum=$(($cnt_nok+$cnt_ok))
            echo cnt_nok=$cnt_nok
            echo cnt_ok=$cnt_ok
            echo cnt_sum=$cnt_sum
            if [ $cnt_sum -lt $sum_num ]; then
                echo "someone not finished even we give 30min more than promised! __fail ..."
                echo FAILED > $dir/result
                echo >> $dir/result
                grep -n "__fail" $dir/log.txt >> $dir/result
                copy_result
                echo normal > $amt/state
                sync
                led_red_on
            else
                c=`wc -l $amt/aging_test/log.txt | busybox awk '{print $1}'`
                # we assume log.txt should not less than 100 lines
                if [ $c -lt 100 ]; then
                    echo "log.txt too less"
                    echo FAILED > $dir/result
                    echo >> $dir/result
                    grep -n "__fail" $dir/log.txt >> $dir/result
                    echo "$amt/aging_test/log.txt is too short with $c lines" >> $dir/result
                    copy_result
                    echo normal > $amt/state
                    sync
                    led_red_on
                else
                    r=`grep __fail $amt/aging_test/log.txt`
                    if [ $? -eq 0 ]; then
                        echo "log.txt grep __fail"
                        echo FAILED > $dir/result
                        echo >> $dir/result
                        grep -n "__fail" $dir/log.txt >> $dir/result
                        copy_result
                        echo normal > $amt/state
                        sync
                        led_red_on
                    else
                        echo "pass"
                        rm -rf $need_to_copy_system_log
                        echo PASSED >> $dir/result
                        copy_result
                        echo normal > $amt/state
                        sync
                        led_green_on
                    fi
                fi
            fi
        fi
    fi
    #####################################################################################################
}

add_date()
{
    while IFS= read -r line; do
        echo "[$(date)] $line"
    done
}

rm -rf $fail_cnt
rm -rf $success_cnt
rm -rf $tmp_dir

mkdir -p $tmp_dir
rm -rf $need_to_copy_gimbal_log
rm -rf $need_to_copy_flyctl_log
rm -rf $need_to_copy_perception_log
rm -rf $need_to_copy_navigation_log
rm -rf $need_to_copy_ofdm_log
rm -rf $need_to_copy_camera_log
#default mark as need copy system log
touch $need_to_copy_system_log

#As sdcard need test, need to detach sdcard from PC
#usb_conn=`cat /sys/class/android_usb/android0/state`
#if [ $usb_conn = "CONFIGURED" ];then
#    echo "detach sd from PC"
#    test_hal_storage -c "0 volume detach_pc"
#fi

touch $fail_cnt
touch $success_cnt

bsp_mmc_sd_thread_num=1
mem_test_thread_num=1
aging_test_thread_num=1
check_camera_thread_num=1
check_perception_thread_num=1
check_navigation_thread_num=1
check_codec_thread_num=1
bsp_monitor_thread_num=1

sum_num=$((\
    $bsp_mmc_sd_thread_num+\
    $mem_test_thread_num+\
    $aging_test_thread_num+\
    $check_camera_thread_num+\
    $check_perception_thread_num+\
    $check_navigation_thread_num+\
    $bsp_monitor_thread_num+\
    $check_codec_thread_num\
    ))

echo "aging_test_local start at `date`" >> /blackbox/system/check_aging.log
aging_test | add_date | tee $amt/aging_test/log.txt
#aging_test >> $amt/aging_test/log.txt
echo "aging_test_local finished at `date`" >> /blackbox/system/check_aging.log
gimbal_exit_aging_mode