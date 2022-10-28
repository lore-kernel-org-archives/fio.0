Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76977C38A02
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJ1LyR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJ1LyQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:16 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170351D2F49
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958052; x=1698494052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5s3Z6xoOsVC4grSDdaCsREyts+EZ6uPuBb7P6WY/Ejc=;
  b=McnSge+msDnxKj/gDqL/JMrcbqxzrrn+1Rf/Dgr5MYIk1Xd9+3EsgROz
   D8VqE+7eC7nmxp737j8H0omaNv4RZHiuNy0eZLFlQmgAgit8Soe4pbyA3
   qY6sJUN+Z7QzbNJsc4Xt9g4QpJGw0wYDMhYTuJcG3hNAUCwIdYeuYxSsN
   PShPpeaMAAZIj1zbOm/p2yGJzsQRnRBP9KYJnCH48lz3ZMLJO+DyKj35Y
   sGclQhiJgoSxkfWsxE06+DmhLGxtIIePXad0FkGY29a8G48HPni3lq9AK
   2hK4FH61vjoHEu7xx7t76O3Q2tBhAdoz/3fFvdiaRFdawZLOvR5IlvqiC
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074541"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:12 +0800
IronPort-SDR: 63pps+DLVaEbDlYke8VOWVdlq4sqTyHUE7X90BmMWhxGY6szoU/GzInT6hMZXtK6vY6eNr4uo2
 AA1tpfsUJvKHLiRXng9OpepzzPLqaCcR72AS4xl/btyZOhfaRqoh0pcoeFmmeOLyBAQZea40mW
 83g6zME1/Q4TKXWAfF0bRrCUuMQxqvZLfrqKRaXSXrQHdhK7WVECWuLzy9a3WPLQvJKbxDaZYf
 WRplC5Fs9haT/DwlrZ5ZLFkNAfvDe15tHsknEMfzRIswlbrm8rOvL6uRWYnl5Ff10qL92OjbmB
 IF/Qav/mDhsZvg+Q/rauZkE/
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:49 -0700
IronPort-SDR: sCsULWcTH8vx0KPZZFCZzVavtfXdMIJHPFdCQN6ntfq32BUJq5SY1TdSmS8dqx8C12ySKofxck
 uzSOb5wz4brVOnGv4hk5lk4bSjNvB8bsFQ2+u0MhVCnni1qx0yDFg+xjVlkQCTvUf6kpbqusG7
 pYh70g+/355sPfo2YdKJyfm943GUC1rDoXBmWbdjMZpvJ4HkNuedy6qKwIXZnygSIQNDR4yerM
 na+3YdfWCdcuJ2RVMkbPci9V+wBSqsPnvda41XyBeQkpqpmChR1DrV1JONlfuA+p/FFKnvlitF
 GJU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:10 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 10/13] t/zbd: modify test case #34 for block size unaligned to zone size
Date:   Fri, 28 Oct 2022 20:53:51 +0900
Message-Id: <20221028115354.971715-11-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test case #34 confirmed that the block size unaligned to zone size
is handled as an error. After recent fix, now fio is able to handle such
block sizes, then the check for the error is no longer required.

Instead of removing this unnecessary test case, change it to cover
verify with complex workload. It runs read-write mix workload with high
queue depth with verify and block size unaligned to zone size. This test
is same as test case #57 except the verify option.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index debe3763..e17a81de 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -826,17 +826,23 @@ test33() {
     check_written $((io_size / bs * bs)) || return $?
 }
 
-# Write to sequential zones with a block size that is not a divisor of the
-# zone size and with data verification enabled.
+# Test repeated async write job with verify.
 test34() {
-    local size
+	local bs off
 
-    prep_write
-    size=$((2 * zone_size))
-    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write --size=$size \
-		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
-		   >> "${logfile}.${test_number}" 2>&1 && return 1
-    grep -q 'not a divisor of' "${logfile}.${test_number}"
+	require_zbd || return $SKIP_TESTCASE
+	prep_write
+
+	bs=$((4096 * 7))
+	off=$((first_sequential_zone_sector * 512))
+
+	run_fio --name=job --filename="${dev}" --rw=randwrite --bs="${bs}" \
+		--offset="${off}" --size=$((4 * zone_size)) --iodepth=256 \
+		"$(ioengine "libaio")" --time_based=1 --runtime=30s \
+		--zonemode=zbd --direct=1 --zonesize="${zone_size}" \
+		--verify=crc32c --do_verify=1 \
+		${job_var_opts[@]} \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
 # Test 1/4 for the I/O boundary rounding code: $size < $zone_size.
-- 
2.37.1

