Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7756CC433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbhLJCT3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:29 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33947 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235856AbhLJCTY (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102550; x=1670638550;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=AY01J5Vse2buD0Gt0s82IuJfpYIKBhwBCqZ3vAcIw3s=;
  b=N2ODHZdNnfZ14PYEoOh+FYfoGI+nN/a/ip0qoPNXT3IasW8ym0LFYbnY
   iGwFQtCoC56wqPSqCYvykj/JZ8iLWNMoShWBxfNjxqkAfwPGLMgnr4w9K
   ZYJxK4UQo8InFvRvipKIGlss1SO24QETbMi79i97BKRVN8WFrxnQQ0uAL
   DUH9J49OTSgOsWm04e7Lw3H1lB+LIyRxW+gJcMANNvZwZFPri/5BV6W6m
   ZO62kOP80qOMTWs/KUew/6NV/FHiSJXcACnv/JRCjxv7sDA9G2Towq/uK
   zE7th+l2eLp7NEc1E1qJV1QMY6L32537alki5C5b8w1B2Agp3NuR69AvN
   A==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907586"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:49 +0800
IronPort-SDR: pb3egAphhn6EQpBDpXLdF8MTzXxOMxQviu2fALT4j0b5XN8aZ15kJS0OBZRRu40+1L5Y6l4xQ2
 tSOmtLToFut9kksXGVXqGj0HX/VGXnFW+6SNoKsggoW5VaS5UWEQpy2eopZqjzHPD5/gXiyCeM
 jUzbwL1slXW7DvgfJuaprCj4M6mXKXTHAIJB6RS7nbKJtbNHNJ7+a59kb+dBobmyYiWa0VbFMl
 Z7tckrfyzNcIbtce2XfFYhbBkB7sSsrB7jxAjTgz+yGD4PQhPfgbTD5EaDkGV1O4wbXNsAqhAf
 YGGZQOtIfxMiQ4MB1MTSlH60
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:21 -0800
IronPort-SDR: ztQBGUAorgr3WNhRTzHEnHJ5UHFfeNqZU9SktKdH9X9tQRLKp54E6VDidBbAmp4darXxUMhXpx
 7AnzqFJo7Id42fuZbSqIy0HPjg8AoZQ8dvQV+p6vvyYjjnpnfJ5RtGxnICBt2C1YMLss08gTfS
 /JdHmgACgCtrSZ+6wyjPa3wpc/K6Y4sfRYJcf4BiKEJZVJE04hu0MG/0JCscwYu84DThkpKbeN
 K7WpFkl8e/Ekqj9HlmgnxIXoBxlAlzgGF+q2dPMQs06BThIE0Nr3yU+13RKbnzYtj8W0sI87+N
 sjo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:49 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dys12sDz1Rwns
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:49 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102548; x=1641694549; bh=AY01J5Vse2buD0Gt0s
        82IuJfpYIKBhwBCqZ3vAcIw3s=; b=iMiCihjbcstncvNB3AMxJ3nuVP4OBrlSst
        i4+Udfa8Bxj8krr51Yrsnfu3aIyggGLtmw+sNZTil3c6sykbB9OaBDdBJ7ksrNBM
        BOOdwer31/sOodMITRQvJJlg1AiqW4ShqSP5iws3njhvoKgnbKzzYiNFUQTVZv+w
        BpGJ7NaaobO6DQwi1mxRc+SoxYlpQHc+Y0uoLpyVEs5zW4m0R0Ptlo7y7OVEUr8Z
        420oJ9kRZ71a4+r7q/Tez7n7oLsaYvIixY0m6ifrmtn8DwcfKWh0jhcZ2aYZCHUN
        MPgWhfW1Mc1P0E4p1yeiOodOcwSKA05tOvSpT2KgZ65Tgu21BbEw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id onuHTrYd-quy for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:48 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyr2BGcz1RvTh;
        Thu,  9 Dec 2021 18:15:48 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/11] zbd: simplify zbd_close_zone()
Date:   Fri, 10 Dec 2021 11:15:37 +0900
Message-Id: <20211210021541.317315-8-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Change the interface of zbd_close_zone() to directly use a pointer to a
zone information structure as all callers already have this information.
Also do nothing for zones that are not marked as open instead of
figuring out this fact by searching the array of open zones.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/zbd.c b/zbd.c
index 6a26269d..c0f43f21 100644
--- a/zbd.c
+++ b/zbd.c
@@ -288,28 +288,31 @@ static int zbd_reset_zone(struct thread_data *td, s=
truct fio_file *f,
  * The caller must hold f->zbd_info->mutex.
  */
 static void zbd_close_zone(struct thread_data *td, const struct fio_file=
 *f,
-			   unsigned int zone_idx)
+			   struct fio_zone_info *z)
 {
-	uint32_t open_zone_idx =3D 0;
+	uint32_t ozi;
=20
-	for (; open_zone_idx < f->zbd_info->num_open_zones; open_zone_idx++) {
-		if (f->zbd_info->open_zones[open_zone_idx] =3D=3D zone_idx)
+	if (!z->open)
+		return;
+
+	for (ozi =3D 0; ozi < f->zbd_info->num_open_zones; ozi++) {
+		if (get_zone(f, f->zbd_info->open_zones[ozi]) =3D=3D z)
 			break;
 	}
-	if (open_zone_idx =3D=3D f->zbd_info->num_open_zones)
+	if (ozi =3D=3D f->zbd_info->num_open_zones)
 		return;
=20
-	dprint(FD_ZBD, "%s: closing zone %d\n",
-	       f->file_name, zone_idx);
+	dprint(FD_ZBD, "%s: closing zone %u\n",
+	       f->file_name, zbd_zone_nr(f, z));
=20
-	memmove(f->zbd_info->open_zones + open_zone_idx,
-		f->zbd_info->open_zones + open_zone_idx + 1,
-		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
+	memmove(f->zbd_info->open_zones + ozi,
+		f->zbd_info->open_zones + ozi + 1,
+		(ZBD_MAX_OPEN_ZONES - (ozi + 1)) *
 		sizeof(f->zbd_info->open_zones[0]));
=20
 	f->zbd_info->num_open_zones--;
 	td->num_open_zones--;
-	get_zone(f, zone_idx)->open =3D 0;
+	z->open =3D 0;
 }
=20
 /**
@@ -335,14 +338,12 @@ static int zbd_reset_zones(struct thread_data *td, =
struct fio_file *f,
 	       f->file_name, zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
=20
 	for (z =3D zb; z < ze; z++) {
-		uint32_t nz =3D zbd_zone_nr(f, z);
-
 		if (!z->has_wp)
 			continue;
=20
 		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, nz);
+		zbd_close_zone(td, f, z);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
=20
 		if (z->wp !=3D z->start) {
@@ -1568,7 +1569,7 @@ static void zbd_end_zone_io(struct thread_data *td,=
 const struct io_u *io_u,
 	if (io_u->ddir =3D=3D DDIR_WRITE &&
 	    io_u->offset + io_u->buflen >=3D zbd_zone_capacity_end(z)) {
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, zbd_zone_nr(f, z));
+		zbd_close_zone(td, f, z);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 	}
 }
--=20
2.31.1

