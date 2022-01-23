#!/system/bin/sh

if [ $# -ne 2 ]; then
    echo "please enter xx.sh test_time_s packet_size"
    exit 1
fi

let "testTime=$1"
let "dataSize=$2"
let "realSize=dataSize-21"

echo "testTime=$testTime, dataSize=$dataSize, realDataSize=$realSize"
data_pad=`echo $realSize|busybox awk '{printf("%04x2001\n",$0)}'`
echo "$data_pad"

start_rec_time=$(date +%s)

# start hp channel rate test
#0120e803
result=`dji_mb_ctrl -S test -R diag -g 2 -t 5 -s 0 -c 59 -4 $data_pad`
ret=$?
echo $result
if [ $ret != 0 ];then
    echo "the hp channel rate test v1 link is not on."
    exit 1
fi

raw_data=${result##*data:}
result=`echo $raw_data | busybox awk '{printf $1}'`
if [ $result != "00" ]; then
    echo "the remote serive refuse to test hp channel rate, $result"
    exit 1
fi

sleep $testTime

#stop hp channel rate test
result=`dji_mb_ctrl -S test -R diag -g 2 -t 5 -s 0 -c 59 00200000`
ret=$?
echo $result
if [ $ret != 0 ];then
    echo "the hp channel rate test v1 link is not on."
    exit 1
fi

raw_data=${result##*data:}
result=`echo $raw_data | busybox awk '{printf $1}'`
if [ $result != "00" ]; then
    echo "the remote serive refuse to test hp channel rate, $result"
    exit 1
fi

current_time=$(date +%s)
let "test_time = $current_time - $start_rec_time"

bytes=`echo $raw_data | busybox awk '{printf $5$4$3$2;}'`
echo "use $test_time seconds to send 0x$bytes packet, and packet size is $dataSize"
rate=$((16#$bytes/$testTime))
echo "the rate is $rate"

exit 0
