ARCHS = arm64
include theos/makefiles/common.mk

BUNDLE_NAME = SpotifyAlarm
SpotifyAlarm_FILES = SpotifyAlarm.mm
SpotifyAlarm_INSTALL_PATH = /Library/PreferenceBundles
SpotifyAlarm_FRAMEWORKS = UIKit
SpotifyAlarm_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SpotifyAlarm.plist$(ECHO_END)
