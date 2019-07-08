Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH] fio: fix aio trim completion latencies
Date: Mon,  8 Jul 2019 15:23:54 -0400
Message-Id: <20190708192354.14979-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

The io_uring, libaio, and posixaio ioengines actually carry out
synchronous trim operations, but latency timestamps are recorded as if
the trims were issued asynchronously. This patch fixes how timestamps
are recorded for trim operations issued by these ioengines.

Fixes: https://github.com/axboe/fio/issues/764
---
 engines/io_uring.c | 1 +
 engines/libaio.c   | 1 +
 engines/posixaio.c | 1 +
 ioengines.c        | 8 ++++++--
 ioengines.h        | 2 ++
 5 files changed, 11 insertions(+), 2 deletions(-)

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
-- 
2.17.1


