#!/system/bin/sh

case $1 in
    "green")
        echo "turn ont the LED for p1 to green..."
        dji_mb_ctrl -R diag -g 9 -t 0 -s 0 -c 0x60 010100ff00
        ;;
    "red")
        echo "turn on the LED for p1 to red..."
        dji_mb_ctrl -R diag -g 9 -t 0 -s 0 -c 0x60 0101ff0000
        ;;
    "off")
        echo "turn off the LED for p1..."
        dji_mb_ctrl -R diag -g 9 -t 0 -s 0 -c 0x60 0100000000
        ;;
    *)
        echo "the parameter is wrong..."
        exit 1
        ;;
esac

exit 0
