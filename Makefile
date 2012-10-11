ARCHS = armv7
TARGET = iphone:latest:4.3
include /opt/theos/makefiles/common.mk

TWEAK_NAME = FakeClockUp
FakeClockUp_FILES = Tweak.xm

include /opt/theos/makefiles/tweak.mk

LIBRARY_NAME = Toggle
Toggle_INSTALL_PATH = /var/mobile/Library/SBSettings/Toggles/FakeClockUp
Toggle_OBJC_FILES = Toggle.m

include $(THEOS_MAKE_PATH)/library.mk

BUNDLE_NAME = FakeClockUpSettings
FakeClockUpSettings_FILES = Preference.m
FakeClockUpSettings_INSTALL_PATH = /Library/PreferenceBundles
FakeClockUpSettings_FRAMEWORKS = UIKit CoreGraphics
FakeClockUpSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FakeClockUp.plist$(ECHO_END)
