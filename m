Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926F9C4332F
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiKNCNg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiKNCNe (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:34 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EB910D4
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392012; x=1699928012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3aryCzR2/xCOnl/I7wy1PTx4lcISITdd1s2lim9kBbM=;
  b=PH/TuSjJq+496sTyPqU8tn4vtVgxBlVDoj3BGHGc7RGTa/cVIsm+PSx9
   dzjTI/23WDPdkNb+KT5iXcyG4CjxkOnKxmJiyc/pRmpOYe6NuMrr53hfY
   dCLDXmRdUvYNgwt6CL5jua0pCG/SQP3G04YPWLjLcy4RQX1roZuvzKR1a
   AzS6N0W7DyAFiZwMLmYm7Qn2hkChv9+ymQq+R5cVkcMaTJ1ctgF2us2rb
   RUM2agRQHoBUqEjRAARiPzNdnpOgYOff1XCP1z8frL9XGhGwIhlPKsuwn
   T6XGDTr/EtslzMbLCchvEv713BeJmUUH0sA+cRkPfsN0OmeGeZIyJjFx0
   A==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279247"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:32 +0800
IronPort-SDR: xVexLB9xKxVIevXjWrgGzvIFDjkbQryfTpdrYaw58j1P73fvxrdSXkZsqpwHpPxXljESaS7UTS
 buhbldHgKrGGLSVWp1/a+ZfaU2pH+pQcMEeKBLDRNLvlledl7F6LY8pHgph5sVmzI4hhDgTE2A
 c1V+CsYBqAxmOG9SIzblBWQjxViHNEStmCiWUdpaAfvAbmHO5OoKMAwzEhcoNI3j62NvUpBcpB
 Mtwhlf+WcZwaqPRVU2zRWaHN/uuO+3/orvYL2l3oKGHrMjjsFSO4TLsn2nbqBGRzVfYnNni6JX
 vx0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:31 -0800
IronPort-SDR: Aay0WQgJfQdw1zrjaOKaBaQvnle31G0rvI+M4OT3VxEMrWdRUrWznhTeDTSI+u44zP96UJBZQ/
 FCUpsAaVTNs9mhAh957wJmet21y+BWrYPC+ttlEKZb+bfMcL91y5qlK/CA5FC9q3e4C5SJOak2
 k0rNlVNTM5aUPeHskQyQtJ0MfV7wgaqsmvHqdML0ouTYL9YyWMTnpGNJIcMdswtzYvzI2TQr4W
 A6ON0yGYjwxkgHhQSWGYNQ0AjrHb0l9ShAMhSlSEYlQAN4pvO/b//WoOfMJ8GZvwJPSo5Z8mtg
 t1I=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:31 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 10/13] t/zbd: modify test case #34 for block size unaligned to zone size
Date:   Mon, 14 Nov 2022 11:13:05 +0900
Message-Id: <20221114021308.1684141-11-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test case #34 confirmed that the block size unaligned to zone size
is handled as an error. After recent fix, now fio is able to handle such
block sizes, then the check for the error is no longer required.

Instead of removing this unnecessary test case, change it to cover
verify with complex workload. It runs random write workload with high
queue depth with verify. Use two types of block sizes unaligned to zone
size. This test workload is same as test case #57 except the verify
option and block sizes.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index debe3763..37af6724 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -826,17 +826,27 @@ test33() {
     check_written $((io_size / bs * bs)) || return $?
 }
 
-# Write to sequential zones with a block size that is not a divisor of the
-# zone size and with data verification enabled.
+# Test repeated async write job with verify using two unaligned block sizes.
 test34() {
-    local size
+	local bs off zone_capacity
+	local -a block_sizes
 
-    prep_write
-    size=$((2 * zone_size))
-    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write --size=$size \
-		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
-		   >> "${logfile}.${test_number}" 2>&1 && return 1
-    grep -q 'not a divisor of' "${logfile}.${test_number}"
+	require_zbd || return $SKIP_TESTCASE
+	prep_write
+
+	off=$((first_sequential_zone_sector * 512))
+	zone_capacity=$(total_zone_capacity 1 $off $dev)
+	block_sizes=($((4096 * 7)) $(($(min ${zone_capacity} 4194304) - 4096)))
+
+	for bs in ${block_sizes[@]}; do
+		run_fio --name=job --filename="${dev}" --rw=randwrite \
+			--bs="${bs}" --offset="${off}" \
+			--size=$((4 * zone_size)) --iodepth=256 \
+			"$(ioengine "libaio")" --time_based=1 --runtime=15s \
+			--zonemode=zbd --direct=1 --zonesize="${zone_size}" \
+			--verify=crc32c --do_verify=1 ${job_var_opts[@]} \
+			>> "${logfile}.${test_number}" 2>&1 || return $?
+	done
 }
 
 # Test 1/4 for the I/O boundary rounding code: $size < $zone_size.
-- 
2.37.1

