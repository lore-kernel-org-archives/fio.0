Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947A0C433EF
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245473AbiASVTY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:19:24 -0500
Received: from mout.web.de ([212.227.15.4]:41971 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239950AbiASVTW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642627160;
        bh=Kv2wGD8+tZY0CPaWvbsqtXz+JeE8MGVOpkEKp9Uqoy0=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=IiSB+gq/2Oi5EG43HcA5+1UBJmPKWUy5q9IO3OREc92rDNjYouUsgfkS38eZ1Bq+6
         nGm6OZoT9chllWTVPl9BPwcGZgQVJ0nlQN/NSLyqZqoZsi/dd9KlZfZlkMaspE1VlW
         wlmHYmNYUo0DeOShEx/BF4X2F7t8bDUAjxqAfZfE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MzTPQ-1mNwvR1h8y-00vXIR; Wed, 19
 Jan 2022 22:14:17 +0100
Date:   Wed, 19 Jan 2022 21:14:16 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 1/8] blktrace.c: Use file stream interface instead of fifo
Message-ID: <5f52a20f95ebead7fa9ae8bce0acf8f0570219ca.1642626314.git.lukasstraub2@web.de>
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/S8uVfDK6RHF9E1BvqxiPIPR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:UohU3CLtcW1vOKCcSu/1O2oAOn2Wo3TgudvE2zLBqw9wCsWPhTE
 if6km8agJiCp5AikU6PfkH05p3rja5qYw0ZbBqfbnkijVNUzKDxvZQdJXQQkoUJlmQBlA0a
 n94IPqk4RkgdLXEPw2ORQVHxhyRyYpsf7J6dvyeDPX/twG9E6sJ68PwR1Dis9BgsqhTsbjq
 Fhj90vp4GtkMIkgVO/qGw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XmFHmsbjmX8=:ZsIJYaRBhL7HAEMsS3TON4
 cf2uA5/XUnVQ4F7ek33dPe66LyWPdLTeWuoZLE/u5WHjzs2GC0KTVEwsVpNn849eTRtn5HYG2
 jXoyTKJXq6kIYCPYarRnfNEt4VnJTaPjo9klx4ZQOF1NrfUe5HFPpB2jXStknb1i1gUSSp5wi
 RsK+gDGL2AWYNrqnp3KUNc/f0LK7Le08S2RUG4mlmYHlXOh4/Mm0WuMLy9Q7LZ7pM+9xcQOO1
 ipXO0pN5uJr2+jP534ougjU/+kgZK+NFbHPDQ9P7/vBh+8JhE7FJavOEZ4kcjUaLoXPZMhxJ1
 QQE1W92bXq2AZFrDoCCiCbdvUTdJbxM+5Gjugzs7GpIAmBEtX/pTm6qDustvzzzMRMAp4GwvG
 pE0JWbcFbPZoBURqM27kc2J/aSVlwj/hwI+47UHTlxzx8097TQSZZ2DUFyFpmtGb+o0vukmfD
 0+Ri8BpM41vHxMetQfwPgjpXYIr0RqfXk5cw374OYBsWnHWIjTLSY8s332j8NrArcGLA4eVX6
 iQnPTu+2ENKPRSxEb/429IfkFj7foif1fHWG/Pyb3n31aacrW9M04xhs/Qs8nt+1rxlZdPqWF
 z9GfrGhLO4iTe5duaf7t7FJQqLidGfFZH4sgBhz3zekhWHubWcO37fXDPCU4TK9J5QxG9q8Xs
 Ss+bfEZXyPN2l3yg/756Fd7+bUrV2n6L8hWMeZRD39S1OuN347CSC9UBKbSvJfubxOaTPpi6Y
 q1tvA9uvBk/R1i+bp21T0XHn+HGGeStwiIBFrlkq3DtcCWmvQPAviffOrdEE0bR9Km2/aQwel
 LanetoscdW1fxZIa3NWFAyVfUYhd6fDlpxKsvx7m3OGYJYcxzKKjVtM1S4tzoWlLnFBJejiu/
 n1QAtiQyJ7fMqcuZvKhTmDIM6CQWseBnm6vMs5c83+uuDT4gqO97J2l4iqY3MwZgAMRxDnUNS
 V+w4/PYXgsV8RZwaCQM+fh3xUwxUkSoCirZ4C26mPR5MT4AISeOOMdktJmULk9GPdQLJnA4fk
 LYow6Gx64A1Cr9ysjKLgic8bx4Ywg770ivjhE8FNxoX3vdjpGraTmJWllo7yQnd5YLMUi/EiB
 rg4Pt/ymji9CWw=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/S8uVfDK6RHF9E1BvqxiPIPR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Like in iolog.c use the file stream interface for accessing
