Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98620C433F5
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245699AbiASVO1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:14:27 -0500
Received: from mout.web.de ([212.227.15.3]:55775 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245473AbiASVO0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642626864;
        bh=Hmlso044AzBQvmlpLhvlcxEvE2L5aIDLDAE4ZFepYTo=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=KE5k5NZfm7dDneLWxckCe0LKLtiz42KUG8mvSveZWAcHbc7tu96t7GKmMJh9VgPyC
         4KwmD9+61NNlTHVj4tOvptLygjNTiHbNWiLnxWUDvx0B32cjkCAyjZfkz1vnz4Fttt
         9H1QSvQGw4opKOnnCYL16rGRmYydaTTT8uZBbw94=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MP384-1mvtd62Uf6-00Paph; Wed, 19
 Jan 2022 22:14:24 +0100
Date:   Wed, 19 Jan 2022 21:14:23 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 3/8] blktrace.c: Add support for read_iolog_chunked
Message-ID: <d43a8a2d5fd23d9756cdcf280cd2f3572585f264.1642626314.git.lukasstraub2@web.de>
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wJReeqjTEa3OXj6HvA/ULxZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:j9juQEk9IgxgOp4/ToZ4x8wGGhq6Didvja83ltywSLHZT5qxq0o
 1L9+sOJLTqbgxACjfDEkJfocfRE254gg+BtPcLUKyccDmrn0B3C1cIJvmXPUF4943WU4YnD
 IxoI5XoaCdLpHSviE8XrufTt88O0xiyXAZzKtPnAVX+h+E3DA81s2Eja7FE+fCB+Mwz8RpL
 cfOzLRlfZGTYiJ/U4f/kQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CBeJ2IyoDqE=:21GQCzqgHI6gp2beY9JEra
 +VLc8gwZUkroHy1SR8Y4m7R5m4b4VDgbxTQa+b4xovO6LfKoOTPI4MLKM/IDis3V1B5MJvWmq
 abwpeLoRuwJt+vBwzCbrkslvd3l/88FOfnGQOLk2TR1dHhszAxS2RWAczBHXCZPNASYehbAlc
 uLAXHPPj16zldYJxt2LSen/UX+DpSHHpv9/GS7y+2prYpkr7h2duD2Kc2W4abMPMZippznh3/
 pGVtlnsLa26wJ/aIBgyDhS1KIXY7Yv2IduMYttUiUejK4mHZAUcOAB0mE8q6/ykkUjamVIWwu
 qpQaW1YoElz23DgX9h87qH1oHb01ymqUI4YCEdRIM4NAzQyjZRkt1UH46+LiPdJ/bWmATyyu5
 f4tjS4cKAiUMsOQ338sDbKLrrs+FLnwFPPTExO0J4Y5vcisSn0vAEj7y1VjeSlCht5crBGW13
 8BQ2rsD8QSmQel38tHBO3vVRbrMih3YmgbgJyCVqCYCdb9jZpTNjRE088jP9ZKMhGN25/QVTZ
 g9vKyDRyrGOstV51yKNTiALKZ8jdx4VjjDrXmE0gdOGwZbLGgBliNjPWLso6yN3/eMfS0ayW0
 0CQqjgnuinjvReT00gtgVy0Rmry611FJl25x2kGC+mQzZM1lHSlsQMXsaCcHbGualVlYmWUo/
 a1yLaBemcz9xqJUXnL3CQsGfDlTJ7M6wey2a3poBHaGyPCy0I9C7+LeRvvQ6diSHjfMPdbOgJ
 hZr+TPBySMzFa/na73pFpP/SMF4PNf5gCeTVWSyd5IXZRYbL9easHLOMZO/iST+XZAMzocndB
 uwcOIJFMPD4CVKy7Vq1sfRHdAxiRqoUMPnO5Hxl+NdfMbGp7+/0msltS1RN4oVPxzM476ZAZL
 gYC9XoVtIArcH0fydl/BFOKoJi6AFbRGSNO7b4HxJ3+is5T+i+AU3LjiwQ0yMlq+uvS8qo3k6
 ZeV8GxSlFYxoK90aKjgoB5Q6VRNUqqRgE7KpV2wjD1PbkcPbW38MQLAyxxfPWInrIdnHPfudp
 52IEghCVhV7GMOOTrFP63jJDQtfujhKidle7C4tm88ncYcESZ5nTjkuQe+5FQe0sYswOSepEk
 KXsidH2lL1veqg=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/wJReeqjTEa3OXj6HvA/ULxZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 blktrace.c | 154 ++++++++++++++++++++++++++++++++++++++---------------
 blktrace.h |  12 ++++-
 fio.h      |   1 +
 iolog.c    |  13 +++--
 4 files changed, 131 insertions(+), 49 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index c9a00eb1..f1dbd1a6 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -8,6 +8,7 @@
