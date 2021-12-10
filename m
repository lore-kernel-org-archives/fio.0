Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82951C43217
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhLJCTW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:22 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33942 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbhLJCTV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102547; x=1670638547;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=9rgyt1RLmWBiDDBwMx3Ms6PrrwQsZh3AX/56vlt3aE4=;
  b=Q/UXMLD0BGl/sBQ65x34gBTVIiQ6tqF+PO5meP7q10AwV/IZY47nE1SF
   Gc76i4GmjYG6Ryk6tiYu4RfK7W7R4OT0Jwcc4AyFfJNktX2sampRUMxA0
   HYnB9OgTboSLoB4mTHHAYajhgKo1NebE9sE4lyYeOdv+30p9xTjAr0O4q
   AC4AK4ZDOKifY2WveQAp2iaO5JRSiWaWC3gCUaH3vGsw8XZYXL58omhEY
   4s9hbxctbTr4JgmfJb4M89RuSyc696AJHm2bUrdxgHGhiVcUoBdIoFu8d
   XcQI95Y/J9w/3xt0PM93qAXHrBAQGP9drlKqeBhlkkYgil1gG/RJ81hUc
   A==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907580"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:47 +0800
IronPort-SDR: 3BdHvT09nVYM9HZd0vJS1XjNKk59Qc/KI13ImZgs52mgJ99XQl8ZRfF7rOCKe2zWzYEqXIuk1F
 ZgobOP4LV6kh5v9SQIA4DZnJuJzyWALJh4vChdBxZShcSwanpXDY5IZybOghaS49IYSMbuDHWB
 WzRKIdJpHH7X1kDLN8H4EDQROJLsqYZGSFo38f8bZ6QDyOiTcWGZwTqNXdxOMZQkQlCQ06d+LE
 PSL/3jG0vEVxqtlg3LvQA92wkQDpLh0vw29/qvy4CnGwyjNk/7v+zz8w6mMVFKLISdrnkuJ2ST
 opatO7rLvHdBZQzlQ2gLQxrk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:19 -0800
IronPort-SDR: XNGNQ6B7Nb9elOB/1IpT8GqQpMvNmvyZqlRQUWbEONKUiU6Tlbz8u456U3qA5CxlHHp11pk01t
 RXwkft1HYmaHuFsDmt1KSw/PUhrGPCwGC6ycvP5P88GcD7jggbqXsVVrKzlZELXBCMBGMTZ8wm
 qaEpadjloHtA7jXtagnwW59izFPrhk1jv9XFQj7UeRfZkpf/192TJ3zHQ9yK+7L8zBcH8xSYNk
 ixI74yPYl68qie4ukHjW80f0zs8wK2nSXVLiHbbmXdc/n+4jSMKsTtgL//WLpAyPUHZyFrzoHQ
 M4o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dyp5XxYz1RwFN
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102546; x=1641694547; bh=9rgyt1RLmWBiDDBwMx
        3Ms6PrrwQsZh3AX/56vlt3aE4=; b=Kktj9sxn1DCz2p/QdeZ2eARi+8ZguymnrB
        j+EKO2yD4uDIm+e0RmkJRMHNjEy2fpJj+dMmFeKoms0xQeFiOz3HeH7VxkO7EqUc
        ilIzyVStoZXhbQwgHQVKTFkwnmMgckcEmbEkDK7iBxK1zfNTC4D3vUVLpnhKr3m0
        +OyPyUh1QZh2lznJvYWqaXKGMylR6N1S6lTrfQFoLfAcWa/XjNER0ULFxInO7dCy
        Qb0aedflP9e71bL+IhafLt/Bw9+XpGko2ugxqieai55GVmQ9EZlE9rA+d/4rmV5R
        dLhnggwWQEqITimQ23PQh1Rq8AcoSPpABd2z7d9vodnpG+MlPaoA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id a1-EqD0ix_My for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:46 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyn6tsyz1RtVG;
        Thu,  9 Dec 2021 18:15:45 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/11] zbd: remove is_zone_open() helper
Date:   Fri, 10 Dec 2021 11:15:34 +0900
Message-Id: <20211210021541.317315-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The helper function is_zone_open() is useless as a each zone has an open
flag indicating if it is part of the array of open zones. Remove this
function code and use the zone open flag in zbd_open_zone().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 38 +++++---------------------------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff --git a/zbd.c b/zbd.c
index 20d53b15..70afdd82 100644
--- a/zbd.c
+++ b/zbd.c
@@ -377,36 +377,6 @@ static int zbd_get_max_open_zones(struct thread_data=
 *td, struct fio_file *f,
 	return ret;
 }
=20
-/**
- * is_zone_open - Test if a zone is already in the array of open zones.
- * @td: fio thread data.
- * @f: fio file for which to test zones.
- * @zone_idx: Index of the zone to check.
- *
- * The caller must hold f->zbd_info->mutex.
- */
-static bool is_zone_open(const struct thread_data *td, const struct fio_=
file *f,
-			 unsigned int zone_idx)
-{
-	struct zoned_block_device_info *zbdi =3D f->zbd_info;
-	int i;
-
-	/*
-	 * This function should never be called when zbdi->max_open_zones =3D=3D=
 0.
-	 */
-	assert(zbdi->max_open_zones);
-	assert(td->o.job_max_open_zones =3D=3D 0 ||
-	       td->num_open_zones <=3D td->o.job_max_open_zones);
-	assert(td->o.job_max_open_zones <=3D zbdi->max_open_zones);
-	assert(zbdi->num_open_zones <=3D zbdi->max_open_zones);
-
-	for (i =3D 0; i < zbdi->num_open_zones; i++)
-		if (zbdi->open_zones[i] =3D=3D zone_idx)
-			return true;
-
-	return false;
-}
-
 /**
  * zbd_open_zone - Add a zone to the array of open zones.
  * @td: fio thread data.
@@ -446,10 +416,12 @@ static bool zbd_open_zone(struct thread_data *td, c=
onst struct fio_file *f,
 		return true;
=20
 	pthread_mutex_lock(&zbdi->mutex);
-	if (is_zone_open(td, f, zone_idx)) {
+
+	if (z->open) {
 		/*
-		 * If the zone is already open and going to be full by writes
-		 * in-flight, handle it as a full zone instead of an open zone.
+		 * If the zone is going to be completely filled by writes
+		 * already in-flight, handle it as a full zone instead of an
+		 * open zone.
 		 */
 		if (z->wp >=3D zbd_zone_capacity_end(z))
 			res =3D false;
--=20
2.31.1

