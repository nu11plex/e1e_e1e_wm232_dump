#!/system/bin/sh

set -x
test_mem -s 0x200000 -l 2

if [[ $? != 0 ]]; then
        echo "DDR test fail"
        exit 1
fi
echo "DDR test success"
exit 0
