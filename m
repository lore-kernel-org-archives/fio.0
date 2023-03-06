Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F29C61DA3
	for <fio@archiver.kernel.org>; Mon,  6 Mar 2023 05:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjCFF6q (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 6 Mar 2023 00:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCFF6p (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Mar 2023 00:58:45 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A932659F8
        for <fio@vger.kernel.org>; Sun,  5 Mar 2023 21:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678082323; x=1709618323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rRz6kcn+T6I4X9I4hFf3AVXDmVS5ciauD4zdfDh1Lbs=;
  b=hPstbEk5sEZvb0bGJp2EAsZ7HlI1wP8780lfEfHOTDCDlXeEDbPzfrCq
   1lrZsjOlDc6N1wmVX5/M0ZFPXADj9x0xxhA9qjKK2y/ac12EE5mrgOvNg
   Ss3Sx3jtZeu1+YajOjbw/deO3kpSpZwadbgwTtO/34eWzwARC4DgSOcOv
   S3ss9FZFEepF7M8leZPrjho9Fgmns6IAN64Yexl/rBVx7WCqdFhCF+ccp
   c4h2eaU1BVlGU/JZAumBvK6FXAzsJ9MZ4I5l7fXnb70nr9p5d6qnkyn/i
   E0LNq/wjrly/tryCI2RF9ZY+tS4Ylz+up3KchFh/T9G447q0wLl7q3T2d
   w==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="223161443"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 13:58:42 +0800
IronPort-SDR: 5aF2Vahtt7KZW45+wj+V/Q3lhozFmzeJXwwnmfzkKnC7Tqf0vE5R1XJgRwTeZo5iAYIg931RKr
 W8lce2dRJWoOHaxyA4IP4JdAH7uHKJIHohR2siXID3O6NY8P61+JejY3lbF5M6aNaG+QFTirQK
 dZxxCqxJ9sNJSDbqfhpM4RfLALTCFM8tfP1YEGVWws7SdOLmIiJByWAA5W7JoJnuf8uhcRULTt
 N+MSQ1D25OWfcUB6rB5EubFWZPGrLXSooGA3NbCVM1mHuMoq/McaG8AtgZI4ib5N9W9tbZLxuj
 u0k=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2023 21:15:24 -0800
IronPort-SDR: sWkcZ3j/M9Ue2tg5AUJXyqzTzxR4+PA0SJ6i5cq8mN+o2EMQS6JEFOAihc22aoAlSOfBMnwkn1
 SUulmjyV/2YvACYb0bWOjUlKKBusL4k9mJz8pJn0vtSjGChQacIwIa8uh3wJ2youN/ZxCkLoRB
 2rY/pEic6DmEq6pqPy1+GwW8t+IeB9kkuj5pNHEG7M7uRaKim+D7UD37MUDMxpCauk3a3Es/IR
 BFAOjr5aLGdT34CBeOe1CkPFP89DitdW9orX3udv9zvuXo+0XJbCOJb+gSOqQP7VO5HB7N7fTH
 KSo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2023 21:58:43 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] t/zbd: rename logical_block_size to min_seq_write_size
Date:   Mon,  6 Mar 2023 14:58:39 +0900
Message-Id: <20230306055840.3375830-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230306055840.3375830-1-shinichiro.kawasaki@wdc.com>
References: <20230306055840.3375830-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test script t/zbd/test-zbd-support assumes that the logical block
size is the minimum size unit to write to sequential write required
zones, then it uses a variable named 'logical_block_size' to keep the
minimum size. The assumption is true for ZNS devices but not for ZBC/ZAC
devices. Rename the variable from 'logical_block_size' to
'min_seq_write_size' to not imply the wrong assumption.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 893aff3c..7b229002 100755
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
+	min_seq_write_size=$(<"/sys/block/$basename/queue/logical_block_size")
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
@@ -1476,7 +1476,7 @@ elif [[ -c "$realdev" ]]; then
 		echo "Failed to determine disk size"
 		exit 1
 	fi
-	if ! logical_block_size=($(zbc_logical_block_size "$dev")); then
+	if ! min_seq_write_size=($(zbc_logical_block_size "$dev")); then
 		echo "Failed to determine logical block size"
 		exit 1
 	fi
-- 
2.38.1

