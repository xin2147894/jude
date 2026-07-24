export TARGET := iphone:clang:latest:13.0
export ARCHS = arm64 arm64e
export GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BypassFace
BypassFace_FILES = Tweak.xm
BypassFace_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
