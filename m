Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318B1C433EF
	for <fio@archiver.kernel.org>; Mon, 18 Oct 2021 12:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 160A16128B
	for <fio@archiver.kernel.org>; Mon, 18 Oct 2021 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhJRMCU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhJRMCU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Oct 2021 08:02:20 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED178C06161C
        for <fio@vger.kernel.org>; Mon, 18 Oct 2021 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2cA8EsSbi8uHt0Rwgo/GI5EipBcqa9Ghi4d3BJx4epI=; b=cpE8dhQxc7gHAtnTHQ72HqeG0L
        U5yVTmK8mVw2Em/wYopdqFObQuLsPtwZvpfD/2mLSI6liV9aHgmTXwVdLDbejritkysoO1kAL2XV4
        mw1gqR+X1SFlxm72u9EtanjcBfey5xMZaH0H7zrDPzyxwWfCICqrmU91Csm/km73iR4vB6PqPmYVl
        s60il1QXE1W8G+UuHXQR7LO9hlBCajNFKqpvNeG/8KDfQ9LJLpHFZUDHvf5GJPWiGvwX7RK0Pnu6P
        GR74PzJE/Ccg+gN4ixtwMf+DGd6RSaCCUplnVl1VAh9cDg/L8HdF+sR6Qnj2vvJ3Mp7ZzCE2fR52E
        3s4U44iw==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcRJG-00AXpe-V1
        for fio@vger.kernel.org; Mon, 18 Oct 2021 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 3ECE91BC016E; Mon, 18 Oct 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211018120002.3ECE91BC016E@kernel.dk>
