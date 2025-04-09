ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
IGNORE_WARNINGS = 1
TARGET = iphone:clang:latest:8.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PCamNoVa

HOOK_SRC = $(wildcard hook/*.c)

$(TWEAK_NAME)_CCFLAGS = -fobjc-arc -fno-rtti -fvisibility=hidden -DNDEBUG -std=gnu++17

$(TWEAK_NAME)_CFLAGS  = -fobjc-arc -Wno-unused-but-set-variable -Wno-deprecated-declarations \
                            -Wno-unused-variable -Wno-unused-value -Wno-unused-function  \
                            -DHAVE_INTTYPES_H -DHAVE_PKCRYPT -DHAVE_STDINT_H -DHAVE_WZAES -DHAVE_ZLIB  

$(TWEAK_NAME)_LDFLAGS += il2cpp/libPPil2cpp.a

$(TWEAK_NAME)_FILES = Hook_Cam_No_Va.mm RealOffset/RealOffset.cpp $(HOOK_SRC)
                          

$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation UniformTypeIdentifiers Security QuartzCore CoreGraphics CoreText AVFoundation \
                               Accelerate GLKit SystemConfiguration GameController UIKit SafariServices Accelerate Foundation \
                               QuartzCore CoreGraphics AudioToolbox CoreText Metal MobileCoreServices Security SystemConfiguration \
                               IOKit CoreImage AdSupport AVFoundation 
$(TWEAK_NAME)_LOGOS_DEFAULT_GENERATOR = internal
include $(THEOS_MAKE_PATH)/tweak.mk