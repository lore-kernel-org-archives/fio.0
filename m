Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46752 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfGJMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Jul 2019 08:00:04 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hlBGV-00042H-Tk
        for fio@vger.kernel.org; Wed, 10 Jul 2019 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190710120001.E4A6B2C0099@kernel.dk>
Date: Wed, 10 Jul 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 308aa5d011158d5f7fa533a60199066dd1858e4c:

  Merge branch 'optlenmax' of https://github.com/powernap/fio (2019-07-01 14:26:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f32a30d4c4eb2490b5c1bdac9ae3c2fc7a7ab20e:

  engines/http: set FIO_SYNCIO flag (2019-07-09 08:55:31 -0600)

----------------------------------------------------------------
Vincent Fu (2):
      fio: fix aio trim completion latencies
      engines/http: set FIO_SYNCIO flag

 engines/http.c     | 2 +-
 engines/io_uring.c | 1 +
 engines/libaio.c   | 1 +
 engines/posixaio.c | 1 +
 ioengines.c        | 8 ++++++--
 ioengines.h        | 2 ++
 6 files changed, 12 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/http.c b/engines/http.c
index a35c0332..275fcab5 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -642,7 +642,7 @@ static int fio_http_invalidate(struct thread_data *td, struct fio_file *f)
 static struct ioengine_ops ioengine = {
 	.name = "http",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_DISKLESSIO,
+	.flags			= FIO_DISKLESSIO | FIO_SYNCIO,
 	.setup			= fio_http_setup,
 	.queue			= fio_http_queue,
 	.getevents		= fio_http_getevents,
diff --git a/engines/io_uring.c b/engines/io_uring.c
index a5e77d8f..9bcfec17 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -533,6 +533,7 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 static struct ioengine_ops ioengine = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
diff --git a/engines/libaio.c b/engines/libaio.c
index 8844ac8b..cc6ca66b 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -429,6 +429,7 @@ static int fio_libaio_init(struct thread_data *td)
 static struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM,
 	.init			= fio_libaio_init,
 	.post_init		= fio_libaio_post_init,
 	.prep			= fio_libaio_prep,
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 4ac01957..82c6aa65 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -243,6 +243,7 @@ static int fio_posixaio_init(struct thread_data *td)
 static struct ioengine_ops ioengine = {
 	.name		= "posixaio",
 	.version	= FIO_IOOPS_VERSION,
+	.flags		= FIO_ASYNCIO_SYNC_TRIM,
 	.init		= fio_posixaio_init,
 	.prep		= fio_posixaio_prep,
 	.queue		= fio_posixaio_queue,
diff --git a/ioengines.c b/ioengines.c
index 7e5a50cc..aa4ccd27 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -308,7 +308,9 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	io_u->error = 0;
 	io_u->resid = 0;
 
-	if (td_ioengine_flagged(td, FIO_SYNCIO)) {
+	if (td_ioengine_flagged(td, FIO_SYNCIO) ||
+		(td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_TRIM) && 
+		io_u->ddir == DDIR_TRIM)) {
 		if (fio_fill_issue_time(td))
 			fio_gettime(&io_u->issue_time, NULL);
 
@@ -389,7 +391,9 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 			td_io_commit(td);
 	}
 
-	if (!td_ioengine_flagged(td, FIO_SYNCIO)) {
+	if (!td_ioengine_flagged(td, FIO_SYNCIO) &&
+		(!td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_TRIM) ||
+		 io_u->ddir != DDIR_TRIM)) {
 		if (fio_fill_issue_time(td))
 			fio_gettime(&io_u->issue_time, NULL);
 
diff --git a/ioengines.h b/ioengines.h
index b9cd33d5..01a9b586 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -63,6 +63,8 @@ enum fio_ioengine_flags {
 	FIO_FAKEIO	= 1 << 11,	/* engine pretends to do IO */
 	FIO_NOSTATS	= 1 << 12,	/* don't do IO stats */
 	FIO_NOFILEHASH	= 1 << 13,	/* doesn't hash the files for lookup later. */
+	FIO_ASYNCIO_SYNC_TRIM
+			= 1 << 14	/* io engine has async ->queue except for trim */
 };
 
 /*

