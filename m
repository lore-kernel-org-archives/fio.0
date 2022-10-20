Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECFBC4332F
	for <fio@archiver.kernel.org>; Thu, 20 Oct 2022 06:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiJTGjG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Oct 2022 02:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiJTGjF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Oct 2022 02:39:05 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F571C19F1
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 23:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666247940; x=1697783940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eld8vrDIY6YfNDPqE8QpRF5/+L9NANOfM0Pq2XuaJ+I=;
  b=EYnkyyJD5IwN6Zt2sSLtYwJQw/Q+yYkksoNhnNE4ttWTsJ/cWxlWeUC5
   JTLLq8VetDaAbAoSpgV47v9Imo2KY15jFjvlFuFWQ+SIfWrGbzPafK6GF
   QwbDLaqtd6axVfZJYmOuXS5RWRO3Xp6QpgMhsTWLn9f30/aylxIOvkHIh
   JLle8PiHroWd28BRQxUrBttuZ6tM/sFYXh2woaiQDAGI7hbLNScafFf3P
   Hy8vhc8LGoBMUNK8GCDiYdRx1O0WvFeX0gt2+UJQZfNuJs7mJle4Jfumh
   stXir4LiiVdpgIl8vgYX/stCnPEDI4dbzkuzwU4B4VR4VtAK1rKm2SSLB
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661788800"; 
   d="scan'208";a="212615961"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2022 14:38:59 +0800
IronPort-SDR: BzD43z481B8SoxNYIaBCkPxb4Xoe5MunuZSKH4SqO8I1lnxCrV8mXDepoB43OCaNdvsRDU89u9
 83ANy5P6MKQ1rrs7/47MBNwHjlZnHbVrwWO8bMqNpQf9hNgAUSOpB4mqiUDrTSVV3H0Eub5fU7
 I5TaNKaoV1XRyBpOud5GkDscygxpu5yNx1Fq/yRPPPuoJr/5VSXWepej30u5Jq0I4Taw8gUULU
 SdCfQ+0VvJsG6UB+IZbfhxDwggdPrZh4vT5TyI2OTvldh5UJXDl7+qb3HjrrADYAh7SMj4AhZ6
 Ivc7jEas0ZrQRsnu9bbRYiJq
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 22:58:28 -0700
IronPort-SDR: FjQImZ4VQe18ZwJU/fHTL3Hhh+Z86SaCSW692x60qors7xVlen/F6cdeV9H7hKMG5ToLL4et+q
 6ItA04ZDoCpNkduPHfrbWUh7TWmWfMvMjqEeMluVBAJ2JferBKJbvLBZkhUgr+I2gJyobPgXcO
 GezU1H0U02y99b2aqM6XnrUaxVH35l1XLeO/iP/8W2sYBNHG+/8dsu+bitEhrjajIVKVzOCo2K
 hqBPtIWYHKPkYXMGmd8dH73F/jycnlkhuZJOwHlCcDxZ+KFjB/Eja0xyvSGBUv4qb4U7/g0Okf
 zBs=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 19 Oct 2022 23:38:58 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/4] verify: fix numberio accounting of experimental verify
Date:   Thu, 20 Oct 2022 15:38:52 +0900
Message-Id: <20221020063854.839158-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
References: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

As for non-experimental verify, numberio is compared between the numbers
saved in metadata and written data header. As for experimental verify,
the metadata is not available. Instead of numberio in metadata, it
refers td->io_issues[] as the numberio value for the comparison.
However, td->io_issues[] is used not only for verify reads but also for
normal I/Os. It results in comparison with wrong numberio value and
verification failure.

Fix this issue by adding a new field td->verify_read_issues which counts
up number of verify reads. Substitute td->verify_read_issues to
io_u->numberio to refer it for the comparison in experimental verify
path. Also move td->io_issues[] substitution to io_u->numberio out of
populate_verify_io_u() to keep same behavior in non-experimental verify
path.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 backend.c | 6 +++++-
 fio.h     | 1 +
 verify.c  | 2 --
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/backend.c b/backend.c
index 15c6e0b3..ba954a6b 100644
--- a/backend.c
+++ b/backend.c
@@ -711,6 +711,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 					break;
 				} else if (io_u->ddir == DDIR_WRITE) {
 					io_u->ddir = DDIR_READ;
+					io_u->numberio = td->verify_read_issues;
+					td->verify_read_issues++;
 					populate_verify_io_u(td, io_u);
 					break;
 				} else {
@@ -1030,8 +1032,10 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			break;
 		}
 
-		if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY)
+		if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY) {
+			io_u->numberio = td->io_issues[io_u->ddir];
 			populate_verify_io_u(td, io_u);
+		}
 
 		ddir = io_u->ddir;
 
diff --git a/fio.h b/fio.h
index 0592a4c3..8da77640 100644
--- a/fio.h
+++ b/fio.h
@@ -356,6 +356,7 @@ struct thread_data {
 	 * Issue side
 	 */
 	uint64_t io_issues[DDIR_RWDIR_CNT];
+	uint64_t verify_read_issues;
 	uint64_t io_issue_bytes[DDIR_RWDIR_CNT];
 	uint64_t loops;
 
diff --git a/verify.c b/verify.c
index 0e1e4639..d6a229ca 100644
--- a/verify.c
+++ b/verify.c
@@ -1287,8 +1287,6 @@ void populate_verify_io_u(struct thread_data *td, struct io_u *io_u)
 	if (td->o.verify == VERIFY_NULL)
 		return;
 
-	io_u->numberio = td->io_issues[io_u->ddir];
-
 	fill_pattern_headers(td, io_u, 0, 0);
 }
 
-- 
2.37.1

