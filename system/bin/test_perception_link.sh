
test_perception_status.sh all
local r=$?
if [ $r != 0 ]; then
    exit 1
fi
exit 0

