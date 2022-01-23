#!/system/bin/sh

# multipled by 10
Ifs0_SMPS457=69615
Ios0_SMPS457=3941

Ifs0_OTHERS=52600
Ios0_OTHERS=8400

# $1 -> k
# $2 -> raw_val
# $3 -> smps id
calc_current()
{
    k=$1
    raw_val=$2
    smps_who=$3
    #echo -n "k = $k, raw_val = $raw_val"

    case $smps_who in
        smps457)
            Ifs0=$Ifs0_SMPS457
            Ios0=$Ios0_SMPS457
            ;;
        *)
            Ifs0=$Ifs0_OTHERS
            Ios0=$Ios0_OTHERS
            ;;
    esac
    ret=$(($k * ($raw_val * $Ifs0 / 4095 - $Ios0) / 10))
    echo ${ret}mA
}

get_ch11_raw()
{
	i2cset -f -y 0 0x49 0xd4 0x2$1
	#i2cget -f -y 0 0x49 0xd5
	ret=`cat /sys/bus/iio/devices/iio:device0/in_voltage11_raw`

	echo $ret
}

echo -n "SMPS12:  "
calc_current 2 `get_ch11_raw 0` smps12

echo -n "SMPS3:   "
calc_current 1 `get_ch11_raw 1` smps3

echo -n "SMPS457: "
calc_current 3 `get_ch11_raw 2` smps457

echo -n "SMPS6:   "
calc_current 1 `get_ch11_raw 3` smps6

echo -n "SMPS7:   "
calc_current 1 `get_ch11_raw 4` smps7

echo -n "SMPS8:   "
calc_current 1 `get_ch11_raw 5` smps8

echo -n "SMPS9:   "
calc_current 1 `get_ch11_raw 6` smps9

exit 0
