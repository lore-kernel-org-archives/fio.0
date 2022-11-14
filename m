Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531C9C433FE
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbiKNCNq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbiKNCNl (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:41 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE057297
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392016; x=1699928016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XRb+U0VoNyFjBwzkaYcOgRRBDyqupQYSufv9D0DGQTs=;
  b=mB6fz9PmXZHDa2SEdZdXAXtw5f92yFmpLF7ooBforX6bmb1EYMkmqoTk
   NZHDIJ31f5KxZ/d3aBaMB8noDn+LowsQPp0AfTyn7WQ4zxv3AkZoDZ54n
   TX7gWbqsc7imHK1CC8ObAFdy/hOefzqopj3xk7R3f1w8gv4jG9NXXqkNj
   /ui500nhO4Myjxs/G3kCmPH1xIgtJXeNCLkl9bOFULcLMPCBMw2YT75K1
   nksdvRw5TqRnSm8grM9xH4bLSzIkzCemd/kRjHzWSvgkILLYSVh7lcozC
   yeGjuWqAgaob0KpxjEtKK7KTlunLjagvPvdSRNWTQssVITlHuSh4yywd8
   w==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279249"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:36 +0800
IronPort-SDR: G2KekScGUClNGcyxHCKAYttauOaSom+hTMS2t6hmVZLzKQA10Cdncm1UlqBw/JFObAVM41mRQQ
 nk6J3fkEc4T/B/Ui3JDxtNCZ6qc5I994tgqvULLBPcxtg90eOVgclTG2UaDBFC81k/lCXnTRfn
 HRIo5VIQKJeoxX2q+4hGQ5q4XbCdR7qz86/n5ej3+uHW32aAWku/z+TNCaDTFKyajM5pwjusaY
 1CysMVQbTKwbKbtFmu2clijwc8YMkUWtATIwYFicu79QKdBiLol9bRu1rylb4/6fbFVfszdTcc
 5ew=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:35 -0800
IronPort-SDR: k0VNQxnvpyhxlRXyq207lUWBrdskpX0KSIhsoSvVdPS4iVWNfOpJEROpTFdh/XKOPshcSm4dR5
 FSZER79kAruZ47DCIXVD28LmL6XEORwtZnom6QtKbhfJgSJu6yqkDyb5AHGH19i1bMyMWlaLna
 j39wSCVQo/fT55y3n9R5fG6P2xVLomdFo7id4OBF9Uv31FjM2rzwdKVuiovkGhwbaFKgr1VNb/
 KAzzty1a64s5i0/kgTJ7/Exi3bx0GHJbGIvABdpwO2wsjEwMNVRFkiejxoMwCPXP9cvnyNlTP0
 PdU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:36 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 12/13] t/zbd: remove experimental_verify option from test case #54
Date:   Mon, 14 Nov 2022 11:13:07 +0900
Message-Id: <20221114021308.1684141-13-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The option experimental_verify does not work with zonemode=zbd. Remove
it from the test case #54.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 1 -
 1 file changed, 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index fec93099..5124296c 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1182,7 +1182,6 @@ test54() {
 		--rw=randrw:2 --rwmixwrite=25 --bsrange=4k-${zone_size} \
 		--zonemode=zbd --zonesize=${zone_size} \
 		--verify=crc32c --do_verify=1 --verify_backlog=2 \
-		--experimental_verify=1 \
 		--alloc-size=65536 --random_generator=tausworthe64 \
 		${job_var_opts[@]} --debug=zbd \
 		>> "${logfile}.${test_number}" 2>&1 || return $?
-- 
2.37.1

