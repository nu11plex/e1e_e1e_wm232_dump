#!/system/bin/sh

result=`dji_mb_ctrl -S test -R  diag -g 11 -t 0 -s 0 -c 1 `
if [ $? != 0 ];then
    echo "cmd error $?, please check your connection with battery!"
    exit 1
fi

echo $result
raw_data=${result##*data:}

result=`echo $raw_data | busybox awk '{printf $1}'`
if [ x"$result" != x"00" ]; then
    echo "check battery version is fail raw_dat: $raw_data . exit."
    exit 1
fi

echo "check battery link ok!"
exit 0