the iolog file.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 blktrace.c | 130 +++++++++++++++--------------------------------------
 blktrace.h |   2 +-
 2 files changed, 36 insertions(+), 96 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index 64a610a9..c9a00eb1 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -4,6 +4,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <errno.h>
=20
 #include "flist.h"
 #include "fio.h"
@@ -11,64 +12,19 @@
 #include "blktrace_api.h"
 #include "oslib/linux-dev-lookup.h"
=20
-#define TRACE_FIFO_SIZE	8192
-
-/*
- * fifo refill frontend, to avoid reading data in trace sized bites
- */
-static int refill_fifo(struct thread_data *td, struct fifo *fifo, int fd)
-{
-	char buf[TRACE_FIFO_SIZE];
-	unsigned int total;
-	int ret;
-
-	total =3D sizeof(buf);
-	if (total > fifo_room(fifo))
-		total =3D fifo_room(fifo);
-
-	ret =3D read(fd, buf, total);
-	if (ret < 0) {
-		int read_err =3D errno;
-
-		assert(read_err > 0);
-		td_verror(td, read_err, "read blktrace file");
-		return -read_err;
-	}
-
-	if (ret > 0)
-		ret =3D fifo_put(fifo, buf, ret);
-
-	dprint(FD_BLKTRACE, "refill: filled %d bytes\n", ret);
-	return ret;
-}
-
-/*
- * Retrieve 'len' bytes from the fifo, refilling if necessary.
- */
-static int trace_fifo_get(struct thread_data *td, struct fifo *fifo, int f=
d,
-			  void *buf, unsigned int len)
-{
-	if (fifo_len(fifo) < len) {
-		int ret =3D refill_fifo(td, fifo, fd);
-
-		if (ret < 0)
-			return ret;
-	}
-
-	return fifo_get(fifo, buf, len);
-}
-
 /*
  * Just discard the pdu by seeking past it.
  */
-static int discard_pdu(struct thread_data *td, struct fifo *fifo, int fd,
-		       struct blk_io_trace *t)
+static int discard_pdu(FILE* f, struct blk_io_trace *t)
 {
 	if (t->pdu_len =3D=3D 0)
 		return 0;
=20
 	dprint(FD_BLKTRACE, "discard pdu len %u\n", t->pdu_len);
-	return trace_fifo_get(td, fifo, fd, NULL, t->pdu_len);
+	if (fseek(f, t->pdu_len, SEEK_CUR) < 0)
+		return -errno;
+
+	return t->pdu_len;
 }
