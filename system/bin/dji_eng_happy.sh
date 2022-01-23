#!/system/bin/sh

dji_is_production()
{
	cat /proc/cmdline | grep "mp_state=production"
	local production_stat=$?
	return $production_stat
}

dji_platform_enable()
{
	platform=`cat /proc/cmdline | grep "e1e"`
	if [ -n "$platform" ]; then
		busybox devmem 0xf0a41084 32 0x00000008
		busybox devmem 0xf0a41088 32 0x00000028
		exit
	fi
	platform=`cat /proc/cmdline | grep "eagle"`
	if [ -n "$platform" ]; then
		busybox devmem 0xf0a41084 32 0x00000001
		busybox devmem 0xf0a41088 32 0x00000007
		exit
	fi
	platform=`cat /proc/cmdline | grep "pigeon"`
	if [ -n "$platform" ]; then
		busybox devmem 0xf0a410c8 32 0x00000008
		busybox devmem 0xf0a410cc 32 0x00000038
		exit
	fi
}

dji_platform_disable()
{
	platform=`cat /proc/cmdline | grep "e1e"`
	if [ -n "$platform" ]; then
		busybox devmem 0xf0a41084 32 0x00010008
		busybox devmem 0xf0a41088 32 0x00010028
		exit
	fi
	platform=`cat /proc/cmdline | grep "eagle"`
	if [ -n "$platform" ]; then
		busybox devmem 0xf0a41084 32 0x00010001
		busybox devmem 0xf0a41088 32 0x00010007
		exit
	fi
	platform=`cat /proc/cmdline | grep "pigeon"`
	if [ -n "$platform" ]; then
		busybox devmem 0xf0a410c8 32 0x00010008
		busybox devmem 0xf0a410cc 32 0x00010038
		exit
	fi
}

dji_is_production

if [ $? -eq 0 ]; then
	dji_platform_disable
else
	dji_platform_enable
fi
