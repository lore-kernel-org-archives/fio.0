Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F594C7EE29
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 08:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbjFGIcl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235660AbjFGIck (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 04:32:40 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACE410F9
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 01:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686126759; x=1717662759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Elns6BmiCC0fgPQeUJgf6n/mTL+yM0VKbf7ppMHdm2o=;
  b=L+vO5vvci/POShbhCvAxg8xSvHuGIECG1rf2ptqqy8tum66NGrCZVe/y
   jR/s3svKrYM7YUpRAe5CdN1R38yTYhmvZdS/JpQnzH96TUHGdRiniTpx4
   gSAjMTy9fZxig/a+sjE3HjtKve047qSiWNgXyxtN0VkFrsGZnsGg2nVtO
   GyCBg8O7tGeeb5eFiTKNMlmxGXdlG1HtjNXmTMPxn4z4xyxykIP/O38hU
   EfAwm3zBpzkSMKX0iks5qLipQYjEGmpTrBe5cP0niCEEjxSOaRxO3Tdcl
   g0k4U8Bgn1dECMH2BZ8+AaGF4uiUp/kfOEoZR9ecAy4AMNC19j1Editvb
   g==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681142400"; 
   d="scan'208";a="232851907"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 16:32:39 +0800
IronPort-SDR: 3eHL0wyudeTDH7Lwr+Bk3p62PVkZzrDZt+/dIgPKwcxNypYXu/FTBUn7Y/Oi/4lFn9ifPZUwzi
 qd+P1G+Qbc/mMnjOZBJZoQ/CJYEaLdIO1zNbXruexktwqOzPNhVexDZuEhQZlxkfMbLxxjYWve
 d4NYWAOwJfzLmsCymsuK3DUl/hIQxxcmFR5qU7h39QoOEKNadHfC3aJyJP4o6sy0MZeh4W+02E
 iA9eoZWGQB2BGwfPdanklNVTdJUcrSG5W2vH6tkLdl4ivySVMuyQI+4FVQ3R94qRvqgOeTk77c
 GC8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 00:47:22 -0700
IronPort-SDR: tph7tF69oWMRFwW/gNv61J792o0WL9aP/RHEeIWnt6mL85kNKy5z1O3Zr3KgTNGl2Eets+OcYt
 72v1Jrlov+y7Oaq8+4b9EtjSf21GJ/oZQJE+wjOglMJI31yCJsmJdr4xQvJqy3LNKnJ1iwVm3t
 2hggjRANwZRJ1TMyJQGAITNIs4uwMBHCvJyOXGSZ++B/CnjRb8JKz2EuztrZuFeyQVk+THBx/q
 P76iY6nywzWQiYJPXEnMKk1cTKP+gqz+UtzH2L9yOFOY2WFskPHrc8lRrc0r6mupTUehcELYDP
 5u4=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Jun 2023 01:32:37 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 5/7] t/zbd: reset zones before tests with max_open_zones option
Date:   Wed,  7 Jun 2023 17:32:28 +0900
Message-Id: <20230607083230.1178573-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
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

