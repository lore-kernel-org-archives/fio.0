Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B20EB64D9
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjGGDPM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjGGDPK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:10 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DED19BD
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699709; x=1720235709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WDze5+hzF7mEC62SgdqnFeb2vNHVESEFhfbq2g047YY=;
  b=kt23RbKQKgNJmmHsGkhKp3wSVzPBKrCUTBz4tPl64TuYA0k8P6oO3nJu
   vXZJaCijHcwQfnJxN4AEP1fQ4VTzd9S1Vn4EVzQQJTJjdDhE9BKqH0jRB
   i+QGDyaVeIrERVYn3fY0U+6+MowH+efK99j4yLts2Ad6R5lZqUh2wn35j
   aSm8TkeLLeRDaz6Cyal6/cRPXgkuJQSQLc3fpYc1hip/LK0Hgp7jfpQuJ
   7qYr4CVmL11fRPgKSmeh/rVOJ1h7yIwOugNffnA2TzF7IkH2Mhul90jVF
   9MSyU6BQbrpoKsA2g4VowSh9vMjHiKTH0oYkOEPWgqTWcYRP5XlADrui/
   w==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468793"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:09 +0800
IronPort-SDR: l3yebK35nRWAJCpkuGZzb6odFIq6J12hkLozw7852ty9BPLnXljfYTNG+ShsqpezbkN2FbkIF6
 f5+T7UzX59IVg1YcrfF3O6pgqjlV9aKyxsUxmLwjcr/v0VXXDrhv9qIRhDj+wqb8E14kG3hBni
 A+URK1E1KmW3NJ3JinIdBP5l004aNcz7eksSNA0Fibp3IJYbqIhkXJ4SxSsUeRB+FT33FeGHpx
 dRdHC5gAP3/O3323PdD+VOAfifHpeuyxatfrCy5iqsRfanPnKBaLaDqGVl8pmLOc+Ql2gqqUlj
 lJI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:16 -0700
IronPort-SDR: v3xm56HR5ufsBoqdgZPb3siuyQOvOlKhhYrtTySzj7VmbyLbTPalaFuu32vyn2SK4VPa8yG/F4
 IJol1AB2liWy4EDWLTenHHMfuk1Tx386KYPq9Y2eZalcQ3Z1D0lM1n4jh1xcIdkg7aFAx5Nqfq
 WS+hrPIAfvESajZ+D32xEZqBg2ddrf+xSknH0IV+seIYrTqN9xV6X6zJWob8WV8Tf0a+FPSI2i
 Kzu5fQIm9khMxACnqdu2mN6Od1IqwkmmoMifSQFDEX4LNIbuNY+qtHB3SOiicpTVtaFkG9RJ+t
 2hU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:09 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 02/13] zbd: write to closed zones on the devices with max_active_zones limit
Date:   Fri,  7 Jul 2023 12:14:54 +0900
Message-Id: <20230707031505.3468915-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Current fio implementation does not handle zones in closed condition as
write target zones. When the device has max_active_zones limit, the
write to other zones may cause errors by exceeding the limit, since the
zones in closed condition consume the device resource for the
max_active_zones limit.

To avoid the error, handle the zones in closed condition as write target
in same manner as the zones in open condition when the device has the
max_active_zones limit. At the job start, check each condition of the
zones in the IO ranges and if it has closed condition, pass the zone
to zbd_write_zones_get() in same manner as the zones in open condition.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 9743b60e..3069ad1d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1255,7 +1255,11 @@ int zbd_setup_files(struct thread_data *td)
 		for (zi = f->min_zone; zi < f->max_zone; zi++) {
 			z = &zbd->zone_info[zi];
 			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
-			    z->cond != ZBD_ZONE_COND_EXP_OPEN)
+			    z->cond != ZBD_ZONE_COND_EXP_OPEN &&
+			    z->cond != ZBD_ZONE_COND_CLOSED)
+				continue;
+			if (!zbd->max_active_zones &&
+			    z->cond == ZBD_ZONE_COND_CLOSED)
 				continue;
 			if (__zbd_write_zone_get(td, f, z))
 				continue;
-- 
2.40.1

