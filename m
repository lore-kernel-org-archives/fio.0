Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9936C433FE
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243204AbhLNBYW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:22 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60902 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243119AbhLNBYV (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445061; x=1670981061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YcA76tycOH+mNJcj8OUI7/3p3CiLLhFneCGmt0o3GsY=;
  b=F+tJ0TAQRQ3WAuewRMOuSnCbqIGjA3dssz05tYvNMDh+4+w8cJ9m1ydn
   TgM+cBts38xRqMj3T/RPYNWD2cchCx58o591RxdwBlRceBvdiaD7UpYK4
   9Xy/uMg5ofGOFgD/V9wHrbbZ7pMCbULat+xHjZTO2ajmybXzud3ftXyOr
   9HUqif0IYzliwD/nmzldCOiHLkJd59JCyIZjgvcgYlf3qbno6wJgeTNK6
   ZGN/n+eml/eU4pqA+GKJy/Sise9f7+6NjzfleDx1tlR24giwrUlhqjVzh
   TB5/1Usnr+uSVKhSsCirKFQK3jHHf5dYUI6ybSLuLut1UmmgvKdbv2G9Y
   g==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300014500"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:21 +0800
IronPort-SDR: s4GTbAkobaOImXIPORt4tlkJhuOEAOkGifSOhtt8Gl6lWHMR5qcMz5E7M9ZCDBx+9Q76k4S2EL
 NTrTHLgiAUfSCJOJjZXojOIvCkqXD9kk+oF+u3jObCC1WfLeT7Yqjz0C2BpyG8gV8PF50kztMa
 Y2wVguE75q4EmH5zr9V/6sdYYwkPKZY2eyRWoWUBNZejutod4SfHYADlW6X7MrQD2ivGy7gptQ
 lmGjY3rZmdL0s2xhHWQtpbsDsvM40MpM5U9g52rTPHuUag2xMFdkCRHSk3teRuUpI63x3CclQq
 aGu7+EHHXDlnkJx+ni9TXVed
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:47 -0800
IronPort-SDR: EiO5pFarF4zbjwzYjRYFMYFuenSYplEIhzhVfgWNHhAouLkIzc9cIbZKNmr3QzkV84vIU/pKVh
 qURCOW1tEct7YvXSbqviDn+askbuYo2LNRU5FsyWSYjWvHvoMVEbJ/JrYvuQOiD0sGqLWY0LHh
 EhFVP0OjUBlA7e5iaSXk9/9Qi/6iPu/NgJ4p56j7gPQII5IqZ3IrmwkNFTPuLmbReZgHUGkPD2
 XXsjHL6SbYqWhJrlKNAHp/SPyeCwRKXOhlEknqlMmyVcGFjyozIfDjB/UOg86STR1j369QqOH0
 Yk4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:21 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdd1q9Wz1RvTh
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445060; x=1642037061; bh=YcA76tycOH+mNJcj8O
        UI7/3p3CiLLhFneCGmt0o3GsY=; b=j3TrtMElIOo1XQNgYK4qGmAkdnKm9jzMgd
        cqVr6P0r1gBHubnpiNwS0Y4HCVXrG8Nhso9W9N2+0nlbGDM/ZOfTBL/DpF560b6x
        rv8iZTi3N1ugzrxHIJmS9jFMCXSJnDZdzcgj4s/psOIoWJFEPa92sp/TDRUA0zQM
        XXGTV4+QUlvoSSKKDDDD4QGRPeLKu9kgy5mL91ucQ0GpCx9L4Z2VqkX4DC2WtpKt
        Ansa+AWKws0rDGh4CXudz5rotij/p6t3FEPPvq5AtwwP8huJSJ7lOwxPG67mcdz5
        EtYuca3OGXHGLXpLtwAbU8Ul2AMDe8EzVCUAYSdHLNUiPyTQfvuA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4Zn6CH7yvKRZ for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:20 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdc0yMtz1RwFN;
        Mon, 13 Dec 2021 17:24:20 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 05/12] zbd: introduce zbd_zone_align_file_sizes() helper
Date:   Tue, 14 Dec 2021 10:24:06 +0900
Message-Id: <20211214012413.464798-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Move the code for the innermost loop of the function zbd_verify_sizes()
to the new helper function zbd_zone_align_file_sizes(). This helper
avoids large indentation of the code in zbd_verify_sizes() and makes
the code easier to read.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 138 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 77 insertions(+), 61 deletions(-)

diff --git a/zbd.c b/zbd.c
index 70afdd82..11c15c62 100644
--- a/zbd.c
+++ b/zbd.c
@@ -482,79 +482,95 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	return false;
 }