Date:   Mon, 18 Oct 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7d1ce4b752e67868b3c7eb9aa5972ceec51210aa:

  t/io_uring: Fix the parameters calculation for multiple threads scenario (2021-10-15 06:20:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aa9f26276e1961fab2d33e188f5a2432360c9c14:

  run-fio-tests: make test runs more resilient (2021-10-17 07:22:55 -0600)

----------------------------------------------------------------
Rebecca Cran (1):
      engines/http.c: add fallthrough annotation to _curl_trace

Shin'ichiro Kawasaki (5):
      zbd: Remove cast to unsigned long long for printf
      zbd: Fix type of local variable min_bs
      t/zbd: Do not use too large block size in test case #4
      t/zbd: Align block size to zone capacity
      t/zbd: Add -w option to ensure no open zone before write tests

Vincent Fu (1):
      run-fio-tests: make test runs more resilient

 engines/http.c         |   3 +-
 t/run-fio-tests.py     |  14 +++++--
 t/zbd/functions        |  26 ++++++++++++
 t/zbd/test-zbd-support |  40 ++++++++++--------
 zbd.c                  | 107 +++++++++++++++++++++++--------------------------
 5 files changed, 112 insertions(+), 78 deletions(-)

---

Diff of recent changes:

diff --git a/engines/http.c b/engines/http.c
index 7a61b132..35c44871 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -297,10 +297,9 @@ static int _curl_trace(CURL *handle, curl_infotype type,
 	switch (type) {
 	case CURLINFO_TEXT:
 		fprintf(stderr, "== Info: %s", data);
-		/* fall through */
+		fallthrough;
 	default:
 	case CURLINFO_SSL_DATA_OUT:
-		/* fall through */
 	case CURLINFO_SSL_DATA_IN:
 		return 0;
 
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index a59cdfe0..612e50ca 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -49,6 +49,7 @@ import shutil
 import logging
 import argparse
 import platform
+import traceback
 import subprocess
 import multiprocessing
 from pathlib import Path
@@ -1057,9 +1058,16 @@ def main():
                 skipped = skipped + 1
                 continue
 
-        test.setup(artifact_root, config['test_id'])
-        test.run()
-        test.check_result()
+        try:
+            test.setup(artifact_root, config['test_id'])
+            test.run()
+            test.check_result()
+        except KeyboardInterrupt:
+            break
+        except Exception as e:
+            test.passed = False
+            test.failure_reason += str(e)
+            logging.debug("Test %d exception:\n%s\n", config['test_id'], traceback.format_exc())
         if test.passed:
             result = "PASSED"
             passed = passed + 1
diff --git a/t/zbd/functions b/t/zbd/functions
index 08a2c629..e4e248b9 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -64,6 +64,32 @@ check_blkzone() {
 	fi
 }
 
+# Check zone capacity of each zone and report block size aligned to the zone
+# capacities. If zone capacity is same as zone size for zones, report zone size.
+zone_cap_bs() {
+	local dev="${1}"
+	local zone_size="${2}"
+	local sed_str='s/.*len \([0-9A-Za-z]*\), cap \([0-9A-Za-z]*\).*/\1 \2/p'
+	local cap bs="$zone_size"
+
+	# When blkzone is not available or blkzone does not report capacity,
+	# assume that zone capacity is same as zone size for all zones.
+	if [ -z "${blkzone}" ] || ! blkzone_reports_capacity "${dev}"; then
+		echo "$zone_size"
+		return
+	fi
+
+	while read -r -a line; do
+		((line[0] == line[1])) && continue
+		cap=$((line[1] * 512))
+		while ((bs > 512 && cap % bs)); do
+			bs=$((bs / 2))
+		done
+	done < <(blkzone report "${dev}" | sed -n "${sed_str}")
+
+	echo "$bs"
+}
+
 # Reports the starting sector and length of the first sequential zone of device
 # $1.
 first_sequential_zone() {
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 5103c406..7e2fff00 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -12,6 +12,7 @@ usage() {
 	echo -e "\t-v Run fio with valgrind --read-var-info option"
 	echo -e "\t-l Test with libzbc ioengine"
 	echo -e "\t-r Reset all zones before test start"
+	echo -e "\t-w Reset all zones before executing each write test case"
 	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
 	echo -e "\t-q Quit the test run after any failed test"
@@ -182,13 +183,14 @@ run_fio_on_seq() {
     run_one_fio_job "${opts[@]}" "$@"
 }
 
-# Prepare for write test by resetting zones. When max_open_zones option is
-# specified, reset all zones of the test target to ensure that zones out of the
-# test target range do not have open zones. This allows the write test to the
-# target range to be able to open zones up to max_open_zones.
+# Prepare for write test by resetting zones. When reset_before_write or
+# max_open_zones option is specified, reset all zones of the test target to
+# ensure that zones out of the test target range do not have open zones. This
+# allows the write test to the target range to be able to open zones up to
+# max_open_zones limit specified as the option or obtained from sysfs.
 prep_write() {
-	[[ -n "${max_open_zones_opt}" && -n "${is_zbd}" ]] &&
-		reset_zone "${dev}" -1
+	[[ -n "${reset_before_write}" || -n "${max_open_zones_opt}" ]] &&
+		[[ -n "${is_zbd}" ]] && reset_zone "${dev}" -1
 }
 
 SKIP_TESTCASE=255
@@ -310,7 +312,8 @@ test4() {
     off=$((first_sequential_zone_sector * 512 + 129 * zone_size))
     size=$((zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
-    opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--bs=$size")
+    opts+=("--name=$dev" "--filename=$dev" "--offset=$off")
+    opts+=(--bs="$(min $((logical_block_size * 256)) $size)")
     opts+=("--size=$size" "--thread=1" "--read_beyond_wp=1")
     opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--disable_lat=1")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
@@ -320,15 +323,15 @@ test4() {
 
 # Sequential write to sequential zones.
 test5() {
-    local size off capacity
+    local size off capacity bs
 
     prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
+    bs=$(min "$(max $((zone_size / 64)) "$logical_block_size")" "$zone_cap_bs")
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
-		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
-		   --do_verify=1 --verify=md5				\
+		   --bs="$bs" --do_verify=1 --verify=md5 \
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $capacity || return $?
     check_read $capacity || return $?
@@ -336,18 +339,18 @@ test5() {
 
 # Sequential read from sequential zones.
 test6() {
-    local size off capacity
+    local size off capacity bs
 
     prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
+    bs=$(min "$(max $((zone_size / 64)) "$logical_block_size")" "$zone_cap_bs")
     write_and_run_one_fio_job \
 	    $((first_sequential_zone_sector * 512)) "${size}" \
 	    --offset="${off}" \
 	    --size="${size}" --zonemode=zbd --zonesize="${zone_size}" \
-	    "$(ioengine "psync")" --iodepth=1 --rw=read \
-	    --bs="$(max $((zone_size / 64)) "$logical_block_size")" \
+	    "$(ioengine "psync")" --iodepth=1 --rw=read --bs="$bs" \
 	    >>"${logfile}.${test_number}" 2>&1 || return $?
     check_read $capacity || return $?
 }
@@ -485,7 +488,7 @@ test14() {
 
 # Sequential read on a mix of empty and full zones.
 test15() {
-    local i off size
+    local i off size bs
     local w_off w_size w_capacity
 
     for ((i=0;i<4;i++)); do
@@ -499,8 +502,9 @@ test15() {
     w_capacity=$(total_zone_capacity 2 $w_off $dev)
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
+    bs=$(min $((zone_size / 16)) "$zone_cap_bs")
     write_and_run_one_fio_job "${w_off}" "${w_size}" \
-		    "$(ioengine "psync")" --rw=read --bs=$((zone_size / 16)) \
+		    "$(ioengine "psync")" --rw=read --bs="$bs" \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$((size)) >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
@@ -852,7 +856,7 @@ test37() {
 	off=$(((first_sequential_zone_sector - 1) * 512))
     fi
     size=$((zone_size + 2 * 512))
-    bs=$((zone_size / 4))
+    bs=$(min $((zone_size / 4)) "$zone_cap_bs")
     run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
 		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
 		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
@@ -1245,6 +1249,7 @@ SECONDS=0
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
+reset_before_write=
 use_libzbc=
 zbd_debug=
 max_open_zones_opt=
@@ -1259,6 +1264,7 @@ while [ "${1#-}" != "$1" ]; do
 	shift;;
     -l) use_libzbc=1; shift;;
     -r) reset_all_zones=1; shift;;
+    -w) reset_before_write=1; shift;;
     -t) tests+=("$2"); shift; shift;;
     -o) max_open_zones_opt="${2}"; shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
@@ -1377,6 +1383,8 @@ fi
 echo -n "First sequential zone starts at sector $first_sequential_zone_sector;"
 echo " zone size: $((zone_size >> 20)) MB"
 
+zone_cap_bs=$(zone_cap_bs "$dev" "$zone_size")
+
 if [ "${#tests[@]}" = 0 ]; then
     readarray -t tests < <(declare -F | grep "test[0-9]*" | \
 				   tr -c -d "[:digit:]\n" | sort -n)
diff --git a/zbd.c b/zbd.c
index c0b0b81c..c18998c4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -83,12 +83,12 @@ int zbd_report_zones(struct thread_data *td, struct fio_file *f,
 		ret = blkzoned_report_zones(td, f, offset, zones, nr_zones);
 	if (ret < 0) {
 		td_verror(td, errno, "report zones failed");
-		log_err("%s: report zones from sector %llu failed (%d).\n",
-			f->file_name, (unsigned long long)offset >> 9, errno);
+		log_err("%s: report zones from sector %"PRIu64" failed (%d).\n",
+			f->file_name, offset >> 9, errno);
 	} else if (ret == 0) {
 		td_verror(td, errno, "Empty zone report");
-		log_err("%s: report zones from sector %llu is empty.\n",
-			f->file_name, (unsigned long long)offset >> 9);
+		log_err("%s: report zones from sector %"PRIu64" is empty.\n",
+			f->file_name, offset >> 9);
 		ret = -EIO;
 	}
 
@@ -116,9 +116,8 @@ int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
 		ret = blkzoned_reset_wp(td, f, offset, length);
 	if (ret < 0) {
 		td_verror(td, errno, "resetting wp failed");
-		log_err("%s: resetting wp for %llu sectors at sector %llu failed (%d).\n",
-			f->file_name, (unsigned long long)length >> 9,
-			(unsigned long long)offset >> 9, errno);
+		log_err("%s: resetting wp for %"PRIu64" sectors at sector %"PRIu64" failed (%d).\n",
+			f->file_name, length >> 9, offset >> 9, errno);
 	}
 
 	return ret;
@@ -318,16 +317,16 @@ static bool zbd_verify_sizes(void)
 					return false;
 				}
 			} else if (td->o.zone_size != f->zbd_info->zone_size) {
-				log_err("%s: job parameter zonesize %llu does not match disk zone size %llu.\n",
-					f->file_name, (unsigned long long) td->o.zone_size,
-					(unsigned long long) f->zbd_info->zone_size);
+				log_err("%s: job parameter zonesize %llu does not match disk zone size %"PRIu64".\n",
+					f->file_name, td->o.zone_size,
+					f->zbd_info->zone_size);
 				return false;
 			}
 
 			if (td->o.zone_skip % td->o.zone_size) {
 				log_err("%s: zoneskip %llu is not a multiple of the device zone size %llu.\n",
-					f->file_name, (unsigned long long) td->o.zone_skip,
-					(unsigned long long) td->o.zone_size);
+					f->file_name, td->o.zone_skip,
+					td->o.zone_size);
 				return false;
 			}
 
@@ -341,9 +340,9 @@ static bool zbd_verify_sizes(void)
 						 f->file_name);
 					return false;
 				}
-				log_info("%s: rounded up offset from %llu to %llu\n",
-					 f->file_name, (unsigned long long) f->file_offset,
-					 (unsigned long long) new_offset);
+				log_info("%s: rounded up offset from %"PRIu64" to %"PRIu64"\n",
+					 f->file_name, f->file_offset,
+					 new_offset);
 				f->io_size -= (new_offset - f->file_offset);
 				f->file_offset = new_offset;
 			}
@@ -357,9 +356,9 @@ static bool zbd_verify_sizes(void)
 						 f->file_name);
 					return false;
 				}
-				log_info("%s: rounded down io_size from %llu to %llu\n",
-					 f->file_name, (unsigned long long) f->io_size,
-					 (unsigned long long) new_end - f->file_offset);
+				log_info("%s: rounded down io_size from %"PRIu64" to %"PRIu64"\n",
+					 f->file_name, f->io_size,
+					 new_end - f->file_offset);
 				f->io_size = new_end - f->file_offset;
 			}
 		}
@@ -388,17 +387,17 @@ static bool zbd_verify_bs(void)
 				continue;
 			zone_size = f->zbd_info->zone_size;
 			if (td_trim(td) && td->o.bs[DDIR_TRIM] != zone_size) {
-				log_info("%s: trim block size %llu is not the zone size %llu\n",
+				log_info("%s: trim block size %llu is not the zone size %"PRIu64"\n",
 					 f->file_name, td->o.bs[DDIR_TRIM],
-					 (unsigned long long)zone_size);
+					 zone_size);
 				return false;
 			}
 			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
 				if (td->o.verify != VERIFY_NONE &&
 				    zone_size % td->o.bs[k] != 0) {
-					log_info("%s: block size %llu is not a divisor of the zone size %llu\n",
+					log_info("%s: block size %llu is not a divisor of the zone size %"PRIu64"\n",
 						 f->file_name, td->o.bs[k],
-						 (unsigned long long)zone_size);
+						 zone_size);
 					return false;
 				}
 			}
