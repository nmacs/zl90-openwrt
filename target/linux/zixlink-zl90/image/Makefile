# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS += UBOOT_DEVICE_NAME

KEYS_PATH       := $(CURDIR)/keys
MKIMAGE		:= mkimage

define Build/Compile
	$(CP) $(LINUX_DIR)/COPYING $(KDIR)/COPYING.linux
endef

### Image scripts ###
define Build/boot-common
	# This creates a new folder copies the dtb (as rockchip.dtb)
	# and the kernel image (as kernel.img)
	rm -fR $@.boot
	mkdir -p $@.boot

	$(CP) $(KERNEL_BUILD_DIR)/image-$(DEVICE_DTS).dtb $@.boot/rockchip.dtb
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel.img
endef

define Build/boot-common-legacy
	# This creates a new folder copies the dtb (as rockchip.dtb)
	# and the kernel image (as kernel.img)
	rm -fR $@.boot
	mkdir -p $@.boot

	$(CP) $(KERNEL_BUILD_DIR)/image-$(DEVICE_DTS).dtb $@.boot/rockchip.dtb
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel.img
endef

define Build/boot-script
	# Make an U-boot image and copy it to the boot partition
	$(MKIMAGE) -A arm -O linux -T script -C none -a 0 -e 0 -d $(if $(1),$(1),mmc).bootscript $@.boot/boot.scr
endef

define Build/rockchip32-legacy-bin-sd
	# Typical Rockchip boot flow with Rockchip miniloader
	# Rockchp idbLoader which is combinded by Rockchip ddr init bin
	# and miniloader bin from Rockchip rkbin project

	# Generate a new partition table in $@ with 32 MiB of alignment
	# padding for the idbloader, uboot and trust image to fit:
	# http://opensource.rock-chips.com/wiki_Boot_option#Boot_flow

	# This creates a new folder copies the dtb (as rockchip.dtb)
	# and the kernel image (as kernel.img)
	rm -fR $@.boot
	mkdir -p $@.boot

	# copy its
	$(CP) ./boot-arm.its $@.boot/boot.its

	# copy resource.img dtb kernel
	$(CP) $(LINUX_DIR)/resource.img $@.boot/resource
	$(CP) $(KERNEL_BUILD_DIR)/image-$(DEVICE_DTS).dtb $@.boot/fdt
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel

	# generate boot.img with boot.its
	$(MKIMAGE) -E -p 0x800 -f $@.boot/boot.its $@.boot/boot.img

	# generate basic image
	dd if=/dev/zero of="$@" bs=512 count=67136 conv=notrunc

	# Copy the idbloader and the u-boot image to the image at sector 0x40 and 0x440
	# Copy the boot.img to sector 0x640
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-env.img of="$@" seek=0 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-idblock.img of="$@" seek=64 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-uboot.img of="$@" seek=1088 conv=notrunc
	dd if="$@.boot"/boot.img of="$@" seek=1600 conv=notrunc
endef

define Build/rockchip32-legacy-bin-nand
	# Typical Rockchip boot flow with Rockchip miniloader
	# Rockchp idbLoader which is combinded by Rockchip ddr init bin
	# and miniloader bin from Rockchip rkbin project

	# Generate a new partition table in $@ with 32 MiB of alignment
	# padding for the idbloader, uboot and trust image to fit:
	# http://opensource.rock-chips.com/wiki_Boot_option#Boot_flow

	# This creates a new folder copies the dtb (as rockchip.dtb)
	# and the kernel image (as kernel.img)
	rm -fR $@.boot
	mkdir -p $@.boot

	# copy its
	$(CP) ./boot-arm.its $@.boot/boot.its

	# copy resource.img dtb kernel
	$(CP) $(LINUX_DIR)/resource.img $@.boot/resource
	$(CP) $(KERNEL_BUILD_DIR)/image-$(DEVICE_DTS).dtb $@.boot/fdt
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel
	
	#xz --check=crc32 $@.boot/kernel && mv $@.boot/kernel.xz $@.boot/kernel

	# generate boot.img with boot.its
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) $(STAGING_DIR_IMAGE)/$(MKIMAGE) -E -p 0x1000 -f $@.boot/boot.its -k $(KEYS_PATH) -K $@.boot/fdt -r $@.boot/boot.img

	# generate basic image 13MB
	dd if=/dev/zero of="$@" bs=512 count=26624 conv=notrunc

	# Copy the idbloader and the u-boot image to the image at sector 0x40 and 0x440
	# Copy the boot.img to sector 0x640
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-env.img of="$@" seek=0 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-idblock.img of="$@" seek=512 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-uboot.img of="$@" seek=1024 conv=notrunc
	dd if="$@.boot"/boot.img of="$@" seek=10240 conv=notrunc
endef

define Build/rockchip-bootloader
	# generate basic image 1MB
	dd if=/dev/zero of="$@" bs=512 count=1024 conv=notrunc
	
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-env.img of="$@" seek=0 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-idblock.img of="$@" seek=512 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-uboot.img of="$@" seek=1024 conv=notrunc
endef

