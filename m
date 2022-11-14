Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEDCC4332F
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbiKNCNd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiKNCNb (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:31 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2BB1092
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392010; x=1699928010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9jPnnjN+AgrmtRFfokTzVQ5/zCKJpS+zSjT5AqDsMJs=;
  b=rAIgtBBJE2YCvOzia7t1SvCNQFYbvMeEShfoTjFWLU3gnSUqstH85r1l
   ijOlaHdZ2Y9Fb6yLt4hIjh+npbhvzPymW4grpdcRaGSY9bEMbdcOes9wp
   B31M9iBxomXkcAfc0VqUsngp35hE8ug1xT1m67HOgN9L/wFmPqc/4ywLI
   xtiJqL3yXX2CGrqkfMyFJDaFSfvOz4zubIva3JPnBVDlg5H7TOJi1GSsr
   aAAOI9WHceRy1KJzBibUBjcnsp+KB9InEKVZwQ+mTxauf/ksrg1xxTiam
   77cfaIaBJqdPdCRhtqzOwLVopC+OzkzNHQPoYAahpia84W8yDJEkap649
   g==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279244"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:30 +0800
IronPort-SDR: apy0sNTXhl1QRAyMbroBSwa7vrsu7J+NGHBJynCJ38WyErBNCZYB2UAycVo1KuFKCnuObH7Wo4
 HiHPexdKVEVtFFCYTSGX/RCXerkG5wK5isCgE8qFHt18AHRgcKPwCpcXVwCOgJNqZYmPhX8TFZ
 flZ+FBu0LOqwxQa/2+Fdrf7UxIJWq5DaimH+wTS6+Cv44MXkJbualzxyxrC/qkBfl3M1YaEyfI
 FTq07h64xMxQBsb2K31CPN+IcU6cY/18ZpvltDOf4ifUJlVEL7BuQqOkQZP5oieEby2C8yVQ9W
 Gvc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:28 -0800
IronPort-SDR: cTmBSCKClp2dnDUHXqa54dFFVvBYvTv/2EIMy0BOaq8G7vV9IAapNhIc0fcu1TJFLRbwTBefKA
 heK5NYxNZfBYr0sUdZ/eStOBYf0SE3W9ENJjOYDtPDRBeVVMHyu0BtHmEmaPRuKToHhy5gxwqd
 A3iS81MRj3BDHOMG6tW8mKvp5qHovIEpzbQWTJvrwLv26Pss1Nko8/EEF3ZhIMmZidWLzBKsRe
 4bn7mr0bY13HUIBb36ZmhzYTOlqeo06/35yqgoHTwxX3vkJWoU8N38a1zT0X/DM/x92sr29Kca
 81g=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:29 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 09/13] t/zbd: fix test case #33 for block size unaligned to zone size
Date:   Mon, 14 Nov 2022 11:13:04 +0900
Message-Id: <20221114021308.1684141-10-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
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

