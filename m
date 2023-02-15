Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D789C636CC
	for <fio@archiver.kernel.org>; Wed, 15 Feb 2023 13:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjBONAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Feb 2023 08:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjBONAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Feb 2023 08:00:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B866180
        for <fio@vger.kernel.org>; Wed, 15 Feb 2023 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=DmVsEArgPRgPDX72zmtjzDiiqKT6CWa8GSvYgLTPm/k=; b=XVMYWg7F/ua51ye4tmQjPbc9Ye
        N2xQqzGeQvGIYpExJG9GCYM+FH+RHt3Z/fIQtSh3xc5g83jw+CkgrkMKobZ3N6MrYLhbQBd836Vxj
        fUx3NiqZtT2kmSEbaGA/gcqaCRZGhHdWvomM496IHw3HI7eVT1tHdFV/1FY+24+m4t6bpK4NcJ+Vc
        nTCvpoM/RUJprqXVeQDTlIHLhwXaiYV7TgaaDaRN+rnOs7hNWujfZAQi8MG91M5Ia4AnawAtTbJDh
        EDeN0esmH5BqzBiiBOUS3OgmWQyMeZs5WQEePl5wQSjTmdluGmdeU3FwlbqGb52OZ7W4g6maAehv1
        pxy7vRvg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSHOG-007TC9-Lf
        for fio@vger.kernel.org; Wed, 15 Feb 2023 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0C79F1BC0189; Wed, 15 Feb 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230215130002.0C79F1BC0189@kernel.dk>
Date:   Wed, 15 Feb 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b65023f3c8849e122b2a223838ae9fdaed994e84:

  Merge branch 'msg-Modify_QD_Sync_Warning_For_offload' of https://github.com/horshack-dpreview/fio (2023-02-10 11:49:46 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1bd16cf9c113fcf9d49cae07da50e8a5c7a784ee:

  examples: update nbd.fio fiograph diagram (2023-02-14 10:47:50 -0500)

----------------------------------------------------------------
Richard W.M. Jones (1):
      examples: Small updates to nbd.fio

Shin'ichiro Kawasaki (8):
      zbd: refer file->last_start[] instead of sectors with data accounting
      zbd: remove CHECK_SWD feature
      zbd: rename the accounting 'sectors with data' to 'valid data bytes'
      doc: fix unit of zone_reset_threshold and relation to other option
      zbd: account valid data bytes only for zone_reset_threshold option
      zbd: check write ranges for zone_reset_threshold option
      zbd: initialize valid data bytes accounting at file setup
      t/zbd: add test cases for zone_reset_threshold option

Vincent Fu (1):
      examples: update nbd.fio fiograph diagram

 HOWTO.rst              |   9 ++-
 examples/nbd.fio       |  28 ++++++----
 examples/nbd.png       | Bin 88667 -> 43251 bytes
 fio.1                  |   8 ++-
 t/zbd/test-zbd-support |  60 +++++++++++++++++++-
 zbd.c                  | 149 +++++++++++++++++++++++--------------------------
 zbd.h                  |  11 ++--
 7 files changed, 161 insertions(+), 104 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 17caaf5d..158c5d89 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1085,9 +1085,12 @@ Target file/device
 
 .. option:: zone_reset_threshold=float
 
-	A number between zero and one that indicates the ratio of logical
-	blocks with data to the total number of logical blocks in the test
-	above which zones should be reset periodically.
+	A number between zero and one that indicates the ratio of written bytes
+	in the zones with write pointers in the IO range to the size of the IO
+	range. When current ratio is above this ratio, zones are reset
+	periodically as :option:`zone_reset_frequency` specifies. If there are
+	multiple jobs when using this option, the IO range for all write jobs
+	has to be the same.
 
 .. option:: zone_reset_frequency=float
 
diff --git a/examples/nbd.fio b/examples/nbd.fio
index 6900ebe7..31629fad 100644
--- a/examples/nbd.fio
+++ b/examples/nbd.fio
@@ -1,21 +1,25 @@
-# To use fio to test nbdkit:
+# To use fio to test nbdkit + RAM disk:
 #
-# nbdkit -U - memory size=256M --run 'export unixsocket; fio examples/nbd.fio'
+#   nbdkit -U - memory size=256M --run 'export uri; fio examples/nbd.fio'
 #
-# To use fio to test qemu-nbd:
+# To use fio to test nbdkit + local file:
 #
