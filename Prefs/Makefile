ARCHS = armv7 arm64 arm64e
include $(THEOS)/makefiles/common.mk

export SYSROOT=$(THEOS)/sdks/iPhoneOS13.3.sdk

TARGET = iphoneos:clang:13.3:11.0

BUNDLE_NAME = GoogleMapsStatusBarETA

GoogleMapsStatusBarETA_FILES = $(wildcard *.m */*.m)
GoogleMapsStatusBarETA_INSTALL_PATH = /Library/PreferenceBundles
GoogleMapsStatusBarETA_FRAMEWORKS = UIKit
GoogleMapsStatusBarETA_PRIVATE_FRAMEWORKS = Preferences
GoogleMapsStatusBarETA_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/GoogleMapsStatusBarETA.plist$(ECHO_END)
