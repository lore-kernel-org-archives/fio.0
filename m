Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12097C4321E
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiKHIuD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiKHIt6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:58 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C935D2DA80
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897397; x=1699433397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YiX0Lste59HJ4kM54FfN4+3UN/TertJJ8B7V+F8kpGs=;
  b=ZN2FwqRh89TECWt/pwM3A9h9nkOQSRdpp/fkzK1WwoPFw06hab/Ao8Nq
   6YK6gd2w0ZpogJE/LJioOhNIt0sObJBOJIzXAUKGwwoqCcUHqcGuCTo3w
   kvvLwssV05jfp5oqvmae+rZGxoqeC2R0A5HRR7V6XsE2llEDKwcaoh7iO
   /HdwMyQG2V0r8/G3yjkG8jY7VHtEQCevC2Sj40jesyD5jsaSIw3DeBgG9
   FW1v5kWOFjNqyn0yU0kHPgglrZy3O9haxxQPYPBIoeQ0dHomZbtO1kT7z
   mybwL66k0f5L1B4r3c8WHVzhAattSdFhDt+Hh7aMMb9uLq3eD/rxbPnjM
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="215743481"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:57 +0800
IronPort-SDR: 47PRKylPODCX/IgpMRU+Ha63fhiEhLQ91oL7IP94z0DGJzNRQDZHsPWkPGJ6pdUW1TrdNv9IpD
 wPM9ZBw3b/CQLB2YsoFzrqlxbYuEGdx4NlRaHgj5WSkCQqIO6rLISN2OGZ+GgLFIroC2g+ZG8x
 nO75oPmJPyLHRxx69Frz//7QLlniAP84v3GBK+B/It0TyIkhZRM7qwXXw6aC9EU2BzY8jnapc+
 xVJmQi3a3xdguHjFvHxXR4xYtTeb6PF8fYEmNZ6gAelxRTkgMD8llCG0G7EFcPqhY9SHlVGvza
 n+4=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:18 -0800
IronPort-SDR: XNFm3Qy32mwkJbu1DU95DBYeFJcqH2v10h8xKFNTRwVYQuMqUpsMvp1BxRgzmyhtrledzGEibG
 wQD1XEQmA1SHo9DXp9v5SpZzTh4N22bJvfYSBfFxyiid83dKHofs8mSAXI+/F5l6T9cD3pE7Im
 7Fxfa4uPiHv2KZzAl/1N8HXIrFzmgQdci+MJQgCE6Y8gPgqaBB9tQ99oNnNeU09CpKAapiasLD
 W3K4D+sVO7X5Gupi18fADTL2vzmvXiU5is+UIIOolLcWYipzVRTSzAmiskpom+d2VQk3KaNQvQ
 njQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:57 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 12/13] t/zbd: remove experimental_verify option from test case #54
Date:   Tue,  8 Nov 2022 17:49:39 +0900
Message-Id: <20221108084940.1574939-13-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
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
index a1e68eea..7b2a71a5 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1178,7 +1178,6 @@ test54() {
 		--rw=randrw:2 --rwmixwrite=25 --bsrange=4k-${zone_size} \
 		--zonemode=zbd --zonesize=${zone_size} \
 		--verify=crc32c --do_verify=1 --verify_backlog=2 \
-		--experimental_verify=1 \
 		--alloc-size=65536 --random_generator=tausworthe64 \
 		${job_var_opts[@]} --debug=zbd \
 		>> "${logfile}.${test_number}" 2>&1 || return $?
-- 
2.37.1

