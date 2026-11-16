// SPDX-License-Identifier: GPL-2.0-only
/*
 * Copyright (c) 2020 XiaoMi, Inc. All rights reserved.
 * Copyright (C) 2026 The LineageOS Project
 */

#include <linux/device.h>
#include <linux/err.h>
#include <linux/kdev_t.h>
#include <linux/moduleparam.h>
#include <linux/string.h>
#include <linux/sysfs.h>

#include "dsi_defs.h"
#include "dsi_display.h"

#define DSI_DISPLAY_CELL_ID_LEN 32

static char dsi_display_cell_id[DSI_DISPLAY_CELL_ID_LEN];
module_param_string(cell_id, dsi_display_cell_id, sizeof(dsi_display_cell_id),
		0600);
MODULE_PARM_DESC(cell_id,
	"msm_drm.cell_id=<cell id> where <cell id> is the panel cell id passed by the bootloader");

static ssize_t cell_id_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	if (!dsi_display_cell_id[0])
		return -ENODATA;

	return sysfs_emit(buf, "%s\n", dsi_display_cell_id);
}
static DEVICE_ATTR_RO(cell_id);

static struct dsi_display *dsi_display_cell_id_primary(void)
{
	void *displays[MAX_DSI_ACTIVE_DISPLAY];
	struct dsi_display *display;
	int i, count;

	count = dsi_display_get_active_displays(displays, ARRAY_SIZE(displays));
	for (i = 0; i < count; i++) {
		display = displays[i];
		if (display->display_type &&
				!strcmp(display->display_type, "primary"))
			return display;
	}

	return NULL;
}

static ssize_t panel_info_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct dsi_display *display = dsi_display_cell_id_primary();
	const char *pname;
	size_t len;

	if (!display)
		return sysfs_emit(buf, "panel_name=null\n");

	/* Panel node name from the boot selection, without the config */
	if (display->boot_disp && display->boot_disp->boot_param) {
		pname = strrchr(display->boot_disp->boot_param, ',');
		if (pname) {
			pname++;
			len = strcspn(pname, ":");
			if (len)
				return sysfs_emit(buf, "panel_name=%.*s\n",
						(int)len, pname);
		}
	}

	if (!display->name)
		return sysfs_emit(buf, "panel_name=null\n");

	pname = strrchr(display->name, ',');
	return sysfs_emit(buf, "panel_name=%s\n",
			pname ? pname + 1 : display->name);
}
static DEVICE_ATTR_RO(panel_info);

static struct attribute *dsi_display_cell_id_attrs[] = {
	&dev_attr_cell_id.attr,
	&dev_attr_panel_info.attr,
	NULL,
};
ATTRIBUTE_GROUPS(dsi_display_cell_id);

static const struct class dsi_display_mi_class = {
	.name = "mi_display",
};

static struct device *dsi_display_cell_id_dev;

void dsi_display_cell_id_register(void)
{
	struct device *dev;
	int rc;

	rc = class_register(&dsi_display_mi_class);
	if (rc) {
		DSI_ERR("failed to register mi_display class, rc=%d\n", rc);
		return;
	}

	dev = device_create_with_groups(&dsi_display_mi_class, NULL,
			MKDEV(0, 0), NULL, dsi_display_cell_id_groups,
			"disp-DSI-0");
	if (IS_ERR(dev)) {
		DSI_ERR("failed to create disp-DSI-0, rc=%ld\n", PTR_ERR(dev));
		class_unregister(&dsi_display_mi_class);
		return;
	}

	dsi_display_cell_id_dev = dev;
}

void dsi_display_cell_id_unregister(void)
{
	if (!dsi_display_cell_id_dev)
		return;

	device_unregister(dsi_display_cell_id_dev);
	dsi_display_cell_id_dev = NULL;
	class_unregister(&dsi_display_mi_class);
}
