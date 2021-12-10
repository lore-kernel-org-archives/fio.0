Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AAEC43219
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhLJCTW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:22 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33942 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbhLJCTW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102548; x=1670638548;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Bp4MAATRdEK8GvjN/t638pN4BXWcVgCzgOeU9pKP2hU=;
  b=XdzfPTC3d4VccXw+Gj7gfc7EZwFcSOGMsb518wGzVHEuxhObxEeZgBg2
   eKbKUjIotj0bI4wxTRFEjvRfDmQgSxfpPO2mfKWcMtpaIlNjH7qhjkG+V
   1z7YaXwxGiohUGKQfYoMoHVvP5uz0UJkIYMRusJdI2+4kZzS0pGyTU1u8
   VbqwTPSunzyDWWsV7NPo4tXfcCq1E4SUlv4PVNUuQbMk+9trngSuZ8r+s
   Mi0w3QfyTHHyJi/bXkpqmv2Sg9F35uiV5N6wR4GN9IvVC8eFD72EubUus
   VKqR/vY6fA3jgq4fjhZb5lbK98RMeiAemc6PpIOPJyh2H2rfaUW5Mg6l6
   A==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907582"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:48 +0800
IronPort-SDR: dSG/Y/iE/VsMru5m5h3XIU99rmLKpTqSkiEfmYbBevOfEc4UKUnyiik13SuAjubCgsPe1MbA9p
 he7vufUcSL5VM4A0zxxr2AZAir+2utnQ+0n32/lO6M+DTKlN2NH5eVYe5kWE2sWnUQVvW7cSQd
 bdeB/eiavkxrf+tX8ivpEHD3A3OvgbGDuYzd8WHMOGM6LS0Y/selR+l1oiYe4oLEG8LHFCs1O0
 FuNLOzuX2jq4oGYdnpDYEZlBPC1X00tLi8ZbAiEgIIT8CYbAmVgGdlNZFQzwLONogitb9Zeeui
 maMmAA+jhOeHAZe10AkQItIw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:19 -0800
IronPort-SDR: lbYyONcVMav75y91WJ0TZiZlFjzOX+ah53hF31eX8U1uP+mLto9gOocRIgIhINV8nIKgZj2i/q
 R9VqOse/uWxpQ1FlssPvekYXX7+er3l8HKHdhT/xzA2zVy/uynYCiJ7AkoYLi29J59nquLSinX
 /R5g0I5Ix7JrVs3GsDLLr/nNhFdNNdmUy80cE/z8u6hxCHOUkjEIY73tjXqdyIF7ADOhJQsAQk
 zHBFmzAdSIwdmqszEifEAol5VH+MEZM022otKFtlHpOcZ+vAVo1lztyuNPByGxuQAn6Qyl7/FR
 cFs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dyq3Qj3z1RwFN
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102547; x=1641694548; bh=Bp4MAATRdEK8GvjN/t
        638pN4BXWcVgCzgOeU9pKP2hU=; b=B5Gs+QGRMjX+9L8RtA+3rXIL6eWpTDf7MR
        yyHhex4O9wpJ1jg57q0RqPU1lmvve3wrkoSCDYmSyeOlk8HAVAZ5nj/p3XxyEoIg
        /XdPQ6dDABSJleXRS6iX9LnAuOvKA/c9QL0inuKE/2jCB/kX7aE5P6D152n5qhlA
        WYMwkRuXU/RwntBgBh1Q8AjYf9xSZBbxyJAnWZXyBllAUrzrOM0N+HIoFbHhbsQG
        qEGAroyVQu2UYOVEI9Gw248qS/lrxz7vSj0e9tyrEsVzySoHPBLn+0SzlDhBnpQp
        I8fvfiRZvJXWpoqiuIjRTBJHn/rXlxxZ+WWd7FOPOhn+MKU1JX1g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id q7lV8D_jJJhx for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:47 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyp4j3Sz1RvTh;
        Thu,  9 Dec 2021 18:15:46 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/11] zbd: introduce zbd_verify_file_sizes()
Date:   Fri, 10 Dec 2021 11:15:35 +0900
Message-Id: <20211210021541.317315-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Introduce the helper function zbd_verify_file_sizes() to check whether
the offset and size options are aligned with zone boundaries for a
job/file combination. This avoids large indentation of the code in
zbd_verify_sizes() and makes the code easier to read.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 135 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 74 insertions(+), 61 deletions(-)

diff --git a/zbd.c b/zbd.c
index 70afdd82..70073461 100644
--- a/zbd.c
+++ b/zbd.c
@@ -485,76 +485,89 @@ static bool zbd_is_seq_job(struct fio_file *f)
 /*
  * Verify whether offset and size parameters are aligned with zone bound=
aries.
  */
-static bool zbd_verify_sizes(void)
+static bool zbd_verify_file_sizes(struct thread_data *td, struct fio_fil=
e *f)
 {
 	const struct fio_zone_info *z;
-	struct thread_data *td;
-	struct fio_file *f;
 	uint64_t new_offset, new_end;
 	uint32_t zone_idx;
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
+/*
+ * Verify whether offset and size parameters are aligned with zone bound=
aries.
+ */
+static bool zbd_verify_sizes(void)
+{
+	struct thread_data *td;
+	struct fio_file *f;
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
-				return false;
-			}
-
-			if (td->o.zone_skip % td->o.zone_size) {
-				log_err("%s: zoneskip %llu is not a multiple of the device zone size=
 %llu.\n",
-					f->file_name, td->o.zone_skip,
-					td->o.zone_size);
+			if (!zbd_verify_file_sizes(td, f))
 				return false;
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

