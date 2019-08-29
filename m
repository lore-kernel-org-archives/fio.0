Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:28106 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfH2HVl (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Aug 2019 03:21:41 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 6/6] zbd: Add support for zoneskip option
Date: Thu, 29 Aug 2019 16:21:35 +0900
Message-Id: <20190829072135.2872-7-damien.lemoal@wdc.com>
In-Reply-To: <20190829072135.2872-1-damien.lemoal@wdc.com>
References: <20190829072135.2872-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

To speed up device tests (performance and or quality validation) of very
large capacity block devices such as SMR disks, it is useful to allow
skipping some block ranges for sequential workloads. While the
zonemode=stridded implements such feature, it does not allow controlling
read operations in partially written zones of zoned block devices (i.e.
prevent reads after a zone write pointer) and can result in IO errors
if executed on a zoned block devices with zones already written.

To solve this problem, add support for the zoneskip option with
zonemode=zbd, allowing a sequential workload to skip zoneskip bytes once
a zone has been fully written or its data has been read. The zoneskip
option is ignored for random workloads.

For read workloads, zone skipping takes into account the read_beyond_wp
option to switch zone either when all valid data in the zone is read
(read_beyond_wp=0) or the entire zone has been read (read_beyond_wp=1).

Add test47 to t/zbd/test-zbd-support to test that zoneskip invalid
values are handled correctly.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fio.1                  |  9 ++++--
 io_u.c                 |  2 ++
 t/zbd/test-zbd-support | 12 ++++++++
 zbd.c                  | 69 ++++++++++++++++++++++++++++++++++++++++++
 zbd.h                  |  1 +
 5 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/fio.1 b/fio.1
index c00579bc..3e872bce 100644
--- a/fio.1
+++ b/fio.1
@@ -773,8 +773,13 @@ device zone size. For a regular block device or file, the specified
 .TP
 .BI zoneskip \fR=\fPint
 For \fBzonemode\fR=strided, the number of bytes to skip after \fBzonesize\fR
-bytes of data have been transferred. This parameter must be zero for
-\fBzonemode\fR=zbd.
+bytes of data have been transferred.
+
+For \fBzonemode\fR=zbd, the \fBzonesize\fR aligned number of bytes to skip
+once a zone is fully written (write workloads) or all written data in the
+zone have been read (read workloads). This parameter is valid only for
+sequential workloads and ignored for random workloads. For read workloads,
+see also \fBread_beyond_wp\fR.
 
 .TP
 .BI read_beyond_wp \fR=\fPbool
diff --git a/io_u.c b/io_u.c
index 80df2854..94899552 100644
--- a/io_u.c
+++ b/io_u.c
@@ -901,6 +901,8 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 
 	if (td->o.zone_mode == ZONE_MODE_STRIDED)
 		setup_strided_zone_mode(td, io_u);
+	else if (td->o.zone_mode == ZONE_MODE_ZBD)
+		setup_zbd_zone_mode(td, io_u);
 
 	/*
 	 * No log, let the seq/rand engine retrieve the next buflen and
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 6eecce9f..90f9f87b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -743,6 +743,18 @@ test46() {
     check_written $((size * 8)) || return $?
 }
 
+# Check whether fio handles --zonemode=zbd --zoneskip=1 correctly.
+test47() {
+    local bs
+
+    [ -z "$is_zbd" ] && return 0
+    bs=$((logical_block_size))
+    run_one_fio_job --ioengine=psync --rw=write --bs=$bs \
+		    --zonemode=zbd --zoneskip=1		 \
+		    >> "${logfile}.${test_number}" 2>&1 && return 1
+    grep -q 'zoneskip 1 is not a multiple of the device zone size' "${logfile}.${test_number}"
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
diff --git a/zbd.c b/zbd.c
index 876246ed..fb81b532 100644
--- a/zbd.c
+++ b/zbd.c
@@ -119,6 +119,16 @@ static bool zbd_verify_sizes(void)
 				continue;
 			if (!zbd_is_seq_job(f))
 				continue;
+
+			if (td->o.zone_skip &&
+			    (td->o.zone_skip < td->o.zone_size ||
+			     td->o.zone_skip % td->o.zone_size)) {
+				log_err("%s: zoneskip %llu is not a multiple of the device zone size %llu.\n",
+					f->file_name, (unsigned long long) td->o.zone_skip,
+					(unsigned long long) td->o.zone_size);
+				return false;
+			}
+
 			zone_idx = zbd_zone_idx(f, f->file_offset);
 			z = &f->zbd_info->zone_info[zone_idx];
 			if (f->file_offset != z->start) {
@@ -1219,6 +1229,65 @@ bool zbd_unaligned_write(int error_code)
 	return false;
 }
 
+/**
+ * setup_zbd_zone_mode - handle zoneskip as necessary for ZBD drives
+ * @td: FIO thread data.
+ * @io_u: FIO I/O unit.
+ *
+ * For sequential workloads, change the file offset to skip zoneskip bytes when
+ * no more IO can be performed in the current zone.
+ * - For read workloads, zoneskip is applied when the io has reached the end of
+ *   the zone or the zone write position (when td->o.read_beyond_wp is false).
+ * - For write workloads, zoneskip is applied when the zone is full.
+ * This applies only to read and write operations.
+ */
+void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	enum fio_ddir ddir = io_u->ddir;
+	struct fio_zone_info *z;
+	uint32_t zone_idx;
+
+	assert(td->o.zone_mode == ZONE_MODE_ZBD);
+	assert(td->o.zone_size);
+
+	/*
+	 * zone_skip is valid only for sequential workloads.
+	 */
+	if (td_random(td) || !td->o.zone_skip)
+		return;
+
+	/*
+	 * It is time to switch to a new zone if:
+	 * - zone_bytes == zone_size bytes have already been accessed
+	 * - The last position reached the end of the current zone.
+	 * - For reads with td->o.read_beyond_wp == false, the last position
+	 *   reached the zone write pointer.
+	 */
+	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
+	z = &f->zbd_info->zone_info[zone_idx];
+
+	if (td->zone_bytes >= td->o.zone_size ||
+	    f->last_pos[ddir] >= (z+1)->start ||
+	    (ddir == DDIR_READ &&
+	     (!td->o.read_beyond_wp) && f->last_pos[ddir] >= z->wp)) {
+		/*
+		 * Skip zones.
+		 */
+		td->zone_bytes = 0;
+		f->file_offset += td->o.zone_size + td->o.zone_skip;
+
+		/*
+		 * Wrap from the beginning, if we exceed the file size
+		 */
+		if (f->file_offset >= f->real_file_size)
+			f->file_offset = get_start_offset(td, f);
+
+		f->last_pos[ddir] = f->file_offset;
+		td->io_skip_bytes += td->o.zone_skip;
+	}
+}
+
 /**
  * zbd_adjust_block - adjust the offset and length as necessary for ZBD drives
  * @td: FIO thread data.
diff --git a/zbd.h b/zbd.h
index 521283b2..a66f40af 100644
--- a/zbd.h
+++ b/zbd.h
@@ -94,6 +94,7 @@ void zbd_free_zone_info(struct fio_file *f);
 int zbd_init(struct thread_data *td);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
+void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 
-- 
2.21.0