-# rm -f /tmp/disk.img /tmp/socket
-# truncate -s 256M /tmp/disk.img
-# export unixsocket=/tmp/socket
-# qemu-nbd -t -k $unixsocket -f raw /tmp/disk.img &
-# fio examples/nbd.fio
-# killall qemu-nbd
+#   rm -f /var/tmp/disk.img
+#   truncate -s 256M /var/tmp/disk.img
+#   nbdkit -U - file /var/tmp/disk.img --run 'export uri; fio examples/nbd.fio'
+#
+# To use fio to test qemu-nbd + local file:
+#
+#   rm -f /var/tmp/disk.img /var/tmp/socket
+#   truncate -s 256M /var/tmp/disk.img
+#   export uri='nbd+unix:///?socket=/var/tmp/socket'
+#   qemu-nbd -t -k /var/tmp/socket -f raw /var/tmp/disk.img &
+#   fio examples/nbd.fio
+#   killall qemu-nbd
 
 [global]
 ioengine=nbd
-uri=nbd+unix:///?socket=${unixsocket}
-# Starting from nbdkit 1.14 the following will work:
-#uri=${uri}
+uri=${uri}
 rw=randrw
 time_based
 runtime=60
diff --git a/examples/nbd.png b/examples/nbd.png
index e3bcf610..3a933c9b 100644
Binary files a/examples/nbd.png and b/examples/nbd.png differ
diff --git a/fio.1 b/fio.1
index 527b3d46..00a09353 100644
--- a/fio.1
+++ b/fio.1
@@ -854,9 +854,11 @@ of the zoned block device in use, thus allowing the option \fBmax_open_zones\fR
 value to be larger than the device reported limit. Default: false.
 .TP
 .BI zone_reset_threshold \fR=\fPfloat
