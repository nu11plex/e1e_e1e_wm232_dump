
echo "test emmc link start"

busybox dd if=/dev/zero of=/camera/test count=10 bs=1M
ret=$?
if [ $ret -ne 0 ]; then
    echo "use dd test emmc link faild, err code:$ret"
    ret=1
else
    echo "use dd test emmc link success"
fi

echo "test emmc link end"

rm /camera/test
sync
exit $ret
