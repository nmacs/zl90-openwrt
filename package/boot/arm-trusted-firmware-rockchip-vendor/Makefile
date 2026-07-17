# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2022 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=arm-trusted-firmware-rockchip-vendor
PKG_RELEASE:=$(AUTORELEASE)

# PKG_MIRROR_HASH update procedure:
# cd ~/openwrt
# make package/arm-trusted-firmware-rockchip-vendor/download -j1 V=s
# make package/arm-trusted-firmware-rockchip-vendor/check FIXUP=1 -j1 V=s

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/nmacs/zl90-rockchip-rkbin
PKG_MIRROR_HASH:=6b28ab9728cbf3408a3be583be10955e4e9b8c78fc02b771c529cb72f6ccc022
PKG_SOURCE_DATE:=2025-24-01
PKG_SOURCE_VERSION:=74213af1e952c4683d2e35952507133b61394862

MAKE_PATH:=$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/arm-trusted-firmware-rockchip-vendor
    SECTION:=boot
    CATEGORY:=Boot Loaders
    TITLE:=ARM Trusted Firmware for Rockchip
endef

define Package/arm-trusted-firmware-rk3328
    $(Package/arm-trusted-firmware-rockchip-vendor)
    DEPENDS:=@TARGET_rockchip_armv8
    VARIANT:=rk3328
endef

define Package/arm-trusted-firmware-rk3399
    $(Package/arm-trusted-firmware-rockchip-vendor)
    DEPENDS:=@TARGET_rockchip_armv8
    VARIANT:=rk3399
endef

define Package/arm-trusted-firmware-rk3568
    $(Package/arm-trusted-firmware-rockchip-vendor)
    DEPENDS:=@TARGET_rockchip_armv8
    VARIANT:=rk3568
endef

define Package/arm-trusted-firmware-rk3588
    $(Package/arm-trusted-firmware-rockchip-vendor)
    DEPENDS:=@TARGET_rockchip_armv8
    VARIANT:=rk3588
endef

define Package/arm-trusted-firmware-rv1103
    $(Package/arm-trusted-firmware-rockchip-vendor)
    DEPENDS:=@TARGET_rockchip_cortexa7
    VARIANT:=rv1103
endef

define Package/arm-trusted-firmware-rv1106
    $(Package/arm-trusted-firmware-rockchip-vendor)
    DEPENDS:=@TARGET_rockchip_cortexa7
    VARIANT:=rv1106
endef

define Package/arm-trusted-firmware-zixlink-zl90
    $(Package/arm-trusted-firmware-rockchip-vendor)
    DEPENDS:=@TARGET_zixlink_zl90_zixlink_zl90_r1
    VARIANT:=rv1106
endef

define Build/Configure
	$(SED) 's,$$$$(PKG_BUILD_DIR),$(PKG_BUILD_DIR),g' $(PKG_BUILD_DIR)/trust.ini
	$(SED) 's,$$$$(VARIANT),$(BUILD_VARIANT),g' $(PKG_BUILD_DIR)/trust.ini
	$(call Build/Configure/Default)
endef

define Build/Compile
	$(CURDIR)/pack-firmware.sh build '$(BUILD_VARIANT)' '$(PKG_BUILD_DIR)'
endef

define Build/InstallDev
	$(CURDIR)/pack-firmware.sh install '$(BUILD_VARIANT)' '$(PKG_BUILD_DIR)' '$(STAGING_DIR_IMAGE)'
endef

define Package/arm-trusted-firmware-rk3328/install
endef

define Package/arm-trusted-firmware-rk3399/install
endef

define Package/arm-trusted-firmware-rk3568/install
endef

define Package/arm-trusted-firmware-rk3588/install
endef

define Package/arm-trusted-firmware-rv1103/install
endef

define Package/arm-trusted-firmware-rv1106/install
endef

define Package/arm-trusted-firmware-zixlink-zl90/install
endef

$(eval $(call BuildPackage,arm-trusted-firmware-rk3328))
$(eval $(call BuildPackage,arm-trusted-firmware-rk3399))
$(eval $(call BuildPackage,arm-trusted-firmware-rk3568))
$(eval $(call BuildPackage,arm-trusted-firmware-rk3588))
$(eval $(call BuildPackage,arm-trusted-firmware-rv1103))
$(eval $(call BuildPackage,arm-trusted-firmware-rv1106))
$(eval $(call BuildPackage,arm-trusted-firmware-zixlink-zl90))
