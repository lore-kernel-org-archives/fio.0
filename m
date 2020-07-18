Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgGRMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 Jul 2020 08:00:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A60C0619D2
        for <fio@vger.kernel.org>; Sat, 18 Jul 2020 05:00:14 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwlVj-0007Ua-E5
        for fio@vger.kernel.org; Sat, 18 Jul 2020 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200718120002.005471BC0CD0@kernel.dk>
Date: Sat, 18 Jul 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 37e8cc62319b30927a3147e25b16c3e00b84692f:

  Merge branch 'fix_devdax' of https://github.com/harish-24/fio (2020-07-14 10:10:23 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e04241512bb69f1fe8ff6eed9402343af436ba75:

  t/zbd: Enable regular block devices for test case #47 (2020-07-17 07:32:12 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (8):
      zbd: Fix initial zone write pointer of regular block devices
      t/zbd: Fix pass condition of test case #3
      t/zbd: Add write_and_run_one_fio_job() helper function
      t/zbd: Combine write and read fio commands for test case #6
      t/zbd: Combine write and read fio commands for test case #15
      t/zbd: Combine write and read fio commands for test case #16
      t/zbd: Remove write before random read/write from test case #17
      t/zbd: Enable regular block devices for test case #47

 t/zbd/test-zbd-support | 78 ++++++++++++++++++++++++++++----------------------
 zbd.c                  |  2 +-
 2 files changed, 44 insertions(+), 36 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4001be3b..80dc3f30 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -109,6 +109,20 @@ run_one_fio_job() {
 	    --thread=1 --direct=1
 }
 
+write_and_run_one_fio_job() {
+    local r
+    local write_offset="${1}"
+    local write_size="${2}"
+
+    shift 2
+    r=$(((RANDOM << 16) | RANDOM))
+    run_fio --filename="$dev" --randseed="$r"  --name="write_job" --rw=write \
+	    "$(ioengine "psync")" --bs="${logical_block_size}" \
+	    --zonemode=zbd --zonesize="${zone_size}" --thread=1 --direct=1 \
+	    --offset="${write_offset}" --size="${write_size}" \
+	    --name="$dev" --wait_for="write_job" "$@" --thread=1 --direct=1
+}
+
 # Run fio on the first four sequential zones of the disk.
 run_fio_on_seq() {
     local opts=()
@@ -170,13 +184,7 @@ test3() {
 	opts+=("--zonesize=${zone_size}")
     fi
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    grep -q 'READ:' "${logfile}.${test_number}"
-    rc=$?
-    if [ -n "$is_zbd" ]; then
-	[ $rc != 0 ]
-    else
-	[ $rc = 0 ]
-    fi
+    ! grep -q 'READ:' "${logfile}.${test_number}"
 }
 
 # Run fio with --read_beyond_wp=1 against an empty zone.
@@ -207,14 +215,18 @@ test5() {
     check_read $size || return $?
 }
 
-# Sequential read from sequential zones. Must be run after test5.
+# Sequential read from sequential zones.
 test6() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=read	\
-		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
-		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    write_and_run_one_fio_job \
+	    $((first_sequential_zone_sector * 512)) "${size}" \
+	    --offset=$((first_sequential_zone_sector * 512)) \
+	    --size="${size}" --zonemode=zbd --zonesize="${zone_size}" \
+	    "$(ioengine "psync")" --iodepth=1 --rw=read \
+	    --bs="$(max $((zone_size / 64)) "$logical_block_size")" \
+	    >>"${logfile}.${test_number}" 2>&1 || return $?
     check_read $size || return $?
 }
 
@@ -337,41 +349,45 @@ test14() {
 # Sequential read on a mix of empty and full zones.
 test15() {
     local i off size
+    local w_off w_size
 
     for ((i=0;i<4;i++)); do
 	[ -n "$is_zbd" ] &&
 	    reset_zone "$dev" $((first_sequential_zone_sector +
 				 i*sectors_per_zone))
     done
-    off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
-    size=$((2 * zone_size))
-    run_one_fio_job "$(ioengine "psync")" --rw=write --bs=$((zone_size / 16))\
-		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
-		    --size=$size >>"${logfile}.${test_number}" 2>&1 ||
-	return $?
-    check_written $size || return $?
+    w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
+    w_size=$((2 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
-    run_one_fio_job "$(ioengine "psync")" --rw=read --bs=$((zone_size / 16)) \
+    write_and_run_one_fio_job "${w_off}" "${w_size}" \
+		    "$(ioengine "psync")" --rw=read --bs=$((zone_size / 16)) \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$((size)) >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
-    if [ -n "$is_zbd" ]; then
-	check_read $((size / 2))
-    else
-	check_read $size
-    fi
+    check_written $((w_size)) || return $?
+    check_read $((size / 2))
 }
 
-# Random read on a mix of empty and full zones. Must be run after test15.
+# Random read on a mix of empty and full zones.
 test16() {
     local off size
+    local i w_off w_size
 
+    for ((i=0;i<4;i++)); do
+	[ -n "$is_zbd" ] &&
+	    reset_zone "$dev" $((first_sequential_zone_sector +
+				 i*sectors_per_zone))
+    done
+    w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
+    w_size=$((2 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
-    run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randread --bs=16K \
+    write_and_run_one_fio_job "${w_off}" "${w_size}" \
+		    "$(ioengine "libaio")" --iodepth=64 --rw=randread --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$size >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $w_size || return $?
     check_read $size || return $?
 }
 
@@ -381,15 +397,9 @@ test17() {
 
     off=$(((disk_size / zone_size - 1) * zone_size))
     size=$((disk_size - off))
-    # Overwrite the last zone to avoid that reading from that zone fails.
     if [ -n "$is_zbd" ]; then
 	reset_zone "$dev" $((off / 512)) || return $?
     fi
-    run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off"	\
-		    --zonemode=zbd --zonesize="${zone_size}"		\
-		    --bs="$zone_size" --size="$zone_size"		\
-		    >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written "$zone_size" || return $?
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw --bs=4K \
 		    --zonemode=zbd --zonesize="${zone_size}"		\
 		    --offset=$off --loops=2 --norandommap=1\
@@ -763,10 +773,8 @@ test46() {
 test47() {
     local bs
 
-    [ -z "$is_zbd" ] && return 0
     bs=$((logical_block_size))
-    run_one_fio_job "$(ioengine "psync")" --rw=write --bs=$bs \
-		    --zonemode=zbd --zoneskip=1		 \
+    run_fio_on_seq "$(ioengine "psync")" --rw=write --bs=$bs --zoneskip=1 \
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'zoneskip 1 is not a multiple of the device zone size' "${logfile}.${test_number}"
 }
diff --git a/zbd.c b/zbd.c
index 8cf8f812..cf2cded9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -381,7 +381,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		mutex_init_pshared_with_type(&p->mutex,
 					     PTHREAD_MUTEX_RECURSIVE);
 		p->start = i * zone_size;
-		p->wp = p->start + zone_size;
+		p->wp = p->start;
 		p->type = ZBD_ZONE_TYPE_SWR;
 		p->cond = ZBD_ZONE_COND_EMPTY;
 	}

