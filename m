Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D8BEB64D9
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjGGDPc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjGGDPW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:22 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34111FD2
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699719; x=1720235719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lFsH9BdFpieg0WbjMmI5MEqKdlakyTU+ZuF0VOrOLsY=;
  b=iNgbrTDvoh5mcPb5aBy6AsvlFaPypi+9zfwnrQJVEvAV0Jj93Iro8mmu
   o0oCZ+Ldf7dOU8+JdNX2Y4str20/GyBVYmQUTqwMb46b5cpHm3lIMXSsf
   T6T2NC7phKFh0KLdNwe1RUV0JLyGiuflwUKGhysIGvx+cWL5z4XEkvluk
   lZG3ftH6d7/mzuVea5v20rFdSCvnIfz5u6cSlTlaB4sEbGw5sXWO+xmUb
   XWOTdFbNUYwAHedWCC8tCC3MARo1/t12OgcvoI8QMbK4nmvaFPmfS8ceX
   w4AxWmMFuGkVpNpNZVKrGUJXKb4dpK6xTRQkOFQr2KmY5cIpjll062p1l
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468817"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:19 +0800
IronPort-SDR: 7uSjncc1yaJpnAJPISvL3KB5jAvp69rqgkoBbpFsBZYiiShC/ESEwQGy53QF+5ZQamsfaBNc/1
 3UEKisiNfPP1hr2Ea5Azegdl026jbOfe8kLd1qdy3YvIedhZasIUMZ8wpShTlbrwaNNQ4wTr0n
 kzddY3kV7s3sD4lqOE84Lur7S0eIKURAaxLH2AVlgaleZykrCEDkoXfKxDxK8Pm+0DmA+1Sup9
 wNWkNJbwiEozgC0xGL8Wb9yOsR9OFzdslpUwwwfaXLSq1AvX4akID6nldkTlqMrpbdNYsF5r4u
 QS0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:26 -0700
IronPort-SDR: YjW35uDCD6JotntfqOZf+4ytACeSOk1gBbrA/9wg5YzUj/VrhRQV72T2DCRXf8Y4UjWwjEVmTg
 qrVoKYTm0IHO6q4KqX5yr6EGfM5yQoSwjnUk4xMne7sWoXf6tBAHe+RKt7lGDwx7qkionjhkNk
 kRmDYEHNhTYbKEORYVmRz4mswG6OV4mqOmK2AUJitPjzNGS0puQwBsdj6cd5GzgXxcPOIM24tC
 PX+gyWS8J1nPwK7jYr2ySEeoUJA5dfOUbl5YLIdkuc4bXs211ncKJtVjgjLP99Gbpn5GsqluF6
 aPo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:18 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 10/13] t/zbd: fix fio failure check and SG node failure in test case 31
Date:   Fri,  7 Jul 2023 12:15:02 +0900
Message-Id: <20230707031505.3468915-11-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test case 31 runs fio twice but the failure of the first fio run was
not checked. This allowed the test case pass even with wrong
max_open_zones value. To fix this, check exit code of the fio run.

Also, the first fio run fails when the test target devices are SG nodes,
since libzbc I/O engine is not used. To fix this, call the ioengine()
helper function which adjusts I/O engine for each device.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 1d1d389b..71cb18bb 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -794,9 +794,10 @@ test31() {
     opts=("--name=$dev" "--filename=$dev" "--rw=write" "--bs=${bs}")
     opts+=("--offset=$off" "--size=$((inc * nz))" "--io_size=$((bs * nz))")
     opts+=("--zonemode=strided" "--zonesize=${bs}" "--zonerange=${inc}")
-    opts+=("--direct=1")
+    opts+=("--direct=1" "$(ioengine "psync")")
     echo "fio ${opts[@]}" >> "${logfile}.${test_number}"
-    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
+    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" \
+				2>&1 || return $?
 
     # Next, run the test.
     opts=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
-- 
2.40.1

