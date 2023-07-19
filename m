Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9508C001DE
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjGSK6N (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjGSK6L (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:11 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B6B197
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764290; x=1721300290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lFsH9BdFpieg0WbjMmI5MEqKdlakyTU+ZuF0VOrOLsY=;
  b=PsXsN/xp/QasN3iveX1zCuuWbhgdK/U6krJVYUDqQp1nfnEC0uInJoSS
   rac+zNo2Udn1msczG43J8xoWb88DIJnlhKkT6z2ahP3QyGArSfddcDbJ0
   9K2W9UCyCKGZlkhzrRVS3MkxDz0owKOZ5UYNzx3PPe3mvorurLwHLBVfe
   DK2kcLgzQxHUJJmuLTYT5tU4h6l12JwXAzN3/oG7Cz2yEY8RATMH0RbZq
   Zi1FEFdEX/itkmvETX/mYMSKf9NtxjdBXvU6+9IEUbfc84KUR/n1OcD6u
   zl9TSKfoD4y8Ynb35jskaTG1qgJCgu6ENqSUTt2l0HcWvMhNRdYFuMAbp
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860340"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:10 +0800
IronPort-SDR: tDCnCVM9ugOCmEBLh+B5te3ugfd/9MqzsE2MQuCajyLt0PK+3tl/OUKe48upoFTFYZO5wGh6yU
 0s/iE07H0VHI6KmtgjnczxYOe1v4wA8R5lmc1w2ssR+U+omGZg2zQcnQoL8+64i0EeM5PguYHX
 c/1W1jDB2FqPo9m+2cHOdCw4ZRR/rounb7I1yfwAqvRt27SchcH7NdLx9yWBTiH7HUWmHBtFLf
 zqCmm9NUK/L7PysJ3hY/6D7DwT7lv+Wsmx8pO1bKR8hZeVAQHEaIr8MED+pGBi9Wc1JPdBsBjV
 cb4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:22 -0700
IronPort-SDR: TYW9OSq+brPwN35Kzkl9cbHEGvTHsXcOy1XzazfbpiL+VSP0nX4ZWN5P9VNwdAaqQ72vMvgoNS
 3Tzk6bpYwlXw/4thsLi20D43y7KL8Sq35pFRTAA5T02bvFlVajaNsbTJWr2IXpdX2nUeAgxfRx
 YY3CME54Tsu8GaLCV4ZmMOYDV9ZhmixK0z37JDE9W8rXWC7TODhiAalxb07Gn7o6W6AdBj7Xea
 i1rLGmZs18FqasAKgOKUO0doWZL+gnC92u85vPf8K3YgG7nmznf16y5/QY202+/uCfs6UqZP/V
 /SE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:10 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 10/13] t/zbd: fix fio failure check and SG node failure in test case 31
Date:   Wed, 19 Jul 2023 19:57:53 +0900
Message-Id: <20230719105756.553146-11-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
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

