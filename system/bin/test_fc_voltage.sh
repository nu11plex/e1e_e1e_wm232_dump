#############################################################################
## judge the fc voltage is good or not
#############################################################################
vol_min=$1
vol_max=$2
echo "vol_min=$vol_min, vol_max=$vol_max"

# 1. judge the flycrl link is ok or not
result=`dji_mb_ctrl -S test -R diag -g 3 -t 6 -s 0 -c 01`
ret=$?
if [ $ret != 0 ];then
    echo "link_to_flyctrl __fail, service_not_on"
    exit 1
fi

# 2. get the voltage
result=`dji_mb_ctrl -S test -R diag -g 3 -t 6 -s 3 -c d9 0100200100`
ret=$?
echo $result
if [ $ret != 0 ];then
    echo "get the voltage __fail"
    exit 1
fi

raw_data=${result##*data:}
bytes=`echo $raw_data | busybox awk '{printf $6$5;}'`
echo "0x$bytes"
vol=`echo $((16#$bytes))`
echo "vol=$vol"

if [ $vol -le $vol_max -a $vol -ge $vol_min ]; then
    echo "the vol is good"
    exit 0
else
    echo "the vol is __fail"
    exit 1
fi
