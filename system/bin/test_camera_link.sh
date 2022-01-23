
test_camera_status.sh all
local r=$?
if [ $r != 0 ]; then
    echo "test camera status error!"
    exit 1
fi
exit 0

