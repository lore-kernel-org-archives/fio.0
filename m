Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6AAC678D5
	for <fio@archiver.kernel.org>; Wed,  8 Mar 2023 13:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjCHNCX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Mar 2023 08:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjCHNBF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Mar 2023 08:01:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A389C560D
        for <fio@vger.kernel.org>; Wed,  8 Mar 2023 05:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=iV4mfTYLcXTWh7VS1wDRyJDXXcycpkbZAF8Iatblh10=; b=f9Inxq6JsUNiXc3dZMkzjN+xQo
        yhuSMYw3mH6dDm0xGJ1eGhVIspuCo04sBvBm2SRC5MG3ZhFT8H5QRZ2uGvZyEOC+YOCKoQe9a3w5o
        SgGNjIFVFqTB/CXUJ5kuuoCnrAoZsfUsCInb5qgiy4IDEAPt6EbqU+XToxs3DLzHIqv7TbQZGr1Yu
        wUng7hPMfawMIK9ggJmzdJpOwiSIL4BUjmojQT5KE0n+/ZSmRCcS8KXZFy5gbI1xKrUvYIMdhV4Ro
        bn8IQgSR4NvZcIyL/0AXxORx85O9KPnB+ogKLmES3slr/MZb24vOvXCEfYb7d82vIUNB0ulnLiuT+
        Es1aycow==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pZtOp-007PCr-7F
        for fio@vger.kernel.org; Wed, 08 Mar 2023 13:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6A1E01BC0183; Wed,  8 Mar 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230308130002.6A1E01BC0183@kernel.dk>
Date:   Wed,  8 Mar 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 051b5785bc47ab216fa3db9dceb6184073dcc88a:

  Merge branch 'For_Each_Td_Private_Scope' of https://github.com/horshack-dpreview/fio (2023-03-03 10:46:26 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 557cfc51068921766e8cd6b242feb4c929cb45ea:

  t/zbd: fix minimum write size to sequential write required zones (2023-03-07 12:45:41 -0500)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      t/zbd: rename logical_block_size to min_seq_write_size
      t/zbd: fix minimum write size to sequential write required zones

 t/zbd/functions        | 28 +++++++++++++++++++++++++---
 t/zbd/test-zbd-support | 42 +++++++++++++++++++++---------------------
 2 files changed, 46 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/functions b/t/zbd/functions
index 812320f5..9a6d6999 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -238,18 +238,40 @@ max_open_zones() {
     fi
 }
 
+# Get minimum block size to write to seq zones. Refer the sysfs attribute
+# zone_write_granularity which shows the valid minimum size regardless of zoned
+# block device type. If the sysfs attribute is not available, refer physical
+# block size for rotational SMR drives. For non-rotational devices such as ZNS
+# devices, refer logical block size.
+min_seq_write_size() {
+	local sys_path="/sys/block/$1/queue"
+	local -i size=0
+
+	if [[ -r "$sys_path/zone_write_granularity" ]]; then
+		size=$(<"$sys_path/zone_write_granularity")
+	fi
+
+	if ((size)); then
+		echo "$size"
+	elif (($(<"$sys_path/rotational"))); then
+		cat "$sys_path/physical_block_size"
+	else
+		cat "$sys_path/logical_block_size"
+	fi
+}
+
 is_zbc() {
 	local dev=$1
 
 	[[ -z "$(${zbc_info} "$dev" | grep "is not a zoned block device")" ]]
 }
 
