Return-Path: <prvs=947609abe=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/8] zbd: Fix partition block device handling
Date: Wed, 20 Feb 2019 16:17:18 +0900
Message-Id: <20190220071725.8487-2-damien.lemoal@wdc.com>
In-Reply-To: <20190220071725.8487-1-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

For fio to correctly handle the zonemode=zbd mode with partitions of
zoned block devices, the partition block device file must be identified
as a zoned disk. However, partition block device files do not have
a zoned sysfs file. This patch allows a correct identification of the
device file zone model by accessing the sysfs "zoned" file of the
holder disk for partition devices.

Change get_zbd_model() function to resolve the symbolic link to the
sysfs path to obtain the canonical sysfs path. The canonical sysfs
path of a partition device includes both of the holder device name and
the partition device name. If the given device is a partition device,
cut the partition device name in the canonical sysfs path to access
the "zoned" file in the holder device sysfs path.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 8acda1f6..9b603b97 100644
--- a/zbd.c
+++ b/zbd.c
@@ -228,12 +228,45 @@ static enum blk_zoned_model get_zbd_model(const char *file_name)
 	char *zoned_attr_path = NULL;
 	char *model_str = NULL;
 	struct stat statbuf;
+	char *sys_devno_path = NULL;
+	char *part_attr_path = NULL;
+	char *part_str = NULL;
+	char sys_path[PATH_MAX];
+	ssize_t sz;
+	char *delim = NULL;
 
 	if (stat(file_name, &statbuf) < 0)
 		goto out;
-	if (asprintf(&zoned_attr_path, "/sys/dev/block/%d:%d/queue/zoned",
+
+	if (asprintf(&sys_devno_path, "/sys/dev/block/%d:%d",
 		     major(statbuf.st_rdev), minor(statbuf.st_rdev)) < 0)
 		goto out;
+
+	sz = readlink(sys_devno_path, sys_path, sizeof(sys_path) - 1);
+	if (sz < 0)
+		goto out;
+	sys_path[sz] = '\0';
+
+	/*
+	 * If the device is a partition device, cut the device name in the
+	 * canonical sysfs path to obtain the sysfs path of the holder device.
+	 *   e.g.:  /sys/devices/.../sda/sda1 -> /sys/devices/.../sda
+	 */
+	if (asprintf(&part_attr_path, "/sys/dev/block/%s/partition",
+		     sys_path) < 0)
+		goto out;
+	part_str = read_file(part_attr_path);
+	if (part_str && *part_str == '1') {
+		delim = strrchr(sys_path, '/');
+		if (!delim)
+			goto out;
+		*delim = '\0';
+	}
+
+	if (asprintf(&zoned_attr_path,
+		     "/sys/dev/block/%s/queue/zoned", sys_path) < 0)
+		goto out;
+
 	model_str = read_file(zoned_attr_path);
 	if (!model_str)
 		goto out;
@@ -246,6 +279,9 @@ static enum blk_zoned_model get_zbd_model(const char *file_name)
 out:
 	free(model_str);
 	free(zoned_attr_path);
+	free(part_str);
+	free(part_attr_path);
+	free(sys_devno_path);
 	return model;
 }
 
-- 
2.20.1


