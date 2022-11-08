Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F46FC4332F
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiKHIuC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiKHIt4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:56 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6F72E9F6
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897395; x=1699433395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5s3Z6xoOsVC4grSDdaCsREyts+EZ6uPuBb7P6WY/Ejc=;
  b=fl304Ag6BysiV9KrswSrc/FxW5YfMXFghmcnuSM8CtENpXHpbf1Ba2KF
   /2v4e2pSyHwteq2r9CC35nqBsR+ypdnRvjJCNUVaWts44PzUJaw0xLt1s
   sTknDoI+j21GeQFYHV5fYoStLjrkd96yK83CLLV8Edv91vRK9L76Q6Nu9
   x6l/2g/NOS5uecZ9Va101pZWg/TTFPDVIoTnLh+sQHVdJQf34OAl+gWD4
   vJp1peY9/iruBdD3j9uGrvFO3zp7B8V9RWHVkloVIUS4HGnndUpmgaumN
   tQx7pfxFp8uY7IVV49w2Z9AI6CXVHNkDw3kmHaSxbb8rWBGmAC29q43+b
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="215743477"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:55 +0800
IronPort-SDR: 0u8gHPn5tuFHittx9MqJT2BPWCGv4g6x3tzAYJT3ci62kUKBPV3GLV44ri41N6avcvWWJXwkYP
 dVxJR/c0uXI2o4NuAeMCwENKvGJvZh2Xxm305fyZ10xO8N/nEDcaotASJXxpjb2a0oF3Yvcx9V
 XwRONx6l8U3tNBUtBmslIagboti73Ox2T6vZ3PmPil9fzklH+OEhfzNifd9IMWCYAWLUNlRTOl
 1W51l0fTd/o3kajFvp9och3n4YKAK/j8AqQwXf+SGQ08Kxv23lDyHrmBKpoRhpqKfrWVE0X4So
 KQo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:16 -0800
IronPort-SDR: xP+5Z/LFCMsjNcOOZGA5cEICzdw8jh+7lL79GCML72MiVPxjqfEr1UwNI1Bm+jBuW7Lni08pNN
 qQ9yQPzPQkyQdo8mttvCGHEdfHRig5aylqqEaLWMVpXwzmjwnBLBS/9WdEsSjI1oakxmfuncYP
 W9lcboaz89OxsuPClORRhyh+xLe/2Kw762xAhH67vihHdcb28LsNpDq2vwxc4cSyAUGEwMVXmO
 PoO9BCUrjBsX7KaY5MWz6c9GvYrnrFPmII6P9shAhhrkM3a2tsHCq5HSus9Zfk1PHzu1o9CTSF
 5WE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:54 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 10/13] t/zbd: modify test case #34 for block size unaligned to zone size
Date:   Tue,  8 Nov 2022 17:49:37 +0900
Message-Id: <20221108084940.1574939-11-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
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

