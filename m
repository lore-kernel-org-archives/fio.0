Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240873AbhDMMA0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Apr 2021 08:00:26 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF653C061574
        for <fio@vger.kernel.org>; Tue, 13 Apr 2021 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lWHi7-0099ew-RX
        for fio@vger.kernel.org; Tue, 13 Apr 2021 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210413120001.A6EFA1BC0143@kernel.dk>
Date: Tue, 13 Apr 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1588c8f571f67a004571e51cdbb5de97c3e4f457:

  Merge branch 'wip-rados-dont-zerowrite' of https://github.com/aclamk/fio (2021-04-10 11:46:30 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9b6253bc6af3b38d4677f7470f42a1ff22492ef3:

  t/zbd: test repeated async write with block size unaligned to zone size (2021-04-12 06:56:29 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      zbd: avoid zone reset during asynchronous IOs in-flight
      t/zbd: test repeated async write with block size unaligned to zone size

 t/zbd/test-zbd-support | 18 ++++++++++++++++++
 zbd.c                  | 23 +++++++----------------
 2 files changed, 25 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index be129615..26aff373 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1201,6 +1201,24 @@ test56() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test that repeated async write job does not cause zone reset during writes
+# in-flight, when the block size is not a divisor of the zone size.
+test57() {
+	local bs off
+
+	require_zbd || return $SKIP_TESTCASE
+
+	bs=$((4096 * 7))
+	off=$((first_sequential_zone_sector * 512))
+
+	run_fio --name=job --filename="${dev}" --rw=randwrite --bs="${bs}" \
+		--offset="${off}" --size=$((4 * zone_size)) --iodepth=256 \
+		"$(ioengine "libaio")" --time_based=1 --runtime=30s \
+		--zonemode=zbd --direct=1 --zonesize="${zone_size}" \
+		${job_var_opts[@]} \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/zbd.c b/zbd.c
index d16b890f..eed796b3 100644
--- a/zbd.c
+++ b/zbd.c
@@ -842,16 +842,13 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
  * @f: fio file for which to reset zones
  * @zb: first zone to reset.
  * @ze: first zone not to reset.
- * @all_zones: whether to reset all zones or only those zones for which the
- *	write pointer is not a multiple of td->o.min_bs[DDIR_WRITE].
  */
 static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			   struct fio_zone_info *const zb,
-			   struct fio_zone_info *const ze, bool all_zones)
+			   struct fio_zone_info *const ze)
 {
 	struct fio_zone_info *z;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
-	bool reset_wp;
 	int res = 0;
 
 	assert(min_bs);
@@ -864,16 +861,10 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		if (!z->has_wp)
 			continue;
 		zone_lock(td, f, z);
-		if (all_zones) {
-			pthread_mutex_lock(&f->zbd_info->mutex);
-			zbd_close_zone(td, f, nz);
-			pthread_mutex_unlock(&f->zbd_info->mutex);
-
-			reset_wp = z->wp != z->start;
-		} else {
-			reset_wp = z->wp % min_bs != 0;
-		}
-		if (reset_wp) {
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		zbd_close_zone(td, f, nz);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		if (z->wp != z->start) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
 			       f->file_name, zbd_zone_nr(f, z));
 			if (zbd_reset_zone(td, f, z) < 0)
@@ -996,8 +987,8 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing any data to avoid that a zone reset has to be issued while
 	 * writing data, which causes data loss.
 	 */
-	zbd_reset_zones(td, f, zb, ze, td->o.verify != VERIFY_NONE &&
-			td->runstate != TD_VERIFYING);
+	if (td->o.verify != VERIFY_NONE && td->runstate != TD_VERIFYING)
+		zbd_reset_zones(td, f, zb, ze);
 	zbd_reset_write_cnt(td, f);
 }
 

