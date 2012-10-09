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
