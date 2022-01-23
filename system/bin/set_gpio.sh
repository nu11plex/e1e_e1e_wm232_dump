#!/system/bin/sh
echo "set_gpio.sh"

if [ "$1"x != ""x -a "$2"x != ""x ]; then
	echo $1 > /sys/class/gpio/export

	if [ $2 -eq 0 ]; then
		echo out > /sys/class/gpio/gpio45/direction
		echo 0 > /sys/class/gpio/gpio45/value
		echo "set gpio $1 to value 0"
	else
		echo out > /sys/class/gpio/gpio45/direction
		echo 1 > /sys/class/gpio/gpio45/value
		echo "set gpio $1 to value 1"
	fi
else
	echo "Need params!"
	exit 1
fi
