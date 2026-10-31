# SPDX-License-Identifier: GPL-2.0-or-later

load("//build/kernel/kleaf:kernel.bzl", "ddk_module")

def define_modules(target, variant):
    tv = "{}_{}".format(target, variant)
    kernel_build = "//vendor/xiaomi/sm8450-kernel:{}".format(tv)
    deps = ["//vendor/xiaomi/sm8450-kernel:all_headers"]

    touch = "drivers/input/touchscreen"

    ddk_module(
        name = "{}_xiaomi_touch".format(tv),
        srcs = [touch + "/xiaomi/xiaomi_touch.c"],
        hdrs = [
            touch + "/xiaomi/xiaomi_touch.h",
            "include/uapi/linux/xiaomi_touch.h",
        ],
        includes = ["include/uapi"],
        out = "xiaomi_touch.ko",
        kernel_build = kernel_build,
        deps = deps,
    )

    goodix = touch + "/goodix_berlin_driver"

    ddk_module(
        name = "{}_goodix_core".format(tv),
        srcs = [goodix + "/" + f for f in [
            "goodix_brl_fwupdate.c",
            "goodix_brl_hw.c",
            "goodix_brl_i2c.c",
            "goodix_brl_spi.c",
            "goodix_cfg_bin.c",
            "goodix_ts_core.c",
            "goodix_ts_gesture.c",
            "goodix_ts_inspect.c",
            "goodix_ts_tools.c",
            "goodix_ts_utils.c",
        ]],
        hdrs = [
            goodix + "/goodix_ts_core.h",
            touch + "/xiaomi/xiaomi_touch.h",
            "include/uapi/linux/xiaomi_touch.h",
        ],
        includes = ["include/uapi"],
        out = "goodix_core.ko",
        kernel_build = kernel_build,
        deps = deps + [":{}_xiaomi_touch".format(tv)],
    )
