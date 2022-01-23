#!/system/bin/sh

result=`i2cget -f -y 7 0x21 0x01`
echo $result
if [ x"$result" == x"0x12" ]; then
   echo "test cclogic link success"
   exit 0
else
   echo "test cclogic link _faild"
   exit 1
fi
