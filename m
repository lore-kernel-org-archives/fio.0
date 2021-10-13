Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E76FC4332F
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5042A60E74
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhJMGLR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:11:17 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:53719 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhJMGLN (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 02:11:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634105351; x=1665641351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Bio1SmU7HnXFxHqTq1/0YDFD+gPT6LVPoK4f3NbMCE=;
  b=PGHBNnsAe/0tBuuI65pqjWYTpRxWsoQE+8AXepC+GDJhZjP4fdxkfMS3
   RrS7rNawcCOeBTQCnX9Kx+UjZ3Hz/MUkbgjL9glx5RH6TzziiZ9eWj6dr
   v+6C1IUQ5YzS62MbI/355KW/oDplggl8P1jjlJkjw1DueSicJEO7x08pW
   qWajiEk/+5MdhHjs09MPJ/Zw0z5WTIBfuDJoBWcM54EQoAdEio6lSyRc/
   D0t4hvrvEh5lCipr+cLxf3ICHjs8CKY2OeunocVpIhd1JlArzar0Hs3dc
   tm+XZV0IGc5GeU/NMQf/NPo8WXLwMJmrPal0rXEdh6KB2aSb/ahSqW43e
   g==;
X-IronPort-AV: E=Sophos;i="5.85,369,1624291200"; 
   d="scan'208";a="181718925"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 14:09:10 +0800
IronPort-SDR: mgIk6C5PKtU/NGILgHFf3sdmY01B2hf0YUSdez9Vu2bYJlGQSTtyUQFTk+3AWnClNrsYtFHnAj
 hStLhyuHUHKdhvl5yv1P9ZX8GE4R8Tl/GfH+y3gIZSjqouzFsInc7CCiHDubZ6MOews7TVeQQA
 IzPL+0h1K9R7lT5ckrzqgvNmJMkpzj0fua1b6upJ2lh7yXImk5wdA9b+faZn4KORphkqKV8IWU
 bHmWv7xpMBBZPN7B+WIj4VgFQsl+IxOxE3tnaq+8Nmf66JTxHbrqmm5fxbKcx8+8iD5Oo+VVvV
 INwcGnbAATXd1/Za1w57Lmes
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 22:43:24 -0700
IronPort-SDR: ZIuksvev+xdDiWvnPW4m68PyRu+PpSl3kRcAXM/jznj+tmDluzNQrg1ZpdeuYCka46opjGPWG3
 2/0IiGO2JSLcbnb2jpmB/0OLdwRo48ebVDD/uKC44AAnDBuTemP5sbuSCXY575AHFcqhn+q6ip
 AAX+/+y5mrSQiYkzbR/8xWlp9giNSy6O0yEYNzaLQTbMrS0R8Yiw/FyoQBvJmzANVuatnTzh7D
 jjPR8y36KXvxtmngSnGCY2wtmOKwsLbBMlmWfrqR8Urx96t7cZfnSM5R22RfPQRf5o2ewNydGn
 k5I=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Oct 2021 23:09:10 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/5] t/zbd: Align block size to zone capacity
Date:   Wed, 13 Oct 2021 15:09:02 +0900
Message-Id: <20211013060903.166543-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test cases #5, #6, #15 and #37 writes data and read it back (or
write with verify option for read back). When test target zones have
zone capacity unaligned to the block size, read request can not be made
to all of the written data, and the test cases fail.

To avoid the failures, check zone capacity of zones and get block size
which can align to the zone capacities. Then use the block size for the
test cases.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions        | 26 ++++++++++++++++++++++++++
 t/zbd/test-zbd-support | 21 ++++++++++++---------
 2 files changed, 38 insertions(+), 9 deletions(-)

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
index f9dc9001..4ee46de3 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -321,15 +321,15 @@ test4() {
 
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
@@ -337,18 +337,18 @@ test5() {
 
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
@@ -486,7 +486,7 @@ test14() {
 
 # Sequential read on a mix of empty and full zones.
 test15() {
-    local i off size
+    local i off size bs
     local w_off w_size w_capacity
 
     for ((i=0;i<4;i++)); do
@@ -500,8 +500,9 @@ test15() {
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
@@ -853,7 +854,7 @@ test37() {
 	off=$(((first_sequential_zone_sector - 1) * 512))
     fi
     size=$((zone_size + 2 * 512))
-    bs=$((zone_size / 4))
+    bs=$(min $((zone_size / 4)) "$zone_cap_bs")
     run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
 		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
 		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
@@ -1378,6 +1379,8 @@ fi
 echo -n "First sequential zone starts at sector $first_sequential_zone_sector;"
 echo " zone size: $((zone_size >> 20)) MB"
 
+zone_cap_bs=$(zone_cap_bs "$dev" "$zone_size")
+
 if [ "${#tests[@]}" = 0 ]; then
     readarray -t tests < <(declare -F | grep "test[0-9]*" | \
 				   tr -c -d "[:digit:]\n" | sort -n)
-- 
2.31.1

