Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54526 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752187AbdFMMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Jun 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dKkUS-0002mI-UH
        for fio@vger.kernel.org; Tue, 13 Jun 2017 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170613120001.D364D2C0083@kernel.dk>
Date: Tue, 13 Jun 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 85c705e55c2bbeb3c74d96ef4ec1ae90203c4083:

  man: Update buffer_pattern entry in man pages (2017-06-08 12:12:36 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 052046a1e92bff19ecae277670a59fb726a66b86:

  binject: don't use void* for pointer arithmetic (gcc) (2017-06-12 14:51:01 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (6):
      sg: add missing free(msg); in ->errdetails() handler
      sg: drop unneeded strdup from ->errdetails() handler
      sg: drop redundant void* cast
      sg: don't use void* for pointer arithmetic (gcc)
      splice: don't use void* for pointer arithmetic (gcc)
      binject: don't use void* for pointer arithmetic (gcc)

 engines/binject.c |  3 ++-
 engines/sg.c      | 16 ++++++++--------
 engines/splice.c  |  5 +++--
 3 files changed, 13 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/engines/binject.c b/engines/binject.c
index 932534a..792dbbd 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -59,11 +59,12 @@ static int pollin_events(struct pollfd *pfds, int fds)
 	return 0;
 }
 
-static unsigned int binject_read_commands(struct thread_data *td, void *p,
+static unsigned int binject_read_commands(struct thread_data *td, void *buf,
 					  int left, int *err)
 {
 	struct fio_file *f;
 	int i, ret, events;
+	char *p = buf;
 
 one_more:
 	events = 0;
diff --git a/engines/sg.c b/engines/sg.c
index 2148e87..4540b57 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -124,7 +124,7 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 	}
 
 	while (left) {
-		void *p;
+		char *p;
 
 		dprint(FD_IO, "sgio_getevents: sd %p: left=%d\n", sd, left);
 
@@ -184,7 +184,7 @@ re_read:
 			if (hdr->info & SG_INFO_CHECK) {
 				struct io_u *io_u;
 				io_u = (struct io_u *)(hdr->usr_ptr);
-				memcpy((void*)&(io_u->hdr), (void*)hdr, sizeof(struct sg_io_hdr));
+				memcpy(&io_u->hdr, hdr, sizeof(struct sg_io_hdr));
 				sd->events[i]->error = EIO;
 			}
 		}
@@ -572,17 +572,17 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 	struct sg_io_hdr *hdr = &io_u->hdr;
 #define MAXERRDETAIL 1024
 #define MAXMSGCHUNK  128
-	char *msg, msgchunk[MAXMSGCHUNK], *ret = NULL;
+	char *msg, msgchunk[MAXMSGCHUNK];
 	int i;
 
 	msg = calloc(1, MAXERRDETAIL);
+	strcpy(msg, "");
 
 	/*
 	 * can't seem to find sg_err.h, so I'll just echo the define values
 	 * so others can search on internet to find clearer clues of meaning.
 	 */
 	if (hdr->info & SG_INFO_CHECK) {
-		ret = msg;
 		if (hdr->host_status) {
 			snprintf(msgchunk, MAXMSGCHUNK, "SG Host Status: 0x%02x; ", hdr->host_status);
 			strlcat(msg, msgchunk, MAXERRDETAIL);
@@ -755,14 +755,14 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 		if (hdr->resid != 0) {
 			snprintf(msgchunk, MAXMSGCHUNK, "SG Driver: %d bytes out of %d not transferred. ", hdr->resid, hdr->dxfer_len);
 			strlcat(msg, msgchunk, MAXERRDETAIL);
-			ret = msg;
 		}
 	}
 
-	if (!ret)
-		ret = strdup("SG Driver did not report a Host, Driver or Device check");
+	if (!(hdr->info & SG_INFO_CHECK) && !strlen(msg))
+		strncpy(msg, "SG Driver did not report a Host, Driver or Device check",
+			MAXERRDETAIL - 1);
 
-	return ret;
+	return msg;
 }
 
 /*
diff --git a/engines/splice.c b/engines/splice.c
index eba093e..d5d8ab0 100644
--- a/engines/splice.c
+++ b/engines/splice.c
@@ -32,7 +32,7 @@ static int fio_splice_read_old(struct thread_data *td, struct io_u *io_u)
 	struct fio_file *f = io_u->file;
 	int ret, ret2, buflen;
 	off_t offset;
-	void *p;
+	char *p;
 
 	offset = io_u->offset;
 	buflen = io_u->xfer_buflen;
@@ -77,7 +77,8 @@ static int fio_splice_read(struct thread_data *td, struct io_u *io_u)
 	struct iovec iov;
 	int ret , buflen, mmap_len;
 	off_t offset;
-	void *p, *map;
+	void *map;
+	char *p;
 
 	ret = 0;
 	offset = io_u->offset;
