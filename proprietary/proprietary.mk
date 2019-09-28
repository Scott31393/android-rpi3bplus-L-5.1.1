PACKAGE_KODI = kodi-16.0-Jarvis-armeabi-v7a.apk

PRODUCT_PACKAGES += \
        device/capsulecorp/proprietary/apk/jackpal.androidterm.apk:system/app/jackpal.androidterm.apk \
        device/capsulecorp/proprietary/apk/CMFileManager.apk:system/app/CMFileManager/CMFileManager.apk         
# Prebuild packages
PRODUCT_COPY_FILES += \
        device/capsulecorp/proprietary/lib/libjackpal-androidterm5.so:system/lib/libjackpal-androidterm5.so \
        device/capsulecorp/proprietary/lib/libjackpal-termexec2.so:system/lib/libjackpal-termexec2.so

# Input device calibration files
PRODUCT_COPY_FILES += \
        device/capsulecorp/proprietary/bin/odroid-ts.idc:system/usr/idc/odroid-ts.idc \
        device/capsulecorp/proprietary/bin/odroid-ts.idc:system/usr/idc/usbio-keypad.idc \
        device/capsulecorp/proprietary/bin/odroid-ts.kl:system/usr/keylayout/odroid-ts.kl \
        device/capsulecorp/proprietary/bin/odroid-ts.kcm:system/usr/keylayout/odroid-ts.kcm \
        device/capsulecorp/proprietary/bin/odroid-keypad.kl:system/usr/keylayout/odroid-keypad.kl \
        device/capsulecorp/proprietary/bin/odroid-keypad.kcm:system/usr/keychars/odroid-keypad.kcm

# for USB HID MULTITOUCH
PRODUCT_COPY_FILES += \
        device/capsulecorp/proprietary/bin/Vendor_0eef_Product_0005.idc:system/usr/idc/Vendor_0eef_Product_0005.idc \
        device/capsulecorp/proprietary/bin/Vendor_03fc_Product_05d8.idc:system/usr/idc/Vendor_03fc_Product_05d8.idc \
        device/capsulecorp/proprietary/bin/Vendor_1870_Product_0119.idc:system/usr/idc/Vendor_1870_Product_0119.idc \
        device/capsulecorp/proprietary/bin/Vendor_1870_Product_0100.idc:system/usr/idc/Vendor_1870_Product_0100.idc \
        device/capsulecorp/proprietary/bin/Vendor_2808_Product_81c9.idc:system/usr/idc/Vendor_2808_Product_81c9.idc \
        device/capsulecorp/proprietary/bin/Vendor_16b4_Product_0704.idc:system/usr/idc/Vendor_16b4_Product_0704.idc \
        device/capsulecorp/proprietary/bin/Vendor_16b4_Product_0705.idc:system/usr/idc/Vendor_16b4_Product_0705.idc \
        device/capsulecorp/proprietary/bin/Vendor_04d8_Product_0c03.idc:system/usr/idc/Vendor_04d8_Product_0c03.idc

# XBox 360 Controller kl keymaps
PRODUCT_COPY_FILES += \
        device/capsulecorp/proprietary/bin/Vendor_045e_Product_0291.kl:system/usr/keylayout/Vendor_045e_Product_0291.kl \
        device/capsulecorp/proprietary/bin/Vendor_045e_Product_0719.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl \
        device/capsulecorp/proprietary/bin/Vendor_0c45_Product_1109.kl:system/usr/keylayout/Vendor_0c45_Product_1109 \
        device/capsulecorp/proprietary/bin/Vendor_1b8e_Product_0cec_Version_0001.kl:system/usr/keylayout/Vendor_1b8e_Product_0cec_Version_0001 \
        device/capsulecorp/proprietary/bin/Vendor_045e_Product_0719.kcm:system/usr/keychars/Vendor_045e_Product_0719.kcm
