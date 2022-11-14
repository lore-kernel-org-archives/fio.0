Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E068C433FE
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiKNCN0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiKNCN0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:26 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFDAE00B
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392002; x=1699928002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5kMgLX3iNTKxbLOQG1EoLRxd/pdxp5W1x2n8aaiL5hk=;
  b=GG0/O9ou5KxCOQ6YR9KsL2/0X85TFGw552LepB7IboIklXTx5PtwZ74m
   BqYN+B3RFsnjNrF5DPvWL97dv6/5lCGHrsemnBX9HFx7fhvLt0LNkic8r
   qNJkxQw8pNygDQ9I4jKxEnE34KmudypolGj2NO6mHJ++bTSCeLTu4ynWl
   iyuQD9ruOz6KfHOq56pkDUSovVCdXlNCCnRdn6R57ncyotg3GuDznl8UH
   c2zqCnmrITHhUv9aU5Ut7+G4VTwEML9VG61BA+kKJ9gUuAEjetE4Pguug
   hckXMetjmGCIhagWGhRStpWUxS9TaidCOr7M75mkVHLw6nkB1zXdZ1uxl
   A==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279224"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:21 +0800
IronPort-SDR: EwQvcIOsPEMl6AgvwiW96+MZAHBgPLB5RlxhKAIMqP166Jn4eyOFJTLU+EvlvLTsTzPxxBeNwn
 N20onM2CC9v7+9XiE/UGajWekRTQ7wOu/RluYCaESmdTPDEbV8vURgbFaD1BgFuA7bovVFENY5
 AfZ0WcvroJyQvfldFnG5Q+1bWKhJmDCyXMxhhFrY7QTlWCgJ/w2zXu/3ukpWET6txOLX/hh5o1
 hiUAnBIYQfakdGT68gSC2N1QyfCabBRaQK0TpXfq3Pj4B8lJ6pEo9OyqtdAsikBfIgWyy/OoFO
 DIU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:20 -0800
IronPort-SDR: ymcv2yGBy7efpYCW2PSD3kg4eyk48a3SqDKKgItyLUSVL4vdEs5uSdFXbfnSWz4IOUBOWeGJzM
 8W4Y+jOI8+bNWmwFWa1v3rhtJdE1YIBnma8AUyHN5UPv3/nMrS58jfQXBsezXUW6J0az235Q8G
 1Co3DpnVjqXM1dobOReRdnhZ2bKzBQqdKEsL0VG5sYyv2/cvqjPvdCYBQH77kgFoPGGEe6az3R
 23OYqAdH0P7hreQSMTTP2/WFyfl5JdcxE5fXC/E7AoXjuZTCMFIgb2/Z1QuulqExqibxAY8zZP
 AJo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:20 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 05/13] zbd: allow block size not divisor of zone size
Date:   Mon, 14 Nov 2022 11:13:00 +0900
Message-Id: <20221114021308.1684141-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
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

