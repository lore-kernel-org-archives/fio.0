Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFD4C38A2D
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbiJ0GDQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiJ0GDA (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:03:00 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC7C15DB09
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850555; x=1698386555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5s3Z6xoOsVC4grSDdaCsREyts+EZ6uPuBb7P6WY/Ejc=;
  b=Ez2mNZQmLH/3WZGzAVB6cxQjxiaLVDIKk2H68W/fKov3tiRoxillCOkb
   aY6nUfK9CPLM2bLx8OTmqHxL5gt1W+xMafXfFHSVmSU8aKOnbvXqIUNK0
   fp5Lp73vVcegrzVoY+DrW4uW3pPXW907RYuszomr0GufFRLUEpYyNY/1V
   5Ur8yvJ65cShZuhZHbB8Lh8fRZJE7R+ZIRmbgQ9vH31YAeBj17UEZZHQt
   owlwXeIe5C5Lx2PjZvji1Urt4ulc5r1rCa5gJhWbgTmcd6Kz96u7c7b3L
   CvCQWI16ZNufMgm9sYINP0MUhIuZNSHihptl47p7ruvRU2rXVmGKZgUR8
   A==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="319174456"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:54 +0800
IronPort-SDR: 0ALEg7gmI0gclai89ef6PzIM4QWPIQ66JC6NqfZYq+E68XSfR2b+DY0hp9MygZ6O9bItA5sxxw
 sxwe8kJLPf6NKlF9Ib57qlXj09oFHggl3d+Zqc+YGhU+46hweNwqamLf5t/7wAqAknNrRCzhPt
 kzkvuwYBOYv9ZCvYFaBDkbkcgr5hgho1ZPz0jKB+1JiYj9ivxWaTsSdJKN+u5dw9IuR71Y+Q6p
 6Dx9wsa03YDj/Zn0CVXM7eHVk1/GLmYbrrJJ9k6NGFOiKy+UtPIuQkxehsjSckwL0ZA3CsYFQr
 HgW0aG4J5cp49GXmfxmTQaGt
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:33 -0700
IronPort-SDR: 4wW/fGcECrpWG005Ay8bOURD0Wx+CeRCUPtQIZ+inE2MVHN2lVVEbnrN9hXJPlqZB54sBM9pDh
 fk8Vps9IPOR971rzjBSwVpVovjvF71uCqKrWEYY0xzgglFcHkwMksD4zfhccWL91mZSXcAWmKU
 rqTd5C4uW86nc6TrAxF5ScDW8KArQf/rX3CIBhuI9EWwEA+parg3BeO0AXF4uvxybvuWHzpe9N
 XPLBrjeo5cb4D2SzNV1pMLnLSPinNlWyK4ZhlUA0cfo+AZtd3XlyuG5Tjkm3AXHPDk4Ngmqd1b
 rPA=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:54 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 10/13] t/zbd: modify test case #34 for block size unaligned to zone size
Date:   Thu, 27 Oct 2022 15:01:36 +0900
Message-Id: <20221027060139.952508-11-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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

