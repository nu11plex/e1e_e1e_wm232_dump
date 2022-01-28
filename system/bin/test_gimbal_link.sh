
test_gimbal_status.sh all
local r=$?
if [ $r != 0 ]; then
    echo "test gimbal status error!"
    exit 1
fi
exit 0