=20
 /*
@@ -444,33 +400,32 @@ bool load_blktrace(struct thread_data *td, const char=
 *filename, int need_swap)
 	unsigned long ios[DDIR_RWDIR_SYNC_CNT] =3D { };
 	unsigned int rw_bs[DDIR_RWDIR_CNT] =3D { };
 	unsigned long skipped_writes;
-	struct fifo *fifo;
-	int fd, i, old_state, max_depth;
-	struct fio_file *f;
+	FILE *f;
+	int i, old_state, max_depth;
+	struct fio_file *fiof;
 	int this_depth[DDIR_RWDIR_CNT] =3D { };
 	int depth[DDIR_RWDIR_CNT] =3D { };
=20
-	fd =3D open(filename, O_RDONLY);
-	if (fd < 0) {
+	f =3D fopen(filename, "rb");
+	if (!f) {
 		td_verror(td, errno, "open blktrace file");
 		return false;
 	}
=20
-	fifo =3D fifo_alloc(TRACE_FIFO_SIZE);
-
 	old_state =3D td_bump_runstate(td, TD_SETTING_UP);
=20
 	td->o.size =3D 0;
 	skipped_writes =3D 0;
 	do {
-		int ret =3D trace_fifo_get(td, fifo, fd, &t, sizeof(t));
+		int ret =3D fread(&t, 1, sizeof(t), f);
=20
-		if (ret < 0)
+		if (ferror(f)) {
+			td_verror(td, errno, "read blktrace file");
 			goto err;
-		else if (!ret)
+		} else if (feof(f)) {
 			break;
-		else if (ret < (int) sizeof(t)) {
-			log_err("fio: short fifo get\n");
+		} else if (ret < (int) sizeof(t)) {
+			log_err("fio: iolog short read\n");
 			break;
 		}
=20
@@ -487,13 +442,10 @@ bool load_blktrace(struct thread_data *td, const char=
 *filename, int need_swap)
 								t.magic & 0xff);
 			goto err;
 		}
-		ret =3D discard_pdu(td, fifo, fd, &t);
+		ret =3D discard_pdu(f, &t);
 		if (ret < 0) {
 			td_verror(td, -ret, "blktrace lseek");
 			goto err;
-		} else if (t.pdu_len !=3D ret) {
-			log_err("fio: discarded %d of %d\n", ret, t.pdu_len);
-			goto err;
 		}
 		if ((t.action & BLK_TC_ACT(BLK_TC_NOTIFY)) =3D=3D 0) {
 			if ((t.action & 0xffff) =3D=3D __BLK_TA_QUEUE)
@@ -513,11 +465,10 @@ bool load_blktrace(struct thread_data *td, const char=
 *filename, int need_swap)
 		handle_trace(td, &t, ios, rw_bs);
 	} while (1);
=20
-	for_each_file(td, f, i)
-		trace_add_open_close_event(td, f->fileno, FIO_LOG_CLOSE_FILE);
+	for_each_file(td, fiof, i)
+		trace_add_open_close_event(td, fiof->fileno, FIO_LOG_CLOSE_FILE);
=20
-	fifo_free(fifo);
-	close(fd);
+	fclose(f);
=20
 	td_restore_runstate(td, old_state);
=20
@@ -579,8 +530,7 @@ bool load_blktrace(struct thread_data *td, const char *=
filename, int need_swap)
=20
 	return true;
 err:
-	close(fd);
-	fifo_free(fifo);
+	fclose(f);
 	return false;
 }
=20
@@ -625,15 +575,14 @@ static void merge_finish_file(struct blktrace_cursor =
*bcs, int i, int *nr_logs)
 {
 	bcs[i].iter++;
 	if (bcs[i].iter < bcs[i].nr_iter) {
-		lseek(bcs[i].fd, 0, SEEK_SET);
+		fseek(bcs[i].f, 0, SEEK_SET);
 		return;
 	}
=20
 	*nr_logs -=3D 1;
=20
 	/* close file */
-	fifo_free(bcs[i].fifo);
-	close(bcs[i].fd);
+	fclose(bcs[i].f);
=20
 	/* keep active files contiguous */
 	memmove(&bcs[i], &bcs[*nr_logs], sizeof(bcs[i]));
@@ -646,15 +595,16 @@ static int read_trace(struct thread_data *td, struct =
blktrace_cursor *bc)
=20
 read_skip:
 	/* read an io trace */