@@ -448,8 +447,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 
 	if (zone_capacity > zone_size) {
 		log_err("%s: job parameter zonecapacity %llu is larger than zone size %llu\n",
-			f->file_name, (unsigned long long) td->o.zone_capacity,
-			(unsigned long long) td->o.zone_size);
+			f->file_name, td->o.zone_capacity, td->o.zone_size);
 		return 1;
 	}
 
@@ -525,15 +523,14 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	if (td->o.zone_size == 0) {
 		td->o.zone_size = zone_size;
 	} else if (td->o.zone_size != zone_size) {
-		log_err("fio: %s job parameter zonesize %llu does not match disk zone size %llu.\n",
-			f->file_name, (unsigned long long) td->o.zone_size,
-			(unsigned long long) zone_size);
+		log_err("fio: %s job parameter zonesize %llu does not match disk zone size %"PRIu64".\n",
+			f->file_name, td->o.zone_size, zone_size);
 		ret = -EINVAL;
 		goto out;
 	}
 
-	dprint(FD_ZBD, "Device %s has %d zones of size %llu KB\n", f->file_name,
-	       nr_zones, (unsigned long long) zone_size / 1024);
+	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n", f->file_name,
+	       nr_zones, zone_size / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -587,9 +584,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 					   ZBD_REPORT_MAX_ZONES));
 		if (nrz < 0) {
 			ret = nrz;
-			log_info("fio: report zones (offset %llu) failed for %s (%d).\n",
-			 	 (unsigned long long)offset,
-				 f->file_name, -ret);
+			log_info("fio: report zones (offset %"PRIu64") failed for %s (%d).\n",
+				 offset, f->file_name, -ret);
 			goto out;
 		}
 	}