=20
+/*
+ * Verify whether the file offset and size parameters are aligned with z=
one
+ * boundaries. If the file offset is not aligned, align it down to the s=
tart of
+ * the zone containing the start offset and align up the file io_size pa=
rameter.
+ */
+static bool zbd_zone_align_file_sizes(struct thread_data *td,
+				      struct fio_file *f)
+{
+	const struct fio_zone_info *z;
+	uint64_t new_offset, new_end;
+	uint32_t zone_idx;
+
+	if (!f->zbd_info)
+		return true;
+	if (f->file_offset >=3D f->real_file_size)
+		return true;
+	if (!zbd_is_seq_job(f))
+		return true;
+
+	if (!td->o.zone_size) {
+		td->o.zone_size =3D f->zbd_info->zone_size;
+		if (!td->o.zone_size) {
+			log_err("%s: invalid 0 zone size\n",
+				f->file_name);
+			return false;
+		}
+	} else if (td->o.zone_size !=3D f->zbd_info->zone_size) {
+		log_err("%s: zonesize %llu does not match the device zone size %"PRIu6=
4".\n",
+			f->file_name, td->o.zone_size,
+			f->zbd_info->zone_size);
+		return false;
+	}
+
+	if (td->o.zone_skip % td->o.zone_size) {
+		log_err("%s: zoneskip %llu is not a multiple of the device zone size %=
llu.\n",
+			f->file_name, td->o.zone_skip,
+			td->o.zone_size);
+		return false;
+	}
+
+	zone_idx =3D zbd_zone_idx(f, f->file_offset);
+	z =3D get_zone(f, zone_idx);
+	if ((f->file_offset !=3D z->start) &&
+	    (td->o.td_ddir !=3D TD_DDIR_READ)) {
+		new_offset =3D zbd_zone_end(z);
+		if (new_offset >=3D f->file_offset + f->io_size) {
+			log_info("%s: io_size must be at least one zone\n",
+				 f->file_name);
+			return false;
+		}
+		log_info("%s: rounded up offset from %"PRIu64" to %"PRIu64"\n",
+			 f->file_name, f->file_offset,
+			 new_offset);
+		f->io_size -=3D (new_offset - f->file_offset);
+		f->file_offset =3D new_offset;
+	}
+
+	zone_idx =3D zbd_zone_idx(f, f->file_offset + f->io_size);
+	z =3D get_zone(f, zone_idx);
+	new_end =3D z->start;
+	if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
+	    (f->file_offset + f->io_size !=3D new_end)) {
+		if (new_end <=3D f->file_offset) {
+			log_info("%s: io_size must be at least one zone\n",
+				 f->file_name);
+			return false;
+		}
+		log_info("%s: rounded down io_size from %"PRIu64" to %"PRIu64"\n",
+			 f->file_name, f->io_size,
+			 new_end - f->file_offset);
+		f->io_size =3D new_end - f->file_offset;
+	}
+
+	return true;
+}
+
 /*
  * Verify whether offset and size parameters are aligned with zone bound=
aries.
  */
 static bool zbd_verify_sizes(void)
 {
-	const struct fio_zone_info *z;
 	struct thread_data *td;
 	struct fio_file *f;
-	uint64_t new_offset, new_end;
-	uint32_t zone_idx;
 	int i, j;
=20
 	for_each_td(td, i) {
 		for_each_file(td, f, j) {
-			if (!f->zbd_info)
-				continue;
-			if (f->file_offset >=3D f->real_file_size)
-				continue;
-			if (!zbd_is_seq_job(f))
-				continue;
-
-			if (!td->o.zone_size) {
-				td->o.zone_size =3D f->zbd_info->zone_size;
-				if (!td->o.zone_size) {
-					log_err("%s: invalid 0 zone size\n",
-						f->file_name);
-					return false;
-				}
-			} else if (td->o.zone_size !=3D f->zbd_info->zone_size) {
-				log_err("%s: job parameter zonesize %llu does not match disk zone si=
ze %"PRIu64".\n",
-					f->file_name, td->o.zone_size,
-					f->zbd_info->zone_size);
+			if (!zbd_zone_align_file_sizes(td, f))
 				return false;
-			}
-
-			if (td->o.zone_skip % td->o.zone_size) {
-				log_err("%s: zoneskip %llu is not a multiple of the device zone size=
 %llu.\n",
-					f->file_name, td->o.zone_skip,
-					td->o.zone_size);
-				return false;
-			}
-
-			zone_idx =3D zbd_zone_idx(f, f->file_offset);
-			z =3D get_zone(f, zone_idx);
-			if ((f->file_offset !=3D z->start) &&
-			    (td->o.td_ddir !=3D TD_DDIR_READ)) {
-				new_offset =3D zbd_zone_end(z);
-				if (new_offset >=3D f->file_offset + f->io_size) {
-					log_info("%s: io_size must be at least one zone\n",
-						 f->file_name);
-					return false;
-				}
-				log_info("%s: rounded up offset from %"PRIu64" to %"PRIu64"\n",
-					 f->file_name, f->file_offset,
-					 new_offset);
-				f->io_size -=3D (new_offset - f->file_offset);
-				f->file_offset =3D new_offset;
-			}
-			zone_idx =3D zbd_zone_idx(f, f->file_offset + f->io_size);
-			z =3D get_zone(f, zone_idx);
-			new_end =3D z->start;
-			if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
-			    (f->file_offset + f->io_size !=3D new_end)) {
-				if (new_end <=3D f->file_offset) {
-					log_info("%s: io_size must be at least one zone\n",
-						 f->file_name);
-					return false;
-				}
-				log_info("%s: rounded down io_size from %"PRIu64" to %"PRIu64"\n",
-					 f->file_name, f->io_size,
-					 new_end - f->file_offset);
-				f->io_size =3D new_end - f->file_offset;
-			}
 		}
 	}
=20
--=20
2.31.1

