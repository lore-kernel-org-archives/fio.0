Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCA1C433FE
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiKHIt5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiKHIty (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:54 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21FB2DABC
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897393; x=1699433393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9jPnnjN+AgrmtRFfokTzVQ5/zCKJpS+zSjT5AqDsMJs=;
  b=TJaFoJEG+hjCoYlX4kR+qvqi7dWzp2LoA7IxbmwGAX5c+qucDpMncO+g
   b30iqBZqbNYImuJyY4PGgM4VBBT8Id34AAS7ucgSNuHTZscuGzYamzmMK
   rEJbjioKW6u+YO+A1fwqwiXiseI6iN5UvuWyZPwFtQ20lPoLXqNSdCdWv
   69JWXmk1tj0cc/m7g5g9FhYmx7xH76OfcMuXXKHzHFfzrVmVlj+r5GZgh
   WTfo85kVAXHRY/E0IUhYlXJOSra4eQJo1M9YztqvLCO588Mbmn/2H4TZQ
   lKqImKyFAVnys7jLM9E7Fgt5qY8oBTXt/B14yDlv/Zl3rTAm5u0293dz4
   g==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="215743473"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:53 +0800
IronPort-SDR: cWBuabz6ijMz9cQtdNMoK6qPeWUABRgpWAPPuF/BqTjKtSFHYf+YJaGLH449iwCm8OTgCliwRz
 QGOF9E+oZVeQE67vgYdIhed9bFmgs6qGkYqdINMNRtxUr+i0xCOtkcTvc9utmsmU+yEXxtjHyh
 WE7z7V7NFXGxhR+cyUHEjjw1H6zRKtvvhs+jJBSMt/hS56w4fWORV7zyJOZ/VUmxe7FtwQxuz5
 Ki22kbrrUPd7jjJysjl5DC/R0Qu9qzHObXlHO3He1+dNiMvbnvhtEbspfBwwRbmlmwkj8MtXPX
 37U=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:14 -0800
IronPort-SDR: zUN84q4aL/PEpGBHID3pVPDYLZp4gg+Iam/Q/Jon2UhIktNZMK4y5zlE4TzS4XLGcRx9zZ4qkG
 Tk3QkZZPspLAxS8UcolFvNQ3pe/lVZQhDkMycm4jNWEsE/SA4dkUlxzqwBsR8is1ZIr07oPp2b
 Vop3GLZduteIkpCurm0bvcZp6pX2yUW9OcMitTtqkaeZC3Z7e9kQefqoUgSAnoYTz5Pcwe9xfz
 pqrtfHR8dl8jbdMaDY1f9DMXu2W4XhQFA7476AnB0FAbMfwn6b98oDjq5XjfHG/9rVaWLiXnCS
 f3k=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:53 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 09/13] t/zbd: fix test case #33 for block size unaligned to zone size
Date:   Tue,  8 Nov 2022 17:49:36 +0900
Message-Id: <20221108084940.1574939-10-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
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

