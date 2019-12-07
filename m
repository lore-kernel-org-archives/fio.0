Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60550 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfLGNAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Dec 2019 08:00:03 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1idZgp-0008VA-75
        for fio@vger.kernel.org; Sat, 07 Dec 2019 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191207130001.C468A1BC004D@kernel.dk>
Date: Sat,  7 Dec 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bef74db41fb5a1607fd55cb86544165fc08acac1:

  Merge branch 'engine-rados-fix-first' of https://github.com/aclamk/fio (2019-11-27 10:23:12 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fd9882facefa0f5b09c09d2bc5cb3a2b6eabda1a:

  filesetup: ensure to setup random generator properly (2019-12-06 22:03:04 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      io_uring: add support for RWF_UNCACHED
      pvsync2: add support for RWF_UNCACHED
      Renumber RWF_UNCACHED
      filesetup: ensure to setup random generator properly

 engines/io_uring.c | 12 ++++++++++++
 engines/sync.c     | 12 ++++++++++++
 filesetup.c        |  4 +++-
 os/os-linux.h      |  4 ++++
 4 files changed, 31 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index ef56345b..9ba126d8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -75,6 +75,7 @@ struct ioring_options {
 	unsigned int sqpoll_thread;
 	unsigned int sqpoll_set;
 	unsigned int sqpoll_cpu;
+	unsigned int uncached;
 };
 
 static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
@@ -132,6 +133,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "uncached",
+		.lname	= "Uncached",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, uncached),
+		.help	= "Use RWF_UNCACHED for buffered read/writes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -180,6 +190,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->addr = (unsigned long) &ld->iovecs[io_u->index];
 			sqe->len = 1;
 		}
+		if (!td->o.odirect && o->uncached)
+			sqe->rw_flags = RWF_UNCACHED;
 		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
 		if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
diff --git a/engines/sync.c b/engines/sync.c
index b3e1c9db..65fd210c 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -39,6 +39,7 @@ struct psyncv2_options {
 	void *pad;
 	unsigned int hipri;
 	unsigned int hipri_percentage;
+	unsigned int uncached;
 };
 
 static struct fio_option options[] = {
@@ -63,6 +64,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "uncached",
+		.lname	= "Uncached",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct psyncv2_options, uncached),
+		.help	= "Use RWF_UNCACHED for buffered read/writes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= NULL,
 	},
@@ -152,6 +162,8 @@ static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
 	if (o->hipri &&
 	    (rand_between(&sd->rand_state, 1, 100) <= o->hipri_percentage))
 		flags |= RWF_HIPRI;
+	if (!td->o.odirect && o->uncached)
+		flags |= RWF_UNCACHED;
 
 	iov->iov_base = io_u->xfer_buf;
 	iov->iov_len = io_u->xfer_buflen;
diff --git a/filesetup.c b/filesetup.c
index 7fe2ebd4..ed3646a4 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1287,7 +1287,9 @@ static bool init_rand_distribution(struct thread_data *td)
 	unsigned int i;
 	int state;
 
-	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM)
+	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM ||
+	    td->o.random_distribution == FIO_RAND_DIST_ZONED ||
+	    td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
 		return false;
 
 	state = td_bump_runstate(td, TD_SETTING_UP);
diff --git a/os/os-linux.h b/os/os-linux.h
index 36339ef3..0f0bcc3a 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -326,6 +326,10 @@ static inline int fio_set_sched_idle(void)
 #define RWF_SYNC	0x00000004
 #endif
 
+#ifndef RWF_UNCACHED
+#define RWF_UNCACHED	0x00000040
+#endif
+
 #ifndef RWF_WRITE_LIFE_SHIFT
 #define RWF_WRITE_LIFE_SHIFT		4
 #define RWF_WRITE_LIFE_SHORT		(1 << RWF_WRITE_LIFE_SHIFT)

