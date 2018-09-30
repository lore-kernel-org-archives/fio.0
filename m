Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52386 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbeI3SdH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 30 Sep 2018 14:33:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g6aOa-0000Xv-GB
        for fio@vger.kernel.org; Sun, 30 Sep 2018 12:00:21 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180930120002.02DE32C031B@kernel.dk>
Date: Sun, 30 Sep 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 152529ae26d1167779138b6cd30d4de10623da1b:

  gettime: slightly improve CPU clock calibration (2018-09-27 17:38:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 91d2513127442c4946dc99978870c4dc4f58427d:

  zbd: Avoid duplicating the code for calculating the number of sectors with data (2018-09-29 15:16:26 -0600)

----------------------------------------------------------------
Bart Van Assche (6):
      t/zbd/functions: Make fio_reset_count() return 0 if no resets occurred
      t/zbd/test-zbd-support: Ensure that an assertion failure causes this test to fail
      t/zbd/test-zbd-support: Set fio aux path and forbid file creation
      t/zbd/test-zbd-support: Report a test summary when finished
      zbd: Restore zbd_check_swd()
      zbd: Avoid duplicating the code for calculating the number of sectors with data

Damien Le Moal (1):
      zbd: Fix incorrect comments

 t/zbd/functions        |  5 +++-
 t/zbd/test-zbd-support | 17 +++++++++---
 zbd.c                  | 75 ++++++++++++++++++++++++++++++++++++++++++--------
 zbd.h                  |  4 +--
 4 files changed, 82 insertions(+), 19 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/functions b/t/zbd/functions
index 95f9bf4..173f0ca 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -102,5 +102,8 @@ fio_written() {
 }
 
 fio_reset_count() {
-    sed -n 's/^.*write:[^;]*; \([0-9]*\) zone resets$/\1/p'
+    local count
+
+    count=$(sed -n 's/^.*write:[^;]*; \([0-9]*\) zone resets$/\1/p')
+    echo "${count:-0}"
 }
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 6ee5055..2d72791 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -81,13 +81,14 @@ is_scsi_device() {
 }
 
 run_fio() {
-    local fio
+    local fio opts
 
     fio=$(dirname "$0")/../../fio
 
-    { echo; echo "fio $*"; echo; } >>"${logfile}.${test_number}"
+    opts=("--aux-path=/tmp" "--allow_file_create=0" "$@")
+    { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
-    "${dynamic_analyzer[@]}" "$fio" "$@"
+    "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
 }
 
 run_one_fio_job() {
@@ -113,7 +114,7 @@ run_fio_on_seq() {
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
-	    --size="${zone_size}"					\
+	    --size="${zone_size}" --thread=1				\
 	    --zonemode=zbd --zonesize="${zone_size}" 2>&1 |
 	tee -a "${logfile}.${test_number}" |
 	grep -q 'Using direct I/O is mandatory for writing to ZBD drives'
@@ -800,18 +801,26 @@ fi
 
 logfile=$0.log
 
+passed=0
+failed=0
 rc=0
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
     echo -n "Running test $test_number ... "
     if eval "test$test_number"; then
 	status="PASS"
+	((passed++))
     else
 	status="FAIL"
+	((failed++))
 	rc=1
     fi
     echo "$status"
     echo "$status" >> "${logfile}.${test_number}"
 done
 
+echo "$passed tests passed"
+if [ $failed -gt 0 ]; then
+    echo " and $failed tests failed"
+fi
 exit $rc
diff --git a/zbd.c b/zbd.c
index aa08b81..8acda1f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -726,29 +726,76 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
-void zbd_file_reset(struct thread_data *td, struct fio_file *f)
+enum swd_action {
+	CHECK_SWD,
+	SET_SWD,
+};
+
+/* Calculate the number of sectors with data (swd) and perform action 'a' */
+static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
 {
 	struct fio_zone_info *zb, *ze, *z;
-	uint32_t zone_idx_e;
 	uint64_t swd = 0;
 
-	if (!f->zbd_info)
-		return;
-
 	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
-	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size);
-	ze = &f->zbd_info->zone_info[zone_idx_e];
-	for (z = zb ; z < ze; z++) {
+	ze = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset +
+						  f->io_size)];
+	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
 		swd += z->wp - z->start;
 	}
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data = swd;
+	switch (a) {
+	case CHECK_SWD:
+		assert(f->zbd_info->sectors_with_data == swd);
+		break;
+	case SET_SWD:
+		f->zbd_info->sectors_with_data = swd;
+		break;
+	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
-	for (z = zb ; z < ze; z++)
+	for (z = zb; z < ze; z++)
 		pthread_mutex_unlock(&z->mutex);
-	dprint(FD_ZBD, "%s(%s): swd = %llu\n", __func__, f->file_name,
-		(unsigned long long) swd);
+
+	return swd;
+}
+
+/*
+ * The swd check is useful for debugging but takes too much time to leave
+ * it enabled all the time. Hence it is disabled by default.
+ */
+static const bool enable_check_swd = false;
+
+/* Check whether the value of zbd_info.sectors_with_data is correct. */
+static void zbd_check_swd(const struct fio_file *f)
+{
+	if (!enable_check_swd)
+		return;
+
+	zbd_process_swd(f, CHECK_SWD);
+}
+
+static void zbd_init_swd(struct fio_file *f)
+{
+	uint64_t swd;
+
+	swd = zbd_process_swd(f, SET_SWD);
+	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
+	       swd);
+}
+
+void zbd_file_reset(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_zone_info *zb, *ze;
+	uint32_t zone_idx_e;
+
+	if (!f->zbd_info)
+		return;
+
+	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
+	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size);
+	ze = &f->zbd_info->zone_info[zone_idx_e];
+	zbd_init_swd(f);
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
@@ -1077,6 +1124,8 @@ static void zbd_post_submit(const struct io_u *io_u, bool success)
 	}
 unlock:
 	pthread_mutex_unlock(&z->mutex);
+
+	zbd_check_swd(io_u->file);
 }
 
 bool zbd_unaligned_write(int error_code)
@@ -1129,6 +1178,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
+	zbd_check_swd(f);
+
 	pthread_mutex_lock(&zb->mutex);
 	switch (io_u->ddir) {
 	case DDIR_READ:
diff --git a/zbd.h b/zbd.h
index d750b67..33e6d8b 100644
--- a/zbd.h
+++ b/zbd.h
@@ -31,8 +31,8 @@ enum io_u_action {
 
 /**
  * struct fio_zone_info - information about a single ZBD zone
- * @start: zone start in 512 byte units
- * @wp: zone write pointer location in 512 byte units
+ * @start: zone start location (bytes)
+ * @wp: zone write pointer location (bytes)
  * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)

