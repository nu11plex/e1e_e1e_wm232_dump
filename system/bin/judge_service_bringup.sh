#!/system/bin/sh

if [ $# -ne 2 ]; then
    echo "please point out the items.."
    exit 1
fi

timeout=$2
i=0

echo "start check dev is on or not, timeout=$timeout"

case $1 in
    "ofdm")
        echo "check ofdm.."
        target=9
        index=0
        ;;
    "camera")
        echo "check camera.."
        target=1
        index=0
        ;;
    "perception")
        echo "check perception.."
        target=18
        index=0
        ;;
    "fc")
        echo "check fly.."
        target=3
        index=6
        ;;
    "gimbal")
        echo "check gimbal.."
        target=4
        index=0
        ;;
    *)
        echo "please point out the items.."
        exit 1
        ;;
esac

while [ $i -lt $timeout ]
do
    ack=`dji_mb_ctrl -S test -R diag -o 1000000 -g $target -t $index -s 0 -c 1`
    if [ $? -eq 0 ]; then
        echo "the target=$target index=$index is on"
        exit 0
    fi

    let i=i+1;
done

if [ $i -eq $timeout ]; then
    echo "the target=$target index=$index is not on"
    exit 1
fi

