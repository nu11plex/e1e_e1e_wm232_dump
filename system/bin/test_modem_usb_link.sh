#!/system/bin/sh

echo "test p1 usb link start"
####################check the p1 link###################################
result=`dji_mb_ctrl -R diag -g 9 -t 0 -s 0 -c 01`
if [ $? -ne 0 ]; then
    echo "e1e to p1 v1 link error"
    exit 1
fi

echo $result
raw_data=${result##*data:}

result=`echo $raw_data | busybox awk '{printf $1}'`
if [ x"$result" != x"00" ]; then
    echo "check p1 version is faild, raw_data: $raw_data"
    exit 1
fi

echo "test p1 usb link success"