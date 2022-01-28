#!/system/bin/sh
for i in `seq 1 7`; do
    let j=8-i
    mv /blackbox/system/emmc.trace.bin.$j /blackbox/system/emmc.trace.bin.$((j+1))
    mv /blackbox/system/sd.trace.bin.$j /blackbox/system/sd.trace.bin.$((j+1))
done

mv /blackbox/system/emmc.trace.bin /blackbox/system/emmc.trace.bin.1
mv /blackbox/system/sd.trace.bin /blackbox/system/sd.trace.bin.1

cat /sys/devices/platform/soc/f0000000.ahb/f0400000.dwmmc0/mmc_host/mmc0/mmc0:*/block/mmcblk0/mrq_trace >> /blackbox/system/emmc.trace.bin &

while true; do
    if [ -b /dev/block/mmcblk1 ]; then
       cat /sys/devices/platform/soc/f0000000.ahb/f0404000.dwsd/mmc_host/mmc1/mmc1:*/block/mmcblk1/mrq_trace >> /blackbox/system/sd.trace.bin
    fi
    sleep 2
done
