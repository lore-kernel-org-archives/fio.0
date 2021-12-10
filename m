Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4974C433FE
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbhLJCT3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:29 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33951 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbhLJCTZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102551; x=1670638551;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=vewTrxgGJ0T07zcnWU3C8fpW4E2G0J+waZX6ZcPC2pk=;
  b=HobOhumEzpr8RhnehaXeKg8WGvzJT64tcZbFQyzwKXUiVv/2RezLx5Et
   ASLN1jJvyjTqLbWe4k0M8+2CHzpUw+UN9R2KEqufxgEWIMpkaq9GoprQd
   j+39avawjMCzuOEeNG/k7kUlRMaIUFqvunjIHE+pM05M+yglYO7xJJZLE
   kCNbZABSg3bPdmOEwz7uBqkCe+DakEGJajCTLmv2LA2ZPC4m6oc635ijO
   n8TjOP8td+AfzdfgiElE6Y2rYbQ9aQqS82jvIKrFR5pm9pQ3Ag0lY2TT4
   qvWw4kSAUiTfFSe5EybH1kcaxG0Gv/S2TcUQXBcRGQByn7WZuo9y8J5O5
   A==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907588"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:50 +0800
IronPort-SDR: nGQP8mQeMJC8mahcukGk2J+yb7orkCDT69ckT0hCt3XakJQPB0bv1u+sv+vkdZ/KGMDWfiK5l7
 FCKgnL+AIPKqakbfWhuW7izTDQE+r7iCkW/CrAKY53KwQoe5Eo3RMvRHA4YSVP3Rg1OGFFT3iA
 dejHYvQ5ntn+4W9ZVxe+k2CTOI7ZuyFEwsylw4/D33l5BqLuDgXYUz18vk6QZK8ASAS7DBxf52
 RLtFCWB4IM1rNlMnmoZviGwFM/+UzK2Woh7zycFRmscsOvK34uzu+06srTJMtImxcoBrz9KSqe
 VcdY52NnhpJ4OQI0DjX7GAma
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:22 -0800
IronPort-SDR: K7TYQWz74AjN6kW0LrEPZn798cjCcSP9rUqF7Zj6YswphK39XR6G0n91DRRE6kbPE/KjNBsBS3
 4DOwfwgx5MBUuN2UzTlK1q9aWndn7Yrz3/D4eEBB80IyQaT5Iaw4Se3GZQe8JVh1Dtw7X0q6L4
 vCdjNru95r8AgxdTWSbYLv8hwnJRhwYD6zLVrP0ueIkQqsUF/cWjq+kbuG1gs7lJUS2hAM1Lg5
 DUrnmn36PApKHeu3SYJAHg+4oniRNzUOq/YjbXkuzXU+9yEn0QTtcBpTRscsF6hAkcuBM0SuAo
 QL0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dys6HVFz1RwFN
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:49 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102549; x=1641694550; bh=vewTrxgGJ0T07zcnWU
        3C8fpW4E2G0J+waZX6ZcPC2pk=; b=Vkv0R4BxLc0IrZqOFL0MXsptSy5LIlejgT
        Z1D4qvmr1pbdZIEZG+CEMFCNr0JnhOHNWc+wd5BOTP3wgj9ZadvztrwfToRQxjRJ
        ME0W4jVBVelpzeZfSQnQAIbbvuOVoZdcNyo/4aF+PcTwFw4K869YVpOI887K0PWb
        27mOhnKDOkkG3zCr0rdNM5bQg5IBp1wvTivruAPlF0tYqjsqeV0iZ/qktXyJCm00
        UTsRSf1DpJwOmDhpJimgG8TxkD311TGFfoMNz8Dq83A92IG5hvNqY4y+aDW8fqg6
        gaXNF8rvm+/TA0eQd+JfRhnZeA35bmDHzk8K3t35sirEa6lb/rcQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1rr-mztyaQAL for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:49 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dys0btfz1RtVG;
        Thu,  9 Dec 2021 18:15:48 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/11] zbd: simplify zbd_open_zone()
Date:   Fri, 10 Dec 2021 11:15:38 +0900
Message-Id: <20211210021541.317315-9-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
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
---
 zbd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/zbd.c b/zbd.c
index c0f43f21..49aee9b8 100644
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
@@ -1084,7 +1084,7 @@ int zbd_setup_files(struct thread_data *td)
 			if (z->cond !=3D ZBD_ZONE_COND_IMP_OPEN &&
 			    z->cond !=3D ZBD_ZONE_COND_EXP_OPEN)
 				continue;
-			if (zbd_open_zone(td, f, zi))
+			if (zbd_open_zone(td, f, z))
 				continue;
 			/*
 			 * If the number of open zones exceeds specified limits,
@@ -1406,7 +1406,7 @@ retry:
 		zone_lock(td, f, z);
 		if (z->open)
 			continue;
-		if (zbd_open_zone(td, f, zone_idx))
+		if (zbd_open_zone(td, f, z))
 			goto out;
 	}
=20
@@ -1475,7 +1475,7 @@ static struct fio_zone_info *zbd_replay_write_order=
(struct thread_data *td,
 	const struct fio_file *f =3D io_u->file;
 	const uint64_t min_bs =3D td->o.min_bs[DDIR_WRITE];
=20
-	if (!zbd_open_zone(td, f, zbd_zone_nr(f, z))) {
+	if (!zbd_open_zone(td, f, z)) {
 		zone_unlock(z);
 		z =3D zbd_convert_to_open_zone(td, io_u);
 		assert(z);
@@ -1944,7 +1944,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
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

