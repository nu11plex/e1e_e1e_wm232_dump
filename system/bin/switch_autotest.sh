#!/system/bin/sh

usage()
{
    echo "usage: switch_autotest.sh <on/off>"
}

if [ $# -gt 1 -o $# == 0 ];then
    usage
    exit 1
fi

if [ $1 == 1 ];then
    echo "start autotest"
    setprop dji.autotest_service 1
fi

if [ $1 == 0 ];then
    echo "stop autotest"
    setprop dji.autotest_service 0
fi
