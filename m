Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E40BC4332F
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiKNCNp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235667AbiKNCNl (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:41 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F316C1144
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392014; x=1699928014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mWJwGAtV4bVbUSSD9bf6ObStJBUNQL0QasHfd/yokMI=;
  b=nJHWT8oujEd5BtNXDNZqCHfaKWHiYeIJsM2Scz/0mOKFCrxEsbs/qkFb
   mWnUyWm+nN9nfuX8VTpXI/qKj15e+EGv2r6b1mUSK3Dd+MATAHjXxLY5N
   OZNEYCYerD0/8ReeDVEpMD71Lpx8At7WSvCJmLLerIAh4bp+WlZriCJoo
   np/tIXc1aDUmWGKX2sSCtG3ldh6G0/zBRHj/jD7XQVo+fY3Tzd3eEgSwj
   MbkI+qhSnZpIWuAavnbizZzEqlP0+smzz8ZRrJAese/vq5l8pyZOllzYr
   QZDRZabCNbnas/FyaEAtLlnQ4AOm30gB3NVN3i21VP4KzQAoCDZWSCZ6v
   w==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279248"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:34 +0800
IronPort-SDR: AGp7RM8glLMtONjMeK2jwFDfjN9a4aiBJAXvIHkbqicTl+DNwpPPZ9McFHtQ3HkPYChxyQ+/4O
 9qCu7tIbe2LGZ5pq0Eot3POH/L2daAHYypy0AtPOCbw5WNQKq7s/N1z87VNPLKAChE7PLKgEbU
 OzjabWkCZyum1l9Kt7V3pd0x92LQMXjxR8yYkSnR5YJlQw5Er2yTo1lgey/h6Z3E9yI31HtC+Y
 Cgdtv48i+9J+xBHqWIdcDNK9SHzh1eKMqKlYsAZ5+5aho4IA+3iqgc9p5whHA91PAkOfp45Ozo
 VdI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:33 -0800
IronPort-SDR: mpATZVadX7Sc8xgBoEVsv2CtYOwOeAvmPvrDmJLjb24sM30SL4okq//zDuz6a+J99erB661I+9
 3NTJMkEA9uhY2DRaAeXsOHmlLBsrwxJ8UQI41saWOa27talJVHjNzVsBKSQn6xFjruhDXm94wK
 PYN/JnjpVDEoR8oXCP25zP03WrtjfTfNXs/fe+EL6aq+dGnu1ArmSeVw0FPbMqLsBWg+9oHgf+
 P2mfmTcVVVANuc5GwN1uFYK6EBu78EkdyBji5AE11GL+DRnpvAJ7Y40HD9VwNQws/mzpAtj/pg
 UcI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:33 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 11/13] t/zbd: add test case to check zone_reset_threshold/frequency with verify
Date:   Mon, 14 Nov 2022 11:13:06 +0900
Message-Id: <20221114021308.1684141-12-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent commit fixed assertion failure observed with zone_reset_threshold
and zone_reset_frequency options together with verify. Add a test case
to confirm the fix. Run four types of workloads and confirm no error.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 37af6724..fec93099 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1280,6 +1280,24 @@ test58() {
 	    >>"${logfile}.${test_number}" 2>&1
 }
 
+# Test zone_reset_threshold with verify.
+test59() {
+	local off bs loops=2 size=$((zone_size)) w
+	local -a workloads=(write randwrite rw randrw)
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+
+	bs=$(min $((256*1024)) "$zone_size")
+	for w in "${workloads[@]}"; do
+		run_fio_on_seq "$(ioengine "psync")" --rw=${w} --bs="$bs" \
+			       --size=$size --loops=$loops --do_verify=1 \
+			       --verify=md5 --zone_reset_frequency=.9 \
+			       --zone_reset_threshold=.1 \
+			       >> "${logfile}.${test_number}" 2>&1 || return $?
+	done
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.37.1

