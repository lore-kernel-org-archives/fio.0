Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B38C67871
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiJ0GCI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiJ0GB4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:01:56 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B077B58F
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850513; x=1698386513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9jPnnjN+AgrmtRFfokTzVQ5/zCKJpS+zSjT5AqDsMJs=;
  b=rMt3P8cZkRPnToPn697hnBWkl3nQdACsxdP6ozBDjgJvAtHKCZbWlRYS
   q3VozjJQP04cM/BUUScBYHjMFB+2rulG8AKL3W9JBgTRDaQ6mrMhAFLq/
   aqLMaR8jXgqe83k4pHXp0ToT6GEihy6qSydXNIHBiUJMZoEONyrNBIZTH
   REwHaPO274XWkTXG3vJ5V7f3BB068W0XOGckTDI77S94wk2PQdnVNnDV6
   6TVYEEwu+GckQwI32cK+PWTxakhJe60hEXcbrRGknCwqOXwroeUp7aesP
   ztYNCKc/KJTx45HS4ciKzBASU++1F/Ke8sMsgB+0LPfmpf4oosze0Dc6R
   w==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="214845871"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:53 +0800
IronPort-SDR: Yi+/jpltcLWvXM1CsnsMdxmSPvS11Pe+Rkv4xyjeYDlhOTLnPQKNPUp9IMmgPh9sQFEiu02knP
 a5AacjL1DQIZQ5laam4Gra7ZZct9HP1pSaZj7Y5rVo8/V0QHz7FjsWO/OnZix/b2Jr41q1tjBd
 R8FX2VRSsFrlrLaXyuriOgqQR7XvRkDdwhDTsYiF3V+OdPmFLoQWS5erJzs7ycgjpJZQZkAVZy
 EAo/UaaEVdTrejfGc8eJiSg9qwCmp3/pZTtxcAlKV2e3CCK4leO1Jzh0ppBu42byfNouXRsd4z
 b/bGviXCBE251yHNhhLyT6wx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:31 -0700
IronPort-SDR: MkcsZBceO/lariw3HgeWSmLpEw3f3k1y1IN09MYMwn1e27QoVOwug70WiEWLZB6iaZoGKaHxDM
 3LN3yZYfTfaFHiyNkn8qr7oFYVGrgV1Xwdpl+XqCUbp84jKleBD6641QRC16C/20h7+UVm9Z24
 bMeaGdxf8q3vPGzFA9NO2bGTuz/B3slQpTZJo9AQO6oD2hQlHWK74/YKh5tIj+w5aQrEfEfCh6
 adYhUFcLOVIzUWvxICnF0kZKAN8j7nUOFCmQMWhVX0I3VsAxxOmJMNkwcEheGUkltbE/rJ57Ju
 FP8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:52 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 09/13] t/zbd: fix test case #33 for block size unaligned to zone size
Date:   Thu, 27 Oct 2022 15:01:35 +0900
Message-Id: <20221027060139.952508-10-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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

