Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50150 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfH3MAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Aug 2019 08:00:10 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3fZW-0001xK-HB
        for fio@vger.kernel.org; Fri, 30 Aug 2019 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190830120002.294DD2C028B@kernel.dk>
Date: Fri, 30 Aug 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0b288ba164c10009ea9f4a2c737bd29863ebc60c:

  options: allow offset_increment to understand percentages (2019-08-28 13:45:37 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 971d6a22bad5942234496683d89a2f8deed57172:

  zbd: Improve job zonesize initialization checks (2019-08-29 20:51:17 -0600)

----------------------------------------------------------------
Damien Le Moal (8):
      zbd: Cleanup zbd_init()
      zbd: Fix initialization error message
      zbd: Fix error message
      man page: Fix read_beyond_wp description
      man: Improve zonemode=zbd information
      zbd: Add support for zoneskip option
      zbd: Fix job zone size initialization
      zbd: Improve job zonesize initialization checks

Jens Axboe (1):
      zbd: provide empty setup_zbd_zone_mode()

 fio.1                  |  29 ++++++++----
 io_u.c                 |   2 +
 t/zbd/test-zbd-support |  15 ++++++-
 zbd.c                  | 117 ++++++++++++++++++++++++++++++++++++++++++-------
 zbd.h                  |   7 +++
 5 files changed, 143 insertions(+), 27 deletions(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index a06a12da..3e872bce 100644
--- a/fio.1
+++ b/fio.1
@@ -753,7 +753,10 @@ restricted to a single zone.
 .RE
 .TP
 .BI zonerange \fR=\fPint
-Size of a single zone. See also \fBzonesize\fR and \fBzoneskip\fR.
+For \fBzonemode\fR=strided, this is the size of a single zone. See also
+\fBzonesize\fR and \fBzoneskip\fR.
+
+For \fBzonemode\fR=zbd, this parameter is ignored.
 .TP
 .BI zonesize \fR=\fPint
 For \fBzonemode\fR=strided, this is the number of bytes to transfer before
@@ -762,13 +765,21 @@ skipping \fBzoneskip\fR bytes. If this parameter is smaller than
 will be accessed.  If this parameter is larger than \fBzonerange\fR then each
 zone will be accessed multiple times before skipping to the next zone.
 
-For \fBzonemode\fR=zbd, this is the size of a single zone. The \fBzonerange\fR
-parameter is ignored in this mode.
+For \fBzonemode\fR=zbd, this is the size of a single zone. The
+\fBzonerange\fR parameter is ignored in this mode. For a job accessing a
+zoned block device, the specified \fBzonesize\fR must be 0 or equal to the
+device zone size. For a regular block device or file, the specified
+\fBzonesize\fR must be at least 512B.
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
@@ -778,10 +789,10 @@ Zoned block devices are block devices that consist of multiple zones. Each
 zone has a type, e.g. conventional or sequential. A conventional zone can be
 written at any offset that is a multiple of the block size. Sequential zones
 must be written sequentially. The position at which a write must occur is
-called the write pointer. A zoned block device can be either drive
-managed, host managed or host aware. For host managed devices the host must
-ensure that writes happen sequentially. Fio recognizes host managed devices
-and serializes writes to sequential zones for these devices.
+called the write pointer. A zoned block device can be either host managed or
+host aware. For host managed devices the host must ensure that writes happen
+sequentially. Fio recognizes host managed devices and serializes writes to
+sequential zones for these devices.
 
 If a read occurs in a sequential zone beyond the write pointer then the zoned
 block device will complete the read without reading any data from the storage
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
index ed54a0aa..90f9f87b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -707,8 +707,9 @@ test42() {
 	grep -q 'Specifying the zone size is mandatory for regular block devices with --zonemode=zbd'
 }
 
-# Check whether fio handles --zonesize=1 correctly.
+# Check whether fio handles --zonesize=1 correctly for regular block devices.
 test43() {
+    [ -n "$is_zbd" ] && return 0
     read_one_block --zonemode=zbd --zonesize=1 |
 	grep -q 'zone size must be at least 512 bytes for --zonemode=zbd'
 }
@@ -742,6 +743,18 @@ test46() {
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
index 2383c57d..99310c49 100644
--- a/zbd.c
+++ b/zbd.c
@@ -119,6 +119,30 @@ static bool zbd_verify_sizes(void)
 				continue;
 			if (!zbd_is_seq_job(f))
 				continue;
+
+			if (!td->o.zone_size) {
+				td->o.zone_size = f->zbd_info->zone_size;
+				if (!td->o.zone_size) {
+					log_err("%s: invalid 0 zone size\n",
+						f->file_name);
+					return false;
+				}
+			} else if (td->o.zone_size != f->zbd_info->zone_size) {
+				log_err("%s: job parameter zonesize %llu does not match disk zone size %llu.\n",
+					f->file_name, (unsigned long long) td->o.zone_size,
+					(unsigned long long) f->zbd_info->zone_size);
+				return false;
+			}
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
@@ -312,13 +336,23 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 {
 	uint32_t nr_zones;
 	struct fio_zone_info *p;
-	uint64_t zone_size;
+	uint64_t zone_size = td->o.zone_size;
 	struct zoned_block_device_info *zbd_info = NULL;
 	pthread_mutexattr_t attr;
 	int i;
 
-	zone_size = td->o.zone_size;
-	assert(zone_size);
+	if (zone_size == 0) {
+		log_err("%s: Specifying the zone size is mandatory for regular block devices with --zonemode=zbd\n\n",
+			f->file_name);
+		return 1;
+	}
+
+	if (zone_size < 512) {
+		log_err("%s: zone size must be at least 512 bytes for --zonemode=zbd\n\n",
+			f->file_name);
+		return 1;
+	}
+
 	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -401,8 +435,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	if (td->o.zone_size == 0) {
 		td->o.zone_size = zone_size;
 	} else if (td->o.zone_size != zone_size) {
-		log_info("fio: %s job parameter zonesize %llu does not match disk zone size %llu.\n",
-			 f->file_name, (unsigned long long) td->o.zone_size,
+		log_err("fio: %s job parameter zonesize %llu does not match disk zone size %llu.\n",
+			f->file_name, (unsigned long long) td->o.zone_size,
 			(unsigned long long) zone_size);
 		ret = -EINVAL;
 		goto close;
@@ -549,7 +583,7 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 
 	ret = zbd_create_zone_info(td, file);
 	if (ret < 0)
-		td_verror(td, -ret, "BLKREPORTZONE failed");
+		td_verror(td, -ret, "zbd_create_zone_info() failed");
 	return ret;
 }
 
@@ -561,18 +595,8 @@ int zbd_init(struct thread_data *td)
 	for_each_file(td, f, i) {
 		if (f->filetype != FIO_TYPE_BLOCK)
 			continue;
-		if (td->o.zone_size && td->o.zone_size < 512) {
-			log_err("%s: zone size must be at least 512 bytes for --zonemode=zbd\n\n",
-				f->file_name);
+		if (zbd_init_zone_info(td, f))
 			return 1;
-		}
-		if (td->o.zone_size == 0 &&
-		    get_zbd_model(f->file_name) == ZBD_DM_NONE) {
-			log_err("%s: Specifying the zone size is mandatory for regular block devices with --zonemode=zbd\n\n",
-				f->file_name);
-			return 1;
-		}
-		zbd_init_zone_info(td, f);
 	}
 
 	if (!zbd_using_direct_io()) {
@@ -1219,6 +1243,65 @@ bool zbd_unaligned_write(int error_code)
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
index 521283b2..e0a7e447 100644
--- a/zbd.h
+++ b/zbd.h
@@ -94,6 +94,7 @@ void zbd_free_zone_info(struct fio_file *f);
 int zbd_init(struct thread_data *td);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
+void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 
@@ -147,6 +148,12 @@ static inline char *zbd_write_status(const struct thread_stat *ts)
 static inline void zbd_queue_io_u(struct io_u *io_u,
 				  enum fio_q_status status) {}
 static inline void zbd_put_io_u(struct io_u *io_u) {}
+
+static inline void setup_zbd_zone_mode(struct thread_data *td,
+					struct io_u *io_u)
+{
+}
+
 #endif
 
 #endif /* FIO_ZBD_H */

