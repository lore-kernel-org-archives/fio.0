Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E335FC67871
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiJ0GDR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiJ0GDA (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:03:00 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADFB15DB1D
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850556; x=1698386556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ySRZgYyxXCmaPlygKH+nlzv6Oi+dAglwTXg7SgBewX8=;
  b=D42Ar7fmbjDVd5BziUzhvK4Q5lObGe3HBvFRKB0U3AdfdXjKbk28UjQt
   T7zNVaNJgUk0L6cJqilYmZRAVET22xi2xBcyBHFSeM3ARCMSHg6LIHLvX
   +O33a48jWX/iYbnh65nUZmzr/nvbF+urBmZm3kE6t4/ChskUyqc7Nau+7
   Y7JCUI97cqryaEsQ1fAMBa20ePmWZfFciIywU3gXwl1q15kUfm6+Z0Hpp
   QhdgwgE2+ZIfkLJ7UjD3W4c5zhNx86SinUoADpV62BBDtAvx3n7OBX0aV
   PXscDBUBt8vGGcK9NNzXyq7GXpBt9kaUZzlVSmn0u+c9Sx266G8pBGvgx
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="319174462"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:55 +0800
IronPort-SDR: j4uCE2hcaDdjSSJHgTuKhIVabB8rXnZXgmrJ6YS8Zh+0ZnrqqkwR2iElRp4uByhhl8gz/xnVkV
 eNTXE8jzyxiN42bHVEhroHxBVyeh6Dr3qVPLGyWH4d6xksQXq6CnKsFbxhU00L+553OOvPsjh5
 71ScufnXzPdYW5dgcz3vfQWkbuCyBCTBKJZbgqfCRslZ24UslzkvRAIjhQ/4593hrwK1IGd9UU
 taRIqxMNdcuAVITyBXdzzNSNIAA4v737PB4RdRlh6i+CDrKnW5vUOEgX2NgQLWkaH+DFIz8EBu
 hPxJI397+qcKs8wjkVl63TqQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:34 -0700
IronPort-SDR: Awvfm4x91iBjlli4lqmKh1604IfEuN7EUrJLon2/75Kkap0WzkwhllEGnod2G8y2Gw6sIjSLTx
 62naYUQBYGOwBQiCOfTlScyFWKin1dv3sYGR4oZvyWT9awu1BomDM+O3JAZZICwtXwvuhphgwR
 4M8BZDJkkteN0pg6ReZl88cZIwvhsBgQ8o5Y582WCvPzIDEySWeSEvViZ5oB9alD4aI78WwXJW
 04QEjK/NuglEYBjtPx2BAA/sS/jAyg6EhLJVSGFOVYWaoHqY7btnXYdBAaAVaKdnNzZ1XLjIq0
 lnk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:55 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 11/13] t/zbd: add test case to check zone_reset_threshold option with verify
Date:   Thu, 27 Oct 2022 15:01:37 +0900
Message-Id: <20221027060139.952508-12-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent commit fix assertion failure observed with zone_reset_threshold
option with verify. Add a test case to confirm the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e17a81de..0e185997 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1276,6 +1276,20 @@ test58() {
 	    >>"${logfile}.${test_number}" 2>&1
 }
 
+# Test zone_reset_threshold with verify.
+test59() {
+	local off bs loops=2 size=$((zone_size))
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+
+	bs=$(min $((256*1024)) "$zone_size")
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$size --loops=$loops --do_verify=1 --verify=md5 \
+		       --zone_reset_frequency=.9 --zone_reset_threshold=.1 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.37.1