=20
 #include "flist.h"
 #include "fio.h"
+#include "iolog.h"
 #include "blktrace.h"
 #include "blktrace_api.h"
 #include "oslib/linux-dev-lookup.h"
@@ -171,7 +172,7 @@ static void store_ipo(struct thread_data *td, unsigned =
long long offset,
 	queue_io_piece(td, ipo);
 }
=20
-static void handle_trace_notify(struct blk_io_trace *t)
+static bool handle_trace_notify(struct blk_io_trace *t)
 {
 	switch (t->action) {
 	case BLK_TN_PROCESS:
@@ -188,18 +189,19 @@ static void handle_trace_notify(struct blk_io_trace *=
t)
 		dprint(FD_BLKTRACE, "unknown trace act %x\n", t->action);
 		break;
 	}
+	return false;
 }
=20
-static void handle_trace_discard(struct thread_data *td,
+static bool handle_trace_discard(struct thread_data *td,
 				 struct blk_io_trace *t,
 				 unsigned long long ttime,
-				 unsigned long *ios, unsigned int *bs)
+				 unsigned long *ios, unsigned long long *bs)
 {
 	struct io_piece *ipo;
 	int fileno;
=20
 	if (td->o.replay_skip & (1u << DDIR_TRIM))
-		return;
+		return false;
=20
 	ipo =3D calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
@@ -226,6 +228,7 @@ static void handle_trace_discard(struct thread_data *td,
 							ipo->offset, ipo->len,
 							ipo->delay);
 	queue_io_piece(td, ipo);
+	return true;
 }
=20
 static void dump_trace(struct blk_io_trace *t)
@@ -233,9 +236,9 @@ static void dump_trace(struct blk_io_trace *t)
 	log_err("blktrace: ignoring zero byte trace: action=3D%x\n", t->action);
 }
