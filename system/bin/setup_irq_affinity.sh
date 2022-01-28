#!/system/bin/sh

cat /proc/interrupts | grep icc139 \
| busybox awk 'sub(/:/,"") {print $1,$9}' \
| while read icc_irq_num icc_irq_name
do
echo 2 > /proc/irq/$icc_irq_num/smp_affinity
done

cat /proc/interrupts | grep ispenh_seq \
| busybox awk 'sub(/:/,"") {print $1,$9}' \
| while read ispenh_seq_irq_num ispenh_seq_irq_name
do
echo 4 > /proc/irq/$ispenh_seq_irq_num/smp_affinity
done

cat /proc/interrupts | grep cinema_seq \
| busybox awk 'sub(/:/,"") {print $1,$9}' \
| while read cinema_seq_irq_num cinema_seq_irq_name
do
echo 4 > /proc/irq/$cinema_seq_irq_num/smp_affinity
done

cat /proc/interrupts | grep dji_gdc \
| busybox awk 'sub(/:/,"") {print $1,$9}' \
| while read gdc_eagle_irq_num gdc_eagle_irq_name
do
echo 2 > /proc/irq/$gdc_eagle_irq_num/smp_affinity
done
