Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA963C433EF
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243162AbhLNBYV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:21 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:51731 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243142AbhLNBYU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445060; x=1670981060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w88FJvM2+sCA5cML6Xhcgcj7dcZnKbRFwKl2YGIHfWY=;
  b=i2hrgeIJBjD0lGWGlV/isZ+629Yw3siolQxOJFwJGB1RFvIiAuyNfCOn
   AQHguCUuFC5Y5yJxZIR5So+s4Pvu4r2sZwtfG50J3drNnsSsWiAskmClj
   APz1fXF5WEOP/UcBlbLRl5Lt5cTGdeCcqZLrmdoUXGEVGJLENLZzF5A1W
   Fxhg3G9SV10HbEHyWoH+uqJNJi3Z+Y6/llzNC1MyoSZZIjza3o5lc6q96
   0YWxBk2YbBGYmaX75xSiiCsHKTkFnx0ji8EC2vTnyH1ecJjUQ9+oq44RB
   dro7mI/uZIPHPuDwr1X1U8Z+Wik0C0H3sIk3EJ3BgwhbTWttIF+y9jmmh
   A==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="188163306"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:20 +0800
IronPort-SDR: Eu3ESnahiiJoMsu7oW2KPAdLZNRARDBADPNY0oyMxZKla1JVbXN6aOPi/GChZCbi0Nd97IqO7S
 Gsnek9SezFZ8hxqL8YaVLHrlcLcq/ag+CbP6SNwKaM8/nmPfW1rW0ifOa6yPSFevn/R6BTh3Ol
 vWxq/e5orqkV+VHPgbd171wNKIs6PvBy56NSG+KInw/Z+p7QOe5fGMrGCV7HwINMAcH3iYpUOj
 jNgTXfW5DcGAvri0260BDvgJd9B54tcYbemQkX85oy2G+f3f4ZCsJ0QQvZt0Ua7nf7gCTrwBNs
 iNnKhnVINtOdRfrBux97Ph60
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:46 -0800
IronPort-SDR: AzO7PRC7WJp1l2WfRAxyHpvQR1ttCIlEqPnQxGJc8JqhTlqcpxiOs0Y1bKL8zI0yG0391QBrht
 c2bmhQOXjMFfIT0u8X7d+gwp2Dcs4Mk0XGnJTd7091UtUhSZKEQKyXnVGfCb60CeQ27YGjNMzC
 4kiRIEChpnuZ2zNOb7V+5WmfxrJtYNnEskMZ+w9UGmrYERWhCjcS+00C0LYT410oQIOT3usOvt
 c51No1b24aUtBz/Lun1B66xr5nJjNGbcVLNOHJswtqygRks2FPs+OQXJ1SRIMdAUePEpl929Av
 iL8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:21 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdc2cyDz1Rwnx
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:20 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445059; x=1642037060; bh=w88FJvM2+sCA5cML6X
        hcgcj7dcZnKbRFwKl2YGIHfWY=; b=DlUOyU8BLAXmWlXF5QZKyfWndzevIbytcX
        cNfQyS23yq8sI0Nkc7tAyR8CEo2A3JJkmgXSLGOQjXNF9CwLPXuRMUFH0iHUA8B7
        B9kDjaq0nbTl49TRwP3wuJSSxWs4V4HS7k5dXGnlLwthXVP+MEdPv6BINbL/ymhz
        4CmyGxIxy7BhPdksYw2pQwWQyCa4asHQ8hbIqRMdscxvBVCqElHr9n6CZacipAxK
        OZP0dolAOf+ZtFgZyrOuPTQUfN6V0YyB7QsUXDM6W6LZcap5gzTNCS9/jdvtdYG9
        xJ9efzEDwh9pSPOrj3laxEOLF2s1QjvBLTPpUsVE+YaVoPoM2gNw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JZ4eFS0aXX_3 for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:19 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdZ6x1Kz1RtVG;
        Mon, 13 Dec 2021 17:24:18 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 04/12] zbd: remove is_zone_open() helper
Date:   Tue, 14 Dec 2021 10:24:05 +0900
Message-Id: <20211214012413.464798-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The helper function is_zone_open() is useless as a each zone has an open
flag indicating if it is part of the array of open zones. Remove this
function code and use the zone open flag in zbd_open_zone().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
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

