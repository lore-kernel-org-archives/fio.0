Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2D2C433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243225AbhLNBYY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:24 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60902 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243119AbhLNBYY (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445064; x=1670981064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZoxaQHlTiop69TlwILuboahHmlEXr6aOsBKFdMT3fAI=;
  b=lA9D6fcvgiRXfDLAGKCsAaPELLNFWcbpchEJ2IflMlIor1eqX98b1w+/
   LZs+ahwD9ogXntgJH+i5HfOtE3zzmX4tvxcCrfEYfmUCXmiUVVFux2wJg
   wouSC+wTB/o1+oX+4VaW9mm7RkbGOpcgXKkw6kSf20ZGgN4qW9KAIqQqx
   a4reUQDK+eWT24kZ6BqWThObmmF46OkhXoA78QVN60QbHrULJu+rVBgF9
   1NcWy9CwqdLN/F++RkjxJsNdBPsN7vpNnzBVco4hIzi4p9WQgzO/u+I8c
   4ReyUyI+LeUUVCbWwD+Iv7Te/k3SkGzXx0YdsQIiAFXGLMAMo2IR1D3n5
   A==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300014504"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:24 +0800
IronPort-SDR: Djtv4Xo5UQcopgKenEvPbF/2tVSI4HC7pNpxHGxS/FvBp0KWREJA0RjDfWfA1XWhOKcS2wIrUr
 ToS3g82ULe3xLlBpYmBclBBDtTcAfCf+Tmkdop0ISY3ony3FRNijk/9QYMm1oX1ZeFZ8UYFs1g
 bMF42quLoUxKCz0cL1xU2MCl2CkmMiR4nVFSiAWZ2gK5lmGB9CMLmFwbw+UPYDEoWgtpDR2Y6s
 yWbPgedof/i/nu99mbsN4ERUrS6FMssxC5MyaTNiQqGyIEX+5xZG/GFV44n0blCt+E714UU9np
 RUt2EqOSTAZRB17dWEFd5b3y
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:50 -0800
IronPort-SDR: 6pLclccol5D2Olonu2ygS86EHF+7afq3e6brwuqz96TE4HlyjvshFGjLR0spRPMHxZJ3jlwj3u
 msuDAIYRNN/8d8MAUusRsQJZBXVi1RFHOjuh9iTnZOxofYeGSqXSaIirTELEJi5uaukim/h5ZE
 1J35k0oiD3EdV67yPueetc82u5PxbaYqJ5dr9SSk29SgkpNHy4KSg0ISor1vFTkddVaGJJbMM7
 SPZUDiZuHDfYWkbWKqN/Brd9xjqZpIGyvTymxHExBisiNor8SsNg0MWJexNE94ieeHVUJvK1md
 T7A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:24 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdg6BYTz1Rwns
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445063; x=1642037064; bh=ZoxaQHlTiop69TlwIL
        uboahHmlEXr6aOsBKFdMT3fAI=; b=Qy1/wkwZpLWb2127h4FOAg+zy5hU6dx7Uq
        0QJmnX7Bj0oMQNXf5C+EkGyPSDVMvFTWmUgpbkNilnVymAPPZ7UNBvUwN+v5WOcY
        7Arai7wqFhH1Lg94Ip95irOvpWgdWatZU2kMmIrVW/abK/pqADvc42rxmoX6gIcF
        wRf9za/a37G9fuJNU+x8DdEWBg7GkXnUiOz/DA24tyNF2D7aA4mTB0oDLOnXQECr
        ukNRFpuma0TD/nZ4tluGGfLUnbxVl5iSKGHYVP0XNIuVDv18PMIZlDABnsdA6JEn
        yPr64Iu4gLB+PX0MMzP1F6sEf4uL6YIGkeWeIzer75KZCMcbe5nA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tq2rPF-DcGtg for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:23 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdf3R9Zz1RvTh;
        Mon, 13 Dec 2021 17:24:22 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 07/12] zbd: simplify zbd_close_zone()
Date:   Tue, 14 Dec 2021 10:24:08 +0900
Message-Id: <20211214012413.464798-8-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/zbd.c b/zbd.c
index b87fefc4..26387335 100644
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
@@ -1571,7 +1572,7 @@ static void zbd_end_zone_io(struct thread_data *td,=
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

