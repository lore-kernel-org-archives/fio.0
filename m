Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFFBC001B0
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjGSK6X (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjGSK6V (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:21 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7C31985
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764295; x=1721300295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HsjfY5vKB0tvk0cf6TH+CRBlqViPuLxqO62T+xDZPoo=;
  b=Koa3J90yHp721jDHV99bka77ifY8+wiwt1YpzahUppP/ENGzOwv3k8Gd
   4+XuQ/MCvdDW0BfYWdbLRCy4a4p5A8MLV7tV1RrJcEpH2in6B03AaXr2w
   TTrx/FhsrpkL7zihk9FSvz4sTZKlgQmYyY3RAkUQLWKU6vQ1ymwN2VAG/
   NawVaa0KNdecpKWIdzXlV+ClxTjNMUQurUW5D1dLOmGUgstTpqtot/kuH
   P3WC0P0ahiW+5MS/FkXFyHYo9uXE7w0/2kGh4Inu8fXt8jzayqNVIbhRz
   d8YOwStA9ol9QAE+aNhSzW4HmFr8wQhI962cqSMU/kLjaNUoPUKbDzd77
   A==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860347"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:14 +0800
IronPort-SDR: 6NPCRLElSC4x/X4fQdNs/6zdKxaVUYVdba0u1/hvx2Z75dEpr8y6DeRDCfxBTfoRZnkL0iNgqO
 Et1qjS+G1d6zRxrDGHEJADcX4r4S2RkMcviuqxet03KfItwXord3JFb+J3Q/2SblcXI4TQuOIs
 A2DTxOnphy9M7k/zvaB+vpAqNvmCQHhJhjaqNSrKEEqQgY8epO5FFo5aG3iBdRQ44lHs32Hf0/
 DUr6Pcm6bdqCaicsfIfEEeXKeB9l8/FtI0VXw35lr4xFBVRJ+elFymYlFVmWSnvp1GRHGcp10S
 g68=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:25 -0700
IronPort-SDR: AwXX1rcnkhxwP8tIJqvSq1IDYPfOUpTwB6QMT5yelExwzmTGghoefuKy4VM2wDHbZ93cPvgBD7
 rSyqISN/cbT0xYKc+p9HVNuK9EBfe0knmMlE+T78aK+D1NDqKNLsSns/FNUTwjw8xYIRI1VvEx
 DLU+5Vw4KIEOaJifeNHUUAUhGKbxh3WuZQUcIPmZx2ziMubBExAWov2TYs4Dr/J+rto7KC24Q1
 oLjhknE8YHSdAVDWerlimuNnkNbLKMjK51CVlWbU4p5q5LLpIRmHnadvv/Jvq8TrYUH/Ve0jPA
 TLs=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:13 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 13/13] t/zbd: add max_active configs to run-tests-against-nullb
Date:   Wed, 19 Jul 2023 19:57:56 +0900
Message-Id: <20230719105756.553146-14-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Introduce several new test device configurations to cover the cases with
max_active_zones is not being zero, i.e. limited. Two group of new
configurations are added, one with max_active_zones == max_open_zones
and the other with max_active_zones > max_open_zones.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/run-tests-against-nullb | 194 ++++++++++++++++++++++++++++++++--
 1 file changed, 188 insertions(+), 6 deletions(-)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index 4617e398..97d29966 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -81,6 +81,13 @@ configure_nullb()
 
 		if ((max_open)); then
 			echo "${max_open}" > zone_max_open
+			if ((max_active)); then
+				if ((!max_act_supported)); then
+					echo "null_blk does not support active zone counts"
+					return 2
+				fi
+				echo "${max_active}" > zone_max_active
+			fi
 		fi
 	fi
 
@@ -97,6 +104,11 @@ show_nullb_config()
 		echo "    $(printf "Zone Capacity: %d MB" ${zone_capacity})"
 		if ((max_open)); then
 			echo "    $(printf "Max Open: %d Zones" ${max_open})"
+			if ((max_active)); then
+				echo "    $(printf "Max Active: %d Zones" ${max_active})"
+			else
+				echo "    Max Active: Unlimited Zones"
+			fi
 		else
 			echo "    Max Open: Unlimited Zones"
 		fi
@@ -131,6 +143,7 @@ section3()
 	zone_size=4
 	zone_capacity=3
 	max_open=0
+	max_active=0
 }
 
 # Zoned device with mostly sequential zones, ZCAP == ZSIZE, unlimited MaxOpen.
