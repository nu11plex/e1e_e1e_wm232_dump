#!/system/bin/sh

echo "test ads-b link start"
####################check the ads-b link###################################
result=`dji_mb_ctrl -R diag -g 8 -t 6 -s 0 -c 01`
if [ $? -ne 0 ]; then
    echo "0807 to 0806 v1 link error"
    exit 1
fi

echo $result
raw_data=${result##*data:}

result=`echo $raw_data | busybox awk '{printf $1}'`
if [ x"$result" != x"00" ]; then
    echo "check 0806 version is faild, raw_data: $raw_data"
    exit 1
fi

echo "test ads-b link success"