=20
-static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
+static bool handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 			    unsigned long long ttime, unsigned long *ios,
-			    unsigned int *bs)
+			    unsigned long long *bs)
 {
 	int rw;
 	int fileno;
@@ -246,16 +249,16 @@ static void handle_trace_fs(struct thread_data *td, s=
truct blk_io_trace *t,
=20
 	if (rw) {
 		if (td->o.replay_skip & (1u << DDIR_WRITE))
-			return;
+			return false;
 	} else {
 		if (td->o.replay_skip & (1u << DDIR_READ))
-			return;
+			return false;
 	}
=20
 	if (!t->bytes) {
 		if (!fio_did_warn(FIO_WARN_BTRACE_ZERO))
 			dump_trace(t);
-		return;
+		return false;
 	}
=20
 	if (t->bytes > bs[rw])
@@ -264,16 +267,17 @@ static void handle_trace_fs(struct thread_data *td, s=
truct blk_io_trace *t,
 	ios[rw]++;
 	td->o.size +=3D t->bytes;
 	store_ipo(td, t->sector, t->bytes, rw, ttime, fileno);
+	return true;
 }
=20
-static void handle_trace_flush(struct thread_data *td, struct blk_io_trace=
 *t,
+static bool handle_trace_flush(struct thread_data *td, struct blk_io_trace=
 *t,
 			       unsigned long long ttime, unsigned long *ios)
 {
 	struct io_piece *ipo;
 	int fileno;
=20
 	if (td->o.replay_skip & (1u << DDIR_SYNC))
-		return;
+		return false;
=20
 	ipo =3D calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
@@ -286,20 +290,21 @@ static void handle_trace_flush(struct thread_data *td=
, struct blk_io_trace *t,
 	ios[DDIR_SYNC]++;
 	dprint(FD_BLKTRACE, "store flush delay=3D%lu\n", ipo->delay);
 	queue_io_piece(td, ipo);
+	return true;
 }
=20
 /*
  * We only care for queue traces, most of the others are side effects
  * due to internal workings of the block layer.
  */
-static void handle_trace(struct thread_data *td, struct blk_io_trace *t,
-			 unsigned long *ios, unsigned int *bs)
+static bool queue_trace(struct thread_data *td, struct blk_io_trace *t,
+			 unsigned long *ios, unsigned long long *bs)
 {
 	static unsigned long long last_ttime;
 	unsigned long long delay =3D 0;
=20
 	if ((t->action & 0xffff) !=3D __BLK_TA_QUEUE)
-		return;
+		return false;
=20
 	if (!(t->action & BLK_TC_ACT(BLK_TC_NOTIFY))) {
 		if (!last_ttime || td->o.no_stall)
@@ -320,13 +325,13 @@ static void handle_trace(struct thread_data *td, stru=
ct blk_io_trace *t,
 	t_bytes_align(&td->o, t);
=20
 	if (t->action & BLK_TC_ACT(BLK_TC_NOTIFY))
-		handle_trace_notify(t);
+		return handle_trace_notify(t);
 	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
-		handle_trace_discard(td, t, delay, ios, bs);
+		return handle_trace_discard(td, t, delay, ios, bs);
 	else if (t->action & BLK_TC_ACT(BLK_TC_FLUSH))
-		handle_trace_flush(td, t, delay, ios);
+		return handle_trace_flush(td, t, delay, ios);
 	else
-		handle_trace_fs(td, t, delay, ios, bs);
+		return handle_trace_fs(td, t, delay, ios, bs);
 }
=20
 static void byteswap_trace(struct blk_io_trace *t)
@@ -394,27 +399,62 @@ static void depth_end(struct blk_io_trace *t, int *th=
is_depth, int *depth)
  * Load a blktrace file by reading all the blk_io_trace entries, and stori=
ng
  * them as io_pieces like the fio text version would do.
  */
-bool load_blktrace(struct thread_data *td, const char *filename, int need_=
swap)
+bool init_blktrace_read(struct thread_data *td, const char *filename, int =
need_swap)
+{
+	int old_state;
+
+	td->io_log_rfile =3D fopen(filename, "rb");
+	if (!td->io_log_rfile) {
+		td_verror(td, errno, "open blktrace file");
+		goto err;
+	}
+	td->io_log_blktrace_swap =3D need_swap;
+	td->o.size =3D 0;
+
+	free_release_files(td);
+
+	old_state =3D td_bump_runstate(td, TD_SETTING_UP);
+
+	if (!read_blktrace(td)) {
+		goto err;
+	}
+
+	td_restore_runstate(td, old_state);
+
+	if (!td->files_index) {
+		log_err("fio: did not find replay device(s)\n");
+		return false;
+	}
+
+	return true;
+
+err:
+	if (td->io_log_rfile) {
+		fclose(td->io_log_rfile);
+		td->io_log_rfile =3D NULL;
+	}
+	return false;
+}
+
+bool read_blktrace(struct thread_data* td)
 {
 	struct blk_io_trace t;
 	unsigned long ios[DDIR_RWDIR_SYNC_CNT] =3D { };
-	unsigned int rw_bs[DDIR_RWDIR_CNT] =3D { };
+	unsigned long long rw_bs[DDIR_RWDIR_CNT] =3D { };
 	unsigned long skipped_writes;
-	FILE *f;
-	int i, old_state, max_depth;
+	FILE *f =3D td->io_log_rfile;
+	int i, max_depth;
 	struct fio_file *fiof;
 	int this_depth[DDIR_RWDIR_CNT] =3D { };
 	int depth[DDIR_RWDIR_CNT] =3D { };
+	int64_t items_to_fetch =3D 0;
=20
-	f =3D fopen(filename, "rb");
-	if (!f) {
-		td_verror(td, errno, "open blktrace file");
-		return false;
+	if (td->o.read_iolog_chunked) {
+		items_to_fetch =3D iolog_items_to_fetch(td);
+		if (!items_to_fetch)
+			return true;
 	}
=20
-	old_state =3D td_bump_runstate(td, TD_SETTING_UP);
-
-	td->o.size =3D 0;
 	skipped_writes =3D 0;
 	do {
 		int ret =3D fread(&t, 1, sizeof(t), f);
@@ -429,7 +469,7 @@ bool load_blktrace(struct thread_data *td, const char *=
filename, int need_swap)
 			break;
 		}
=20
-		if (need_swap)
+		if (td->io_log_blktrace_swap)
 			byteswap_trace(&t);
=20
 		if ((t.magic & 0xffffff00) !=3D BLK_IO_TRACE_MAGIC) {
@@ -462,21 +502,53 @@ bool load_blktrace(struct thread_data *td, const char=
 *filename, int need_swap)
 			}
 		}
=20
-		handle_trace(td, &t, ios, rw_bs);
-	} while (1);
+		if (!queue_trace(td, &t, ios, rw_bs))
+			continue;
=20
-	for_each_file(td, fiof, i)
-		trace_add_open_close_event(td, fiof->fileno, FIO_LOG_CLOSE_FILE);
+		if (td->o.read_iolog_chunked) {
+			td->io_log_current++;
+			items_to_fetch--;
+			if (items_to_fetch =3D=3D 0)
+				break;
+		}
+	} while (1);
=20
-	fclose(f);
+	if (td->o.read_iolog_chunked) {
+		td->io_log_highmark =3D td->io_log_current;
+		td->io_log_checkmark =3D (td->io_log_highmark + 1) / 2;
+		fio_gettime(&td->io_log_highmark_time, NULL);
+	}
=20
-	td_restore_runstate(td, old_state);
+	if (skipped_writes)
+		log_err("fio: %s skips replay of %lu writes due to read-only\n",
+						td->o.name, skipped_writes);
=20
-	if (!td->files_index) {
-		log_err("fio: did not find replay device(s)\n");
-		return false;
+	if (td->o.read_iolog_chunked) {
+		if (td->io_log_current =3D=3D 0) {
+			return false;
+		}
+		td->o.td_ddir =3D TD_DDIR_RW;
+		if ((rw_bs[DDIR_READ] > td->o.max_bs[DDIR_READ] ||
+		     rw_bs[DDIR_WRITE] > td->o.max_bs[DDIR_WRITE] ||
+		     rw_bs[DDIR_TRIM] > td->o.max_bs[DDIR_TRIM]) &&
+		    td->orig_buffer)
+		{
+			td->o.max_bs[DDIR_READ] =3D max(td->o.max_bs[DDIR_READ], rw_bs[DDIR_REA=
D]);
+			td->o.max_bs[DDIR_WRITE] =3D max(td->o.max_bs[DDIR_WRITE], rw_bs[DDIR_W=
RITE]);
+			td->o.max_bs[DDIR_TRIM] =3D max(td->o.max_bs[DDIR_TRIM], rw_bs[DDIR_TRI=
M]);
+			io_u_quiesce(td);
+			free_io_mem(td);
+			init_io_u_buffers(td);
+		}
+		return true;
 	}
=20
+	for_each_file(td, fiof, i)
+		trace_add_open_close_event(td, fiof->fileno, FIO_LOG_CLOSE_FILE);
+
+	fclose(td->io_log_rfile);
+	td->io_log_rfile =3D NULL;
+
 	/*
 	 * For stacked devices, we don't always get a COMPLETE event so
 	 * the depth grows to insane values. Limit it to something sane(r).
@@ -490,10 +562,6 @@ bool load_blktrace(struct thread_data *td, const char =
*filename, int need_swap)
 		max_depth =3D max(depth[i], max_depth);
 	}
=20
-	if (skipped_writes)
-		log_err("fio: %s skips replay of %lu writes due to read-only\n",
-						td->o.name, skipped_writes);
-
 	if (!ios[DDIR_READ] && !ios[DDIR_WRITE] && !ios[DDIR_TRIM] &&
 	    !ios[DDIR_SYNC]) {
 		log_err("fio: found no ios in blktrace data\n");
diff --git a/blktrace.h b/blktrace.h
index b2ebdba3..c53b717b 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -20,7 +20,9 @@ struct blktrace_cursor {
 };
=20
 bool is_blktrace(const char *, int *);
-bool load_blktrace(struct thread_data *, const char *, int);
+bool init_blktrace_read(struct thread_data *, const char *, int);
+bool read_blktrace(struct thread_data* td);
+
 int merge_blktrace_iologs(struct thread_data *td);
=20
 #else
@@ -30,12 +32,18 @@ static inline bool is_blktrace(const char *fname, int *=
need_swap)
 	return false;
 }
=20
-static inline bool load_blktrace(struct thread_data *td, const char *fname,
+static inline bool init_blktrace_read(struct thread_data *td, const char *=
fname,
 				 int need_swap)
 {
 	return false;
 }
=20
+static inline bool read_blktrace(struct thread_data* td)
+{
+	return false;
+}
+
+
 static inline int merge_blktrace_iologs(struct thread_data *td)
 {
 	return false;
diff --git a/fio.h b/fio.h
index 6bb21ebb..5c68ad80 100644
--- a/fio.h
+++ b/fio.h
@@ -428,6 +428,7 @@ struct thread_data {
 	struct flist_head io_log_list;
 	FILE *io_log_rfile;
 	unsigned int io_log_blktrace;
+	unsigned int io_log_blktrace_swap;
 	unsigned int io_log_current;
 	unsigned int io_log_checkmark;
 	unsigned int io_log_highmark;
diff --git a/iolog.c b/iolog.c
index 3d4646a8..5a41e93f 100644
--- a/iolog.c
+++ b/iolog.c
@@ -152,10 +152,15 @@ int read_iolog_get(struct thread_data *td, struct io_=
u *io_u)
 	while (!flist_empty(&td->io_log_list)) {
 		int ret;
=20
-		if (!td->io_log_blktrace && td->o.read_iolog_chunked) {
+		if (td->o.read_iolog_chunked) {
 			if (td->io_log_checkmark =3D=3D td->io_log_current) {
-				if (!read_iolog2(td))
-					return 1;
+				if (td->io_log_blktrace) {
+					if (!read_blktrace(td))
+						return 1;
+				} else {
+					if (!read_iolog2(td))
+						return 1;
+				}
 			}
 			td->io_log_current--;
 		}
@@ -709,7 +714,7 @@ bool init_iolog(struct thread_data *td)
 		 */
 		if (is_blktrace(fname, &need_swap)) {
 			td->io_log_blktrace =3D 1;
-			ret =3D load_blktrace(td, fname, need_swap);
+			ret =3D init_blktrace_read(td, fname, need_swap);
 		} else {
 			td->io_log_blktrace =3D 0;
 			ret =3D init_iolog_read(td, fname);
--=20
2.34.1


--Sig_/wJReeqjTEa3OXj6HvA/ULxZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHofy8ACgkQNasLKJxd
slhjzg//cFpuQ6A09iHuo8Yy5WJm6UFKPPkFKMtUOa6jx3rUpm9gPwyE/WI1aWmj
JzpSDMZu6Jj5bPe+LRtgQz01jVF0xM9fDyjiY+Tuvsj7u4MZSfImojhMLm0Zgvwe
I2mpBISJA9w4P4bt24OdAAdI6OrE7/sBJsFvtE+XnonNFj8l8xTWnWXf8+lYptRz
Myi5TIiZXzWjG5Mf+fhVmgIcLApioVNg/awj2kQWp9yI9gzu91j9hPJeHXiMDAef
47RTIrHYvIWJ4B6pGE70nz5YaJLZtOijL0n9R65cI2Cp5WTXopfRF6SgM+PzQiik
WTot1QfAv99H/aIRWXXMsywZn5H+dqXPGjeaQQe0hk0UsNNfGHQRYf0pmQsL1C3K
d6p++ZANCT8UM6MzHvGCYW8gXqMjW/NbVlB8xTonOnilEZwVz6pBojkqusK9oavm
HqyOrOXT1j5Z9NXNjQuav8/9fcBRXByiOgyls82g/Gx3hcl1U3RhpoLQfFuISOHx
wxc0QhJfqn/HyHUYGOV029u2+j1m/95yTZOK5Cz99VcUbqOHwDUb0ZrFaby0q7+n
JdhCEh/u5DM51itKn5k3ntux3n7Qn6aiVvDuyeNO5LxEkn8lI5uYQL+sXQmKwss3
r5Me/Yu3Jwad8C5XBe2ecXgn2NpRCvHss1Iz7fbnazG6byHuKlQ=
=Gwjn
-----END PGP SIGNATURE-----

--Sig_/wJReeqjTEa3OXj6HvA/ULxZ--
