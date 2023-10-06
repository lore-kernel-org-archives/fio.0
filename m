Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE15E92FF2
	for <fio@archiver.kernel.org>; Fri,  6 Oct 2023 07:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjJFHNY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 6 Oct 2023 03:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjJFHNW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Oct 2023 03:13:22 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2217FE9
        for <fio@vger.kernel.org>; Fri,  6 Oct 2023 00:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1696576402; x=1728112402;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/iwY4OqjAAE8JzJB0ZBm6ANSQtvddDUnGRXNQTAXaDg=;
  b=dVPHHaaP3i9jCfwOf0+XVuejFQebh7EU7PV+ds0jhGUahPpkd+WHLl+y
   V5B+ZOmsRna8ikcmy6ZLqxIigoyAf5Y9pCQdj/leLee5a++DmfItFC4L1
   thS8IW0fP4au0y9Ja+pN+XM8MB/UQERLSV7S4OTR7AkISM8hlIimFHuFa
   nePq5DDhpb9Be5gEeftFI7vnL7D3XgUeYKvC8r/N4+FcfZhXm3tJSQ4Pu
   eOpwGUxKqpO/TPl5Ixi1diZdRuqzPniRnh0PamUUHpEAYeAN3lSlpwOcv
   3+OwhgNsztximFlTKxr3rduvfcIC3LaQdITCuPENZFHoYXy/aXZk95Wls
   Q==;
X-CSE-ConnectionGUID: 1FkU6nowSlSnfcY88H0bmA==
X-CSE-MsgGUID: MqkSNrQ3QRmB1sKexHZZJA==
X-IronPort-AV: E=Sophos;i="6.03,203,1694707200"; 
   d="scan'208";a="357919728"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Oct 2023 15:13:21 +0800
IronPort-SDR: XmVgsbtUiJTAErQml45hu1XtHXXwZOZc7Z9OQiH1MMmAsY+NWjAxfIIEsicyhNK4920t+fWQJ/
 uW2dxU1fMPknnHitbEsW1H4NH6d5nO/T19ONuJrDcydoGbzwqHko/uZ4ruJ9JQsR5IVJxqB9nd
 M6hF0dTNTBCJEhFPerQRK3IwAAcjA4HQKTJeA6aW/nDJqARVkYhheWmMTqTasxbv/UuhfyBsrG
 bDdCicjYUDoNK7ptM8nzkrOUrATBMIEybYQikU74+OZ30pGylyhRDbBE81NZ/nWcI2mSXkHlUm
 Xz4=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Oct 2023 23:25:37 -0700
IronPort-SDR: F9jfIQQsSSLPypV1Dw8C/eihRw9wNLVT4j3ZMJrF00XiAokRiD8UJQghpgZUafeW3yUs6S70f1
 nJzxxoRbkV9pS91sgp9EO8TspqvFOBR9r8hdpGdNxtq0qSQJeSGF3jQC26K9BEoUbmdyt3fWI+
 avMWqkx/JDT8RL33VpaY/Avaqd1HBaoQr8hWZplpgqIgn2eHTqi6cvHMj1CxpXXANIHKdbRPjx
 Abt5re0DlbxTiOFi38Yiyvv+gfp8ILtppGE+UcVKkLIP0ZMSacfdIQCppSC6Daug404VzLIhBs
 yz8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Oct 2023 00:13:20 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] t/zbd: avoid test case 45 failure
Date:   Fri,  6 Oct 2023 16:13:20 +0900
Message-ID: <20231006071320.425270-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When zonemode=zbd option is not specified, random writes to zoned block
devices fail because writes to sequential write required zones shall
happen only at write pointers. Randomly chosen write addresses do not
match with the write pointers, then fail. On such failures, fio prints
out the message below and tell users how to avoid the failures:

    "fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd".

The test case 45 in t/zbd/test-zbd-support confirms the message is
printed when the first random write command to a sequential write
required zone fails. However, the random write can succeed very rarely
since the randomly chosen write address can be same as the write pointer
address. For example, a zoned block device with 1MB zone size with 4KB
block size device can have the first random write at write pointer with
ratio of 4KB/1MB = 1/256. This causes sporadic test case failures.

Avoid the failures by two changes. Firstly, change the random write
range from a zone to whole sequential write required zones to reduce the
failure ratio. Secondly, repeat the test if the message is not printed
by the accidental write success. As the test repeated, failure ratio is
multiplied and the failure ratio becomes as small as it can be ignored.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 0436d319..2f15a191 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1058,15 +1058,20 @@ test44() {
 
 test45() {
     local bs i
+    local grep_str="fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
 
     require_zbd || return $SKIP_TESTCASE
     prep_write
     bs=$((min_seq_write_size))
-    run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
-		    --offset=$((first_sequential_zone_sector * 512)) \
-		    --size="$zone_size" --do_verify=1 --verify=md5 2>&1 |
-	tee -a "${logfile}.${test_number}" |
-	grep -q "fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
+    for ((i = 0; i < 10; i++)); do
+	    run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite \
+			    --offset=$((first_sequential_zone_sector * 512)) \
+			    --bs="$bs" --time_based --runtime=1s \
+			    --do_verify=1 --verify=md5 \
+		    >> "${logfile}.${test_number}" 2>&1
+	    grep -qe "$grep_str" "${logfile}.${test_number}" && return 0
+    done
+    return 1
 }
 
 # Random write to sequential zones, libaio, 8 jobs, queue depth 64 per job
-- 
2.41.0