@@ -972,7 +968,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			   struct fio_zone_info *const ze)
 {
 	struct fio_zone_info *z;
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 	int res = 0;
 
 	assert(min_bs);
@@ -1145,7 +1141,7 @@ static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
 static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 			  uint32_t zone_idx)
 {
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z = get_zone(f, zone_idx);
 	bool res = true;
@@ -1228,7 +1224,7 @@ static bool any_io_in_flight(void)
 static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 						      struct io_u *io_u)
 {
-	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
+	const uint64_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z;
@@ -1431,7 +1427,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 						    struct fio_zone_info *z)
 {
 	const struct fio_file *f = io_u->file;
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 
 	if (!zbd_open_zone(td, f, zbd_zone_nr(f, z))) {
 		zone_unlock(z);
@@ -1440,8 +1436,8 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	}
 
 	if (z->verify_block * min_bs >= z->capacity) {
-		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
-			min_bs, (unsigned long long)z->capacity);
+		log_err("%s: %d * %"PRIu64" >= %"PRIu64"\n", f->file_name, z->verify_block,
+			min_bs, z->capacity);
 		/*
 		 * If the assertion below fails during a test run, adding
 		 * "--experimental_verify=1" to the command line may help.
@@ -1450,8 +1446,8 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	}
 	io_u->offset = z->start + z->verify_block * min_bs;
 	if (io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
-		log_err("%s: %llu + %llu >= %llu\n", f->file_name, io_u->offset,
-			io_u->buflen, (unsigned long long) zbd_zone_capacity_end(z));
+		log_err("%s: %llu + %llu >= %"PRIu64"\n", f->file_name, io_u->offset,
+			io_u->buflen, zbd_zone_capacity_end(z));
 		assert(false);
 	}
 	z->verify_block += io_u->buflen / min_bs;
@@ -1467,7 +1463,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
  * pointer, hold the mutex for the zone.
  */
 static struct fio_zone_info *
-zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint32_t min_bytes,
+zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint64_t min_bytes,
 	      struct fio_zone_info *zb, struct fio_zone_info *zl)
 {
 	struct fio_file *f = io_u->file;
@@ -1499,7 +1495,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint32_t min_bytes,
 				zone_unlock(z2);
 		}
 	}
