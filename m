Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44876FA3741
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiJ1LyN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJ1LyL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:11 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE841D2F52
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958049; x=1698494049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9jPnnjN+AgrmtRFfokTzVQ5/zCKJpS+zSjT5AqDsMJs=;
  b=IoJnM2njed0EWRvy/fmuWAkal0jPYaxsH3wfU+YRwWNrCXanoOdUydIl
   fU2PkDWwn+3u6wdHaJ2LmOcPudtKpl5WQH4WccO2KAw+LmH6KegqNz6W9
   rj3SSqSROG+UpQhG2VNVKVcPYr7ZIwYIgXAut1o6tyW1qETRbeJpNEzRN
   Fj1Mh39EyIL+S6AZ6z+s28k95R2mLm5pTAJ5OBUfm8N+2/pzSfIcqYvL7
   JjchDgwaQ2B6e2LFXIImR2vJeNU287hqGhs/e15kzkCjpxqzE0osJsERX
   91B7ui5oboXf8fh3oARyVuchXZRU3iHKVVLOhIrx0dQPL3HuCMB7vJKN6
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074535"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:09 +0800
IronPort-SDR: JUg3y9mL1s0gAoBsHhcB33d4D59eJN1+5E3i5XEn6V7uAAg0slWIEJ9Mm7jOl4QYUkaGi+eYAd
 2x5kLwUnN2lOUTd7eRtQNvT6lXtfb5cadOhjsAvVPil3wME7pDaOU49DAJ5n2ws2h5D+wuWu0L
 IsyhmaRit/GkfZDydMghfhWz9KrRMba1gxISPuJPcxHtlwuCyL1KHQC/oX7SB4IBdvDQ7kEH6D
 7ZRjam7RtNOwc0+CpaDCCSlrowrs6ixrUcXiSi234pIqr18VOOTgX2lD1xrbi6KVFteaHpySe/
 IvzcPQ2QX2Bp5GIUv+cRGaWo
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:45 -0700
IronPort-SDR: YjwKn8+HjbURHfzFq3FRdLb5B+zMHLIGQhEjt/paresZ2WL8cAdtl/BTD8uCZLEh4roKFL1+OR
 wcGkS/+m+iyO4Y0bZ4rFtzXK3Blz50oo15F/tE7JcvOvxdeySsayQPmNiXmfiwH93uOxBRUhmW
 zMxBTe2Mmte6dMZGBpdYlX4oTFtC/Sn1O2rFF1KpgpYOaXorBlInhlxNPci8OohC9k2w8FPo49
 Ws7NDG8NZghiLzAI3aTYCmstNnhUNglhMipWBa1u1YwZx5abYXMcvIvjL3WgZGCAU2PB2sgOgm
 dyc=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:08 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 09/13] t/zbd: fix test case #33 for block size unaligned to zone size
Date:   Fri, 28 Oct 2022 20:53:50 +0900
Message-Id: <20221028115354.971715-10-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent fix of zonemode=zbd support for block size unaligned to zone size
unveiled that the test case #33 has two issues.

First issue is test preparation. Before the fix, write was done to only
to the first zone due to a bug in zone selection which happens when
block size is not a divisor of zone size. Then, status of second zone
did not affect. After the fix, write count to the zones may vary if the
second zone has almost full status since the zone is skipped from write
target. Fix this by resetting the write target zones.

Second issue is expected written data size. The test case checks that
the written data size is larger than the io_size option value. This
expectation was fine before the fix because data write was repeated in
do_io() and the limit was checked with io_issue_bytes_exceeded(),
which triggers loop break when written data is larger than io_size.
However, after the fix, the limit is checked with keep_running() in
thread_main(). According to code and block comment in keep_running(),
fio job terminates even when written data size is smaller than io_size
if the gap is smaller than maximum IO size. Then the expected written
data size is the largest multiple of block size smaller than or equal to
the io_size. This io_size check change resulted in the test case
failure. Avoid the failure by fixing the expected written data size
calculation.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index cdc03f28..debe3763 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -813,7 +813,8 @@ test33() {
     local bs io_size size
     local off capacity=0;
 
-    prep_write
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
     size=$((2 * zone_size))
@@ -822,7 +823,7 @@ test33() {
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $(((io_size + bs - 1) / bs * bs)) || return $?
+    check_written $((io_size / bs * bs)) || return $?
 }
 
 # Write to sequential zones with a block size that is not a divisor of the
-- 
2.37.1

