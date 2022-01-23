# include the script lib
. lib_test.sh
. lib_test_cases.sh
. fc_led_ctrl.sh
. parse_error_reason.sh
. lock.sh

#aging work flow
aging_npi_ctrl=18
pigeon_name=pigeon
# test for 2 hours (7200s)
timeout=7200
amt=/data/dji/amt
dir=$amt/aging_test
headtitle=unknown
no_sdcard=0
with_camera=0
lockfile=/data/dji/lock.tmp

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
mkdir -p $dir/ofdm/
mkdir -p $amt/codec/
mkdir -p $amt/codec/out/
cp -rf /data/dji/codec/ /data/dji/amt/

sd_dir=/storage/sdcard0
log_copy_base_dir=$sd_dir/aging_test
fc_dir=/blackbox/flyctrl
flight_dir=/blackbox/dji_flight
gimbal_dir=/blackbox/gimbal
perception_dir=/blackbox/dji_perception
dsp_manager_dir=/blackbox/ss_dsp_manager
navigation_dir=/blackbox/navigation
navigation_fc_dir=/blackbox/navigation_fc
camera_dir=/blackbox/camera
ofdm_dir=/blackbox/sdrs_log
ofdm_dump_dir=/blackbox/p1_dump_data
sys_dir=/blackbox/system

# camera store flag in camera partition or sdcard
stored_camera=1

# s1 high consump test flag
amt0_amt1=1

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

