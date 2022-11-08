Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10A2C43219
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiKHIuC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiKHIt5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:57 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF062ED4D
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897396; x=1699433396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=607VKYaUO21JCM+ZGnXqGzFjL/gCFRy/99rGKNjqakY=;
  b=oJMVSjS+7k4wTjhk66eZRpj3KntGIvODPwF+XZQnj4dFHL4UuuEYyWpx
   ePYZzUv59O/0TNzuwwjSx4zgmDnT4vVkDv6PSfWyG9nuGE52RoQ2brru4
   GFC+REsi07envIM4fg0labXTPcEhnxrf6YqAxx474Q+2cxfgpMaBSqn5y
   pvSepzEC2EDWROXqSq4lFO8yF1CyTuleWVbxBX09E4KK5Kxs+F+/oJGc5
   pBEi03R9pQ3YIDS5JxH3DM4x11IZoY8QLcyY2ULig7jAQC1LPFOs8Zmfx
   0bgKB3gQ++HDPsBLwAtcvZDHQ+IS7LwemK5Q4W2SNctDA1w37uCvfxt4b
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="215743480"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:56 +0800
IronPort-SDR: QJPoIrHH63GhKZDir2dnVl4dCT7vxA8KE1TUogPFOdOCPrUocWWfbZCenLMlTQX6l2Fyisfk9Z
 uePNzYZNwQyfeGfZpFNa00Ve8uwj5ieH+i45g0AnsL45XlF98oc7yta1q4HP2QUdIVmfGVw0Cu
 MCsDNM3QntA6F2sB4NjfmQ0Um9wT0QYu95BZsHboU9nyBOJDnPULscAC/q5LKymx7z3QnId8ga
 WWNBPjGOqxtS6E7+7dXtPjnWRnv4ClHPAlo7FytED43V9zV8cquFptzY5GNMnJd1eVytHypENL
 BlE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:17 -0800
IronPort-SDR: xjvGuY1YyzfhzT2eBsYVYFzaDxD51cr5KwFO+V5rFDNXuCmNfPu1Uo/YCpf3SX50/swWXycnIP
 +96xeB6apv7J4pSba8Ndar2+WC4T3Ekrj6k6IAe/lWPsiTb12INA/sOH0OYGSsPABD0c4DA0Gu
 mtc/keOERP+bfARIEta1biqmZ1qT/DbU+kK5MEtwlq3vtGY1Zc/pl2znu1s9bvq7drVp/vlH1E
 fQn2fFcM8pid4uC3aCw8qRJjsLZBbgzk0aqD5d9CRKU9BDbmaUKSpujUmiYR4Rd0ToEtRu8p7V
 Dwo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:56 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 11/13] t/zbd: add test case to check zone_reset_threshold/frequency with verify
Date:   Tue,  8 Nov 2022 17:49:38 +0900
Message-Id: <20221108084940.1574939-12-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
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
index e17a81de..a1e68eea 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1276,6 +1276,24 @@ test58() {
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

