Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135A0C43217
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiJUGej (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiJUGeh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:37 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163A4205D7
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334068; x=1697870068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h/K9h7P2GcN7bsprPiqvlqEQaGgktwjHifWbD+q20i8=;
  b=IwecbZxZgfoRXEfPywklK6YGoqPlOQ6LrjufteRCupTpVd7TSauvu6Sq
   vpMqlF/34ztOZaKys5CTkZB94C5k95qUGp/hgpym8gbI6TnPOnHoi1BV2
   sDpLAp89XjEXalPU7gEv1fTTXOgdLtUaFgxlr67DKjkOF7/cNzEW8Nuq/
   gpi139/l0PNQq8qjD3FAkHs+ZiHcuYCqbfIgzQGXOrOeSc8Hn/9SpdD6Y
   hqLS6e6IeXldA8X0SqDwsYlzTYlaZqLrdPGUjMWoa+9fIhjHrqhJl/uRd
   nsUSQifRIHeTR957AciLA3yglLDT3PPyzBfToestS8JJsGoEaSMIuBfiH
   A==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733117"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:28 +0800
IronPort-SDR: jDiJy/SxOadZJ5jYIXezTGcK6yiMsen6YdZIWi9+18pDrgQl5scUvA1XMSKHRVjETwjlzKKeME
 ZSEgWb53o3W6/4D3w2s2uQ9kwdXzE1hsz2njxVKm7cVcytl+5E31foiLrYIjYvdiwmzwQJw1Qa
 whWARqTxUdImLa3hYsK68+RpAjBDLhA6BrRY1QCDbJuH9UDmoXUKQqG5O1Hmwc3iewNMz0+LO5
 zFlKV1OWXkOHtAD6GlGlglGEw3r70Vb9pf0N0cWY4qwsvnf/1PfrIxZIyASja9ZxxjpKHfv3RG
 BAAZSAwRukcjLC2motZt0rQ/
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:16 -0700
IronPort-SDR: yzsE7sgLy8i7uo7hsbYUTSt+fW1hbvq+b4XJWxvtbZXEaaK/0CvESLQ/oJ1RVAozCpqjv0TImt
 v63IoVnc64dgiXtlHTbUefi0QLAOfamnanMx+B1jpgrz8f6yUTmtJcbrO/T/9kvrMVO5Apuz5q
 /in1uYorA98SQIwammLccHZ1pGemMC5zyoZHdj7uzCTsvfOIhun5ZMwo46RemFcjD27dKDXnbb
 5Z8ZfhEpS6+xU88C/JgkTFqZmawGjKLECCbL3VfduIdrEVVevGdcmIImpwGmbhHAUY8SvhEC5L
 s9A=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:28 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 08/11] t/zbd: fix test case #33 for block size unaligned to zone size
Date:   Fri, 21 Oct 2022 15:34:13 +0900
Message-Id: <20221021063416.860438-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
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

