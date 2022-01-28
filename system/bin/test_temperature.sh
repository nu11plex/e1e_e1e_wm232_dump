#!/system/bin/sh

CHNL0=00
CHNL1=01
CHNL2=02
CHNL3=03
CHNL4=04
save=0
seq=0
get_chnl_temp()
{
    let seq=seq+1
    result=`dji_mb_ctrl -S test -R diag -q $seq -g 3 -t 6 -s 0 -c 0x54 $1 `

    if [ $? != 0 ];then
        echo "0807 <-> 0306 cmd failed!!!"
        exit 1
    fi
    echo $result > /tmp/env_data
    temp=`cat /tmp/env_data | busybox awk '{ print $(NF-2)$(NF)$(NF-1) }'`
    byte1=$((16#$temp&16#10000))
    if [ $byte1 -ne 0 ];then
        echo "get $1 channel temperature error: $byte1!"
        echo "the channel's temperature may exceed the normal area!!"
        return 1
     fi
    temp=$((16#$temp))
    byte1=`expr $temp / 10`
    byte2=$(($temp%10))
    echo "channel $1 temperature is: $byte1.$byte2"
}

usage()
{
    echo "usage: test_temperature.sh <time interval> <save>"
    echo "For example: 'test_temperature.sh 5' means get temperature every 5s"
    echo "             'test_temperature.sh 5 save' means save to /data/dji/log/temp00.log"
}
if [ $# -gt 2 -o $# == 0 ];then
    usage();
    exit 1
fi

if [ $# == 2 ];then
   if [ $2 == save ];then
       save=1
   else
       usage();
       echo "wrong parameter '$2', should be 'save'"
       exit
   fi
fi

if [ $1 -gt 1800 ];then
   echo "it is not recommended to set inetrval > one hour"
   exit 1
fi

if [ $save == 1 ];then
    if [ -e /data/dji/log/temp00.log ];then
        mv /data/dji/log/temp09.log /data/dji/log/temp10.log
        mv /data/dji/log/temp08.log /data/dji/log/temp09.log
        mv /data/dji/log/temp07.log /data/dji/log/temp08.log
        mv /data/dji/log/temp06.log /data/dji/log/temp07.log
        mv /data/dji/log/temp05.log /data/dji/log/temp06.log
        mv /data/dji/log/temp04.log /data/dji/log/temp05.log
        mv /data/dji/log/temp03.log /data/dji/log/temp04.log
        mv /data/dji/log/temp02.log /data/dji/log/temp03.log
        mv /data/dji/log/temp01.log /data/dji/log/temp02.log
        mv /data/dji/log/temp00.log /data/dji/log/temp01.log
    fi
fi

while true
do
if [ $save == 1 ];then
    date >> /data/dji/log/temp00.log
    get_chnl_temp $CHNL0 >> /data/dji/log/temp00.log
    get_chnl_temp $CHNL1 >> /data/dji/log/temp00.log
    get_chnl_temp $CHNL2 >> /data/dji/log/temp00.log
    get_chnl_temp $CHNL3 >> /data/dji/log/temp00.log
    get_chnl_temp $CHNL4 >> /data/dji/log/temp00.log
else
    get_chnl_temp $CHNL0
    get_chnl_temp $CHNL1
    get_chnl_temp $CHNL2
    get_chnl_temp $CHNL3
    get_chnl_temp $CHNL4
fi
sleep $1
done
