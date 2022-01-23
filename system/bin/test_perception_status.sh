#
#    It can show the perception link status, the bit is defined as below:
#    bit 0: STATUS_CAM_DOWN_LEFT
#    bit 1: STATUS_CAM_DOWN_RIGHT
#    bit 2: STATUS_CAM_FRONT_LEFT
#    bit 3: STATUS_CAM_FRONT_RIGHT
#    bit 4: STATUS_TOF_DOWN
#    bit 5: STATUS_TOP_UP
#    bit 6: STATUS_CAM_BACK_LEFT
#    bit 7: STATUS_CAM_BACK_RIGHT
#    bit 8: STATUS_CAM_LEFT
#    bit 9: STATUS_CAM_RIGHT
#    usage:
#
function get_bit_name()
{
    if [ $# -ne 1 ]; then
        echo "invalid parameters($@)!"
        return
    fi
    case $1 in
        0) echo -n "cam_down_left" ;;
        1) echo -n "cam_down_right" ;;
        2) echo -n "cam_front_left" ;;
        3) echo -n "cam_front_right" ;;
        4) echo -n "tof_down" ;;
        5) echo -n "tof_up" ;;
        6) echo -n "cam_back_left" ;;
        7) echo -n "cam_back_right" ;;
        8) echo -n "cam_left" ;;
        9) echo -n "cam_right" ;;
        32) echo -n "cam_up_left" ;;
        33) echo -n "cam_up_right" ;;
        *) echo -n "unknown" ;;
    esac
}

result=`dji_mb_ctrl -S test -R diag -g 18 -t 0 -s 0 -c 0x5f 12ffffffff`
ret=$?
echo $result
if [ $ret -ne 0 ]; then
    echo "cmd error $ret, please check perception control version and connection!!!"
    sleep 2
    result=`dji_mb_ctrl -S test -R diag -g 18 -t 0 -s 0 -c 0x5f 12ffffffff`
    ret=$?
    echo $result
    if [ $ret -ne 0 ]; then
        echo "cmd error $ret, please check perception control version and connection!!!"
        echo "link_to_perception __fail, service_not_on"
        exit 1
    fi
fi
raw_data=${result##*data:}
echo $raw_data

result=`echo $raw_data | busybox awk '{printf $1}'`
if [ "$result" != "00" ]; then
    echo "this 0x0-0x5f command is not successful, result=$result and try again."
    sleep 2
    result=`dji_mb_ctrl -S test -R diag -g 18 -t 0 -s 0 -c 0x5f 12ffffffff`
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "cmd error $ret, please check perception control version and connection!!!"
        exit 1
    fi
    raw_data=${result##*data:}
    result=`echo $raw_data | busybox awk '{printf $1}'`
    if [ "$result" != "00" ]; then
        echo "this 0x0-0x5f command is not successful, result=$result, maybe have no sensor."
        echo "link_to_perception __fail, maybe_no_sensor"
        exit 1
    fi
fi

high_bytes=$(echo $raw_data | busybox awk '{printf $10$9$8$7;}')
low_bytes=$(echo $raw_data | busybox awk '{printf $6$5$4$3;}')
echo "0x$high_bytes  0x$low_bytes"

flag=0
case $1 in
    "all")
        echo "check all of the sensors.."
        index={0,1,2,3,4,6,7,32,33}
        ;;
    "down_sensors")
        echo "check down sensors.."
        index={0,1}
        ;;
	"up_sensors")
        echo "check up sensors.."
        index={32,33}
        ;;
    "front_sensors")
        index={2,3}
        echo "check front sensors.."
        ;;
    "back_sensors")
        echo "check left-right-back sensors.."
        index={6,7}
        ;;
    "down_tof")
        echo "check up down sensors.."
        index=4
        ;;
    "up_tof")
        echo "check up tof sensors.."
        index=5
        ;;
    *)
        echo "please point out the items.."
        exit 1
        ;;
esac

for i in $index; do
	if [ $i -gt 31 ]; then
		n_move=$i-32
		bitmask=$((1 << $n_move))
		bit_result=$((16#$high_bytes & $bitmask))
	else
		bitmask=$((1 << $i))
		bit_result=$((16#$low_bytes & $bitmask))
	fi
    err_msg=`get_bit_name $i`
    if [ $bit_result == 0 ]; then
        echo "perception bit $i is not set, the $err_msg ok"
    else
        flag=1
        echo "perception bit $i is set, the $err_msg error!"
        echo "link_to_perception __fail, $err_msg"
    fi
done
if [ $flag == 0 ]; then
    echo "test_perception_status.sh success ..."
else
    echo "test_perception_status.sh __fail ..."
fi

exit $flag
