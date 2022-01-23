#############################################################################
# fc aging/linking test script
# exit code:
#  0 - success
#  1 - mb_ctrl fail
#  2 - fc general fail
#  3 - some bits fail
#  4 - user param fail
#############################################################################

test_esc_link_by_version()
{
    MAX_ESC=4
    i=0
    ret=0

    while [ $i -lt $MAX_ESC ]
    do
        ack=`dji_mb_ctrl -S test -R diag -g 12 -t $i -s 0 -c 1`
        if [ $? -ne 0 ]; then
            #echo $ack;
            echo "esc $i check version error"
            ret=1
        fi

        raw_data=${ack##*data:}
        res=`echo $raw_data | busybox awk '{printf $1;}'`

        if [ $res -ne 0 ]; then
            echo "fc check esc $i error"
            ret=1
        fi

        let i=i+1;
    done
    return $ret
}


just_test_fc_bit()
{
    result=`dji_mb_ctrl -S test -R diag -g 3 -t 6 -s 0 -c 5f 03ffffffffffffffff`
    ret=$?
    echo $result
    if [ $ret != 0 ];then
        local err_msg=${result##*error:}
        echo "just_test_fc_bit ret=$ret, mb_ctrl fc $err_msg __fail."
        return 1
    fi
    raw_data=${result##*data:}

    result=`echo $raw_data | busybox awk '{printf $1}'`
    if [ $result != "00" ]; then
        echo "just_test_fc_bit result=$result, fc __fail."
        return 2
    fi

    bytes=`echo $raw_data | busybox awk '{printf $10$9$8$7$6$5$4$3;}'`
    echo "0x$bytes"
    bitmask=$((1 << $1))
    bit_result=$((16#$bytes&$bitmask))
    if [ $bit_result != 0 ]; then
        echo "just_test_fc_bit $1 result $bit_result, fc bit __fail"
        return 3
    fi
    return 0
}

check_fan_by_fc()
{
    fan_cmd_set=0x3
    fan_cmd_idx=0xd9
    fan_test_level=00
    echo "check_fan_by_fc enter"
    echo "set fan stop"
    info=`dji_mb_ctrl -S test -R diag -g 3 -t 6  -s $fan_cmd_set -c $fan_cmd_idx 02001F04$fan_test_level`
    echo $info
    if [ $? != 0 ]; then
        local err_msg=${info##*error:}
        echo "check_fan_by_fc1 1 mb_ctrl fc $err_msg __fail."
        return 1
    fi
    sleep 1
    just_test_fc_bit 29
    if [ $? != 0 ]; then
        echo $info
        echo "check_fan_by_fc 2 __fail"
        return 3
    fi

    echo "set fan start"
    fan_test_level=64
    info=`dji_mb_ctrl -S test -R diag -g 3 -t 6  -s $fan_cmd_set -c $fan_cmd_idx 02001F04$fan_test_level`
    echo $info
    if [ $? != 0 ]; then
        local err_msg=${info##*error:}
        echo "check_fan_by_fc 3 mb_ctrl fc $err_msg __fail."
        return 1
    fi
    sleep 1
    just_test_fc_bit 29
    echo $info
    if [ $? != 0 ]; then
        echo "check_fan_by_fc 4 __fail"
        return 3
    fi

    echo "check_fan_by_fc ok"
    return  0
}

get_module_name_for_index()
{
    case $1 in
        "8")
            module_name=acc
            ;;
        "9")
            module_name=gypo
            ;;
        "10")
            module_name=baro
            ;;
        "11")
            module_name=compass
            ;;
        "12")
            module_name=gps
            ;;
        "13")
            module_name=recorder
            ;;
        "14")
            module_name=esc
            ;;
        "15")
            module_name=bat
            ;;
        "16")
            module_name=ofdm
            ;;
        "17")
            module_name=rc
            ;;
        "18")
            module_name=vo
            ;;
        "19")
            module_name=acc_disconnected
            ;;
        "20")
            module_name=gyro_disconnected
            ;;
        "21")
            module_name=acc1
            ;;
        "22")
            module_name=gyro1
            ;;
        "23")
            module_name=acc1_disconnected
            ;;
        "24")
            module_name=gyro1_disconnected
            ;;
        "25")
            module_name=acc2
            ;;
        "26")
            module_name=gyro2
            ;;
        "27")
            module_name=acc2_disconnected
            ;;
        "28")
            module_name=gyro2_disconnected
            ;;
        "29")
            module_name=fan_disconnected
            ;;
        "31")
            module_name=esc_pwm
            ;;
    esac
    echo -n "fc -> $module_name"
}

