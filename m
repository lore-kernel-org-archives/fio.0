Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60254 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbeKGWa1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Nov 2018 17:30:27 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gKNRJ-0005sY-Kx
        for fio@vger.kernel.org; Wed, 07 Nov 2018 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181107130001.CC3832C0144@kernel.dk>
Date: Wed,  7 Nov 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 16500b5a0b03ee0142d592bb74a46943a223b06e:

  Fio 3.12 (2018-11-02 12:41:50 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 46ff70e8795e91acb2ffc041e6c1fdb4e157dff4:

  verify: add requested block information to failure trace (2018-11-06 21:30:32 -0700)

----------------------------------------------------------------
Feng, Changyu (1):
      verify: add requested block information to failure trace

Jens Axboe (2):
      libaio: add support for polled IO
      libaio: fix 'hipri' help entry

 engines/libaio.c | 24 +++++++++++++++++++++---
 verify.c         | 12 ++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libaio.c b/engines/libaio.c
index 7ac36b2..b241ed9 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -13,6 +13,9 @@
 #include "../lib/pow2.h"
 #include "../optgroup.h"
 
+#define IOCB_CMD_PREAD_POLL 9
+#define IOCB_CMD_PWRITE_POLL 10
+
 static int fio_libaio_commit(struct thread_data *td);
 
 struct libaio_data {
@@ -39,6 +42,7 @@ struct libaio_data {
 struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
+	unsigned int hipri;
 };
 
 static struct fio_option options[] = {
@@ -52,6 +56,15 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_LIBAIO,
 	},
 	{
+		.name	= "hipri",
+		.lname	= "RWF_HIPRI",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct libaio_options, hipri),
+		.help	= "Use polled IO completions",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -68,12 +81,17 @@ static inline void ring_inc(struct libaio_data *ld, unsigned int *val,
 static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
+	struct libaio_options *o = td->eo;
 
-	if (io_u->ddir == DDIR_READ)
+	if (io_u->ddir == DDIR_READ) {
 		io_prep_pread(&io_u->iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-	else if (io_u->ddir == DDIR_WRITE)
+		if (o->hipri)
+			io_u->iocb.aio_lio_opcode = IOCB_CMD_PREAD_POLL;
+	} else if (io_u->ddir == DDIR_WRITE) {
 		io_prep_pwrite(&io_u->iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-	else if (ddir_sync(io_u->ddir))
+		if (o->hipri)
+			io_u->iocb.aio_lio_opcode = IOCB_CMD_PWRITE_POLL;
+	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(&io_u->iocb, f->fd);
 
 	return 0;
diff --git a/verify.c b/verify.c
index 01492f2..da429e7 100644
--- a/verify.c
+++ b/verify.c
@@ -345,8 +345,10 @@ static void log_verify_failure(struct verify_header *hdr, struct vcont *vc)
 
 	offset = vc->io_u->offset;
 	offset += vc->hdr_num * hdr->len;
-	log_err("%.8s: verify failed at file %s offset %llu, length %u\n",
-			vc->name, vc->io_u->file->file_name, offset, hdr->len);
+	log_err("%.8s: verify failed at file %s offset %llu, length %u"
+			" (requested block: offset=%llu, length=%llu)\n",
+			vc->name, vc->io_u->file->file_name, offset, hdr->len,
+			vc->io_u->offset, vc->io_u->buflen);
 
 	if (vc->good_crc && vc->bad_crc) {
 		log_err("       Expected CRC: ");
@@ -865,9 +867,11 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 	return 0;
 
 err:
-	log_err(" at file %s offset %llu, length %u\n",
+	log_err(" at file %s offset %llu, length %u"
+		" (requested block: offset=%llu, length=%llu)\n",
 		io_u->file->file_name,
-		io_u->offset + hdr_num * hdr_len, hdr_len);
+		io_u->offset + hdr_num * hdr_len, hdr_len,
+		io_u->offset, io_u->buflen);
 
 	if (td->o.verify_dump)
 		dump_buf(p, hdr_len, io_u->offset + hdr_num * hdr_len,