-	ret =3D trace_fifo_get(td, bc->fifo, bc->fd, t, sizeof(*t));
-	if (ret < 0) {
+	ret =3D fread(&t, 1, sizeof(t), bc->f);
+	if (ferror(bc->f)) {
+		td_verror(td, errno, "read blktrace file");
 		return ret;
-	} else if (!ret) {
+	} else if (feof(bc->f)) {
 		if (!bc->length)
 			bc->length =3D bc->t.time;
 		return ret;
 	} else if (ret < (int) sizeof(*t)) {
-		log_err("fio: short fifo get\n");
+		log_err("fio: iolog short read\n");
 		return -1;
 	}
=20
@@ -664,14 +614,10 @@ read_skip:
 	/* skip over actions that fio does not care about */
 	if ((t->action & 0xffff) !=3D __BLK_TA_QUEUE ||
 	    t_get_ddir(t) =3D=3D DDIR_INVAL) {
-		ret =3D discard_pdu(td, bc->fifo, bc->fd, t);
+		ret =3D discard_pdu(bc->f, t);
 		if (ret < 0) {
 			td_verror(td, -ret, "blktrace lseek");
 			return ret;
-		} else if (t->pdu_len !=3D ret) {
-			log_err("fio: discarded %d of %d\n", ret,
-				t->pdu_len);
-			return -1;
 		}
 		goto read_skip;
 	}
@@ -729,14 +675,13 @@ int merge_blktrace_iologs(struct thread_data *td)
 	str =3D ptr =3D strdup(td->o.read_iolog_file);
 	nr_logs =3D 0;
 	for (i =3D 0; (name =3D get_next_str(&ptr)) !=3D NULL; i++) {
-		bcs[i].fd =3D open(name, O_RDONLY);
-		if (bcs[i].fd < 0) {
+		bcs[i].f =3D fopen(name, "rb");
+		if (!bcs[i].f) {
 			log_err("fio: could not open file: %s\n", name);
-			ret =3D bcs[i].fd;
+			ret =3D -errno;
 			free(str);
 			goto err_file;
 		}
-		bcs[i].fifo =3D fifo_alloc(TRACE_FIFO_SIZE);
 		nr_logs++;
=20
 		if (!is_blktrace(name, &bcs[i].swap)) {
@@ -761,14 +706,10 @@ int merge_blktrace_iologs(struct thread_data *td)
 		i =3D find_earliest_io(bcs, nr_logs);
 		bc =3D &bcs[i];
 		/* skip over the pdu */
-		ret =3D discard_pdu(td, bc->fifo, bc->fd, &bc->t);
+		ret =3D discard_pdu(bc->f, &bc->t);
 		if (ret < 0) {
 			td_verror(td, -ret, "blktrace lseek");
 			goto err_file;
-		} else if (bc->t.pdu_len !=3D ret) {
-			log_err("fio: discarded %d of %d\n", ret,
-				bc->t.pdu_len);
-			goto err_file;
 		}
=20
 		ret =3D write_trace(merge_fp, &bc->t);
@@ -786,8 +727,7 @@ int merge_blktrace_iologs(struct thread_data *td)
 err_file:
 	/* cleanup */
 	for (i =3D 0; i < nr_logs; i++) {
-		fifo_free(bcs[i].fifo);
-		close(bcs[i].fd);
+		fclose(bcs[i].f);
 	}
 err_merge_buf:
 	free(merge_buf);
diff --git a/blktrace.h b/blktrace.h
index a0e82faa..b2ebdba3 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -10,7 +10,7 @@
=20
 struct blktrace_cursor {
 	struct fifo		*fifo;	// fifo queue for reading
-	int			fd;	// blktrace file
+	FILE			*f;	// blktrace file
 	__u64			length; // length of trace
 	struct blk_io_trace	t;	// current io trace
 	int			swap;	// bitwise reverse required
--=20
2.34.1


--Sig_/S8uVfDK6RHF9E1BvqxiPIPR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHofygACgkQNasLKJxd
sljunQ//aUm5/c01fvZETV1PqsC+uZ74AQyuPPpSUJSlhGfHFatUVE5mBTU06eWg
jWA4+q3yRWVamQ5L9vAs4uYt3IgkeJ+4Bap1/7vrE7HMkSoa7GzafZNhjVRZlpfF
GinWZtDPwp4aoNkwjJMk/O2PDUVG+BK7xWrvtT8I0Zw5UXMj+Be8X4d/kTsD9W6V
NdhdMSt+gaBbko5s46C/uRHZUtemFLhm9nNLmyJ+YOfEQQH4YfCqE93OxcGhSqH7
qbzPhnnqeedhKo9TVG1TPI2SydVR/aEei3xpRhyb/ebBc/PU5LX+81cUqMqcs88f
Bce0pma+hfOzceyqGfOm6a4dMxg4zsTzlmwVRFEeftPXlqO2W3X30YCs0GKc2YlP
p/C42ybY7hmhrfWVAlD/rO1w92AJPy4nzASpFcfrzM0FclE6AtWyC1gkJ8Qi6CqL
QtgCPFu1hWX5jLazp5BDo5Dc8Cz7LrblmOBZ6PoeFv3I4LWUZxVhr/cPrRwUlgdb
/zx9/d/zyl5ObOgEFBZVvCP9nCGmMrlIG0PtXpx+ivKUBum5Ua8MPlNp2JrvJanY
sd1/bkOCPqgfPfCP88NRddG7QmI2zCCVWTncjPyQCx8UYPbc0mIdeKXlqwvMtpsK
okCzaWSLFKY8xyJK3PVAYh4vrywHZCieptzaYqzypQZZs1UCBeE=
=gHTS
-----END PGP SIGNATURE-----

--Sig_/S8uVfDK6RHF9E1BvqxiPIPR--
