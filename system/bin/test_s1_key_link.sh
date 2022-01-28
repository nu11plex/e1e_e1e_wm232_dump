#
#    It can show the ofdm link status, the bit is defined as below:
#    usage:
#
function get_bit_name()
{
    if [ $# -ne 1 ]; then
    echo "invalid parameters($@)!"
    return
    fi
    case $1 in
        0) echo -n "key_up" ;;
        1) echo -n "key_down" ;;
        *) echo -n "unknown" ;;
    esac
}

result=`dji_mb_ctrl -S test -R diag -g 9 -t 0 -s 0 -c 0x5f 09ffffffff`
if [ $? != 0 ];then
    echo "cmd error $?, please check ofdm control version and connection!!!"
    exit 1
fi
echo $result
raw_data=${result##*data:}

result=`echo $raw_data | busybox awk '{printf $1}'`
if [ $result != "00" ]; then
    echo "error $result, p1 return __fail."
    exit 2
fi

bytes=`echo $raw_data | busybox awk '{printf $6$5$4$3;}'`
echo "0x$bytes"

flag=0

case $1 in
    "all")
        echo "check all of the items..."
        index={0,1}
        ;;
    "key_up")
        echo "check key_up..."
        index=0
        ;;
    "key_down")
        echo "check key_down..."
        index=1
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
        echo "ofdm bit $i is not set, the $err_msg ok "
    else
        flag=1
        echo "ofdm bit $i is set, the $err_msg error!"
    fi
done

exit $flag