-A number between zero and one that indicates the ratio of logical blocks with
-data to the total number of logical blocks in the test above which zones
-should be reset periodically.
+A number between zero and one that indicates the ratio of written bytes in the
+zones with write pointers in the IO range to the size of the IO range. When
+current ratio is above this ratio, zones are reset periodically as
+\fBzone_reset_frequency\fR specifies. If there are multiple jobs when using this
+option, the IO range for all write jobs has to be the same.
 .TP
 .BI zone_reset_frequency \fR=\fPfloat
 A number between zero and one that indicates how often a zone reset should be
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4091d9ac..893aff3c 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1110,8 +1110,8 @@ test51() {
 	run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
-# Verify that zone_reset_threshold only takes logical blocks from seq
-# zones into account, and logical blocks of conv zones are not counted.
+# Verify that zone_reset_threshold only accounts written bytes in seq
+# zones, and written data bytes of conv zones are not counted.
 test52() {
 	local off io_size
 
@@ -1305,6 +1305,62 @@ test60() {
 	grep -q 'not support experimental verify' "${logfile}.${test_number}"
 }
 
+# Test fio errors out zone_reset_threshold option for multiple jobs with
+# different write ranges.
+test61() {
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --size="$zone_size" \
+		       --numjobs=2 --offset_increment="$zone_size" \
+		       --zone_reset_threshold=0.1 --zone_reset_frequency=1 \
+		       --exitall_on_error=1 \
+		       >> "${logfile}.${test_number}" 2>&1 && return 1
+	grep -q 'different write ranges' "${logfile}.${test_number}"
+}
+
+# Test zone_reset_threshold option works for multiple jobs with same write
+# range.
+test62() {
+	local bs loops=2 size=$((zone_size))
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	# Two jobs write to single zone twice. Reset zone happens at next write
+	# after half of the zone gets filled. So 2 * 2 * 2 - 1 = 7 times zone
+	# resets are expected.
+	bs=$(min $((256*1024)) $((zone_size / 4)))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$size --loops=$loops --numjobs=2 \
+		       --zone_reset_frequency=1 --zone_reset_threshold=.5 \
+		       --group_reporting=1 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	check_written $((size * loops * 2)) || return $?
+	check_reset_count -eq 7 || return $?
+}
+
+# Test zone_reset_threshold option works for a read job and a write job with
+# different IO range.
+test63() {
+	local bs loops=2 size=$((zone_size)) off1 off2
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	off1=$((first_sequential_zone_sector * 512))
+	off2=$((off1 + zone_size))
+	bs=$(min $((256*1024)) $((zone_size / 4)))
+
+	# One job writes to single zone twice. Reset zone happens at next write
+	# after half of the zone gets filled. So 2 * 2 - 1 = 3 times zone resets
+	# are expected.
+	run_fio "$(ioengine "psync")" --bs="$bs" --size=$size --loops=$loops \
+		--filename="$dev" --group_reporting=1 \
+		--zonemode=zbd --zonesize="$zone_size" --direct=1 \
+		--zone_reset_frequency=1 --zone_reset_threshold=.5 \
+		--name=r --rw=read --offset=$off1 "${job_var_opts[@]}" \
+		--name=w --rw=write --offset=$off2 "${job_var_opts[@]}" \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	check_written $((size * loops)) || return $?
+	check_reset_count -eq 3 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/zbd.c b/zbd.c
index d1e469f6..ba2c0401 100644
--- a/zbd.c
+++ b/zbd.c
@@ -147,6 +147,11 @@ zbd_offset_to_zone(const struct fio_file *f,  uint64_t offset)
 	return zbd_get_zone(f, zbd_offset_to_zone_idx(f, offset));
 }
 
+static bool accounting_vdb(struct thread_data *td, const struct fio_file *f)
+{
+	return td->o.zrt.u.f && td_write(td);
+}
+
 /**
  * zbd_get_zoned_model - Get a device zoned model
  * @td: FIO thread data
@@ -285,10 +290,11 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 		break;
 	}
 
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data -= data_in_zone;
-	f->zbd_info->wp_sectors_with_data -= data_in_zone;
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	if (accounting_vdb(td, f)) {
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		f->zbd_info->wp_valid_data_bytes -= data_in_zone;
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+	}
 
 	z->wp = z->start;
 
@@ -536,7 +542,7 @@ static bool zbd_using_direct_io(void)
 }
 
 /* Whether or not the I/O range for f includes one or more sequential zones */
-static bool zbd_is_seq_job(struct fio_file *f)
+static bool zbd_is_seq_job(const struct fio_file *f)
 {
 	uint32_t zone_idx, zone_idx_b, zone_idx_e;
 
@@ -1068,6 +1074,52 @@ void zbd_recalc_options_with_zone_granularity(struct thread_data *td)
 	}
 }
 
+static uint64_t zbd_verify_and_set_vdb(struct thread_data *td,
+				       const struct fio_file *f)
+{
+	struct fio_zone_info *zb, *ze, *z;
+	uint64_t wp_vdb = 0;
+	struct zoned_block_device_info *zbdi = f->zbd_info;
+
+	assert(td->runstate < TD_RUNNING);
+	assert(zbdi);
+
+	if (!accounting_vdb(td, f))
+		return 0;
+
+	/*
+	 * Ensure that the I/O range includes one or more sequential zones so
+	 * that f->min_zone and f->max_zone have different values.
+	 */
+	if (!zbd_is_seq_job(f))
+		return 0;
+
+	if (zbdi->write_min_zone != zbdi->write_max_zone) {
+		if (zbdi->write_min_zone != f->min_zone ||
+		    zbdi->write_max_zone != f->max_zone) {
+			td_verror(td, EINVAL,
+				  "multi-jobs with different write ranges are "
+				  "not supported with zone_reset_threshold");
+			log_err("multi-jobs with different write ranges are "
+				"not supported with zone_reset_threshold\n");
+		}
+		return 0;
+	}
+
+	zbdi->write_min_zone = f->min_zone;
+	zbdi->write_max_zone = f->max_zone;
+
+	zb = zbd_get_zone(f, f->min_zone);
+	ze = zbd_get_zone(f, f->max_zone);
+	for (z = zb; z < ze; z++)
+		if (z->has_wp)
+			wp_vdb += z->wp - z->start;
+
+	zbdi->wp_valid_data_bytes = wp_vdb;
+
+	return wp_vdb;
+}
+
 int zbd_setup_files(struct thread_data *td)
 {
 	struct fio_file *f;
@@ -1093,6 +1145,7 @@ int zbd_setup_files(struct thread_data *td)
 		struct zoned_block_device_info *zbd = f->zbd_info;
 		struct fio_zone_info *z;
 		int zi;
+		uint64_t vdb;
 
 		assert(zbd);
 
@@ -1100,6 +1153,11 @@ int zbd_setup_files(struct thread_data *td)
 		f->max_zone =
 			zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
 
+		vdb = zbd_verify_and_set_vdb(td, f);
+
+		dprint(FD_ZBD, "%s(%s): valid data bytes = %" PRIu64 "\n",
+		       __func__, f->file_name, vdb);
+
 		/*
 		 * When all zones in the I/O range are conventional, io_size
 		 * can be smaller than zone size, making min_zone the same
@@ -1191,68 +1249,9 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
-enum swd_action {
-	CHECK_SWD,
-	SET_SWD,
-};
-
-/* Calculate the number of sectors with data (swd) and perform action 'a' */
-static uint64_t zbd_process_swd(struct thread_data *td,
-				const struct fio_file *f, enum swd_action a)
-{
-	struct fio_zone_info *zb, *ze, *z;
-	uint64_t swd = 0;
-	uint64_t wp_swd = 0;
-
-	zb = zbd_get_zone(f, f->min_zone);
-	ze = zbd_get_zone(f, f->max_zone);
-	for (z = zb; z < ze; z++) {
-		if (z->has_wp) {
-			zone_lock(td, f, z);
-			wp_swd += z->wp - z->start;
-		}
-		swd += z->wp - z->start;
-	}
-
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	switch (a) {
-	case CHECK_SWD:
-		assert(f->zbd_info->sectors_with_data == swd);
-		assert(f->zbd_info->wp_sectors_with_data == wp_swd);
-		break;
-	case SET_SWD:
-		f->zbd_info->sectors_with_data = swd;
-		f->zbd_info->wp_sectors_with_data = wp_swd;
-		break;
-	}
-	pthread_mutex_unlock(&f->zbd_info->mutex);
-
-	for (z = zb; z < ze; z++)
-		if (z->has_wp)
-			zone_unlock(z);
-
-	return swd;
-}
-
-/*
- * The swd check is useful for debugging but takes too much time to leave
- * it enabled all the time. Hence it is disabled by default.
- */
-static const bool enable_check_swd = false;
-
-/* Check whether the values of zbd_info.*sectors_with_data are correct. */
-static void zbd_check_swd(struct thread_data *td, const struct fio_file *f)
-{
-	if (!enable_check_swd)
-		return;
-
-	zbd_process_swd(td, f, CHECK_SWD);
-}
-
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
-	uint64_t swd;
 	bool verify_data_left = false;
 
 	if (!f->zbd_info || !td_write(td))
@@ -1260,10 +1259,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
-	swd = zbd_process_swd(td, f, SET_SWD);
-
-	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n",
-	       __func__, f->file_name, swd);
 
 	/*
 	 * If data verification is enabled reset the affected zones before
@@ -1639,12 +1634,11 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		 * z->wp > zone_end means that one or more I/O errors
 		 * have occurred.
 		 */
-		pthread_mutex_lock(&zbd_info->mutex);
-		if (z->wp <= zone_end) {
-			zbd_info->sectors_with_data += zone_end - z->wp;
-			zbd_info->wp_sectors_with_data += zone_end - z->wp;
+		if (accounting_vdb(td, f) && z->wp <= zone_end) {
+			pthread_mutex_lock(&zbd_info->mutex);
+			zbd_info->wp_valid_data_bytes += zone_end - z->wp;
+			pthread_mutex_unlock(&zbd_info->mutex);
 		}
-		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
 	default:
@@ -1684,7 +1678,6 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	zbd_end_zone_io(td, io_u, z);
 
 	zone_unlock(z);
-	zbd_check_swd(td, f);
 }
 
 /*
@@ -1801,8 +1794,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
-	if (io_u->file->zbd_info->sectors_with_data ||
-	    td->o.read_beyond_wp)
+	if (io_u->file->last_start[DDIR_WRITE] != -1ULL || td->o.read_beyond_wp)
 		return DDIR_READ;
 
 	return DDIR_WRITE;
@@ -1874,8 +1866,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
-	zbd_check_swd(td, f);
-
 	zone_lock(td, f, zb);
 
 	switch (io_u->ddir) {
@@ -2000,7 +1990,8 @@ retry:
 
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (zbdi->wp_sectors_with_data >= f->io_size * td->o.zrt.u.f &&
+			if (zbdi->wp_valid_data_bytes >=
+			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f))
 				zb->reset_zone = 1;
 		}
diff --git a/zbd.h b/zbd.h
index d425707e..05189555 100644
--- a/zbd.h
+++ b/zbd.h
@@ -54,9 +54,9 @@ struct fio_zone_info {
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
- * @sectors_with_data: total size of data in all zones in units of 512 bytes
- * @wp_sectors_with_data: total size of data in zones with write pointers in
- *                        units of 512 bytes
+ * @wp_valid_data_bytes: total size of data in zones with write pointers
+ * @write_min_zone: Minimum zone index of all job's write ranges. Inclusive.
+ * @write_max_zone: Maximum zone index of all job's write ranges. Exclusive.
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
@@ -76,8 +76,9 @@ struct zoned_block_device_info {
 	uint32_t		max_open_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
-	uint64_t		sectors_with_data;
-	uint64_t		wp_sectors_with_data;
+	uint64_t		wp_valid_data_bytes;
+	uint32_t		write_min_zone;
+	uint32_t		write_max_zone;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
