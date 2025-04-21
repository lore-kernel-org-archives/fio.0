Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99258264FBA
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239122; cv=none; b=LEU705ZpdxlXEcbOxG3ryuXgF61bm5svEwHpslQEv2i6XVz8+tJ+/Y1uFLKayhMZGmb3rntJTqyjPvXcdvxiK6vnmGr4TVwuztfKtpI/8WHHIeWDoXRoc5/RwaDK60BrWMDa35i/dtniBRnQe2HznpweLN6PaUCl7lSSQ/QWTlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239122; c=relaxed/simple;
	bh=gVwGvCmRkfXjkthi6g326aeD6/pCnHnxMzJqWUmovjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8kzuqwwvEcQWYsCPLQSiIYVQw+ox4HkA0L3LEYlIbDJ9kg/xDMqscF+opYr0hLqHO3IZnvSvy/mFhxlp1LhqihLpPsMVDbPnjOzucKyjdyYW/utjJ85TCldI2qt25Uvq7oyi4ozOJIRlx7Wu1tQVmfbUFzD4wp9+yKDxinHIao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Fj3bXhqY; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Fj3bXhqY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239120; x=1776775120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gVwGvCmRkfXjkthi6g326aeD6/pCnHnxMzJqWUmovjQ=;
  b=Fj3bXhqYb2eZHyD7X3GUOjmj0j7da1rcERvzoVBypnJCFn26NRcwWSuq
   zw25GMGZUC9mPjuaw5XnYnbXpdPsLSvOHoBRpiROAhuViIc4E1kwDdFnZ
   4+9W46s2VI2nNZvh+n9383Tql7BM0HGTTzErmYkyt4hz8k3KhioPtnHLF
   6mdEOVcqOiq7Sakq5AuM3f1O9ADpvFwACRtmecvAA9UvESTYai4TmlKqf
   sWmPjzGbdj5SFRckpoL51QlvgTeHlZ4Y1qy1rHmCH6hodGgMXtgH/Bleh
   l109hW3d7zLlt4FNnN5e+5D+HloWjzg2x184zVZVRvelzfQGQ6qzpvbcD
   g==;
X-CSE-ConnectionGUID: POmdeOHMSWuzvl6A6esVQg==
X-CSE-MsgGUID: tR6jEuntQIiCnYWSFzMeGg==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027527"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:37 +0800
IronPort-SDR: 68062e37_3ZdDN8q6HWDYMYUkgaOTV/ltA5hLYRkf3adf0CoGhKQDZP+
 L9rnp8g+MGZ0ZxE3b5aNhbQfdKBjtQBkS2O/FaQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:31 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:36 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 7/8] t/zbd: add the test cases to confirm continue_on_error option
Date: Mon, 21 Apr 2025 21:38:27 +0900
Message-ID: <20250421123828.82712-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the continue_on_error option is specified, it is expected that
write workloads do not stop even when bad blocks cause IO errors and
leave partially written data. Add a test cases to confirm it with
zonemode=zbd and the new option recover_zbd_write_error.

To create the IO errors as expected, use null_blk and scsi_debug.
Especially, use null_blk and its parameters badblocks and
badblocks_once, which can control the block to cause the IO error.
Introduce helper functions which confirms the parameters for bad blocks
are available, and sets up the bad blocks.

Using the helper functions, add four new test cases. The first two cases
confirm that the fio recovers after the IO error with partial write.
One test case covers psync IO engine. The other test case covers async
IO with libaio engine with high queue depth and multiple jobs. The last
two test cases confirm the case that another IO error happen again
during the recovery process from the IO error.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 185 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 0278ac17..40f1de90 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -60,6 +60,17 @@ get_dev_path_by_id() {
 	return 1
 }
 
