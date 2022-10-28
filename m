Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5813FA3741
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJ1LyF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJ1LyE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:04 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92881D2F43
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958042; x=1698494042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5kMgLX3iNTKxbLOQG1EoLRxd/pdxp5W1x2n8aaiL5hk=;
  b=enSV7AllLgvTY6yA0AWLcGEQoaLxZeL8DiGYYakP41Pr86jFHl9brOFt
   8vFWRPiaekaQC+23mnX63ki3j40YHqjNitGpQTJu0KxaeQz9fWO1eULX6
   SKtD8a65XhKsrGE640q/DREjzGDkUBe1xYP40RZLmc3RnnQNbX6HrYjFj
   5kI6Tw73dZeyo7BdE44rbp2j7oNfD26JVXbgEYze2LC4fVAm+/wk5qRrE
   ASvWrH28JRikLVB/JoDzRcU85myW8zI3iEvTvrz2CbdNyl/c1z/PXZQeH
   F1tfMJdNiZq+9SGPk8JQ0K9v05cDjWATbPWdkRoWy1XgsSX8TJN/fHNbv
   g==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074526"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:02 +0800
IronPort-SDR: BuWNHCjcoD5hDcsjcOU6enFV3aqyUxurjGh+2qR8udoedipQYNESG/9ze0lxkYRsd1VFxd7n//
 dhaMP+uldQgj0vhxoB5ZuBON1SVUiW7rA85fsDkv6Z9T2jn+hKH2fDoJsdD1AzUrLJwDgbZCbs
 Ht9zCc480j7AmRVupgChpuQjszY0IBgoYTSmFEFByrsOruyr/mtaDjsZTOl0TAA83nr90Mw8sO
 g+DC+Q3U4J7xK7Txz4O0HiBQk4n5qlFqzO+suszuFrYosBiiNRWq2bc01pc4txES9iT3cwKSDy
 KwJgCfLfThmd29579QLAPnuD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:39 -0700
IronPort-SDR: YTb2MuEXgADx9GFFk18olXDqVg/t7doLj7WpmYO18omcMd7ZlUlqLiVgW+GP1v1pbCJoHeSmro
 zwjEgmodaz2GyHE+0J46Hd4I86MaIlNFZf0QmaP8V39tEtwAjRLtI40jL/72mFdyVNuBXgvkwE
 GVN2xYuMXFd+x8kcdsafR3LnVrRDV8xYleKpnoU6tPeUNp/gK3rsMLfGwj3R9vbpa41BOJLQ8Y
 hUCdZ8E36RK2hsuIo/bk3dNpRsSkyJj9D/alxtTBrpE0o26Z9HV3Q5ID46EajduBlM1wKJb7l7
 0Oo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:02 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 05/13] zbd: allow block size not divisor of zone size
Date:   Fri, 28 Oct 2022 20:53:46 +0900
Message-Id: <20221028115354.971715-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
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

