if [ $1 == "on" ];then
    echo "---> set autotest always on"
    touch /data/dji/autotest_on
fi

if [ $1 == "off" ];then
    echo "---> set autotest always off"
    rm -f /data/dji/autotest_on
fi

sync

exit 0
