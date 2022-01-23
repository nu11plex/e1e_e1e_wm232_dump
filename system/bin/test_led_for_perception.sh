#!/system/bin/sh

case $1 in
    "on")
        echo "turn on the LED for perception..."
        dji_mb_ctrl -R diag -g 18 -t 0 -s 0xa -c 0x56 030101
        ;;
    "off")
        echo "turn off the LED for perception..."
        dji_mb_ctrl -R diag -g 18 -t 0 -s 0xa -c 0x56 030102
        ;;
    *)
        echo "the parameter is wrong..."
        exit 1
        ;;
esac

exit 0
