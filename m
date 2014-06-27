Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0MAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 27 Jun 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X0Up3-0004Nh-V2
	for fio@vger.kernel.org; Fri, 27 Jun 2014 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140627120003.B2DD5401FC@lyth.info>
Date: Fri, 27 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a606a802173272002e37be6475802be8c37481d6:

  Cast input argument for json_object_add_value_int to long long (2014-06-24 19:31:22 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4445856ab659ffa41bdb8f5b81aa00704c50a5c6:

  Verify: Tighten header length check in verify_header() (2014-06-26 19:30:16 +0200)

----------------------------------------------------------------
Andreas Gruenbacher (3):
      update_condensed_str(): Fix for empty input strings
      Verify: Fix and improve verify_header()
      Verify: Tighten header length check in verify_header()

Tiziano M��ller (1):
      Add configure flags for gfapi and rbd

 configure |    8 +++++--
 eta.c     |   39 ++++++++++--------------------
 verify.c  |   80 +++++++++++++++++++++++++------------------------------------
 3 files changed, 51 insertions(+), 76 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 0e861ee..f1e116e 100755
--- a/configure
+++ b/configure
@@ -156,6 +156,10 @@ for opt do
   ;;
   --disable-numa) disable_numa="yes"
   ;;
+  --disable-rbd) disable_rbd="yes"
+  ;;
+  --disable-gfapi) disable_gfapi="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -1146,7 +1150,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-lrbd -lrados" "rbd"; then
+if test "$disable_rbd" != "yes"  && compile_prog "" "-lrbd -lrados" "rbd"; then
   LIBS="-lrbd -lrados $LIBS"
   rbd="yes"
 fi
@@ -1183,7 +1187,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
+if test "$disable_gfapi" != "yes"  && compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
   LIBS="-lgfapi -lglusterfs $LIBS"
   gfapi="yes"
 fi
diff --git a/eta.c b/eta.c
index bdd5376..850a784 100644
--- a/eta.c
+++ b/eta.c
@@ -12,35 +12,20 @@ static char run_str[__THREAD_RUNSTR_SZ(REAL_MAX_JOBS)];
 
 static void update_condensed_str(char *run_str, char *run_str_condensed)
 {
-	int i, ci, last, nr;
-	size_t len;
-
-	len = strlen(run_str);
-	if (!len)
-		return;
-
-	last = 0;
-	nr = 0;
-	ci = 0;
-	for (i = 0; i < len; i++) {
-		if (!last) {
-new:
-			run_str_condensed[ci] = run_str[i];
-			last = run_str[i];
-			nr = 1;
-			ci++;
-		} else if (last == run_str[i]) {
-			nr++;
-		} else {
-			ci += sprintf(&run_str_condensed[ci], "(%u),", nr);
-			goto new;
+	if (*run_str) {
+		while (*run_str) {
+			int nr = 1;
+
+			*run_str_condensed++ = *run_str++;
+			while (*(run_str - 1) == *run_str) {
+				run_str++;
+				nr++;
+			}
+			run_str_condensed += sprintf(run_str_condensed, "(%u),", nr);
 		}
+		run_str_condensed--;
 	}
-
-	if (nr)
-		ci += sprintf(&run_str_condensed[ci], "(%u)", nr);
-
-	run_str_condensed[ci + 1] = '\0';
+	*run_str_condensed = '\0';
 }
 
 /*
diff --git a/verify.c b/verify.c
index 282a8cf..2615701 100644
--- a/verify.c
+++ b/verify.c
@@ -709,23 +709,42 @@ static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
 	return ret;
 }
 
-static int verify_header(struct io_u *io_u, struct verify_header *hdr)
+static int verify_header(struct io_u *io_u, struct verify_header *hdr,
+			 unsigned int hdr_num, unsigned int hdr_len)
 {
 	void *p = hdr;
 	uint32_t crc;
 
-	if (hdr->magic != FIO_HDR_MAGIC)
-		return 1;
-	if (hdr->len > io_u->buflen)
-		return 2;
-	if (hdr->rand_seed != io_u->rand_seed)
-		return 3;
+	if (hdr->magic != FIO_HDR_MAGIC) {
+		log_err("verify: bad magic header %x, wanted %x",
+			hdr->magic, FIO_HDR_MAGIC);
+		goto err;
+	}
+	if (hdr->len != hdr_len) {
+		log_err("verify: bad header length %u, wanted %u",
+			hdr->len, hdr_len);
+		goto err;
+	}
+	if (hdr->rand_seed != io_u->rand_seed) {
+		log_err("verify: bad header rand_seed %"PRIu64
+			", wanted %"PRIu64,
+			hdr->rand_seed, io_u->rand_seed);
+		goto err;
+	}
 
 	crc = fio_crc32c(p, offsetof(struct verify_header, crc32));
-	if (crc == hdr->crc32)
-		return 0;
-	log_err("fio: verify header crc %x, calculated %x\n", hdr->crc32, crc);
-	return 4;
+	if (crc != hdr->crc32) {
+		log_err("verify: bad header crc %x, calculated %x",
+			hdr->crc32, crc);
+		goto err;
+	}
+	return 0;
+
+err:
+	log_err(" at file %s offset %llu, length %u\n",
+		io_u->file->file_name,
+		io_u->offset + hdr_num * hdr_len, hdr_len);
+	return EILSEQ;
 }
 
 int verify_io_u(struct thread_data *td, struct io_u *io_u)
@@ -769,42 +788,9 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
 		if (td->o.verifysort || (td->flags & TD_F_VER_BACKLOG))
 			io_u->rand_seed = hdr->rand_seed;
 
-		ret = verify_header(io_u, hdr);
-		switch (ret) {
-		case 0:
-			break;
-		case 1:
-			log_err("verify: bad magic header %x, wanted %x at "
-				"file %s offset %llu, length %u\n",
-				hdr->magic, FIO_HDR_MAGIC,
-				io_u->file->file_name,
-				io_u->offset + hdr_num * hdr->len, hdr->len);
-			return EILSEQ;
-			break;
-		case 2:
-			log_err("fio: verify header exceeds buffer length (%u "
-				"> %lu)\n", hdr->len, io_u->buflen);
-			return EILSEQ;
-			break;
-		case 3:
-			log_err("verify: bad header rand_seed %"PRIu64
-				", wanted %"PRIu64" at file %s offset %llu, "
-				"length %u\n",
-				hdr->rand_seed, io_u->rand_seed,
-				io_u->file->file_name,
-				io_u->offset + hdr_num * hdr->len, hdr->len);
-			return EILSEQ;
-			break;
-		case 4:
-			return EILSEQ;
-			break;
-		default:
-			log_err("verify: unknown header error at file %s "
-			"offset %llu, length %u\n",
-			io_u->file->file_name,
-			io_u->offset + hdr_num * hdr->len, hdr->len);
-			return EILSEQ;
-		}
+		ret = verify_header(io_u, hdr, hdr_num, hdr_inc);
+		if (ret)
+			return ret;
 
 		if (td->o.verify != VERIFY_NONE)
 			verify_type = td->o.verify;
