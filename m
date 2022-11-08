Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833FBC433FE
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiKHIt4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbiKHItx (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:53 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A656D2ED4D
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897392; x=1699433392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5kMgLX3iNTKxbLOQG1EoLRxd/pdxp5W1x2n8aaiL5hk=;
  b=rfxwLKRMuECkYu5rwtLFYw54M1SQ9ea7VMTQnEvJhD4ea3cZp4WGXQXC
   +vJhZl6j2LDc3gEJantwqaBomrdcHio0bQZ26UgNeRKBHl1kIEPIGBu67
   ZHSGSn74c1iosv+/XYWshMtL/jZYtQ6AYi5dtvF45TkZ8xHIwIyQ/3z5/
   vlj7ESgBO1W3WSXiBnHZ0x26GzTya5Wmy3/E6ixGyhuMr7nN2MKFZb6SC
   62hqIDsY5KXGES/Z6xNcHeXvhSHFIBkoheWLRdFTA7QRSXp+4Mr4DQf6v
   WuDDy6+1icfY/8JGuMbSzdoSXBTR9tR/RHY2xV4WVPhIOPw2+xtoeimrA
   A==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="320079430"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:50 +0800
IronPort-SDR: BYKffTq94ceKPQ4GrZQH+ELPVXZGVE7w+OEatHK844ZqJhBwNnB9uA7aflP7F3J1CNrHh87jLp
 5OmNyZ6EXRcr+3C2DxJxExPfIJ9p61bqnxWp5D6xhtah9SHh0WO9eu11XcflmxxtfyVx72Ffrx
 SHJXFSoEk7nbQxeA6o0S3dcVKVpmGwam56qgO9MQ55HrlXN4ePixxjRoBVFFoVgaNW+hladSi6
 VFjLe1zOma1BOvnrIw2btzNa9mmsDZ5scgoUbBZbapLrH9MhnY83bBERSNp5dZesUj//4wWJeF
 5F4=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:09 -0800
IronPort-SDR: RiyVOnUtJ6I6T0t30G5DNpqUXolJe80bXXNI5uCwtDyouP6i+7F0JXDmeHHTSviqBr/U7O7frd
 kqGddvmHgrtICX2YdpQMF3uWzr/xzyqvOQe+dAVdToiUk5RaW3FiZz8O1BM8Y6yqW9v8vcJvJh
 wRxsPy0MN3ze6pbkA0zxNtRIM5cV/niSIXYxSULOLtdtfvbgkj2GFCcAdzEktqL8OtI7m7jIsl
 3j/wg2yAc8nB/Y+iAWheTAsS3RaEJsiiyGsjVICLrMfwX5Ye36vuPeVg0DjUWttC7IaapDlSDH
 008=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:48 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 05/13] zbd: allow block size not divisor of zone size
Date:   Tue,  8 Nov 2022 17:49:32 +0900
Message-Id: <20221108084940.1574939-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Current implementation checks that block size is divisor of zone size
when verify work load is specified. After the recent fix of block size
unaligned to zone, this check is no longer valid. Remove the check.

The check had been valid since such block size left unwritten area at
each zone end and keeps the zones in open/active status until verify
read is done. It easily hit max open/active zones limitation. After the
fix, the zones with unwritten area are finished then they do not hit the
limitation.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/zbd.c b/zbd.c
index 9ab78e2e..6f4e5ab2 100644
--- a/zbd.c
+++ b/zbd.c
@@ -652,7 +652,7 @@ static bool zbd_verify_bs(void)
 {
 	struct thread_data *td;
 	struct fio_file *f;
-	int i, j, k;
+	int i, j;
 
 	for_each_td(td, i) {
 		if (td_trim(td) &&
@@ -674,15 +674,6 @@ static bool zbd_verify_bs(void)
 					 zone_size);
 				return false;
 			}
-			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
-				if (td->o.verify != VERIFY_NONE &&
-				    zone_size % td->o.bs[k] != 0) {
-					log_info("%s: block size %llu is not a divisor of the zone size %"PRIu64"\n",
-						 f->file_name, td->o.bs[k],
-						 zone_size);
-					return false;
-				}
-			}
 		}
 	}
 	return true;
-- 
2.37.1

