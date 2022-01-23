#!/system/bin/sh

. lib_test_cases.sh

e1e_state()
{
    echo 6 1 > /sys/devices/platform/efuse_power/efuse_power:on_off_ldo/state
    usleep 100000
    amt_test_cmd efuse
    local efuse_ret=$?
    echo 6 0 > /sys/devices/platform/efuse_power/efuse_power:on_off_ldo/state
    return $efuse_ret
}

sleep 1
e1e_state
local state_ret=$?
if [ $state_ret -ne 0 ]; then
    echo "red"
    exit 1
else
    echo "green"
    exit 0
fi
