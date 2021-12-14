Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C54DC433FE
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243260AbhLNBYZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:25 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60902 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243119AbhLNBYZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445065; x=1670981065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mBAgoDmqyq7xzgOm2e0FXIXYxlTW0XecMF03lu/YPiI=;
  b=h/tcAg29HzTzJuE+ZbFWYdDEyOqV5ITEfFudWr8zST4NPR6umBOc5kyB
   Rjn0uGMkCnWinetLjdluBEDb8BC0nUqZXiDIMsnPWT0IbZehetbkroqKo
   OytxNB/DemWT91AFyxZ6CqWDDe+ZWg8ikscBUZltKEe9tCO3UvVFGv1oJ
   vbf6PpcF0IaZf8ehksvOhZjRpYXbkNFptJfx/0N9N6d8CE9izPyAr7PyD
   y1gTU3U42DRVe5EvimEnxNt24Em1ebyoDtH2OMOK7rlKS1FiIOG/84rqN
   Uk3GMOt9y9QRs5MvY2ntJfn8q0cOfxcmvwVoU6+x5AQ3gXAz9YnuodW9U
   g==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300014506"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:24 +0800
IronPort-SDR: m9v3xRHCJuOT6TxJUk9lcHakfu5w1P2QSS8tnl454p63Zexmc5FfLzwOiwxLteMQoHCyr5JXqo
 n6OPR2j60w7QgV64DImnjYdB9RZDXcHi4RjZ+K20SSXCRz8pVQkllvwVAg7IFoGVWDJGUFdHzl
 zAvoS7aKnlSSPVGb+ckUhzJFwRshu6RBma3qNBXcqSmJSgCWTQL/9NDtP0skVZKtVrZ+YPdb4d
 yutbXmoefMrolbRoz/ag2S/ogSXOuR02Uy4p6i5409V+RBAC6rqfpVmPv0hO0CsuO6xgWTSS7d
 hrIIrZ3hR4pfZ/Ug01J4MgcL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:51 -0800
IronPort-SDR: jFQABsSW/vbmp/7gIA1IByJh1qk1FObKUqk/mYndiDIiE9mhK8YYJ3F91Nklj5AIxX1pPSkSWJ
 LiV2FFd0HWUskg2DOgWIq1TSLaUT7iMQbZegDEacVYY3FVI7d26E4cvhVt3r2vakgc4Sga//Qw
 tuQ86gePYQv6XSB4Z/58MSjnpahiTuQVTLMMHSzbegKRQ65UOE1pmOsXdDOENcpvJaaNeG9TpH
 rqxwHw3iPH+Cb5bZmWj79qhL8O2bMcbPl4M+sYgjRrlTA4vORuij/NSCe4fACD5TyzJgm59pyI
 io4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:25 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdh5bSYz1Rwnv
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:24 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445064; x=1642037065; bh=mBAgoDmqyq7xzgOm2e
        0FXIXYxlTW0XecMF03lu/YPiI=; b=dXL9w+KYL6zQxL01/ivYu09qKS48RRLfsA
        MSy3tM6tfMn7jqEfSeVK0kaCPvyRenSoWsJul6Il4n6TmkAWGpKcnLLAQgH6aHpa
        XyXniFa3YNeAr7AwQ41vW91punFK360G9LG4NhhPERSOs88rD3WWRQ5iQIHwUxON
        nzzkCrRAhS/KdHaXh6lD9Rry+YvWoB+sPsGCnzKPgpO0C+Vsor1iA3agX9tQ+78t
        8v04dQOh5DXQGSEyqrXCn0EYPLuTBmPsVWmehabitKiEmbwvDYPO9JE14EUZOp8d
        IuMBdGIu6vHGiksDW8FV649FljWQecb+8lCzfkwJXa644FZKTnFQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8LBw4LXRFlIZ for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:24 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdg4y7Jz1RtVG;
        Mon, 13 Dec 2021 17:24:23 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 08/12] zbd: simplify zbd_open_zone()
Date:   Tue, 14 Dec 2021 10:24:09 +0900
Message-Id: <20211214012413.464798-9-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Similarly to zbd_close_zone(), directly pass a pointer to a zone
information structure to zbd_open_zone() instead of a zone number.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/zbd.c b/zbd.c
index 26387335..b917fa42 100644
--- a/zbd.c
+++ b/zbd.c
@@ -400,11 +400,11 @@ static int zbd_get_max_open_zones(struct thread_dat=
a *td, struct fio_file *f,
  * to be exceeded.
  */
 static bool zbd_open_zone(struct thread_data *td, const struct fio_file =
*f,
-			  uint32_t zone_idx)
+			  struct fio_zone_info *z)
 {
 	const uint64_t min_bs =3D td->o.min_bs[DDIR_WRITE];
 	struct zoned_block_device_info *zbdi =3D f->zbd_info;
-	struct fio_zone_info *z =3D get_zone(f, zone_idx);
+	uint32_t zone_idx =3D zbd_zone_nr(f, z);
 	bool res =3D true;
=20
 	if (z->cond =3D=3D ZBD_ZONE_COND_OFFLINE)
@@ -446,7 +446,7 @@ static bool zbd_open_zone(struct thread_data *td, con=
st struct fio_file *f,
 	if (zbdi->num_open_zones >=3D zbdi->max_open_zones)
 		goto out;
=20
-	dprint(FD_ZBD, "%s: opening zone %d\n",
+	dprint(FD_ZBD, "%s: opening zone %u\n",
 	       f->file_name, zone_idx);
=20
 	zbdi->open_zones[zbdi->num_open_zones++] =3D zone_idx;
@@ -1087,7 +1087,7 @@ int zbd_setup_files(struct thread_data *td)
 			if (z->cond !=3D ZBD_ZONE_COND_IMP_OPEN &&
 			    z->cond !=3D ZBD_ZONE_COND_EXP_OPEN)
 				continue;
-			if (zbd_open_zone(td, f, zi))
+			if (zbd_open_zone(td, f, z))
 				continue;
 			/*
 			 * If the number of open zones exceeds specified limits,
@@ -1409,7 +1409,7 @@ retry:
 		zone_lock(td, f, z);
 		if (z->open)
 			continue;
-		if (zbd_open_zone(td, f, zone_idx))
+		if (zbd_open_zone(td, f, z))
 			goto out;
 	}
=20
@@ -1478,7 +1478,7 @@ static struct fio_zone_info *zbd_replay_write_order=
(struct thread_data *td,
 	const struct fio_file *f =3D io_u->file;
 	const uint64_t min_bs =3D td->o.min_bs[DDIR_WRITE];
=20
-	if (!zbd_open_zone(td, f, zbd_zone_nr(f, z))) {
+	if (!zbd_open_zone(td, f, z)) {
 		zone_unlock(z);
 		z =3D zbd_convert_to_open_zone(td, io_u);
 		assert(z);
@@ -1947,7 +1947,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			goto eof;
 		}
=20
-		if (!zbd_open_zone(td, f, zone_idx_b)) {
+		if (!zbd_open_zone(td, f, zb)) {
 			zone_unlock(zb);
 			zb =3D zbd_convert_to_open_zone(td, io_u);
 			if (!zb) {
--=20
2.31.1

