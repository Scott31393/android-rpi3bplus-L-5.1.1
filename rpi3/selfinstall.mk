#
# Copyright (C) 2015 Hardkernel Co,. Ltd.
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

SIGNJAR := prebuilts/sdk/tools/lib/signapk.jar

SELFINSTALL_DIR := $(PRODUCT_OUT)/selfinstall
SELFINSTALL_SIGNED_UPDATEPACKAGE := $(SELFINSTALL_DIR)/cache/update.zip
BOOTLOADER_MESSAGE := $(SELFINSTALL_DIR)/BOOTLOADER_MESSAGE
SELFINSTALL_CACHEIMAGE_SIZE := 256	# MB
SELFINSTALL_CACHE_IMAGE := $(SELFINSTALL_DIR)/cache.ext4
UPDATE_PACKAGE_PATH := $(ANDROID_BUILD_TOP)/vendor/capsulecorp-opensource/updat-package-path
#
# Bootloader
#
$(PRODUCT_OUT)/u-boot.bin:
	make -C vendor/capsulecorp-opensource/u-boot-android-2018-07 $(TARGET_PRODUCT)_defconfig
	make -C vendor/capsulecorp-opensource/u-boot-android-2018-07
	cp -vf $(ANDROID_BUILD_TOP)/vendor/capsulecorp-opensource/u-boot-android-2018-07/u-boot.bin $(PRODUCT_OUT)/u-boot.bin


$(SELFINSTALL_DIR)/update.unsigned.zip: userdataimage cacheimage rootsystem recoveryimage
	rm -rf $@
	rm -rf $(UPDATE_PACKAGE_PATH)
	mkdir -p $(UPDATE_PACKAGE_PATH)/META-INF/com/google/android
	cp -af $(PRODUCT_OUT)/rootsystem.img $(UPDATE_PACKAGE_PATH)
	cp -af $(INSTALLED_CACHEIMAGE_TARGET) $(UPDATE_PACKAGE_PATH)
	cp -af $(PRODUCT_OUT)/system/bin/updater \
		$(UPDATE_PACKAGE_PATH)/META-INF/com/google/android/update-binary
	cp -af $(TARGET_DEVICE_DIR)/recovery/updater-script \
		$(UPDATE_PACKAGE_PATH)/META-INF/com/google/android/updater-script
	( pushd $(UPDATE_PACKAGE_PATH); \
		zip -r $(CURDIR)/$@ * ; \
	)

$(SELFINSTALL_SIGNED_UPDATEPACKAGE): $(SELFINSTALL_DIR)/update.unsigned.zip
	mkdir -p $(dir $@)
	java -jar $(SIGNJAR) -w \
		$(DEFAULT_KEY_CERT_PAIR).x509.pem \
		$(DEFAULT_KEY_CERT_PAIR).pk8 $< $@

$(BOOTLOADER_MESSAGE):
	mkdir -p $(dir $@)
	dd if=/dev/zero of=$@ bs=16 count=4	# 64 Bytes
	echo "recovery" >> $@
	echo "--locale=en_US" >> $@
	echo "--selfinstall" >> $@
	echo "--update_package=CACHE:update.zip" >> $@

.PHONY: $(SELFINSTALL_DIR)/cache
$(SELFINSTALL_DIR)/cache: $(SELFINSTALL_SIGNED_UPDATEPACKAGE) $(BOOTLOADER_MESSAGE)
	cp -af $(PRODUCT_OUT)/cache/ $(SELFINSTALL_DIR)/

$(SELFINSTALL_DIR)/cache.img: $(SELFINSTALL_DIR)/cache
	$(MAKE_EXT4FS) -s -L cache -a cache \
		-l $(BOARD_CACHEIMAGE_PARTITION_SIZE) $@ $<

$(SELFINSTALL_CACHE_IMAGE): $(SELFINSTALL_DIR)/cache.img
	simg2img $? $@

#
# Android Self-Installation
#
$(PRODUCT_OUT)/selfinstall-$(TARGET_DEVICE).bin: \
	$(INSTALLED_BOOTIMAGE_TARGET) \
	$(INSTALLED_RECOVERYIMAGE_TARGET) \
	$(PRODUCT_OUT)/u-boot.bin \
	$(SELFINSTALL_CACHE_IMAGE)
	@echo "Creating installable single image file..."
	dd if=$(PRODUCT_OUT)/u-boot.bin of=$@ bs=512 seek=97
	dd if=$(BOOTLOADER_MESSAGE) of=$@ bs=512 seek=1432
	dd if=$(PRODUCT_OUT)/obj/KERNEL_OBJ/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b-plus.dtb of=$@ bs=512 seek=1504
	dd if=$(PRODUCT_OUT)/obj/KERNEL_OBJ/arch/arm64/boot/Image of=$@ bs=512 seek=1632
	dd if=$(INSTALLED_RECOVERYIMAGE_TARGET) of=$@ bs=512 seek=34400
	dd if=device/capsulecorp/$(TARGET_PRODUCT)/files/hardkernel-720.bmp.gz of=$@ \
		bs=512 seek=61024
	dd if=$(SELFINSTALL_CACHE_IMAGE) of=$@ bs=512 seek=65536
	sync
	@echo "Done."

.PHONY: selfinstall
selfinstall: $(PRODUCT_OUT)/selfinstall-$(TARGET_DEVICE).bin
