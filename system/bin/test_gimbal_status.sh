#
#    It can show the perception link status, the bit is defined as below:
#    bit 14: 加速度计
#    bit 15: 陀螺仪
#    bit 16: 飞控
#    bit 17: 电调
#    usage:
#
function get_bit_name()
{
    if [ $# -ne 1 ]; then
    echo "invalid parameters($@)!"
    return
    fi
    case $1 in
        14) echo -n "accelerometer" ;;
        15) echo -n "gyroscope" ;;
        16) echo -n "fly control" ;;
        17) echo -n "esc" ;;
        18) echo -n "pitch_motor" ;;
        19) echo -n "roll_motor" ;;
        20) echo -n "yaw_motor" ;;
        21) echo -n "pitch_hall_a" ;;
        22) echo -n "pitch_hall_b" ;;
        23) echo -n "roll_hall_a" ;;
        24) echo -n "roll_hall_b" ;;
        25) echo -n "yaw_hall_a" ;;
        26) echo -n "yaw_hall_b" ;;
        *) echo -n "unknown" ;;
    esac
}


result=`dji_mb_ctrl -S test -R diag -g 4 -t 0 -s 0 -c 0x5f 04ffffffff`
if [ $? != 0 ];then
    echo "cmd error $?, please check gimbal control version and connection!!!"
    exit 1
fi
echo $result
raw_data=${result##*data:}

result=`echo $raw_data | busybox awk '{printf $1}'`
if [ $result != "00" ]; then
    echo "err $result, gimbal return __fail."
    exit 2
fi

bytes=`echo $raw_data | busybox awk '{printf $6$5$4$3;}'`
echo "0x$bytes"

flag=0

case $1 in
    "all")
        echo "check all of the items..."
        index={14,15,18,19,20,21,22,23,24,25,26}
        ;;
    "main_card")
        echo "check main_card..."
        index={14,15,16}
        ;;
    "onboard")
        echo "check onboard..."
        index={14,15,16,21,22,23,24,25,26}
        ;;
    *)
        echo "please point out the items.."
        exit 2
        ;;
esac

for i in $index; do
    bitmask=$((1 << $i))
    bit_result=$((16#$bytes&$bitmask))
    err_msg=`get_bit_name $i`
    if [ $bit_result == 0 ]; then
        echo "gimbal bit $i is not set, the $err_msg ok "
    else
        flag=1
        echo "gimbal bit $i is set, the $err_msg error!"
    fi
done

if [ $flag == 0 ]; then
    echo "test_gimbal_status.sh success ..."
else
    echo "test_gimbal_status.sh __fail ..."
fi

exit $flag
