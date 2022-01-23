#########################################################################
# File Name: BWL.sh
# Description:
# Author: Cao Dan
# mail: dan.cao@dji.com
# Created Time: 2018-01-31 18:04:33
#########################################################################
#!/bin/sh


# DDRC BWL cfg

echo "====> Setting BWL cfg <==== "

busybox devmem 0xF0451060 32 0x00000008  # AXI0_bwl_rd ISP
busybox devmem 0xF0451064 32 0x00000008  # AXI0_bwl_wr
busybox devmem 0xF0451068 32 0xC0000008  # AXI1_bwl_rd DSP  0Mbps
busybox devmem 0xF045106C 32 0xC0000008  # AXI1_bwl_wr DSP  0Mbps
busybox devmem 0xF0451070 32 0xC0000008  # AXI2_bwl_rd Peri
busybox devmem 0xF0451074 32 0xC0000008  # AXI2_bwl_wr
busybox devmem 0xF0451078 32 0xC0000008  # AXI3_bwl_rd  ACPU
busybox devmem 0xF045107C 32 0xC0000008  # AXI3_bwl_wr  ACPU
busybox devmem 0xF0451080 32 0xC0000008  # AXI4_bwl_rd  VACC  0MBps
busybox devmem 0xF0451084 32 0xC0000008  # AXI4_bwl_wr        0MBps
busybox devmem 0xF0451088 32 0xC0000008  # AXI5_bwl_rd  2D  
busybox devmem 0xF045108C 32 0xC0000008  # AXI5_bwl_wr  
busybox devmem 0xF0451090 32 0xC0000008  # AXI6_bwl_rd  CodeC  
busybox devmem 0xF0451094 32 0xC0000008  # AXI6_bwl_wr

busybox devmem 0xF0451098 32 0x0  # lpr_credit_cnt
busybox devmem 0xF045109C 32 0x0  # hpr_credit_cnt
busybox devmem 0xF04510A0 32 0x0  # wr_credit_cnt

busybox devmem 0xF04510A4 32 0x73C  # req_signal_mask


# ISP BWL cfg
echo "===> ISP BWL cfg <==="
# temper_rd_bwl_en 1
# temper_wr_bwl_en 1
# temper_enter_thres 8
# temper_exit_thres 4
busybox devmem 0xFD106334 32 0x04111019    # isp_bwl_ctrl2

# Axi_out_bwl_en
# Axi_out_enter_thres 8
# Axi_out_exit_thres 4
busybox devmem 0xFD106338 32 0x04110000    # isp_bwl_ctrl3

# CINE BWL cfg
# cine_wrap wr buffer depth is 4096
# bit[31]    thr_en
# bit[28:16] thres_h  2048
# bit[12:0]  thres_l  1024
busybox devmem 0xFD201630 32 0x88000400

# LCDC BWL cfg
# th0 = 'd5600
# th1 = 'd8912
busybox devmem 0xFD44029C 32 0x22D015E0    # lcdc axi read thres


# Limit dsp and cnn outstanding
busybox devmem 0xfb003908 32 6
busybox devmem 0xfb003988 32 6
busybox devmem 0xfb003a08 32 6 
busybox devmem 0xfb003a88 32 6 

busybox devmem 0xfaf03008 32 6
busybox devmem 0xfaf03088 32 6
busybox devmem 0xfaf03108 32 6
busybox devmem 0xfaf03188 32 6
busybox devmem 0xfaf03208 32 1
busybox devmem 0xfaf03288 32 1
busybox devmem 0xfaf03308 32 1
busybox devmem 0xfaf03388 32 1
busybox devmem 0xfaf03408 32 1
busybox devmem 0xfaf03488 32 1






