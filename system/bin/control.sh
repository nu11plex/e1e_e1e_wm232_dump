
get_control()
{

    NUM=$1
    control=$(busybox awk 'NR=='$NUM' {print $1}' /factory_data/control.bit)
    echo "control bit $NUM is $control."

}

set_control()
{

    NUM=$1
    VAL=$2

    busybox sed -i "${NUM}c $VAL" /factory_data/control.bit
    ret=$?
    echo "set return value $ret"
    if [ $ret -eq 0 ]; then
        echo "set control bit $NUM success"
    else
        echo "set control bit $NUM fail."
    fi

}

mount -o remount,rw /factory_data
if [ -f /factory_data/control.bit ]; then
    echo "control bit already exist"
else
    cp -f /data/dji/control.bit /factory_data/control.bit
fi

if [ $1 == "get" ];then
    get_control $2
fi

if [ $1 == "set" ];then
    set_control $2 $3
fi

#mount -o remount,ro /factory_data
