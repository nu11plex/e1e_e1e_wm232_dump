#!/system/bin/sh

echo "test reset p1 link start"
####################1. check the p1 link###################################
result=`dji_mb_ctrl -R diag -g 9 -t 0 -s 0 -c 01`
if [ $? -ne 0 ]; then
    echo "before reset, e1e to p1 v1 link error"
    exit 1
fi

echo $result
raw_data=${result##*data:}

result=`echo $raw_data | busybox awk '{printf $1}'`
if [ x"$result" != x"00" ]; then
    echo "before reset,check p1 version is faild, raw_data: $raw_data"
    exit 1
fi

####################2. reset the p1########################################
result=`dji_mb_ctrl -R diag -a 1 -g 9 -t 4 -s 0 -c 0b 0000000000000000000000000000`
if [ $? -ne 0 ]; then
    echo "reset p1 v1 link error"
    exit 1
fi
sleep 1
#echo $result
#raw_data=${result##*data:}

#result=`echo $raw_data | busybox awk '{printf $1}'`
#if [ x"$result" != x"00" ]; then
#    echo "reset p1 faild, raw_data: $raw_data"
#    exit 1
#fi

####################3. check the p1 link###################################
result=`dji_mb_ctrl -R diag -o 1000000 -g 9 -t 0 -s 0 -c 01`
if [ $? -ne 0 ]; then
    echo "test reset p1 link success"
    exit 0
else
    echo "test reset p1 link faild"
    exit 1
fi