@@ -140,6 +153,7 @@ section4()
 	zone_size=1
 	zone_capacity=1
 	max_open=0
+	max_active=0
 }
 
 # Zoned device with mostly sequential zones, ZCAP < ZSIZE, unlimited MaxOpen.
@@ -149,6 +163,7 @@ section5()
 	zone_size=4
 	zone_capacity=3
 	max_open=0
+	max_active=0
 }
 
 # Zoned device with mostly conventional zones, ZCAP == ZSIZE, unlimited MaxOpen.
@@ -158,6 +173,7 @@ section6()
 	zone_size=1
 	zone_capacity=1
 	max_open=0
+	max_active=0
 }
 
 # Zoned device with mostly conventional zones, ZCAP < ZSIZE, unlimited MaxOpen.
@@ -168,9 +184,11 @@ section7()
 	zone_size=4
 	zone_capacity=3
 	max_open=0
+	max_active=0
 }
 
-# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen.
+# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section8()
 {
 	dev_size=1024
@@ -179,9 +197,11 @@ section8()
 	zone_capacity=1
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen.
+# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section9()
 {
 	conv_pcnt=0
@@ -189,9 +209,11 @@ section9()
 	zone_capacity=3
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen.
+# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section10()
 {
 	conv_pcnt=10
@@ -199,9 +221,11 @@ section10()
 	zone_capacity=1
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen.
+# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section11()
 {
 	conv_pcnt=10
@@ -209,9 +233,11 @@ section11()
 	zone_capacity=3
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen.
+# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section12()
 {
 	conv_pcnt=66
@@ -219,9 +245,11 @@ section12()
 	zone_capacity=1
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen.
+# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section13()
 {
 	dev_size=2048
@@ -230,6 +258,155 @@ section13()
 	zone_capacity=3
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
+}
+
+# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section14()
+{
+	dev_size=1024
+	conv_pcnt=0
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section15()
+{
+	conv_pcnt=0
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section16()
+{
+	conv_pcnt=10
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section17()
+{
+	conv_pcnt=10
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section18()
+{
+	conv_pcnt=66
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section19()
+{
+	dev_size=2048
+	conv_pcnt=66
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section20()
+{
+	dev_size=1024
+	conv_pcnt=0
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section21()
+{
+	conv_pcnt=0
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section22()
+{
+	conv_pcnt=10
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section23()
+{
+	conv_pcnt=10
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section24()
+{
+	conv_pcnt=66
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section25()
+{
+	dev_size=2048
+	conv_pcnt=66
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
 }
 
 #
@@ -240,10 +417,12 @@ scriptdir="$(cd "$(dirname "$0")" && pwd)"
 sections=()
 zcap_supported=1
 conv_supported=1
+max_act_supported=1
 list_only=0
 dev_size=1024
 dev_blocksize=4096
 set_max_open=8
+set_extra_max_active=2
 zbd_test_opts=()
 num_of_runs=1
 test_case=0
@@ -283,6 +462,9 @@ fi
 if ! cat /sys/kernel/config/nullb/features | grep -q zone_nr_conv; then
 	conv_supported=0
 fi
+if ! cat /sys/kernel/config/nullb/features | grep -q zone_max_active; then
+	max_act_supported=0
+fi
 
 rc=0
 test_rc=0
-- 
2.40.1

