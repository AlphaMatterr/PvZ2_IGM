GO_EASY_ON_ME = 1
include theos/makefiles/common.mk
archs = armv7 arm64

TWEAK_NAME = PvZ2
PvZ2_FILES = Tweak.xm
PvZ2_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
