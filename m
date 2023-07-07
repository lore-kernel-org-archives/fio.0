Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCBCC001DC
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjGGDPf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjGGDP3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:29 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604301FEC
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699723; x=1720235723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HsjfY5vKB0tvk0cf6TH+CRBlqViPuLxqO62T+xDZPoo=;
  b=MHSQzKPhvF3hf4d18e6AzVbKxVUMh5tkISIZt766ykOR63LaNLei1pMf
   bTzg3qVSklel/KEVcAse9+RHzsZgFYu2EoqDCRRZdmd9nqBl5YrQFjW50
   ntgjneSCZbNwj7sNUJok3nxu2x3D9vhEtvHxe04ueQdnP4m7bM1lXZ9ed
   K/Qm3nLJ8vaqtghk1T/EdM7xIJ9nAp2Kl9tWeJgF+pg+CAl8Sg9nIGIq+
   grjJ4uF2cMmEJUI/KB20rwzJTVroRWrRrfgZyl11qMR9rfPRd5LnUQAVg
   8NBUudh0eN0KMgyDQ5CDw/MEN3xS8M2vhuPeKExGO9n1PqW+3lJhkpIAa
   w==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468823"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:22 +0800
IronPort-SDR: QNWATtP+dx9WE43S87H9HI1VMILHt3YQmJHoUVOB0DM6CZMbG0jb3rv2GcbHOylmW+YYUx22+k
 d8aKv26Q6xB6tVIXiwa+a9K7Z3rnePAVq4yxTkSNGmsGUJAL63CzXYdA01slZkuip2aKuOqB7z
 tN5WNTMB4RB3RF2cV5vfNriGopljD0cGFIurArS0YnEuVpfwp+3LoKvwq73uD8pda3mi/Ncw8L
 4hJlp/Z1qAClaVl8hJ+/uy+lzWsNbyXGqRngXpVE6iP0N+c4n+XT3kRq/xtvDFtPxzkNcJr9R0
 TxU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:29 -0700
IronPort-SDR: Az95UUHdXM+Y547P5cHNtBBUEKwXufeNQ9K1nlJzo993488Bhhciyjwca6Cl2cKoJOlRC4ba6q
 M2IeM4hJ+uxPODH+hvdU+67tCUsmylOwUgXVsTfbIX5l9dUSLe5PfoJSlh+uDQT2BFz8QboDH3
 NgEi0dUtqfKPRzWNaUCZ2AEuBf+PZncU0M/iGHXX1klPfgYTda+IA0hc3FYMimcRy2s1ZOaxNk
 m4HRJEWzdZXxw7jhZwwi1MIsyu/xgGac5Rlw7vcJI/xGdTlugsqe2Sum8PAeVvrg1oUqFTmNPi
 42g=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:22 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 13/13] t/zbd: add max_active configs to run-tests-against-nullb
Date:   Fri,  7 Jul 2023 12:15:05 +0900
Message-Id: <20230707031505.3468915-14-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
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

