Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1F1C001B0
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjGGDPd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjGGDPW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:22 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EC41FDD
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699720; x=1720235720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QKttZppwADzhLuHHs1MEl+B+q3Y9uGWgKuARVuAwTxQ=;
  b=cFMKzZQf/esSIlb11d/seEOL5ffRYmiYP4OV6YjVHoV8ngBLTDHhBaul
   3vL5BV+QUBJXtHaKG4yGC/AvvDSV4bFtQOvT9lKFUO9jKRa+HMM5cTyYa
   QndAnx6esPXzHf3rsv0A9+D2vkJzefUP8TWFhQEHWXWUctBq6ERbvbal2
   dQW1u79SUeMIexD0qRJ2aOpPka5exHZg45ACyfdd0NCeJvTFb7559WQXW
   eCK0/pBSxNGtmQLWtf0bVGP7Yn2K3IODQ0twHIJDh2jmQF6QaPz5mKY7V
   nY+0Wg4fSznLdUO6cnvZ5Tn1+h7A7Vrtb1r4XghHWwPEotH053PMdO0GA
   w==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468819"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:20 +0800
IronPort-SDR: DNFFyLAj9y7kxYdHrDvL0dHJwpLPlfrMRDwVjb4tJwv8XAjyyhhE+9JzNYnWTksfEO712AQzhj
 ygMhG6ZUEsGkclU7/QD5BEXMPzCNBvb9Jy98LwgjC0M77UpV7GqVDy0gQ2XoPbNnt423c6obSb
 vgvEoGVfHbMNGUkLJh4uuvDjN4z2Lih2mpvo0/nKZoIQzjP1uP/5YS7lZzTlyr3q4EdVDhO92O
 s1V9M2WEqp0yCa7CoLPJC0nCyxW6x4uheXf/Ex3fI3kLnpt88RH7xuvgemzIGXkP6Qtj5OdURt
 N04=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:27 -0700
IronPort-SDR: H1Nj6ObxZBLSxA4oaDaZSXs0YF1qTzqYCLJOR8JjDS04gIuaP+4ZRrSRB1fWzkHL54HfE/xAjf
 /Tjas9jf/8SctNpy4pyPNHHc1NDoe6vjZunVbMsrzKgp5Pxxtk/LYFdn3wxYgcL+xnFS5AhHhk
 byayYdp+msgCZ3l0/CWgmEUQFmxy/n0s9HRCqxAFQUuBm20/Mfz4jH2eLBsu9R+71CTSmEy1d+
 meZ1Q8DvoqQNdDui78/2EzFgyIz6vXRq3zytYzA2oiXFV3SRRMJ1JC4ncFIYFYLUfX/lg8mSE6
 tY0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:19 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 11/13] t/zbd: add missing prep_write for test cases with write workloads
Date:   Fri,  7 Jul 2023 12:15:03 +0900
Message-Id: <20230707031505.3468915-12-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
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

