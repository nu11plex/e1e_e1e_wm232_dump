
test_fc_status.sh all
local r=$?
if [ $r != 0 ]; then
    exit 1
fi

echo "FC test PASS"
exit 0
