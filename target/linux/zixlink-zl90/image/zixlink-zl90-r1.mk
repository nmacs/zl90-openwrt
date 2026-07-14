MAIN_IMAGE_INITRAMFS := initramfs $(PLATFORM_DIR)/initramfs/initramfs-base-files.txt $(PLATFORM_DIR)/initramfs/files

define Device/Default-emmc
	$(Device/Default-arm32)
	FILESYSTEMS += squashfs ext4
	IMAGES := boot.img rootfs.img
	IMAGE/rootfs.img := append-rootfs | pad-extra 128k
	IMAGE/boot.img := resource-img | boot-arm-bin
endef

define Device/Default-sdcard
	$(Device/Default-arm32)
	FILESYSTEMS += squashfs ext4
	IMAGES := boot.img rootfs.img
	IMAGE/rootfs.img := append-rootfs | pad-extra 128k
	IMAGE/boot.img := resource-img | boot-arm-bin
endef

define Device/Default-spiflash
	$(Device/Default-arm32)
	FILESYSTEMS += squashfs jffs2
	IMAGES := boot.img rootfs.img
	IMAGE/rootfs.img := append-rootfs | pad-extra 128k
	IMAGE/boot.img := resource-img | boot-arm-bin
endef

define Device/Default-nandflash
	$(Device/Default-arm32)
	FILESYSTEMS += squashfs jffs2
	IMAGES := boot.img rootfs.img image.img
	IMAGE/rootfs.img := append-rootfs | pad-to 128k
	IMAGE/boot.img := resource-img | $(MAIN_IMAGE_INITRAMFS) | rockchip-boot | pad-to 128k
	IMAGE/image.img := env-sfc-img | $(MAIN_IMAGE_INITRAMFS) | rockchip-image | append-rootfs | pad-to 128k
endef

define Device/zixlink-zl90-nand
	PAGESIZE := 2048
	BLOCKSIZE := 128k
	$(Device/Default-nandflash)
	DEVICE_TITLE := Zixlink Router NAND
	SUPPORTED_DEVICES := zixlink-zl90
	SOC := rv1106
	MKUBIFS_OPTS := -m 2048 -e 124KiB -c 512
	UBINIZE_OPTS := -E 5
	DEVICE_DTS := zixlink-zl90
	DEVICE_DTS_DIR := $(DTS_DIR)/rockchip
	UBOOT_DEVICE_NAME := zixlink-zl90-sfc
	KERNEL := kernel-bin | resource-img
	IMAGES += sysupgrade.tar
	IMAGE/sysupgrade.tar := $(MAIN_IMAGE_INITRAMFS) | rockchip-boot | pad-to 128k | rockchip-sysupgrade | append-metadata
endef
TARGET_DEVICES += zixlink-zl90-nand

define Device/zixlink-zl90-sd
	PAGESIZE := 2048
	BLOCKSIZE := 128k
	$(Device/Default-emmc)
	DEVICE_TITLE := Zixlink Router SD
	SUPPORTED_DEVICES := zixlink-zl90
	SOC := rv1106
	MKUBIFS_OPTS := -m 2048 -e 124KiB -c 2114
	UBINIZE_OPTS := -E 5
	DEVICE_DTS := zixlink-zl90
	UBOOT_DEVICE_NAME := zixlink-zl90-emmc
	IMAGES += sysupgrade.img.gz
	IMAGE/sysupgrade.img.gz := env-sd-img | rockchip32-legacy-bin | append-rootfs | pad-extra 128k | gzip | append-metadata
endef
TARGET_DEVICES += zixlink-zl90-sd
