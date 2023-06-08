Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022B7C7EE23
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 07:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbjFHHGW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 03:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235100AbjFHHGU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 03:06:20 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D079E
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 00:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686207978; x=1717743978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Elns6BmiCC0fgPQeUJgf6n/mTL+yM0VKbf7ppMHdm2o=;
  b=M1KSGVWOSc+WKsJMfbVrPPjqmci2DpGnZoZrWgXHaZv81YqDqpDMujUm
   hbgNa5LSM8kPDwxCXWLdtplg9iEqRBeCGbpfg6/+e+ZaLoJ26D2f7Jx7W
   R/v0r79cPMrqs/3xFus8qjaA2ZXtaYLxLjIt30WYkxum0WcD3j4nHL69G
   PxyCFnQMMAy8P+BJJFErO6DkIWlBAZHrc2cVvvP7adW/utw50zA1dPhLN
   cUDS5rlx4LZOPDJwkzKvRDYnIKMS1pLYlzEcuUE0NymvU4+xUQjovK4ly
   DU6FgIYUmaDvQlZ6H/QWDzELCl2uNGYlQ4OwNuB8I9gHmHr7hhZweYd11
   A==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="231238483"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 15:06:17 +0800
IronPort-SDR: fdBdghigXO99RhIutvcCzhQrxKieiPUPQZLXCzQyrKzBItS3vaVrvynyMdfADWp6fL6QmZ6o+f
 id/ukhD/E9EFNH3SYRpK9G3xz85PeFt6GvhVI8wHLsEzIkQbRTkyvS7dZ48ao+YkNxxdDyIR3P
 jyjrFgdUfo1H7CJQQ7a/XkTdC/SrdbMeMFzwnotk6B+NQbsBvBTD5qtWcFimvxGFy/Zr58Jr6s
 /ZiYUt6ZrQr6Ygxl5S5ScaaTJsbUXh/mdCWfqXI9HBM/gsL8i359hmWFq59MhaJtxcLSXSuH9F
 F60=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 23:15:19 -0700
IronPort-SDR: YULw3bxI4TmSs2VTokBLYkboWkuPtr2ArhE00qM32ATUyH9o8SLNqVawmCoA0lT6nMxPPDVr9X
 3QWb3v0ZYjimMAQnw8B0YacA2r5xXAhd0gseTjK3NdGrQdh9bVzYBVKTqAlTAa6xgXLJEiQE5l
 AfNwYh0KVVwj62C/9hgS5UvWdt/N1ZjR8sPQ9ehhFSKAPCSi376NyeHEUoVK2YofzhzN6v1Ups
 FSzbWhMzt6r2YUKT8ql2QTLosrs04t9zXPpt2Sk3uZgQUHKkMmQgj8039QMwEPbbgM/3SVFu0b
 ARg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jun 2023 00:06:17 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 5/7] t/zbd: reset zones before tests with max_open_zones option
Date:   Thu,  8 Jun 2023 16:06:06 +0900
Message-Id: <20230608070608.1256970-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

After the recent fix, fio no longer resets zones when it finds more
zones in open condition than the max_open_zones option. This results in
failure of test cases 12, 13, 29, 32, 48 and 51. To avoid the failures,
reset zones at the beginning of the test cases.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 996160e7..86577952 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -460,7 +460,8 @@ test11() {
 test12() {
     local size off capacity
 
-    prep_write
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 8 $off $dev)
@@ -477,7 +478,8 @@ test13() {
 
     require_max_open_zones 4 || return $SKIP_TESTCASE
 
-    prep_write
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 8 $off $dev)
@@ -726,7 +728,9 @@ test29() {
     require_seq_zones 80 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-    prep_write
+
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     opts=("--debug=zbd")
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
@@ -796,7 +800,8 @@ test32() {
 
     require_zbd || return $SKIP_TESTCASE
 
-    prep_write
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
@@ -1024,7 +1029,9 @@ test48() {
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-    prep_write
+
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     opts=("--aux-path=/tmp" "--allow_file_create=0" "--significant_figures=10")
     opts+=("--debug=zbd")
     opts+=("$(ioengine "libaio")" "--rw=randwrite" "--direct=1")
@@ -1094,7 +1101,7 @@ test51() {
 	require_conv_zones 8 || return $SKIP_TESTCASE
 	require_seq_zones 8 || return $SKIP_TESTCASE
 
-	prep_write
+	reset_zone "$dev" -1
 
 	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
 	opts+=("--size=$((16 * zone_size))" "$(ioengine "libaio")")
-- 
2.40.1

