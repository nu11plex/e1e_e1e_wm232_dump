#!/system/bin/sh

# test act8846
i2cget -f -y 0 0x5a 0x02 2>&1 1>/dev/null
let result=$?

if [ $result -ne 0 ]; then
	echo "i2c link to ACT8846 __fail !!!"
else
	echo "i2c link to ACT8846 pass"
fi

# test LP8758
i2cget -f -y 0 0x60 0x00 2>&1 1>/dev/null
let result=$?

if [ $result -ne 0 ]; then
	echo "i2c link to LP8758 __fail !!!"
else
	echo "i2c link to LP8758 pass"
fi