-zbc_logical_block_size() {
+zbc_physical_block_size() {
 	local dev=$1
 
 	${zbc_info} "$dev" |
-		grep "logical blocks" |
-		sed -n 's/^[[:blank:]]*[0-9]* logical blocks of[[:blank:]]*//p' |
+		grep "physical blocks" |
+		sed -n 's/^[[:blank:]]*[0-9]* physical blocks of[[:blank:]]*//p' |
 		sed 's/ B//'
 }
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 893aff3c..996160e7 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -166,7 +166,7 @@ write_and_run_one_fio_job() {
     shift 2
     r=$(((RANDOM << 16) | RANDOM))
     write_opts=(--name="write_job" --rw=write "$(ioengine "psync")" \
-		      --bs="${logical_block_size}" --zonemode=zbd \
+		      --bs="${min_seq_write_size}" --zonemode=zbd \
 		      --zonesize="${zone_size}" --thread=1 --direct=1 \
 		      --offset="${write_offset}" --size="${write_size}")
     write_opts+=("${job_var_opts[@]}")
@@ -335,7 +335,7 @@ test4() {
     size=$((zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off")
-    opts+=(--bs="$(min $((logical_block_size * 256)) $size)")
+    opts+=(--bs="$(min $((min_seq_write_size * 256)) $size)")
     opts+=("--size=$size" "--thread=1" "--read_beyond_wp=1")
     opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--disable_lat=1")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
@@ -351,7 +351,7 @@ test5() {
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
-    bs=$(min "$(max $((zone_size / 64)) "$logical_block_size")" "$zone_cap_bs")
+    bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --bs="$bs" --do_verify=1 --verify=md5 \
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -367,7 +367,7 @@ test6() {
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
-    bs=$(min "$(max $((zone_size / 64)) "$logical_block_size")" "$zone_cap_bs")
+    bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
     write_and_run_one_fio_job \
 	    $((first_sequential_zone_sector * 512)) "${size}" \
 	    --offset="${off}" \
@@ -748,7 +748,7 @@ test30() {
     prep_write
     off=$((first_sequential_zone_sector * 512))
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw	\
-		    --bs="$(max $((zone_size / 128)) "$logical_block_size")"\
+		    --bs="$(max $((zone_size / 128)) "$min_seq_write_size")"\
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off\
 		    --loops=2 --time_based --runtime=30s --norandommap=1\
 		    >>"${logfile}.${test_number}" 2>&1
@@ -904,9 +904,9 @@ test38() {
     local bs off size
 
     prep_write
-    size=$((logical_block_size))
-    off=$((disk_size - logical_block_size))
-    bs=$((logical_block_size))
+    size=$((min_seq_write_size))
+    off=$((disk_size - min_seq_write_size))
+    bs=$((min_seq_write_size))
     run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
 		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
 		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
@@ -924,7 +924,7 @@ read_one_block() {
 	exit 1
     fi
     off=${result[0]}
-    bs=$((logical_block_size))
+    bs=$((min_seq_write_size))
     run_one_fio_job --rw=read "$(ioengine "psync")" --offset=$off --bs=$bs \
 		    --size=$bs "$@" 2>&1 |
 	tee -a "${logfile}.${test_number}"
@@ -934,14 +934,14 @@ read_one_block() {
 test39() {
     require_zbd || return $SKIP_TESTCASE
     read_one_block --zonemode=none >/dev/null || return $?
-    check_read $((logical_block_size)) || return $?
+    check_read $((min_seq_write_size)) || return $?
 }
 
 # Check whether fio accepts --zonemode=strided for zoned block devices.
 test40() {
     local bs
 
-    bs=$((logical_block_size))
+    bs=$((min_seq_write_size))
     require_zbd || return $SKIP_TESTCASE
     read_one_block --zonemode=strided |
 	grep -q 'fio: --zonesize must be specified when using --zonemode=strided' ||
@@ -982,7 +982,7 @@ test45() {
 
     require_zbd || return $SKIP_TESTCASE
     prep_write
-    bs=$((logical_block_size))
+    bs=$((min_seq_write_size))
     run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
 		    --offset=$((first_sequential_zone_sector * 512)) \
 		    --size="$zone_size" --do_verify=1 --verify=md5 2>&1 |
@@ -1007,7 +1007,7 @@ test47() {
     local bs
 
     prep_write
-    bs=$((logical_block_size))
+    bs=$((min_seq_write_size))
     run_fio_on_seq "$(ioengine "psync")" --rw=write --bs=$bs --zoneskip=1 \
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'zoneskip 1 is not a multiple of the device zone size' "${logfile}.${test_number}"
@@ -1190,7 +1190,7 @@ test54() {
 # test 'z' suffix parsing only
 test55() {
 	local bs
-	bs=$((logical_block_size))
+	bs=$((min_seq_write_size))
 
 	require_zbd || return $SKIP_TESTCASE
 	# offset=1z + offset_increment=10z + size=2z
@@ -1216,7 +1216,7 @@ test55() {
 # test 'z' suffix parsing only
 test56() {
 	local bs
-	bs=$((logical_block_size))
+	bs=$((min_seq_write_size))
 
 	require_regular_block_dev || return $SKIP_TESTCASE
 	require_seq_zones 10 || return $SKIP_TESTCASE
@@ -1260,7 +1260,7 @@ test58() {
     require_seq_zones 128 || return $SKIP_TESTCASE
 
     size=$((zone_size * 128))
-    bs="$(max $((zone_size / 128)) "$logical_block_size")"
+    bs="$(max $((zone_size / 128)) "$min_seq_write_size")"
     prep_write
     off=$((first_sequential_zone_sector * 512))
     run_fio --zonemode=zbd --direct=1 --zonesize="${zone_size}" --thread=1 \
@@ -1427,7 +1427,7 @@ if [[ -b "$realdev" ]]; then
 		realsysfs=$(readlink "/sys/dev/block/$major:$minor")
 		basename=$(basename "${realsysfs%/*}")
 	fi
-	logical_block_size=$(<"/sys/block/$basename/queue/logical_block_size")
+	min_seq_write_size=$(min_seq_write_size "$basename")
 	case "$(<"/sys/class/block/$basename/queue/zoned")" in
 	host-managed|host-aware)
 		is_zbd=true
@@ -1452,8 +1452,8 @@ if [[ -b "$realdev" ]]; then
 		;;
 	*)
 		first_sequential_zone_sector=$(((disk_size / 2) &
-						(logical_block_size - 1)))
-		zone_size=$(max 65536 "$logical_block_size")
+						(min_seq_write_size - 1)))
+		zone_size=$(max 65536 "$min_seq_write_size")
 		sectors_per_zone=$((zone_size / 512))
 		max_open_zones=128
 		set_io_scheduler "$basename" none || exit $?
@@ -1476,8 +1476,8 @@ elif [[ -c "$realdev" ]]; then
 		echo "Failed to determine disk size"
 		exit 1
 	fi
-	if ! logical_block_size=($(zbc_logical_block_size "$dev")); then
-		echo "Failed to determine logical block size"
+	if ! min_seq_write_size=($(zbc_physical_block_size "$dev")); then
+		echo "Failed to determine physical block size"
 		exit 1
 	fi
 	if ! result=($(first_sequential_zone "$dev")); then
