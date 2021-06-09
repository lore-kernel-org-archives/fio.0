Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhFIMCP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Jun 2021 08:02:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B950DC061574
        for <fio@vger.kernel.org>; Wed,  9 Jun 2021 05:00:20 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lqwsP-000TDi-T7
        for fio@vger.kernel.org; Wed, 09 Jun 2021 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210609120002.2D6DF1BC0106@kernel.dk>
Date: Wed,  9 Jun 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d7a28031718d281f1b9ea593c8a3f395761510ca:

  Merge branch 'fix/928' of https://github.com/larsks/fio (2021-06-03 09:01:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 40d0b84220f7c0ff9c3874656db7f0f8cb6a85e6:

  t/zbd: Fix write target zones counting in test case #31 (2021-06-08 15:15:58 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (3):
      t/zbd: Use max_open_zones that fio fetched from device
      t/zbd: Add ignore_zone_limit option to test with special max_open_zones
      t/zbd: Fix write target zones counting in test case #31

 t/zbd/functions        | 14 +++++++++++---
 t/zbd/test-zbd-support | 37 +++++++++++++++++--------------------
 2 files changed, 28 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/functions b/t/zbd/functions
index 40ffe1de..08a2c629 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -173,15 +173,23 @@ last_online_zone() {
     fi
 }
 
+# Get max_open_zones of SMR drives using sg_inq or libzbc tools. Two test cases
+# 31 and 32 use this max_open_zones value. The test case 31 uses max_open_zones
+# to decide number of write target zones. The test case 32 passes max_open_zones
+# value to fio with --max_open_zones option. Of note is that fio itself has the
+# feature to get max_open_zones from the device through sysfs or ioengine
+# specific implementation. This max_open_zones fetch by test script is required
+# in case fio is running on an old Linux kernel version which lacks
+# max_open_zones in sysfs, or which lacks zoned block device support completely.
 max_open_zones() {
     local dev=$1
 
     if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
 	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" \
 		 > /dev/null 2>&1; then
-	    # Non scsi device such as null_blk can not return max open zones.
-	    # Use default value.
-	    echo 128
+	    # When sg_inq can not get max open zones, specify 0 which indicates
+	    # fio to get max open zones limit from the device.
+	    echo 0
 	else
 	    ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" | tail -1 |
 		{
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 26aff373..a684f988 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -731,32 +731,28 @@ test30() {
 test31() {
     local bs inc nz off opts size
 
-    prep_write
-    # Start with writing 128 KB to max_open_zones sequential zones.
-    bs=128K
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+    # As preparation, write 128 KB to sequential write required zones. Limit
+    # write target zones up to max_open_zones to keep test time reasonable.
+    # To distribute the write target zones evenly, skip certain zones for every
+    # write. Utilize zonemode strided for such write patterns.
+    bs=$((128 * 1024))
     nz=$((max_open_zones))
     if [[ $nz -eq 0 ]]; then
 	nz=128
     fi
-    # shellcheck disable=SC2017
-    inc=$(((disk_size - (first_sequential_zone_sector * 512)) / (nz * zone_size)
-	   * zone_size))
-    if [ "$inc" -eq 0 ]; then
-	require_seq_zones $nz || return $SKIP_TESTCASE
-    fi
-    opts=()
-    for ((off = first_sequential_zone_sector * 512; off < disk_size;
-	  off += inc)); do
-	opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--io_size=$bs")
-	opts+=("--bs=$bs" "--size=$zone_size" "$(ioengine "libaio")")
-	opts+=("--rw=write" "--direct=1" "--thread=1" "--stats=0")
-	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-	opts+=(${job_var_opts[@]})
-    done
-    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
-    # Next, run the test.
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
+    inc=$(((size / nz / zone_size) * zone_size))
+    opts=("--name=$dev" "--filename=$dev" "--rw=write" "--bs=${bs}")
+    opts+=("--offset=$off" "--size=$((inc * nz))" "--io_size=$((bs * nz))")
+    opts+=("--zonemode=strided" "--zonesize=${bs}" "--zonerange=${inc}")
+    opts+=("--direct=1")
+    echo "fio ${opts[@]}" >> "${logfile}.${test_number}"
+    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
+
+    # Next, run the test.
     opts=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
     opts+=("--bs=$bs" "$(ioengine "psync")" "--rw=randread" "--direct=1")
     opts+=("--thread=1" "--time_based" "--runtime=30" "--zonemode=zbd")
@@ -1348,6 +1344,7 @@ fi
 if [[ -n ${max_open_zones_opt} ]]; then
 	# Override max_open_zones with the script option value
 	max_open_zones="${max_open_zones_opt}"
+	global_var_opts+=("--ignore_zone_limits=1")
 	job_var_opts+=("--max_open_zones=${max_open_zones_opt}")
 fi
 

