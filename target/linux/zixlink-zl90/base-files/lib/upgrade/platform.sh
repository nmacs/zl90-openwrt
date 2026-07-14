#
# Copyright (C) 2010-2015 OpenWrt.org
#

platform_check_image() {
	local board=$(board_name)
	local kernelfile="unknownfile"
	local rootfsfile="unknownfile"

	case "$board" in
	rockchip,zixlink-zl90)
		kernelfile="sysupgrade-zixlink-zl90-nand/kernel"
		rootfsfile="sysupgrade-zixlink-zl90-nand/root"
		;;
	
	*)
		echo "Sysupgrade is not yet supported on $board."
		return 1
		;;
	esac
	
	if ! tar -tf $1 $kernelfile $rootfsfile >/dev/null 2>&1; then
		echo "Kernel file not found. Upgrade failed"
		return 1
	else
		return 0
	fi

	echo "Sysupgrade is not yet supported on $board."
	return 1
}

platform_do_upgrade() {
	local board=$(board_name)
	board_name=${board_name/,/_}

	echo "BOARD: $board $board_name"

	case "$board" in
	rockchip,zixlink-zl90)
		slot=$(env | grep "android_slotsufix=" | awk -F'[ =]' '{print $2}')
		get_image "$1" | tar Oxf - sysupgrade-zixlink-zl90-nand/kernel > /tmp/kernel
		get_image "$1" | tar Oxf - sysupgrade-zixlink-zl90-nand/root > /tmp/rootfs
		if [ "$slot" = "_a" ]; then
			echo "Current slot: A. Next slot: B"
			flashcp /tmp/kernel /dev/mtd7 || (echo "kernel flash err" && return 1)
			flashcp /tmp/rootfs /dev/mtd8 || (echo "rootfs flash err" && return 1)
			rk-ota --misc=other
		elif [ "$slot" = "_b" ]; then
			echo "Current slot: B. Next slot: A"
			flashcp /tmp/kernel /dev/mtd5 || (echo "kernel flash err" && return 1)
			flashcp /tmp/rootfs /dev/mtd6 || (echo "rootfs flash err" && return 1)
			rk-ota --misc=other
		else
			echo "Unknown slot: $slot"
			return 1
		fi
		;;

	*)
		echo "Sysupgrade is not yet supported on $board."
		return 1
		;;
	esac

	echo "Flash updating done"
	sync
	
	if [ -z "$UPGRADE_BACKUP" ]; then
		echo "Erase overlay"
		rm -rf /overlay/upper
		rm -rf /overlay/work
		mkdir -p /overlay/upper
		mkdir -p /overlay/work
		
		sync
	fi

	return 0
}

platform_copy_config() {
	local board=$(board_name)
}

platform_pre_upgrade() {
	local board=$(board_name)
}
