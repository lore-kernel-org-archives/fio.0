Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125E1C4332F
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343491AbiASVOk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:14:40 -0500
Received: from mout.web.de ([212.227.15.3]:42805 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245473AbiASVOj (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642626878;
        bh=jxnjTL7UT49Zrl5v4ZywieQGlXd/yTrBHfPP16162Bo=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=op0SwY+tZ3FA7pIPf772klATHPpE7cmR4urtl8L3uSWbx9/z0WVhMyXzGI72Z7al2
         sKdYO95x9geqW0LB8DQ5h2M6kitCW1EULVl6Dd8Mmg7DLoeYT5VB/aFzo9jq4we3mm
         xLZ34EZ1CdjPPiR+pet6u9wHkfyl/C1BkJ5HOZCw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M4sbr-1nCDAA45rz-001jBq; Wed, 19
 Jan 2022 22:14:38 +0100
Date:   Wed, 19 Jan 2022 21:14:36 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 7/8] blktrace.c: Make thread-safe by removing local static
 variables
Message-ID: <b805bb3f6acf6c5b4d8811872c62af939aac62a7.1642626314.git.lukasstraub2@web.de>
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/A+PrpwYU=gbEnUZK7/hcp/w";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:jDVzyL8RhjbunvjHLg2W8SP1ErsHsrwEStbP2Rh0zPeaWsX0Keq
 G1fR5n8gbrpSwrzjuyC0L45AoqOR0nxzbrL3Obg9DDro6MBycVu2P0pGiFti+BiKGs8ThI3
 fNlnAncRL95tHExSIJ1z6lOZuxdedQoMEjiXESLJFK/nUAI3f9ZOflk8diXeGcE4ZLS+iqO
 9e7BKi9dICuH0BEL21ofA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tD2ZYg2dvWM=:+p4qMivBeUFVeuPGVu0qS8
 POu4geblmklFgZR4sSI9lqEaGt8l4k0qEJ4A+gxmDYbjTxmUaZ1q4DjByAcsdsjr+rRj9fbsi
 hpoCti7M9WMFuEhN4ltU6CGdq3bPVbC7/cqAn6Hbko3e4TjrAeO3MoQFEt3aabyRue+vjhqr9
 s+2bzEsajKvKZpm+GVqmJXAUoJK+RaWJElJjhF8qg7GmJspEXmYiMj4dQ1ZXRV0XzJ+WRXIZs
 46UgGNmy5cpS9oFtSjiwTg1knnW1bu50XRejqViA8bqe6VyLN5uuM1aU1xyHRgJ3KfLhkm3sh
 dy78N1ei5lsO4IRoASt6Fl4X8QFBRtU5Bt5kgs5A0imWn7PDFWLq21Qs/9CMX9Nc3aNSSRnAl
 uL4tiWrzLHbzUQAzXUC7dHXS//Vm4IUzDTw7x9R7TihDA4mLyfJDrVil+iicCPucxp4LiR9rc
 KWvLBnOSsI2QUrijGgI+5JmGogU1tBILUXwiERQpPbtUuR/yyD23A3RVgXhzeDWTAf/UwxJ3A
 xtnTP/Hcn77obvH0WopuGAlP8ZMC/OgNkDr3mvVIV2iJW7x1bO/K228VPAp5GS/NOar545GCG
 ZASvING5a43slWjSm39Pq0dLXvy2qSXLhokHwATh4gMUdwGRJT090igzAWByoy7hWSBGZU9tN
 0oH2sghfsrnerPiZDvJTvroHLWg12hSTCdM7UW9KNcta9ma94OoCKcPa0oJqpAATuibKpbm0x
 PzOzHXOzbqLTOIsGj9bjCmKM6BxlE8Kpwrad3qzK/omYAm/3L5IH3uniPIsbECpCtgTn2tY0y
 dbtn+8DDLObNBvopg3clToLbmXSvsBN3HQ7cd1D2sXpY1HLrHIbaUfyoo6btMD6ZvY7yZ5C5u
 frMEcxqDZvdfKp2hvCuXxWWklOEa6gWve3aEFncct5wcP+n1CB5AL7pDs+RF3SECRFpujRixN
 WGvRsAo/V6YQmzyg02MPPSFntiUjkEuaTjzjtM1zjl79GMEZ6AhPESmnvetGQIEkoX25whr0q
 eRpJ2rDC6T/Ja1sLyZGJyuY/0UZuDY5TUtcJ5ychYN/GtnLA5J4MYNy2vPanXJ+53h/eg/oxf
 SOF1B19eqOYj1g=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/A+PrpwYU=gbEnUZK7/hcp/w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Local static variables are not thread-safe. Make the functions in
blktrace.c safe by replacing them.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 blktrace.c | 63 ++++++++++++++++++++++++++++++++----------------------
 fio.h      |  1 +
 2 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index 1faa83bf..e1804765 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -13,6 +13,12 @@
 #include "blktrace_api.h"
 #include "oslib/linux-dev-lookup.h"
=20
+struct file_cache {
+	unsigned int maj;
+	unsigned int min;
+	unsigned int fileno;
+};
+
 /*
  * Just discard the pdu by seeking past it.
  */
@@ -87,28 +93,28 @@ static void trace_add_open_close_event(struct thread_da=
ta *td, int fileno, enum
 	flist_add_tail(&ipo->list, &td->io_log_list);
 }
=20
-static int trace_add_file(struct thread_data *td, __u32 device)
+static int trace_add_file(struct thread_data *td, __u32 device,
+			  struct file_cache *cache)
 {
-	static unsigned int last_maj, last_min, last_fileno;
 	unsigned int maj =3D FMAJOR(device);
 	unsigned int min =3D FMINOR(device);
 	struct fio_file *f;
 	char dev[256];
 	unsigned int i;
=20
-	if (last_maj =3D=3D maj && last_min =3D=3D min)
-		return last_fileno;
+	if (cache->maj =3D=3D maj && cache->min =3D=3D min)
+		return cache->fileno;
=20
-	last_maj =3D maj;
-	last_min =3D min;
+	cache->maj =3D maj;
+	cache->min =3D min;
=20
 	/*
 	 * check for this file in our list
 	 */
 	for_each_file(td, f, i)
 		if (f->major =3D=3D maj && f->minor =3D=3D min) {
-			last_fileno =3D f->fileno;
-			return last_fileno;
+			cache->fileno =3D f->fileno;
+			return cache->fileno;
 		}
=20
 	strcpy(dev, "/dev");
@@ -128,10 +134,10 @@ static int trace_add_file(struct thread_data *td, __u=
32 device)
 		td->files[fileno]->major =3D maj;
 		td->files[fileno]->minor =3D min;
 		trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
-		last_fileno =3D fileno;
+		cache->fileno =3D fileno;
 	}
=20
-	return last_fileno;
+	return cache->fileno;
 }