-	dprint(FD_ZBD, "%s: no zone has %d bytes of readable data\n",
+	dprint(FD_ZBD, "%s: no zone has %"PRIu64" bytes of readable data\n",
 	       f->file_name, min_bytes);
 	return NULL;
 }
@@ -1672,10 +1668,9 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	    f->last_pos[ddir] >= zbd_zone_capacity_end(z)) {
 		dprint(FD_ZBD,
 		       "%s: Jump from zone capacity limit to zone end:"
-		       " (%llu -> %llu) for zone %u (%llu)\n",
-		       f->file_name, (unsigned long long) f->last_pos[ddir],
-		       (unsigned long long) zbd_zone_end(z), zone_idx,
-		       (unsigned long long) z->capacity);
+		       " (%"PRIu64" -> %"PRIu64") for zone %u (%"PRIu64")\n",
+		       f->file_name, f->last_pos[ddir],
+		       zbd_zone_end(z), zone_idx, z->capacity);
 		td->io_skip_bytes += zbd_zone_end(z) - f->last_pos[ddir];
 		f->last_pos[ddir] = zbd_zone_end(z);
 	}
@@ -1759,7 +1754,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len = io_u->buflen;
-	uint32_t min_bs = td->o.min_bs[io_u->ddir];
+	uint64_t min_bs = td->o.min_bs[io_u->ddir];
 	uint64_t new_len;
 	int64_t range;
 
