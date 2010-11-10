#
# Copyright (C) 2006-2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

WIRELESS_MENU:=Wireless Drivers

define KernelPackage/lib80211
  SUBMENU:=$(WIRELESS_MENU)
  TITLE:=802.11 Networking stack
  KCONFIG:= \
	CONFIG_LIB80211 \
	CONFIG_LIB80211_CRYPT_WEP \
	CONFIG_LIB80211_CRYPT_TKIP \
	CONFIG_LIB80211_CRYPT_CCMP
  FILES:= \
  	$(LINUX_DIR)/net/wireless/lib80211.ko \
  	$(LINUX_DIR)/net/wireless/lib80211_crypt_wep.ko \
  	$(LINUX_DIR)/net/wireless/lib80211_crypt_ccmp.ko \
  	$(LINUX_DIR)/net/wireless/lib80211_crypt_tkip.ko
  AUTOLOAD:=$(call AutoLoad,10, \
	lib80211 \
	lib80211_crypt_wep \
	lib80211_crypt_ccmp \
	lib80211_crypt_tkip \
  )
endef

define KernelPackage/lib80211/description
 Kernel modules for 802.11 Networking stack
 Includes:
 - lib80211
 - lib80211_crypt_wep
 - lib80211_crypt_tkip
 - lib80211_crytp_ccmp
endef

$(eval $(call KernelPackage,lib80211))

define KernelPackage/net-airo
  SUBMENU:=$(WIRELESS_MENU)
  TITLE:=Cisco Aironet driver
  DEPENDS:=@PCI_SUPPORT
  KCONFIG:=CONFIG_AIRO
  FILES:=$(LINUX_DIR)/drivers/net/wireless/airo.ko
  AUTOLOAD:=$(call AutoLoad,50,airo)
endef

define KernelPackage/net-airo/description
 Kernel support for Cisco Aironet cards
endef

$(eval $(call KernelPackage,net-airo))


define KernelPackage/net-prism54
  SUBMENU:=$(WIRELESS_MENU)
  TITLE:=Intersil Prism54 support
  DEPENDS:=@PCI_SUPPORT
  KCONFIG:=CONFIG_PRISM54
  FILES:=$(LINUX_DIR)/drivers/net/wireless/prism54/prism54.ko
  AUTOLOAD:=$(call AutoLoad,60,prism54)
endef

define KernelPackage/net-prism54/description
 Kernel modules for Intersil Prism54 support
endef

# Prism54 FullMAC firmware (jbnore.free.fr seems to be rather slow, so we use daemonizer.de)
PRISM54_FW:=1.0.4.3.arm

define Download/net-prism54
  FILE:=$(PRISM54_FW)
  URL:=http://daemonizer.de/prism54/prism54-fw/fw-fullmac/
  MD5SUM:=8bd4310971772a486b9784c77f8a6df9
endef

define KernelPackage/net-prism54/install
	$(INSTALL_DIR) $(1)/lib/firmware
	$(INSTALL_DATA) $(DL_DIR)/$(PRISM54_FW) $(1)/lib/firmware/isl3890
endef

$(eval $(call Download,net-prism54))
$(eval $(call KernelPackage,net-prism54))

