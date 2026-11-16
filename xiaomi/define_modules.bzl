# SPDX-License-Identifier: GPL-2.0-or-later

load("//build/kernel/kleaf:kernel.bzl", "ddk_module")

def define_modules(target, variant):
    tv = "{}_{}".format(target, variant)
    kernel_build = "//vendor/xiaomi/sm7435-kernel:{}".format(tv)
    deps = ["//vendor/xiaomi/sm7435-kernel:all_headers"]

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

    focal = touch + "/focaltech_3683g"

    ddk_module(
        name = "{}_focaltech_3683g".format(tv),
        srcs = [focal + "/" + f for f in [
            "focaltech_core.c",
            "focaltech_debug.c",
            "focaltech_esdcheck.c",
            "focaltech_ex_fun.c",
            "focaltech_ex_mode.c",
            "focaltech_flash.c",
            "focaltech_gesture.c",
            "focaltech_point_report_check.c",
            "focaltech_spi_v2.c",
            "focaltech_flash/focaltech_upgrade_ft3683g.c",
            "focaltech_flash/focaltech_upgrade_ft3681.c",
        ]],
        hdrs = [focal + "/" + f for f in [
            "focaltech_common.h",
            "focaltech_config.h",
            "focaltech_core.h",
            "focaltech_flash.h",
        ]] + [
            touch + "/xiaomi/xiaomi_touch.h",
            "include/uapi/linux/xiaomi_touch.h",
        ],
        includes = ["include/uapi", focal, focal + "/focaltech_flash"],
        out = "focaltech_3683g.ko",
        kernel_build = kernel_build,
        deps = deps + [":{}_xiaomi_touch".format(tv)],
    )
