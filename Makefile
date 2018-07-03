export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222

ARCHS = arm64
TARGET = iphone:9.2
SDKVERSION = 9.2
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 8.0
TARGET_STRIP_FLAGS = -u -r -s /dev/null

#CFLAGS = -fobjc-arc
#THEOS_PACKAGE_DIR_NAME = debs

include theos/makefiles/common.mk

TWEAK_NAME = SpotifyAlarm
SpotifyAlarm_FILES = Tweak.xm
SpotifyAlarm_FRAMEWORKS = UIKit
SpotifyAlarm_PRIVATE_FRAMEWORKS = MobileTimer
SpotifyAlarm_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += SpotifyAlarm
include $(THEOS_MAKE_PATH)/aggregate.mk