+get_scsi_device_path() {
+	local dev="${1}"
+	local syspath
+
+	syspath=/sys/block/"${dev##*/}"/device
+	if [[ -r /sys/class/scsi_generic/"${dev##*/}"/device ]]; then
+		syspath=/sys/class/scsi_generic/"${dev##*/}"/device
+	fi
+	realpath "$syspath"
+}
+
 dm_destination_dev_set_io_scheduler() {
 	local dev=$1 sched=$2
 	local dest_dev_id dest_dev path
@@ -354,6 +365,49 @@ require_no_max_active_zones() {
 	return 0
 }
 
+require_badblock() {
+	local syspath sdebug_path
+
+	syspath=/sys/kernel/config/nullb/"${dev##*/}"
+	if [[ -d "${syspath}" ]]; then
+		if [[ ! -w "${syspath}/badblocks" ]]; then
+			SKIP_REASON="$dev does not have badblocks attribute"
+			return 1
+		fi
+		if [[ ! -w "${syspath}/badblocks_once" ]]; then
+			SKIP_REASON="$dev does not have badblocks_once attribute"
+			return 1
+		fi
+		if ((! $(<"${syspath}/badblocks_once"))); then
+			SKIP_REASON="badblocks_once attribute is not set for $dev"
+			return 1
+		fi
+		return 0
+	fi
+
+	syspath=$(get_scsi_device_path "$dev")
+	if [[ -r ${syspath}/model &&
+		      $(<"${syspath}"/model) =~ scsi_debug ]]; then
+		sdebug_path=/sys/kernel/debug/scsi_debug/${syspath##*/}
+		if [[ ! -w "$sdebug_path"/error ]]; then
+			SKIP_REASON="$dev does not have write error injection"
+			return 1
+		fi
+		return 0
+	fi
+
+	SKIP_REASON="$dev does not support either badblocks or error injection"
+	return 1
+}
+
+require_nullb() {
+	if [[ ! -d /sys/kernel/config/nullb/"${dev##*/}" ]]; then
+		SKIP_REASON="$dev is not null_blk"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused for block devices.
 test1() {
     require_block_dev || return $SKIP_TESTCASE
@@ -1685,6 +1739,137 @@ test71() {
 	check_written $((zone_size * 8)) || return $?
 }
 
+set_nullb_badblocks() {
+	local syspath
+
+	syspath=/sys/kernel/config/nullb/"${dev##*/}"
+	if [[ -w $syspath/badblocks ]]; then
+		echo "$1" > "$syspath"/badblocks
+	fi
+
+	return 0
+}
+
+# The helper function to set up badblocks or error command and echo back
+# number of expected failures. If the device is null_blk, set the errors
+# at the sectors based of 1st argument (offset) and 2nd argument (gap).
+# If the device is scsi_debug, set the first write commands to fail.
+set_badblocks() {
+	local off=$(($1 / 512))
+	local gap=$(($2 / 512))
+	local syspath block scsi_dev
+
+	# null_blk
+	syspath=/sys/kernel/config/nullb/"${dev##*/}"
+	if [[ -d ${syspath} ]]; then
+		block=$((off + 2))
+		set_nullb_badblocks "+${block}-${block}"
+		block=$((off + gap + 11))
+		set_nullb_badblocks "+${block}-${block}"
+		block=$((off + gap*2 + 8))
+		set_nullb_badblocks "+${block}-${block}"
+
+		echo 3
+		return
+	fi
+
+	# scsi_debug
+	scsi_dev=$(get_scsi_device_path "$dev")
+	syspath=/sys/kernel/debug/scsi_debug/"${scsi_dev##*/}"/
+	echo 2 -1 0x8a 0x00 0x00 0x02 0x03 0x11 0x02 > "$syspath"/error
+
+	echo 1
+}
+
+# Single job sequential sync write to sequential zones, with continue_on_error
+test72() {
+	local size off capacity bs expected_errors
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_badblock || return "$SKIP_TESTCASE"
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+	bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
+	expected_errors=$(set_badblocks "$off" "$zone_size")
+	size=$((4 * zone_size))
+	capacity=$((size - bs * expected_errors))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --offset="$off" \
+		       --size="$size" --bs="$bs" --do_verify=1 --verify=md5 \
+		       --continue_on_error=1 --recover_zbd_write_error=1 \
+		       --ignore_error=,EIO:61 --debug=zbd \
+		       >>"${logfile}.${test_number}" 2>&1 || return $?
+	check_written "$capacity" || return $?
+	grep -qe "Write pointer move succeeded" "${logfile}.${test_number}"
+}
+
+# Multi job sequential async write to sequential zones, with continue_on_error
+test73() {
+	local size off capacity bs
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_badblock || return "$SKIP_TESTCASE"
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+	bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
+	set_badblocks "$off" "$zone_size" > /dev/null
+	capacity=$(total_zone_capacity 4 "$off" "$dev")
+	size=$((zone_size * 4))
+	run_fio --name=w --filename="${dev}" --rw=write "$(ioengine "libaio")" \
+		--iodepth=32 --numjob=8 --group_reporting=1 --offset="$off" \
+		--size="$size" --bs="$bs" --zonemode=zbd --direct=1 \
+		--zonesize="$zone_size" --continue_on_error=1 \
+		--recover_zbd_write_error=1 --debug=zbd \
+		>>"${logfile}.${test_number}" 2>&1 || return $?
+	grep -qe "Write pointer move succeeded" \
+	     "${logfile}.${test_number}"
+}
+
+# Single job sequential sync write to sequential zones, with continue_on_error,
+# with failures in the recovery writes.
+test74() {
+	local size off bs
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_nullb || return "$SKIP_TESTCASE"
+	require_badblock || return "$SKIP_TESTCASE"
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+	bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
+	set_badblocks "$off" "$((bs / 2))" > /dev/null
+	size=$((4 * zone_size))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --offset="$off" \
+		       --size="$size" --bs="$bs" --continue_on_error=1 \
+		       --recover_zbd_write_error=1 --ignore_error=,EIO:61 \
+		       >>"${logfile}.${test_number}" 2>&1 || return $?
+	grep -qe "Failed to recover write pointer" "${logfile}.${test_number}"
+}
+
+# Multi job sequential async write to sequential zones, with continue_on_error
+# with failures in the recovery writes.
+test75() {
+	local size off bs
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_nullb || return "$SKIP_TESTCASE"
+	require_badblock || return "$SKIP_TESTCASE"
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+	bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
+	set_badblocks "$off" $((bs / 2)) > /dev/null
+	size=$((zone_size * 4))
+	run_fio --name=w --filename="${dev}" --rw=write "$(ioengine "libaio")" \
+		--iodepth=32 --numjob=8 --group_reporting=1 --offset="$off" \
+		--size="$size" --bs="$bs" --zonemode=zbd --direct=1 \
+		--zonesize="$zone_size" --continue_on_error=1 \
+		--recover_zbd_write_error=1 --debug=zbd \
+		>>"${logfile}.${test_number}" 2>&1 || return $?
+	grep -qe "Failed to recover write pointer" "${logfile}.${test_number}"
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.49.0

