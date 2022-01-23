#!/system/bin/sh

# Parameters validation
if [ -z "$1" ]
then
    echo "Usage"
    echo "set_country_code.sh <Country Code>"
    echo "example: set_country_code.sh F2"
    mount -o remount,ro /amt
    exit 1
fi
/system/bin/wifi_info.sh set cc $1
if [ $? == 0 ]; then
    echo "SUCCESS"
    exit 0
else
    echo "FAILURE"
    exit 1
fi