copy_all_need_log()
{
    if [ $no_sdcard -eq 0 ]; then
        sync

        local module_name=$1
        echo "$module_name: start to copy log"

        get_log_copy_flag $module_name flyctrl
        if [ $? == 1 ];then
            echo "$module_name: flyctrl log need to copy, now copy it."
            #mkdir -p $log_copy_base_dir/$module_name/flyctrl
            #mkdir -p $log_copy_base_dir/$module_name/flight
            log_to_dest_direct flyctrl now $log_copy_base_dir/$module_name > /dev/null 2>&1
            log_to_dest_direct dji_flight now $log_copy_base_dir/$module_name > /dev/null 2>&1
            #busybox cp $fc_dir/* $log_copy_base_dir/$module_name/flyctrl -rf
           # busybox cp $flight_dir/* $log_copy_base_dir/$module_name/flight -rf
        fi

        get_log_copy_flag $module_name gimbal
        if [ $? == 1 ];then
            echo "$module_name: gimbal log need to copy, now copy it."
            #mkdir -p $log_copy_base_dir/$module_name/gimbal
            #busybox cp $fc_dir/* $log_copy_base_dir/$module_name/gimbal -rf
            log_to_dest_direct flyctrl now $log_copy_base_dir/$module_name > /dev/null 2>&1
        fi

        get_log_copy_flag $module_name camera
        if [ $? == 1 ];then
            echo "$module_name: camera log need to copy, now copy it."
            mkdir -p $log_copy_base_dir/$module_name/camera
            busybox cp $camera_dir/* $log_copy_base_dir/$module_name/camera -rf
        fi

        get_log_copy_flag $module_name perception
        if [ $? == 1 ];then
            echo "$module_name: perception log need to copy, now copy it."
            #mkdir -p $log_copy_base_dir/$module_name/perception
            #mkdir -p $log_copy_base_dir/$module_name/ss_dsp_manager
            log_to_dest_direct perception now $log_copy_base_dir/$module_name > /dev/null 2>&1
            log_to_dest_direct ss_dsp now $log_copy_base_dir/$module_name > /dev/null 2>&1
            #busybox cp $perception_dir/* $log_copy_base_dir/$module_name/perception -rf
            #busybox cp $dsp_manager_dir/* $log_copy_base_dir/$module_name/ss_dsp_manager -rf
        fi

        get_log_copy_flag $module_name navigation
        if [ $? == 1 ];then
            echo "$module_name: navigation log need to copy, now copy it."
            #mkdir -p $log_copy_base_dir/$module_name/navigation
            #mkdir -p $log_copy_base_dir/$module_name/navigation_fc
            log_to_dest_direct navigation now $log_copy_base_dir/$module_name > /dev/null 2>&1
            #busybox cp $navigation_dir/* $log_copy_base_dir/$module_name/navigation -rf
            #busybox cp $navigation_fc_dir/* $log_copy_base_dir/$module_name/navigation_fc -rf
        fi

        get_log_copy_flag $module_name ofdm
        if [ $? == 1 ];then
            echo "$module_name: ofdm log need to copy, now copy it."
            mkdir -p $log_copy_base_dir/$module_name/ofdm
            #mkdir -p $log_copy_base_dir/$module_name/ofdm_dump
            #log_to_dest_direct sdrs_log now $log_copy_base_dir/$module_name > /dev/null 2>&1
            #log_to_dest_direct sdrs_serial now $log_copy_base_dir/$module_name > /dev/null 2>&1
            busybox cp $ofdm_dir/* $log_copy_base_dir/$module_name/ofdm -rf
            #busybox cp $ofdm_dump_dir/* $log_copy_base_dir/$module_name/ofdm_dump -rf
        fi

        # the system log need to copy, no matter what err happen
        #get_log_copy_flag $module_name system
        #if [ $? == 1 ];then
            echo "$module_name: system log need to copy, now copy it."
            mkdir -p $log_copy_base_dir/$module_name/system
            mkdir -p $log_copy_base_dir/$module_name/coredump
            mkdir -p $log_copy_base_dir/$module_name/tombstones
            busybox cp $sys_dir/* $log_copy_base_dir/$module_name/system -rf
            busybox cp /data/coredump/* $log_copy_base_dir/$module_name/coredump -rf
            busybox cp /data/tombstones/* $log_copy_base_dir/$module_name/tombstones -rf
        #fi

        sync
        # no matter what err , the aging log must copy to sdcard.
        mkdir -p $log_copy_base_dir/$module_name/aging_test
        busybox cp $amt/* $log_copy_base_dir/$module_name/aging_test -rf
    fi
}

# error action
error_action()
{
    aging_test_lock
    local me=$BASHPID
    local case_name=`echo $2 |busybox sed 's/\"//g'`
    local orig_error_reason=$1

    echo "######################pid=${me}, name=${case_name} finished, result=${orig_error_reason}###################################"
    # if someone is complete, no matter it is success or faild, we change the amt state to normal. the next brying up will not restart the aging test
    echo normal > $amt/state
    echo "###########################$case_name finished###################################" >> $dir/result

    if [ $1 -ne 0 ]; then
        echo $2 >> $fail_cnt
        touch ${tmp_dir}/${me}_${fail_postfix}
        grep  "__fail" $dir/$case_name.log >> $dir/result
        #echo __fail, \"$case_name\", error $1 >> $dir/result
        echo "$case_name: FAIL, error code: ${orig_error_reason}, at $(aging_elapsed) seconds __fail" >> $dir/result
        echo "$case_name: FAIL, error code: ${orig_error_reason}, at $(aging_elapsed) seconds __fail"
        echo
        echo
        #echo aging_test failed, error at case: \"$case_name\"
        copy_all_need_log $case_name
        # blinking the red led
        led_red_blink
    else
        # success in silent
        echo $case_name >> $success_cnt
        touch $tmp_dir/${me}_${success_postfix}
        echo __success, \"$case_name\" >> $dir/result
    fi
    sync

    local cnt_nok=`ls -l $tmp_dir | grep -c "${fail_postfix}"`
    local cnt_ok=`ls -l $tmp_dir | grep -c "${success_postfix}"`
    local cnt_sum=$(($cnt_nok+$cnt_ok))
    echo cnt_nok=$cnt_nok
    echo cnt_ok=$cnt_ok
    echo cnt_sum=$cnt_sum

    if [ $cnt_sum -ge $sum_num ]; then
        touch $dir/finished
        echo "pid of me: $BASHPID, $case_name, i am exiting."
        if [ $cnt_nok -eq 0 ]; then
            echo PASSED >> $dir/result
        fi
       sync
    fi
    aging_test_unlock
}

empty_aging_test()
{
    sleep 60
    return 0
}

aging_test()
{
    #####################################################################################################
    #              Eagle Platform aging test
    #####################################################################################################
    echo "running aging_test simple version!!"
    echo "pid of me: $BASHPID"
    echo "interrupts stats :"
    cat /proc/interrupts | grep sd
    cat /proc/interrupts | grep mmc
    cat /proc/interrupts | grep usb
    dmesg | grep mmcblk1
    echo "interrupts stat ends"
    sleep 20
    if [ -e $sd_dir ];then
        rm -rf $sd_dir/aging_test
        mkdir -p $sd_dir/aging_test
    else
        echo "no sd card __fail"
        echo "no sdcard : FAIL, error code: 111, at $(aging_elapsed) seconds __fail" >> $dir/result
        ls -l /dev/block/vold/
        no_sdcard=1
        led_red_on
        return
    fi
    sleep 10
    led_green_blink
    config_timeout

    set_ofdm_aging_timeout
    start_ofdm_aging_test

    # prepare
    gimbal_enter_aging_mode
    init_bsp_emmc_sd

    # bsp ddr aging test
    start_timeout_error_action $mem_test_thread_num "bsp_ddr_codec_aging_test"
    # bsp emmc sd aging test
    start_timeout_error_action $bsp_mmc_sd_thread_num "bsp_emmc_sd_aging_test && sleep 15"
    # check camera aging_test
    start_timeout_error_action $check_camera_thread_num "camera_aging_test 0"
    # check perception aging_test
    #start_timeout_error_action $check_perception_thread_num "perception_aging_test"
    # check navigation aging_test
    #start_timeout_error_action $check_navigation_thread_num "navigation_aging_test"
    # check codec aging_test
    #start_timeout_error_action $check_codec_thread_num "empty_aging_test"

    echo "wait..."
    sleep 120
    #p1_enter_5G_mode
    #p1_enter_amt_mode

    # check kinds of components
    start_timeout_error_action $aging_test_thread_num "aging_test_check_link"

    # check s1 hig consump test
    #start_timeout_error_action $s1_high_consump_test_num "s1_high_consump_test"

    # check sys error status
    start_timeout_error_action $sys_error_status_check_num "sys_error_status_check"

    # Check pigeon aging test state, running
    start_timeout_error_action ${check_ofdm_result_thread_num} "ofdm_aging_test && sleep 3"

    # check other module aging test result
    start_timeout_error_action $module_aging_test_result_check_num "module_aging_test_result_check"

    #####################################################################################################
    echo "I am the watcher for aging_test..."
    local elapsed=0
    ((total_watch_time=$timeout+1800))
    while [ $elapsed -lt $total_watch_time ]; do
        echo "$BASHPID waiting for aging_test..."
        if [ -f $dir/finished ]; then
            echo "$dir/finished has been generated, now exit!"
            break
        fi
        sleep 60
        ((elapsed=$elapsed+60))
    done
    echo "aging_test_local done. check finished"
    aging_test_lock
    if [ ! -f $dir/finished ]; then
        if [ ! -f $amt/aging_test/log.txt ]; then
            echo __fail, log.txt not exists
            echo __fail, log.txt not exists  >> $dir/result
            copy_all_need_log no_finished
        else
            cnt_nok=`ls -l $tmp_dir | grep -c "${fail_postfix}"`
            cnt_ok=`ls -l $tmp_dir | grep -c "${success_postfix}"`
            cnt_sum=$(($cnt_nok+$cnt_ok))
            echo cnt_nok=$cnt_nok
            echo cnt_ok=$cnt_ok
            echo cnt_sum=$cnt_sum
            if [ $cnt_sum -lt $sum_num ]; then
                echo "__fail, someone not finished even we give 30min more than promised!"
                echo "__fail, someone not finished even we give 30min more than promised!"  >> $dir/result
                copy_all_need_log no_finished
            else
                c=`wc -l $amt/aging_test/log.txt | busybox awk '{print $1}'`
                # we assume log.txt should not less than 100 lines
                if [ $c -lt 100 ]; then
                    echo "log.txt too less"
                    echo "__fail, $amt/aging_test/log.txt is too short with $c lines" >> $dir/result
                    copy_all_need_log no_finished
                else
                    r=`grep __fail $amt/aging_test/log.txt`
                    if [ $? -eq 0 ]; then
                        echo "log.txt grep __fail"
                        echo "__fail, some thread faild, but the finished file do not generate" >> $dir/result
                        touch $dir/finished
                        copy_all_need_log no_finished
                    else
                        echo "pass"
                        echo PASSED >> $dir/result
                        touch $dir/finished
                        copy_all_need_log no_finished
                    fi
                fi
            fi
        fi
    fi
    #####################################################################################################
    aging_test_unlock

    copy_ofdm_aging_test_log

    grep -n "fail" $dir/result > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        led_green_on
    else
        led_red_on
    fi
    gimbal_exit_aging_mode
}

rm -rf $fail_cnt
rm -rf $success_cnt
rm -rf $tmp_dir
rm -rf $need_copy_log_dir

mkdir -p $tmp_dir
mkdir -p $need_copy_log_dir

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
check_perception_thread_num=0
check_navigation_thread_num=0
check_codec_thread_num=0
s1_high_consump_test_num=0
check_ofdm_result_thread_num=1
sys_error_status_check_num=1
module_aging_test_result_check_num=1

sum_num=$((\
    $bsp_mmc_sd_thread_num+\
    $mem_test_thread_num+\
    $aging_test_thread_num+\
    $check_camera_thread_num+\
    $check_perception_thread_num+\
    $check_navigation_thread_num+\
    $s1_high_consump_test_num+\
    $sys_error_status_check_num+\
    $module_aging_test_result_check_num+\
    $check_codec_thread_num+\
    $check_ofdm_result_thread_num\
    ))

echo "aging_test start at `date`" >> /blackbox/system/check_aging.log
aging_test | add_date | tee $amt/aging_test/log.txt
echo "aging_test finished at `date`" >> /blackbox/system/check_aging.log
sync
