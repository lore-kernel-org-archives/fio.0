Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9324BC001DE
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjGSK6H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjGSK6G (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:06 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4396197
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764284; x=1721300284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zZk0bzjeX1u4dbsRpmx0ELsKSiVJsm/20JCbvwcKNRw=;
  b=qepNC12wz5J2ly2nEfB5e+ntImlNZeivIwOi04j0omJt8rAW0u47Rs8+
   YtmJ4KTvTW9ftMmjonxpI0tqrhcS6DJVtKw3BuouMo9ZBzTDYgAxXx4Ze
   S8BR0gqIA/DMkkx/rBxOjYLCIIx1CiBNjSIfe4d/BnkpC96a0M4ngVBXH
   0ikRS98/slJDBukIC6DPW0taFCMX0ZTPI/5J5jbH6X/nrnkDXdMWhMQjf
   KgSysYmU7soOUQD+U9x/e2y+KCq1XSiEnzgOTIX9P1KB3pQN2fdBsjfvt
   Buasb3YERqIPr11l+nogjs7Bw8gUOx6wbrrfXXQzOX9ESJI4kpfnhGTVm
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860318"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:01 +0800
IronPort-SDR: AOghWGXR6S96tHKlY+AFOdIsgtKaMXj1NNR8oEcKi2Aqli/BTVMpdmMia0m+X9bGF8tICYv4PT
 3itv1rtcWDf6dp85W5A+d90vaNcDKojDKaR3O8GcZFiRw5zWh+7yKM27Tbs4yaw8J67IfhIBWJ
 Y/4ghsnhJ+azxiGSjmMJwHNAUxZh2BZ423s8QnPm+LZeMlFFYGk/rmlG61WLAlMqFD1fp4l1xM
 HHav1l+WUQLv6mx+EpooXPmGEMDeb55Ep7P5ft4jeOQideb3/qmZa4A3imJvAAPsjHD02USbrs
 3dU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:12 -0700
IronPort-SDR: Nmh2avV68R7p21By7q5VDo3jx4R/CW53wOOvextb1lxvKrTkDPxfub+jFdmrtF2ZXClkXSiv96
 S6gS2vh5OHwUvYn6Fnp1b+zAD1td+ygVVD5eg1BeVtAI92qti3ZzpWdQwfdVvDGRVgSA8/aukm
 SP6WaN6gOthBKo/rVpAxKoTeNuzCbYNyu2c6kSixaLxEWbYJGqUorDxyTC6qCQ3bLKE5Juh3NB
 9JyH8FeraXsttbdR5DOSPVXRgHwu2bC7dpXfl36pVtx7uuyEzrjvnObUWWg/owqPCDzh0jTFCI
 bow=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:00 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 02/13] zbd: write to closed zones on the devices with max_active_zones limit
Date:   Wed, 19 Jul 2023 19:57:45 +0900
Message-Id: <20230719105756.553146-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
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
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index a5cb34d2..b05d2360 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1276,7 +1276,11 @@ int zbd_setup_files(struct thread_data *td)
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

