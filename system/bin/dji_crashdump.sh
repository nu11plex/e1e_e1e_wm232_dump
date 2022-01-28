#!/system/bin/sh

# crash dump collection function

# NR_FILES=10
# KPANIC_CONSOLE_FILE="/data/dji/log/kpanic_console"
# DONTPANIC_CONSOLE_FILE="/data/dontpanic/kpanic_console"
# process_kpanic $NR_FILES $KPANIC_CONSOLE_FILE $DONTPANIC_CONSOLE_FILE
function process_kpanic() {
	COUNTER=$1
	KPANIC_FILE=$2
	DONTPANIC_FILE=$3
	DOT="."

	if [ -f "$DONTPANIC_FILE" ];then

		while [ $COUNTER -gt 0 ]
		do
		    OLD_FILE=$KPANIC_FILE$DOT$COUNTER
		    if [ -f "$OLD_FILE" ];then
			NEW_FILE=$KPANIC_FILE$DOT$(($COUNTER+1))
			echo "rename $OLD_FILE to $NEW_FILE"
			mv $OLD_FILE $NEW_FILE
		    fi

		let COUNTER=$COUNTER-1
		#echo $COUNTER
		done

		OLD_FILE=$KPANIC_FILE
		if [ -f "$OLD_FILE" ];then
			NEW_FILE=$KPANIC_FILE".1"
			echo "rename $OLD_FILE to $NEW_FILE"
			mv $OLD_FILE $NEW_FILE
		fi

		echo "move $DONTPANIC_FILE to $OLD_FILE"
		mv $DONTPANIC_FILE $OLD_FILE
	fi
}

########################################################################################
## crash dump processes
if [ ! -d "/data/dontpanic" ];then
    mkdir /data/dontpanic
fi

if [ ! -d "/blackbox/system" ];then
    mkdir -p /blackbox/system
fi

# do trigger to create real proc node if necessary
echo 1 > /proc/kpanic_mmc

# process kpanic_minidump
if [ -f "/proc/kpanic_minidump" ];then
    echo "process kpanic_minidump"
    cat /proc/kpanic_minidump > /data/dontpanic/kpanic_minidump
    chmod 0640 /data/dontpanic/kpanic_minidump
fi

NR_FILES=4
KPANIC_MINIDUMP_FILE="/blackbox/system/kpanic_minidump"
DONTPANIC_MINIDUMP_FILE="/data/dontpanic/kpanic_minidump"
process_kpanic $NR_FILES $KPANIC_MINIDUMP_FILE $DONTPANIC_MINIDUMP_FILE

# process kpanic_console
if [ -f "/proc/kpanic_console" ];then
    echo "process kpanic_console"
    cat /proc/kpanic_console > /data/dontpanic/kpanic_console
    chmod 0640 /data/dontpanic/kpanic_console
    date >> /data/dontpanic/kpanic_console
fi

NR_FILES=4
KPANIC_CONSOLE_FILE="/blackbox/system/kpanic_console"
DONTPANIC_CONSOLE_FILE="/data/dontpanic/kpanic_console"
process_kpanic $NR_FILES $KPANIC_CONSOLE_FILE $DONTPANIC_CONSOLE_FILE


# process tee_ramconsole
if [ -f "/proc/tee_ramconsole" ];then
    echo "process tee_ramconsole"
    cat /proc/tee_ramconsole > /data/dontpanic/tee_ramconsole
    chmod 0640 /data/dontpanic/tee_ramconsole
    date >> /data/dontpanic/tee_ramconsole
fi

NR_FILES=4
KPANIC_TEE_RAMCONSOLE_FILE="/blackbox/system/tee_ramconsole"
DONTPANIC_TEE_RAMCONSOLE_FILE="/data/dontpanic/tee_ramconsole"
process_kpanic $NR_FILES $KPANIC_TEE_RAMCONSOLE_FILE $DONTPANIC_TEE_RAMCONSOLE_FILE

# process fulldump
if [ -f "/proc/kpanic_fulldump" ];then
    echo "process kpanic_fulldump"
    partition=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/media
    dumpfile=/blackbox/system/fulldump-`date +%F-%H-%M-%S`.bin
    offset=`cat /sys/kernel/debug/fulldump_offset`
    size=`cat /sys/kernel/debug/fulldump_size`
    dji_fulldump -i $partition -o $dumpfile -s "$offset"M -c "$size"M
fi

## process kpanic_threads
if [ -f "/proc/kpanic_threads" ];then
    echo "process kpanic_threads"
    cat /proc/kpanic_threads > /data/dontpanic/kpanic_threads
    chmod 0640 /data/dontpanic/kpanic_threads
    date >> /data/dontpanic/kpanic_threads
fi

KPANIC_THREADS_FILE="/blackbox/system/kpanic_threads"
DONTPANIC_THREADS_FILE="/data/dontpanic/kpanic_threads"
process_kpanic $NR_FILES $KPANIC_THREADS_FILE $DONTPANIC_THREADS_FILE


# remove proc node
if [ -f "/proc/kpanic_console" ];then
    echo "remove kpanic proc node"
    echo 1 > /proc/kpanic_console
fi

# process pstore file

if [ ! -d "/data/dji/pstore" ];then
    mkdir -p /data/dji/pstore
fi

mount -t pstore pstore /data/dji/pstore

if [ ! -d "/blackbox/system/pstore" ];then
    mkdir -p /blackbox/system/pstore
fi

NR_FILES=14
CONSOLE_RAMOOPS_FILE="/blackbox/system/pstore/console-ramoops-0"
RAM_CONSOLE_RAMOOPS_FILE="/data/dji/pstore/console-ramoops-0"
process_kpanic $NR_FILES $CONSOLE_RAMOOPS_FILE $RAM_CONSOLE_RAMOOPS_FILE