get_module_name_for_index1()
{
    case $1 in
        "10")
            module_name=bat_on
            ;;
    esac
    echo -n "fc -> $module_name"
}
#
#    It can show the fly ctrl status, the bit is defined as below:
#    bit 8:  acc
#    bit 9:  gypo
#    bit 10: baro
#    bit 11: compass
#    bit 12: gps
#    bit 13: recorder
#    bit 14: esc uart
#    bit 15: bat
#    bit 16: ofdm
#    bit 17: rc
#    bit 18: vo
#    bit 19: raw_acc
#    bit 20: raw_gypo
#    bit 29: fan
#    bit 31: esc pwm

flag=0
case $1 in
    "all")
        echo "check all of the items..."
        index={8,9,10,11,12,14,16,19,20,29,31}
        ;;
    "ofdm")
        echo "check ofdm..."
        index=16
        ;;
    "bat")
        echo "check bat..."
        index1=10
        ;;
    "fan")
        echo "check fan..."
        check_fan_by_fc
        exit $?
        ;;
    "main_card")
        echo "check main_card..."
        index={10,11,12,14,16,19,20}
        ;;
    "main_card2")
        echo "check main_card2..."
        index={10,11,12,14,16,19,20,31}
        ;;
    "main_card3")
        echo "check main_card2..."
        index={10,11,12,14,19,20}
        ;;
    "gps_card")
        echo "check gps_card..."
        index={10,11,12,19,20}
        ;;
    "raw_imu")
        echo "check raw_imu..."
        index={19,20}
        ;;
    *)
        echo "please point out the items.."
        exit 4
        ;;
esac

result=`dji_mb_ctrl -S test -R diag -g 3 -t 6 -s 0 -c 5f 03ffffffffffffffff`
ret=$?
echo $result
if [ $ret != 0 ];then
    err_msg=${result##*error:}
    echo "link_to_flyctrl __fail, service_not_on"
    exit 1
fi

raw_data=${result##*data:}

result=`echo $raw_data | busybox awk '{printf $1}'`
if [ $result != "00" ]; then
    echo "link_to_flyctrl __fail, return_not_00, $result"
    exit 1
fi

bytes=`echo $raw_data | busybox awk '{printf $6$5$4$3;}'`
echo "0x$bytes"

for i in $index; do
    bitmask=$((1 << $i))
    bit_result=$((16#$bytes&$bitmask))
    err_msg=`get_module_name_for_index $i`
    if [ $bit_result != 0 ]; then
        flag=3
        echo "first 32 bit $i is set, the $err_msg error!!!!"
        echo "link_to_flyctrl __fail, $err_msg"
    else
        echo "first 32  bit $i not set, the $err_msg ok"
    fi
done

bytes=`echo $raw_data | busybox awk '{printf $10$9$8$7;}'`
echo "0x$bytes"

for i in $index1; do
    bitmask=$((1 << $i))
    bit_result=$((16#$bytes&$bitmask))
    err_msg=`get_module_name_for_index1 $i`
    if [ $bit_result != 0 ]; then
        flag=3
        echo "last 32 bit $i is set, the $err_msg error!!!!"
        echo "link_to_flyctrl __fail, $err_msg"
    else
        echo "last 32 bit $i not set, the $err_msg ok"
    fi
done

if [ $flag == 0 ]; then
    echo "test_fc_status.sh success ..."
else
    echo "test_fc_status.sh __fail ..."
fi

exit $flag