define Build/rockchip-image
	rm -fR $@.boot
	mkdir -p $@.boot
	
	# copy its
	$(CP) ./boot-arm.its $@.boot/boot.its
	
	# copy resource.img dtb kernel
	$(CP) $(LINUX_DIR)/resource.img $@.boot/resource
	$(CP) $(KERNEL_BUILD_DIR)/image-$(DEVICE_DTS).dtb $@.boot/fdt
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel
	$(CP) $@.ramdisk $@.boot/ramdisk

	# generate boot.img with boot.its
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) $(STAGING_DIR_IMAGE)/$(MKIMAGE) -E -p 0x1000 -f $@.boot/boot.its -k $(KEYS_PATH) -K $@.boot/fdt -r $@.boot/boot.img
	
	# generate basic image 13MB
	dd if=/dev/zero of="$@" bs=512 count=26624 conv=notrunc

	# Copy the idbloader and the u-boot image to the image at sector 0x40 and 0x440
	# Copy the boot.img to sector 0x640
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-env.img of="$@" seek=0 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-idblock.img of="$@" seek=512 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-uboot.img of="$@" seek=1024 conv=notrunc
	dd if="$@.boot"/boot.img of="$@" seek=10240 conv=notrunc
endef

define Build/rockchip-boot
	rm -fR $@.boot
	mkdir -p $@.boot
	
	# copy its
	$(CP) ./boot-arm.its $@.boot/boot.its
	
	# copy resource.img dtb kernel
	$(CP) $(LINUX_DIR)/resource.img $@.boot/resource
	$(CP) $(KERNEL_BUILD_DIR)/image-$(DEVICE_DTS).dtb $@.boot/fdt
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel
	$(CP) $@.ramdisk $@.boot/ramdisk

	# generate boot.img with boot.its
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) $(STAGING_DIR_IMAGE)/$(MKIMAGE) -E -p 0x1000 -f $@.boot/boot.its -k $(KEYS_PATH) -K $@.boot/fdt -r $@
endef

define Build/rockchip-sysupgrade
	sh $(TOPDIR)/scripts/sysupgrade-tar.sh \
		--board $(DEVICE_NAME) \
		--kernel "$@" \
		--rootfs $(call param_get_default,rootfs,$(1),$(IMAGE_ROOTFS)) \
		$@.new

	mv $@.new $@
endef

### resource.img generate scripts ###
define Build/resource-img
	$(LINUX_DIR)/scripts/resource_tool $(KERNEL_BUILD_DIR)/image-$(DEVICE_DTS).dtb $(LINUX_DIR)/logo.bmp $(LINUX_DIR)/logo_kernel.bmp
	mv ./resource.img $(LINUX_DIR)/resource.img
endef

### env.img generate scripts ###
define Build/env-sd-img
	mkenvimage -s 0x8000 -p 0x0 -o $(STAGING_DIR_IMAGE)/$(UBOOT_DEVICE_NAME)-env.img ./uboot.env.sd.txt
endef

### env.img generate scripts ###
define Build/env-sfc-img
	mkenvimage -s 0x40000 -p 0x0 -o $(STAGING_DIR_IMAGE)/$(UBOOT_DEVICE_NAME)-env.img ./uboot.env.sfc.txt
endef

### Image scripts ###
define Build/boot-arm-bin
	# This creates a new folder copies the dtb (as rockchip.dtb)
	# and the kernel image (as kernel.img)
	rm -fR $@.boot
	mkdir -p $@.boot

	# copy its
	$(CP) ./boot-arm.its $@.boot/boot.its

	# copy resource.img dtb kernel
	$(CP) $(LINUX_DIR)/resource.img $@.boot/resource
	$(CP) $(KERNEL_BUILD_DIR)/image-$(DEVICE_DTS).dtb $@.boot/fdt
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel
	$(CP) $(IMAGE_ROOTFS) $@.boot/rootfs
	
	#xz --check=crc32 $@.boot/kernel && mv $@.boot/kernel.xz $@.boot/kernel

	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) $(STAGING_DIR_IMAGE)/$(MKIMAGE) -k $(KEYS_PATH) -r -E -p 0x1000 -f $@.boot/boot.its $@
endef

define Build/sysupgrade
	sh $(TOPDIR)/scripts/sysupgrade-tar.sh \
		--board $(DEVICE_NAME) \
		--kernel "$@" \
		$@.new

	mv $@.new $@
endef

define Build/initramfs
	cd $(LINUX_DIR); platform=$(PLATFORM_DIR) target=$(TARGET) usr/gen_initramfs.sh -o $@.ramdisk -u squash -g squash $(1) && gzip -n -9 -f $@.ramdisk && mv $@.ramdisk.gz $@.ramdisk
endef

define Build/boot-arm64-bin
	# This creates a new folder copies the dtb (as rockchip.dtb)
	# and the kernel image (as kernel.img)
	rm -fR $@.boot
	mkdir -p $@.boot

	# copy its
	$(CP) ./boot-arm64.its $@.boot/boot.its

	# copy resource.img dtb kernel
	$(CP) $(LINUX_DIR)/resource.img $@.boot/resource
	$(CP) $(LINUX_DIR)/../image-$(DEVICE_DTS).dtb $@.boot/fdt
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel

	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) $(MKIMAGE) -E -p 0x800 -f $@.boot/boot.its $@
endef

### Devices ###
define Device/Default
  PROFILES := Default
  KERNEL_NAME := zImage
  KERNEL := kernel-bin
  IMAGES := sysupgrade.img.gz
  DEVICE_DTS = rockchip/$$(SOC)-$(lastword $(subst _, ,$(1)))
  DEVICE_DTS_DIR := $(DTS_DIR)/rockchip
endef

define Device/Default-arm32
  PROFILES := Default
  KERNEL_NAME := zImage
  KERNEL := kernel-bin
  IMAGES := sysupgrade.img.gz
  DEVICE_DTS = rockchip/$$(SOC)-$(lastword $(subst _, ,$(1)))
  DEVICE_DTS_DIR := $(DTS_DIR)/rockchip
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))
