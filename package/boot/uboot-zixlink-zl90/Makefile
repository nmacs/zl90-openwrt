#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_RELEASE:=$(AUTORELEASE)

# PKG_MIRROR_HASH update procedure:
# cd ~/openwrt
# make package/uboot-zixlink-zl90/download -j1 V=s
# make package/uboot-zixlink-zl90/check FIXUP=1 -j1 V=s

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nmacs/zl90-uboot
PKG_MIRROR_HASH:=
PKG_SOURCE_DATE:=2026-07-10
PKG_SOURCE_VERSION:=917cd54273e6a02f532000c794c52dea7a4a70af

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
	BUILD_TARGET:=zixlink_zl90
	UENV:=default
	HIDDEN:=0
endef

# zixlink-zl90 boards
define U-Boot/zixlink-zl90-sfc
	BUILD_SUBTARGET:=zixlink_zl90_r1
	NAME:=Zixlink Industrial Router SFC UBoot
	BOOT_SOC:=rv1106
	BUILD_DEVICES:= \
		zixlink-zl90-nand
	DEPENDS:=+TARGET_zixlink_zl90_zixlink_zl90_r1_DEVICE_zixlink-zl90-nand:arm-trusted-firmware-zixlink-zl90
	PKG_BUILD_DEPENDS:=arm-trusted-firmware-rockchip-vendor
	DDR_BLOB:=rv11/rv1106_ddr_924MHz_v1.15.bin
	MCU0_BLOB:=rv11/rv1106_hpmcu_wrap_v1.70.bin
	SPL_BLOB:=rv11/rv1106_spl_v1.02.bin
endef

define U-Boot/zixlink-zl90-emmc
	BUILD_SUBTARGET:=zixlink_zl90_r1
	NAME:=Zixlink Industrial Router EMMC UBoot
	BOOT_SOC:=rv1106
	BUILD_DEVICES:= \
		zixlink-zl90-sd
	DEPENDS:=+TARGET_zixlink_zl90_zixlink_zl90_r1_DEVICE_zixlink-zl90-sd:arm-trusted-firmware-zixlink-zl90
	PKG_BUILD_DEPENDS:=arm-trusted-firmware-rockchip-vendor
	DDR_BLOB:=rv11/rv1106_ddr_924MHz_v1.10.bin
	MCU0_BLOB:=rv11/rv1106_hpmcu_wrap_v1.53.bin
	SPL_BLOB:=rv11/rv1106_spl_v1.01.bin
endef

UBOOT_TARGETS := \
	zixlink-zl90-sfc \
	zixlink-zl90-emmc

UBOOT_CONFIGURE_VARS	+= USE_PRIVATE_LIBGCC=yes

UBOOT_MAKE_FLAGS	+= all
USE_TEE			:= 1
BL32_BLOB		:= bin/rv11/rv1106_tee_ta_v1.13.bin

define Build/Configure
	$(call Build/Configure/U-Boot)

	$(SED) 's#CONFIG_MKIMAGE_DTC_PATH=.*#CONFIG_MKIMAGE_DTC_PATH="$(PKG_BUILD_DIR)/scripts/dtc/dtc"#g' $(PKG_BUILD_DIR)/.config

ifneq ($(USE_TEE),)
	$(CP) $(STAGING_DIR_IMAGE)/$(BL32_BLOB) $(PKG_BUILD_DIR)/tee.bin
endif

endef

define Build/Compile
	rm -rf $(PKG_BUILD_DIR)/../rkbin
	ln -s $(STAGING_DIR_IMAGE) $(PKG_BUILD_DIR)/../rkbin
	cd $(PKG_BUILD_DIR)
	
	# add --burn-key-hash for OTP programm
	cp -r $(TOPDIR)/target/linux/$(BOARD)/image/keys $(PKG_BUILD_DIR)/
	pushd $(PKG_BUILD_DIR);$(PKG_BUILD_DIR)/make.sh --spl-new --optee $(PKG_BUILD_DIR)/tee.bin CROSS_COMPILE=$(TARGET_CROSS) "$(UBOOT_CONFIG)";popd
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)

	$(CP) $(PKG_BUILD_DIR)/*download*.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-download.bin
	$(CP) $(PKG_BUILD_DIR)/*idblock*.img $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-idblock.img
	$(CP) $(PKG_BUILD_DIR)/uboot.img $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-uboot.img
	$(CP) $(PKG_BUILD_DIR)/tools/mkimage $(STAGING_DIR_IMAGE)/
endef

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
