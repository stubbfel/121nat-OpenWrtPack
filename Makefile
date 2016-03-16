include $(TOPDIR)/rules.mk

PKG_NAME:=121nat
PKG_VERSION:=0.6.5
PKG_RELEASE:=1
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/stubbfel/121nat.git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/121nat
	SECTION:=net
	SUBMENU:=Routing and Redirection
	CATEGORY:=Network
	TITLE:=Transparent One-To-One-Nat
	DEPENDS:=+libstdcpp +libpthread +libpcap
endef

define Package/121nat/description
	a simple transparent one to one nat
endef

define Build/Configure
	mkdir -p $(PKG_BUILD_DIR)/build/121Nat
	$(CP) ./files/libtins/CMakeLists.txt  $(PKG_BUILD_DIR)/lib/src/libtins/
	$(CP) ./files/121nat/CMakeLists.txt  $(PKG_BUILD_DIR)/

	IN_OPENWRT=1 \
	AR="$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)ar" \
	AS="$(TOOLCHAIN_DIR)/bin/$(TARGET_CC) -c $(TARGET_CFLAGS)" \
	LD="$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)ld" \
	NM="$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)nm" \
	CC="$(TOOLCHAIN_DIR)/bin/$(TARGET_CC)" \
	GCC="$(TOOLCHAIN_DIR)/bin/$(TARGET_CC)" \
	CXX="$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)g++" \
	RANLIB="$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)ranlib" \
	STRIP="$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)strip" \
	OBJCOPY="$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)objcopy" \
	OBJDUMP="$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)objdump" \
	TARGET_CPPFLAGS="$(TARGET_CPPFLAGS)" \
	TARGET_CFLAGS="$(TARGET_CFLAGS)" \
	TARGET_LDFLAGS="$(TARGET_LDFLAGS)" \
	cmake -H$(PKG_BUILD_DIR)/ -B$(PKG_BUILD_DIR)/build/121Nat/
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/build/121Nat/
endef

define Package/121nat/install
	#$(INSTALL_DIR) $(1)/usr/lib/
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/121Nat/lib/src/libtins/lib/libtins.a $(1)/usr/lib/
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/121Nat/lib/src/jsoncpp/src/lib_json/libjsoncpp.a  $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/121Nat/src/121Nat $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/121nat
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/config.json $(1)/etc/121nat
endef

$(eval $(call BuildPackage,121nat))
