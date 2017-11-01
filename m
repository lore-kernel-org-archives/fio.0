Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37400 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdKAMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Nov 2017 08:00:16 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9rgt-0003wC-A4
        for fio@vger.kernel.org; Wed, 01 Nov 2017 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171101120002.2A4842C23D1@kernel.dk>
Date: Wed,  1 Nov 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e2b7f9fb0d105de217fe97817b47c594232ac14f:

  Merge branch 'misc' of https://github.com/sitsofe/fio (2017-10-30 09:05:43 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1633aa61a68593b4a4cc5dbb621129303a7c3049:

  engines/windowsaio: style fixups (2017-10-31 14:01:16 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      init: make sure that compression enables refill buffers
      Update compression documentation
      Default buffer_compress_chunk to 512
      engines/windowsaio: style fixups

 HOWTO                |  7 ++++---
 engines/windowsaio.c | 25 ++++++++++++++-----------
 fio.1                |  7 ++++---
 init.c               |  4 +++-
 options.c            |  1 +
 5 files changed, 26 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f151350..419fa73 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1453,8 +1453,8 @@ Buffers and memory
 	mix of random data and a fixed pattern. The fixed pattern is either zeros,
 	or the pattern specified by :option:`buffer_pattern`. If the pattern option
 	is used, it might skew the compression ratio slightly. Note that this is per
-	block size unit, for file/disk wide compression level that matches this
-	setting, you'll also want to set :option:`refill_buffers`.
+	block size unit, see :option:`buffer_compress_chunk` for setting a finer
+	granularity of compression regions.
 
 .. option:: buffer_compress_chunk=int
 
@@ -1463,7 +1463,8 @@ Buffers and memory
 	will provide :option:`buffer_compress_percentage` of blocksize random data,
 	followed by the remaining zeroed. With this set to some chunk size smaller
 	than the block size, fio can alternate random and zeroed data throughout the
-	I/O buffer.
+	I/O buffer. This is particularly useful when bigger block sizes are used
+	for a job. Defaults to 512.
 
 .. option:: buffer_pattern=str
 
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index a66b1df..9439393 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -94,15 +94,13 @@ static int fio_windowsaio_init(struct thread_data *td)
 		if (!rc)
 			ctx = malloc(sizeof(struct thread_ctx));
 
-		if (!rc && ctx == NULL)
-		{
+		if (!rc && ctx == NULL) {
 			log_err("windowsaio: failed to allocate memory for thread context structure\n");
 			CloseHandle(hFile);
 			rc = 1;
 		}
 
-		if (!rc)
-		{
+		if (!rc) {
 			DWORD threadid;
 
 			ctx->iocp = hFile;
@@ -146,7 +144,7 @@ static int windowsaio_invalidate_cache(struct fio_file *f)
 {
 	DWORD error;
 	DWORD isharemode = (FILE_SHARE_DELETE | FILE_SHARE_READ |
-			FILE_SHARE_WRITE);
+				FILE_SHARE_WRITE);
 	HANDLE ihFile;
 	int rc = 0;
 
@@ -348,7 +346,8 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 				break;
 		}
 
-		if (dequeued >= min || (t != NULL && timeout_expired(start_count, end_count)))
+		if (dequeued >= min ||
+		    (t != NULL && timeout_expired(start_count, end_count)))
 			break;
 	} while (1);
 
@@ -371,10 +370,12 @@ static int fio_windowsaio_queue(struct thread_data *td, struct io_u *io_u)
 
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
-		success = WriteFile(io_u->file->hFile, io_u->xfer_buf, io_u->xfer_buflen, NULL, lpOvl);
+		success = WriteFile(io_u->file->hFile, io_u->xfer_buf,
+					io_u->xfer_buflen, NULL, lpOvl);
 		break;
 	case DDIR_READ:
-		success = ReadFile(io_u->file->hFile, io_u->xfer_buf, io_u->xfer_buflen, NULL, lpOvl);
+		success = ReadFile(io_u->file->hFile, io_u->xfer_buf,
+					io_u->xfer_buflen, NULL, lpOvl);
 		break;
 	case DDIR_SYNC:
 	case DDIR_DATASYNC:
@@ -386,13 +387,11 @@ static int fio_windowsaio_queue(struct thread_data *td, struct io_u *io_u)
 		}
 
 		return FIO_Q_COMPLETED;
-		break;
 	case DDIR_TRIM:
 		log_err("windowsaio: manual TRIM isn't supported on Windows\n");
 		io_u->error = 1;
 		io_u->resid = io_u->xfer_buflen;
 		return FIO_Q_COMPLETED;
-		break;
 	default:
 		assert(0);
 		break;
@@ -423,7 +422,11 @@ static DWORD WINAPI IoCompletionRoutine(LPVOID lpParameter)
 	wd = ctx->wd;
 
 	do {
-		if (!GetQueuedCompletionStatus(ctx->iocp, &bytes, &ulKey, &ovl, 250) && ovl == NULL)
+		BOOL ret;
+
+		ret = GetQueuedCompletionStatus(ctx->iocp, &bytes, &ulKey,
+						&ovl, 250);
+		if (!ret && ovl == NULL)
 			continue;
 
 		fov = CONTAINING_RECORD(ovl, struct fio_overlapped, o);
diff --git a/fio.1 b/fio.1
index 198b9d8..63d32a5 100644
--- a/fio.1
+++ b/fio.1
@@ -1242,8 +1242,8 @@ WRITEs) that compresses to the specified level. Fio does this by providing a
 mix of random data and a fixed pattern. The fixed pattern is either zeros,
 or the pattern specified by \fBbuffer_pattern\fR. If the pattern option
 is used, it might skew the compression ratio slightly. Note that this is per
-block size unit, for file/disk wide compression level that matches this
-setting, you'll also want to set \fBrefill_buffers\fR.
+block size unit, see \fBbuffer_compress_chunk\fR for setting a finer granularity
+of compressible regions.
 .TP
 .BI buffer_compress_chunk \fR=\fPint
 See \fBbuffer_compress_percentage\fR. This setting allows fio to manage
@@ -1251,7 +1251,8 @@ how big the ranges of random data and zeroed data is. Without this set, fio
 will provide \fBbuffer_compress_percentage\fR of blocksize random data,
 followed by the remaining zeroed. With this set to some chunk size smaller
 than the block size, fio can alternate random and zeroed data throughout the
-I/O buffer.
+I/O buffer. This is particularly useful when bigger block sizes are used
+for a job. Defaults to 512.
 .TP
 .BI buffer_pattern \fR=\fPstr
 If set, fio will fill the I/O buffers with this pattern or with the contents
diff --git a/init.c b/init.c
index e80aec3..736c6ff 100644
--- a/init.c
+++ b/init.c
@@ -855,8 +855,10 @@ static int fixup_options(struct thread_data *td)
 		if (o->compress_percentage == 100) {
 			o->zero_buffers = 1;
 			o->compress_percentage = 0;
-		} else if (!fio_option_is_set(o, refill_buffers))
+		} else if (!fio_option_is_set(o, refill_buffers)) {
 			o->refill_buffers = 1;
+			td->flags |= TD_F_REFILL_BUFFERS;
+		}
 	}
 
 	/*
diff --git a/options.c b/options.c
index 5813a66..e8d1a3a 100644
--- a/options.c
+++ b/options.c
@@ -4067,6 +4067,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.parent	= "buffer_compress_percentage",
 		.hide	= 1,
 		.help	= "Size of compressible region in buffer",
+		.def	= "512",
 		.interval = 256,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_BUF,
