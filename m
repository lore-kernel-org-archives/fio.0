Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F035C77B7A
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 08:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbjFGIcm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237218AbjFGIcl (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 04:32:41 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C9C10FB
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 01:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686126761; x=1717662761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gx3doQmyvYr75Gai/JXJV0NEx+hvZiJ1/Cg31lD4DoI=;
  b=RJnxk6mIZKsKzlLI6bhL3zhxAa+HcIW4DVFqMSEFu+ecslga+a7cNTiL
   WIkmV21lP/cmg1n3mWFtsNKWVOJ9A49LTjjVSWE9Ytqog/pJp8czSGZTd
   A8pIqbFhZG7Fp0zwVp+P1e5ApgVuU+u7PDj1dQjnph1PjdBIBH4lrGrnp
   e0lgl52nNqXEwL7jX0mWd6rq08k3cpZZQCQTeltNFHSUcjWZsQXuYW59x
   dwYIxiM6BgTHKRT6djigcdWijYno/5roJmelWlQwVJfGLh7Iptg84rhbs
   gSuoVMWfwxU17e/GJahGt9KqHYczBHRHSKU7yueWHxRh+f39jPht0PyQy
   g==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681142400"; 
   d="scan'208";a="232851914"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 16:32:41 +0800
IronPort-SDR: /Wxd0q/mZ6c/mE6G8lre3WJ5WxFrWZmnPjGPiWQE89KFiDmugpMvXS1c46kO+qraDq75cy5aon
 2VamnEr0hgSaRolzwarf2RguM7OAfzxceLme1Px/5IZhH8r5tq19PJOjYdyQzmpuRNf+xE5A2v
 G9tN9UW2qZ7GcD+u821NHPEgH9pTxAPIk5N1lU0yiDpT4lXCG5IEBf3UstN1+cnyIPuZYb1jb7
 2YmpgX34d0po4+kKZHC2Q8/LfQT4tzZHtOSfyBrE02FRT9VsaCu5bBebAcTUctUNvBJcRETcyz
 Odo=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 00:47:24 -0700
IronPort-SDR: UtDkBxYaSMS7Lndv6u38gVhPUEzgFwymVJ2r8DAciB9Od2CsuhcBbK7f27ujP/6jeTx1rm6lZB
 ML2qO+SS649DqjLXTgzPVXf3AKRgVqahiN3zzOL282ekZYUCWEC5y8asoaFwpkTApC1cx5eBiJ
 XgBk9i3AqXteqNtbV6y+gz5/eBIEuCEpkaxifaU5RPj7Q4vgnt2dgIfN/2JmuGs/4UoT8jWNNA
 LHNfJJh5y5kFpw0LTeNhamhrCIKkyUchnyfj7EI7GOYSWiEEd0GbzNnnzaj6VUrnhMvaXJXrak
 zQM=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Jun 2023 01:32:40 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 7/7] t/zbd: test write zone accounting of trim workload
Date:   Wed,  7 Jun 2023 17:32:30 +0900
Message-Id: <20230607083230.1178573-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent commit fixed the bug of the write zone accounting of trim
workload. Add a test case which confirms the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index cdaa0574..a3d37a7d 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1389,6 +1389,30 @@ test64() {
 		       >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test open zone accounting handles trim workload correctly. Prepare open zones
+# as many as max_open_zones=4. Trim one of the 4 zones. Then write to another
+# zone and check the write amount is expected size.
+test65() {
+	local off capacity
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	off=$((first_sequential_zone_sector * 512))
+	capacity=$(total_zone_capacity 1 $off "$dev")
+	run_fio --zonemode=zbd --direct=1 --zonesize="$zone_size" --thread=1 \
+		--filename="$dev" --group_reporting=1 --max_open_zones=4 \
+		"$(ioengine "psync")" \
+		--name="prep_open_zones" --rw=randwrite --offset="$off" \
+		--size="$((zone_size * 4))" --bs=4096 --io_size="$zone_size" \
+		--name=trimjob --wait_for="prep_open_zones" --rw=trim \
+		--bs="$zone_size" --offset="$off" --size="$zone_size" \
+		--name=write --wait_for="trimjob" --rw=write --bs=4096 \
+		--offset="$((off + zone_size * 4))" --size="$zone_size" \
+		>> "${logfile}.${test_number}" 2>&1
+
+	check_written $((zone_size + capacity))
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.40.1