@@ -1785,9 +1780,9 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 		if (io_u->offset + min_bs > (zb + 1)->start) {
 			dprint(FD_IO,
-			       "%s: off=%llu + min_bs=%u > next zone %llu\n",
+			       "%s: off=%llu + min_bs=%"PRIu64" > next zone %"PRIu64"\n",
 			       f->file_name, io_u->offset,
-			       min_bs, (unsigned long long) (zb + 1)->start);
+			       min_bs, (zb + 1)->start);
 			io_u->offset = zb->start + (zb + 1)->start - io_u->offset;
 			new_len = min(io_u->buflen, (zb + 1)->start - io_u->offset);
 		} else {
@@ -1878,9 +1873,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		if (io_u->buflen > zbdi->zone_size) {
 			td_verror(td, EINVAL, "I/O buflen exceeds zone size");
 			dprint(FD_IO,
-			       "%s: I/O buflen %llu exceeds zone size %llu\n",
-			       f->file_name, io_u->buflen,
-			       (unsigned long long) zbdi->zone_size);
+			       "%s: I/O buflen %llu exceeds zone size %"PRIu64"\n",
+			       f->file_name, io_u->buflen, zbdi->zone_size);
 			goto eof;
 		}
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
@@ -1917,9 +1911,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 			if (zb->capacity < min_bs) {
 				td_verror(td, EINVAL, "ZCAP is less min_bs");
-				log_err("zone capacity %llu smaller than minimum block size %d\n",
-					(unsigned long long)zb->capacity,
-					min_bs);
+				log_err("zone capacity %"PRIu64" smaller than minimum block size %"PRIu64"\n",
+					zb->capacity, min_bs);
 				goto eof;
 			}
 		}
@@ -1949,7 +1942,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto accept;
 		}
 		td_verror(td, EIO, "zone remainder too small");
-		log_err("zone remainder %lld smaller than min block size %d\n",
+		log_err("zone remainder %lld smaller than min block size %"PRIu64"\n",
 			(zbd_zone_capacity_end(zb) - io_u->offset), min_bs);
 		goto eof;
 	case DDIR_TRIM:
@@ -2006,7 +1999,7 @@ char *zbd_write_status(const struct thread_stat *ts)
 {
 	char *res;
 
-	if (asprintf(&res, "; %llu zone resets", (unsigned long long) ts->nr_zone_resets) < 0)
+	if (asprintf(&res, "; %"PRIu64" zone resets", ts->nr_zone_resets) < 0)
 		return NULL;
 	return res;
 }
