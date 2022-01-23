#!/system/bin/sh

SERIAL_LOG="/blackbox/sdrs_log/serial_log"
SERIAL_TEST_DATA="test_modem_serial_link!"
SERIAL_TEST_COUNT=4

echo "test modem serial link start"
####################start run modem code###################################
result=`adb shell test_modem_serial_link.sh`

sleep 1

echo $result

if [[ $result == *"success"* ]]; then
    echo "start shell cmd success!"
else
    echo "start shell cmd failed!"
    exit 1
fi

if [[ ! -f $SERIAL_LOG/latest ]]; then
    echo "latest not exist"
    exit 1
else
    echo "latest exist"
fi

sync

result=`cat $SERIAL_LOG/latest`
echo $result

result=${result:0:2}
path="UART"$result".log"
echo $path

for i in $(seq 1 $SERIAL_TEST_COUNT)
do
result=`cat $SERIAL_LOG/$path | grep $SERIAL_TEST_DATA`
#echo $result

if [[ $result == *$SERIAL_TEST_DATA* ]]; then
    echo "test modem serial link success!"
    exit 0
else
    echo "test modem serial link......"
    if [ $SERIAL_TEST_COUNT -eq $i ]
    then
        echo "test modem serial link failed!"
        exit 1
    fi
    usleep 500000
fi
done
