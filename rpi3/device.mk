#
# Copyright (C) 2013 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_COPY_FILES += \
    device/capsulecorp/rpi3/init.rpi3.board.rc:root/init.rpi3.board.rc \
    device/capsulecorp/rpi3/init.rpi3.usb.rc:root/init.rpi3.usb.rc \
    device/capsulecorp/rpi3/init.rpi3.rc:root/init.rpi3.rc \
    device/capsulecorp/rpi3/ueventd.rpi3.rc:root/ueventd.rpi3.rc

PRODUCT_COPY_FILES += \
    device/capsulecorp/rpi3/recovery/init.recovery.rpi3.rc:root/init.recovery.rpi3.rc

PRODUCT_COPY_FILES += \
    device/capsulecorp/rpi3/files/media_profiles.xml:system/etc/media_profiles.xml \
    device/capsulecorp/rpi3/files/audio_policy.conf:system/etc/audio_policy.conf \
    device/capsulecorp/rpi3/files/media_codecs.xml:system/etc/media_codecs.xml \
    device/capsulecorp/rpi3/files/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/capsulecorp/rpi3/files/mesondisplay.cfg:system/etc/mesondisplay.cfg \
    device/capsulecorp/rpi3/files/boot.ini.template:system/etc/boot.ini.template \
    device/capsulecorp/rpi3/files/preinstall.sh:system/bin/preinstall.sh \
    device/capsulecorp/rpi3/files/makebootini.sh:system/bin/makebootini.sh \
    device/capsulecorp/rpi3/files/usb_reset.sh:system/bin/usb_reset.sh \
    device/capsulecorp/rpi3/files/ups3.sh:system/bin/ups3.sh \
    device/capsulecorp/rpi3/files/rotation.sh:system/bin/rotation.sh \
    device/capsulecorp/rpi3/files/vu8_backlight.sh:system/bin/vu8_backlight.sh \
    device/capsulecorp/rpi3/files/hardkernel-720.bmp.gz:system/etc/hardkernel-720.bmp.gz

# remote IME config file
PRODUCT_COPY_FILES += \
    device/capsulecorp/rpi3/files/remote.conf:system/etc/remote.conf \
    device/capsulecorp/rpi3/files/Vendor_0001_Product_0001.kl:/system/usr/keylayout/Vendor_0001_Product_0001.kl

PRODUCT_CHARACTERISTICS := tablet

DEVICE_PACKAGE_OVERLAYS := \
    device/capsulecorp/rpi3/rpi3/overlay

PRODUCT_TAGS += dalvik.gc.type-precise


# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp
