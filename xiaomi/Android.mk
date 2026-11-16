LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := xiaomi_touch.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(KERNEL_MODULES_OUT)
LOCAL_SRC_FILES := $(wildcard $(LOCAL_PATH)/**/*) $(wildcard $(LOCAL_PATH)/*)

DLKM_DIR := $(TOP)/device/qcom/common/dlkm
include $(DLKM_DIR)/Build_external_kernelmodule.mk

include $(CLEAR_VARS)
LOCAL_MODULE := goodix_core.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(KERNEL_MODULES_OUT)
LOCAL_SRC_FILES := $(wildcard $(LOCAL_PATH)/**/*) $(wildcard $(LOCAL_PATH)/*)

include $(DLKM_DIR)/Build_external_kernelmodule.mk

include $(CLEAR_VARS)
LOCAL_MODULE := focaltech_3683g.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(KERNEL_MODULES_OUT)
LOCAL_SRC_FILES := $(wildcard $(LOCAL_PATH)/**/*) $(wildcard $(LOCAL_PATH)/*)

include $(DLKM_DIR)/Build_external_kernelmodule.mk
