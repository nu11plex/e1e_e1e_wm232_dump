
board_id()
{

if [ $1 == "WR" ];then
    echo $2 > /factory_data/board_id.txt
fi

if [ $1 == "RD" ];then
    local ret=`cat /factory_data/board_id.txt`
    echo "BoardID:$ret"
fi

}

device_id()
{
if [ $1 == "WR" ];then
    echo $2 > /factory_data/device_id.txt
fi

if [ $1 == "RD" ];then
    local ret=`cat /factory_data/device_id.txt`
    echo "DeviceID:$ret"
fi

}

if [ $1 == "board" ];then
    board_id  $2 $3
fi

if [ $1 == "device" ];then
    device_id  $2 $3
fi

exit 0
