GO_EASY_ON_ME=1
TARGET = iphone:clang:latest:6.0
THEOS_BUILD_DIR=build
OPTFLAG = -Ofast
CFLAGS = -Wall

include theos/makefiles/common.mk

TWEAK_NAME = CoverMeNot
CoverMeNot_FILES = Tweak.xm
CoverMeNot_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