=20
 static void t_bytes_align(struct thread_options *o, struct blk_io_trace *t)
@@ -195,7 +201,8 @@ static bool handle_trace_notify(struct blk_io_trace *t)
 static bool handle_trace_discard(struct thread_data *td,
 				 struct blk_io_trace *t,
 				 unsigned long long ttime,
-				 unsigned long *ios, unsigned long long *bs)
+				 unsigned long *ios, unsigned long long *bs,
+				 struct file_cache *cache)
 {
 	struct io_piece *ipo;
 	int fileno;
@@ -205,7 +212,7 @@ static bool handle_trace_discard(struct thread_data *td,
=20
 	ipo =3D calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
-	fileno =3D trace_add_file(td, t->device);
+	fileno =3D trace_add_file(td, t->device, cache);
=20
 	ios[DDIR_TRIM]++;
 	if (t->bytes > bs[DDIR_TRIM])
@@ -238,12 +245,12 @@ static void dump_trace(struct blk_io_trace *t)
=20
 static bool handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 			    unsigned long long ttime, unsigned long *ios,
-			    unsigned long long *bs)
+			    unsigned long long *bs, struct file_cache *cache)
 {
 	int rw;
 	int fileno;
=20
-	fileno =3D trace_add_file(td, t->device);
+	fileno =3D trace_add_file(td, t->device, cache);
=20
 	rw =3D (t->action & BLK_TC_ACT(BLK_TC_WRITE)) !=3D 0;
=20
@@ -271,7 +278,8 @@ static bool handle_trace_fs(struct thread_data *td, str=
uct blk_io_trace *t,
 }
=20
 static bool handle_trace_flush(struct thread_data *td, struct blk_io_trace=
 *t,
-			       unsigned long long ttime, unsigned long *ios)
+			       unsigned long long ttime, unsigned long *ios,
+			       struct file_cache *cache)
 {
 	struct io_piece *ipo;
 	int fileno;
@@ -281,7 +289,7 @@ static bool handle_trace_flush(struct thread_data *td, =
struct blk_io_trace *t,
=20
 	ipo =3D calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
-	fileno =3D trace_add_file(td, t->device);
+	fileno =3D trace_add_file(td, t->device, cache);
=20
 	ipo->delay =3D ttime / 1000;
 	ipo->ddir =3D DDIR_SYNC;
@@ -298,28 +306,29 @@ static bool handle_trace_flush(struct thread_data *td=
, struct blk_io_trace *t,
  * due to internal workings of the block layer.
  */
 static bool queue_trace(struct thread_data *td, struct blk_io_trace *t,
-			 unsigned long *ios, unsigned long long *bs)
+			 unsigned long *ios, unsigned long long *bs,
+			 struct file_cache *cache)
 {
-	static unsigned long long last_ttime;
+	unsigned long long *last_ttime =3D &td->io_log_blktrace_last_ttime;
 	unsigned long long delay =3D 0;
=20
 	if ((t->action & 0xffff) !=3D __BLK_TA_QUEUE)
 		return false;
=20
 	if (!(t->action & BLK_TC_ACT(BLK_TC_NOTIFY))) {
-		if (!last_ttime || td->o.no_stall || t->time < last_ttime)
+		if (!*last_ttime || td->o.no_stall || t->time < *last_ttime)
 			delay =3D 0;
 		else if (td->o.replay_time_scale =3D=3D 100)
-			delay =3D t->time - last_ttime;
+			delay =3D t->time - *last_ttime;
 		else {
-			double tmp =3D t->time - last_ttime;
+			double tmp =3D t->time - *last_ttime;
 			double scale;
=20
 			scale =3D (double) 100.0 / (double) td->o.replay_time_scale;
 			tmp *=3D scale;
 			delay =3D tmp;
 		}
-		last_ttime =3D t->time;
+		*last_ttime =3D t->time;
 	}
=20
 	t_bytes_align(&td->o, t);
@@ -327,11 +336,11 @@ static bool queue_trace(struct thread_data *td, struc=
t blk_io_trace *t,
 	if (t->action & BLK_TC_ACT(BLK_TC_NOTIFY))
 		return handle_trace_notify(t);
 	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
-		return handle_trace_discard(td, t, delay, ios, bs);
+		return handle_trace_discard(td, t, delay, ios, bs, cache);
 	else if (t->action & BLK_TC_ACT(BLK_TC_FLUSH))
-		return handle_trace_flush(td, t, delay, ios);
+		return handle_trace_flush(td, t, delay, ios, cache);
 	else
-		return handle_trace_fs(td, t, delay, ios, bs);
+		return handle_trace_fs(td, t, delay, ios, bs, cache);
 }
=20
 static void byteswap_trace(struct blk_io_trace *t)
@@ -409,6 +418,7 @@ bool init_blktrace_read(struct thread_data *td, const c=
har *filename, int need_s
 		goto err;
 	}
 	td->io_log_blktrace_swap =3D need_swap;
+	td->io_log_blktrace_last_ttime =3D 0;
 	td->o.size =3D 0;
=20
 	free_release_files(td);
@@ -439,6 +449,7 @@ err:
 bool read_blktrace(struct thread_data* td)
 {
 	struct blk_io_trace t;
+	struct file_cache cache =3D { };
 	unsigned long ios[DDIR_RWDIR_SYNC_CNT] =3D { };
 	unsigned long long rw_bs[DDIR_RWDIR_CNT] =3D { };
 	unsigned long skipped_writes;
@@ -502,7 +513,7 @@ bool read_blktrace(struct thread_data* td)
 			}
 		}
=20
-		if (!queue_trace(td, &t, ios, rw_bs))
+		if (!queue_trace(td, &t, ios, rw_bs, &cache))
 			continue;
=20
 		if (td->o.read_iolog_chunked) {
diff --git a/fio.h b/fio.h
index 5c68ad80..1ea3d064 100644
--- a/fio.h
+++ b/fio.h
@@ -429,6 +429,7 @@ struct thread_data {
 	FILE *io_log_rfile;
 	unsigned int io_log_blktrace;
 	unsigned int io_log_blktrace_swap;
+	unsigned long long io_log_blktrace_last_ttime;
 	unsigned int io_log_current;
 	unsigned int io_log_checkmark;
 	unsigned int io_log_highmark;
--=20
2.34.1


--Sig_/A+PrpwYU=gbEnUZK7/hcp/w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHofz0ACgkQNasLKJxd
slirURAAn/nwNXMyUEAmZNPP2f3A4qk322ZFD/rwKEDxgbzVB11c9EuhjGIUNbX2
nNzCqhts77oYlR3gCYt1UyW3F0h3u3XBXs58B5jLvURZHTgrOmWuhmOotJrJgITQ
rA/eMMOBzzcLFq4jGFGR5UElba3smbYcetQEnnqzFgXb1luev0pjyF6f9SFoUII0
I2/xKl/cgxFO3urEnXTOKF3240iea5EU/XAUvHQAFKzSghULatB5YFXNu8AAoG+G
m3pn0cfe8qg0J/uLHpUjQabveADJoyc8jd5GucMO+QXQTFVNuhQUbrFLEqCZan9K
CoPmqmhceuINZaaGVZOIQd4IqFk1kAoo+GPK91XYS3Jy6poPSShu0ZJUjnDj1JNP
iOEKLe03gS/j9IPFCqBFwhMmdmryUa7WgpkoQmALJ9pONq3SrnOlsVPdfYrpUEAh
lgpeNVnrbBKabpiGHGdkAAWhWzHR3uZkdc8+JuqnD3BDiKgf1N2ZCPewaVfVhwF7
fcYyXTTR0zobnSQTqgxfg1KFQhJO2wiLLBth34trnoOcs/z4f3OP+jAVw18/KYhf
6PaAsG+S5ikVzGWdgEV3qEBJEe1wB6CruyEJyA2ylEteHzuCePJX6RBqkls0Jp/J
fMDLNB0ndNv6ydq/olffBBjD7cNBB382v5pRyIo4SaUSyorPfi8=
=J/FU
-----END PGP SIGNATURE-----

--Sig_/A+PrpwYU=gbEnUZK7/hcp/w--
