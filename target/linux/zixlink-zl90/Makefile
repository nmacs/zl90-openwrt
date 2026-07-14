# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk

ARCH:=arm
BOARD:=zixlink-zl90
BOARDNAME:=ZixLink Industrial Router
FEATURES:=ext4 ubifs audio usb usbgadget display gpio fpu pci pcie rootfs-part boot-part squashfs
SUBTARGETS:=zixlink-zl90-r1

KERNEL_PATCHVER:=6.6

define Target/Description
	Build firmware image for Zixlink Rockchip Industrial Router
endef

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += uboot-envtools partx-utils e2fsprogs mkf2fs kmod-gpio-button-hotplug

KERNELNAME:=zImage dtbs

$(eval $(call BuildTarget))
