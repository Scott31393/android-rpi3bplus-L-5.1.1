#if use probuilt kernel or build kernel from source code
-include device/capsulecorp/common/gpu64.mk

INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel

KERNEL_ARCH := arm64
KERNEL_DEVICETREE := bcm2837-rpi-3-b-plus
KERNEL_DEFCONFIG := bcm2837_defconfig

KERNEL_ROOTDIR := $(ANDROID_BUILD_TOP)/vendor/capsulecorp-opensource/linux-android-4.19.72
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
KERNEL_IMAGE := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image
KERNEL_MODULES_INSTALL := system
KERNEL_MODULES_OUT := $(TARGET_OUT)/lib/modules
BOARD_MKBOOTIMG_ARGS := --second $(PRODUCT_OUT)/obj/KERNEL_OBJ/arch/arm64/boot/dts/broadcom/$(KERNEL_DEVICETREE).dtb


define cp-modules
	mkdir -p $(PRODUCT_OUT)/root/boot
	cp $(MALI_OUT)/mali.ko $(PRODUCT_OUT)/root/boot
	cp $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(KERNEL_DEVICETREE).dtb $(PRODUCT_OUT)/
endef

define mv-modules
mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.dep`;\
	if [ "$$mdpath" != "" ]; then \
	mpath=`dirname $$mdpath`;\
	ko=`find $$mpath/kernel $$mpath/hardware -type f -name *.ko`;\
	for i in $$ko; do echo $$i; mv $$i $(KERNEL_MODULES_OUT)/; done;\
	fi;\
	ko=`find hardware/backports -type f -name *.ko`;\
	mkdir -p $(KERNEL_MODULES_OUT)/backports; \
	for i in $$ko; do echo $$i; mv $$i $(KERNEL_MODULES_OUT)/backports/; done;
endef

define clean-module-folder
mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.dep`;\
       if [ "$$mdpath" != "" ];then\
       mpath=`dirname $$mdpath`; rm -rf $$mpath;\
       fi
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)
	cp -frv $(KERNEL_ROOTDIR)/* $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_DEFCONFIG)


$(KERNEL_IMAGE): $(KERNEL_OUT) $(KERNEL_CONFIG)
	$(MAKE) -C $(KERNEL_OUT) ARCH=$(KERNEL_ARCH)

.PHONY: kernelconfig
kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
		$(MAKE) -C $(KERNEL_OUT) ARCH=$(KERNEL_ARCH) menuconfig

.PHONY: savekernelconfig
savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
		$(MAKE) -C $(KERNEL_OUT) ARCH=$(KERNEL_ARCH) savedefconfig
	@echo
	@echo Saved to $(KERNEL_OUT)/defconfig
	@echo
	@echo handly merge to "$(KERNEL_ROOTDIR)/arch/$(KERNEL_ARCH)/configs/$(KERNEL_DEFCONFIG)" if need



$(INSTALLED_KERNEL_TARGET): $(KERNEL_IMAGE) $(I2CKERNEL_IMAGE) | $(ACP)
	@echo "Kernel installed"
	$(transform-prebuilt-to-target)
