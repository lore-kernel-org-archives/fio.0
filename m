Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33ED6C38A02
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJ1LyU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiJ1LyR (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:17 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E41A1D2F5C
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958055; x=1698494055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ySRZgYyxXCmaPlygKH+nlzv6Oi+dAglwTXg7SgBewX8=;
  b=MxW0EjGA+NMOUF7pDjEN3bxOBLc9bBsISbYYAHB8k+vTHxW1pu0hRJue
   d5F+vJ3gyLE84440HtHhQRaKCOhGyENeV+nl49yCVrLRknVn6+eaYyZ2R
   JYLZlzMipO9X8G7AvSCiirjDGgEhdpPg+pS811dc4vA5+7Fjzgr1Pd+An
   SD5ObmD8FhZbNpkzT1hDGEDhOIG2e72rnehY8a8bprSUIRjGovziYeorM
   IqiFCJsHqyf/c8Hs7lzNSrMT5dytmwgtazV7jm3AyCq1OQYEcN1V6AKs0
   +FwSc8CWJFWnHZXv9D99AT80bXEtoPqFXR/8YyhrivbYyx2Oeolfzy0N3
   g==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074542"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:14 +0800
IronPort-SDR: BJjsKsadt/A7ORVd6/tQBumSyLhbKqO9ZZWfu1rKOC9Vau1CeMqy0oRqbs8tFwsr5Y72ZAKJ/1
 7U+OFKI91wtgnIl24HpD0oqQMuqHP7T4VvqovijUSJ0h+hW+c53aeGi9UXgDExhmug5eGQJZlT
 DnzLchax30oyiMce6nNb6Lo/21pIHLgc5LylnPSlAtcZYtqt081WW99fcdXlvs7HhzFQPsJKYf
 J7soqrv8BpyoybWyiiK43xTgBUkngIlsS2Pz8g5JzoxWC28cAl5hs3WLUjNqJk9DSf14dQeQfe
 K8SsDKwwtoIk4sfT4J8yRD8a
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:50 -0700
IronPort-SDR: 3nz/YOciS7aAiYuD3Kolxlo5GCQmhXprrw4VY/fPC5VDDsT5f9hT02nQnTbq/vnAp1BPJE6zR3
 1fpznSuvPE2eq8hb8wbio8iL+2YABYQ3HEX/CoVT0yLQd4tRTf3y0XqweTCZhD6pGRp1EyedLh
 KibP2/beTUnCjMECts3aXZhViR85kDT4JPZQMYEoT4EGMRSx74he1evTxSmHRVhe7Nchq1qUaA
 XfBXx6sKxhv+3yAgEh9bHZpq2dfR66tPDAcGANegQ2KJP6XMoG9nYjd4zKWr23CRJLCgyvoIti
 ScY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:14 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 11/13] t/zbd: add test case to check zone_reset_threshold option with verify
Date:   Fri, 28 Oct 2022 20:53:52 +0900
Message-Id: <20221028115354.971715-12-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent commit fix assertion failure observed with zone_reset_threshold
option with verify. Add a test case to confirm the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e17a81de..0e185997 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1276,6 +1276,20 @@ test58() {
 	    >>"${logfile}.${test_number}" 2>&1
 }
 
+# Test zone_reset_threshold with verify.
+test59() {
+	local off bs loops=2 size=$((zone_size))
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+
+	bs=$(min $((256*1024)) "$zone_size")
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$size --loops=$loops --do_verify=1 --verify=md5 \
+		       --zone_reset_frequency=.9 --zone_reset_threshold=.1 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.37.1

