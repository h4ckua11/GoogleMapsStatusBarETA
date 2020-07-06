ARCHS = armv7 arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoogleMapsStatusBarETA
GoogleMapsStatusBarETA_CFLAGS = -fobjc-arc

SUBPROJECTS += Tweak Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	find . -name ".DS_Store" -type f -delete

after-install::
	install.exec "killall maps"
	