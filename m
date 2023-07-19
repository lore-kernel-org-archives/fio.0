Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3100EB64DA
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjGSK6Q (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjGSK6O (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:14 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857D8197
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764292; x=1721300292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QKttZppwADzhLuHHs1MEl+B+q3Y9uGWgKuARVuAwTxQ=;
  b=NLnit5NRLP6XVck3a7tsTg9/o91k0ECytPj2LM92M8hIxvjUK2xWxe9o
   uK6fSVyYLlH8w12VNMAJXwUwh0Tf/9KtPGAe+Dxd5wXgPpdnZesN0phIz
   zqNhr484HfS1TEN2BYjq4j6bYXwP0sVfr5RkT9S4cNCY8EYWiucY6ydt/
   NkWuKsPRkvTStFg9TbmtBKz2cX2UsthKZbETjZ+34ttvfKI+FmLQJ/QVv
   wDesWNJGl0bqk+g73brMcxVijvW94yYwVeOOkTqDM+Wl86I+hvpxA0ksb
   h65VTAHR/DlDp6M9h5SNZhG6qro4+pjcyQ/sqXWrG+mYOzrix6vVFbd4m
   A==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860342"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:11 +0800
IronPort-SDR: L0pHZ77r3LScwlP+nKiIDZGa/yeZlvh+gidQnnnmSA8GPK8TERgS6hBDd9s4AkEmdqoJCPlcaj
 99juIQlxkGCSw21ELZ3Vsmy12XGVHXMXT2zLZn1iyXkbkh1j9Lu6jIpsoz/L9rujvPzK5JvE1v
 66IvgtfnMX08yyH4lz8fYz84GDbLR3clNpVKnxGVCB+R/wVcDuaiK8Ryz11NpDOeLCgU3oapcZ
 ctwf5DtBqJP1W8xRjZTjHBUt+JXu5S6vm+PgXZy8lzagKU8dqYB2s7RD1dx2ycOR0DtNjmMHQa
 ovI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:23 -0700
IronPort-SDR: EGkaKFWDgmnEQ1FgVbTGiF+RlYsePplOfLniGm50Pa+ztLiM5X+3NuWWrEK/4PewcIbjnzNKIL
 9mBD9Vf2w9PhBImKrYNw+L3SiM/djTDARaSatzmodcEkl+Ax56jEjm13hEQT16PWy57SzLKFiG
 v/Ic6lmguGbG2SsrPG9RiC43j4AHSR+TFhyU2Zy3upjmRxT1VUBJrawPS+i/6vFPuS02ytCMe+
 Y9mE6ar9FofGlgF6651q7hohIIWw81UwqEggIyz5JLU3iKdZdYGQEpXWzchCnmQr0v5yT8+TQ+
 BI8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:11 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 11/13] t/zbd: add missing prep_write for test cases with write workloads
Date:   Wed, 19 Jul 2023 19:57:54 +0900
Message-Id: <20230719105756.553146-12-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test cases from 54 to 57 do writes but miss prep_write() call which
resets zones of the test target device with max_active_zones limit. This
results in failures due to open zones out of I/O ranges and
max_active_zones limit error. Add the missing prep_write() call to avoid
the failures.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 71cb18bb..c8f3eb61 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1197,6 +1197,7 @@ test54() {
 	require_zbd || return $SKIP_TESTCASE
 	require_seq_zones 8 || return $SKIP_TESTCASE
 
+	prep_write
 	run_fio --name=job --filename=${dev} "$(ioengine "libaio")" \
 		--time_based=1 --runtime=30s --continue_on_error=0 \
 		--offset=$((first_sequential_zone_sector * 512)) \
@@ -1218,6 +1219,7 @@ test55() {
 	# offset=1z + offset_increment=10z + size=2z
 	require_seq_zones 13 || return $SKIP_TESTCASE
 
+	prep_write
 	run_fio	--name=j		\
 		--filename=${dev}	\
 		--direct=1		\
@@ -1243,6 +1245,7 @@ test56() {
 	require_regular_block_dev || return $SKIP_TESTCASE
 	require_seq_zones 10 || return $SKIP_TESTCASE
 
+	prep_write
 	run_fio	--name=j		\
 		--filename=${dev}	\
 		--direct=1		\
@@ -1264,6 +1267,7 @@ test57() {
 
 	require_zbd || return $SKIP_TESTCASE
 
+	prep_write
 	bs=$((4096 * 7))
 	off=$((first_sequential_zone_sector * 512))
 
-- 
2.40.1

