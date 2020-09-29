Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 2/3] Add support for open_zones in libzbc I/O engine.
Date: Tue, 29 Sep 2020 18:29:49 +0530
Message-Id: <20200929125950.20343-3-krish.reddy@samsung.com>
In-Reply-To: <20200929125950.20343-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20200929125950.20343-1-krish.reddy@samsung.com>
	<CGME20200929130325epcas5p285128c2026c1bb8743967f15b0657ec7@epcas5p2.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 engines/libzbc.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 4b900233..4b742d24 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -334,6 +334,47 @@ err:
 	return -ret;
 }
 
+static int libzbc_open_zones(struct thread_data *td, const struct fio_file *f,
+			     uint64_t offset, uint64_t length)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	uint64_t sector = offset >> 9;
+	uint64_t end_sector = (offset + length) >> 9;
+	unsigned int nr_zones;
+	struct zbc_errno err;
+	int i, ret;
+
+	assert(ld);
+	assert(ld->zdev);
+
+	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
+	if (!sector && end_sector >= ld->nr_sectors) {
+		/* Open all zones */
+		ret = zbc_open_zone(ld->zdev, 0, ZBC_OP_ALL_ZONES);
+		if (ret)
+			goto err;
+
+		return 0;
+	}
+
+	for (i = 0; i < nr_zones; i++, sector += td->o.zone_size >> 9) {
+		ret = zbc_open_zone(ld->zdev, sector, 0);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	zbc_errno(ld->zdev, &err);
+	td_verror(td, errno, "zbc_open_zone failed");
+	if (err.sk)
+		log_err("%s: open failed %s:%s\n",
+			f->file_name,
+			zbc_sk_str(err.sk), zbc_asc_ascq_str(err.asc_ascq));
+	return -ret;
+}
+
 ssize_t libzbc_rw(struct thread_data *td, struct io_u *io_u)
 {
 	struct libzbc_data *ld = td->io_ops_data;
@@ -413,6 +454,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.get_zoned_model	= libzbc_get_zoned_model,
 	.report_zones		= libzbc_report_zones,
 	.reset_wp		= libzbc_reset_wp,
+	.open_zones		= libzbc_open_zones,
 	.queue			= libzbc_queue,
 	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
 };
-- 
2.17.1


