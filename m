Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50045 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdJKMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Oct 2017 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e2FgM-0006ya-6N
        for fio@vger.kernel.org; Wed, 11 Oct 2017 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171011120001.C6E6B2C00C4@kernel.dk>
Date: Wed, 11 Oct 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b18775f7b7c6c7d0a4d9b0a38e2a979e4180d14e:

  Update file creation example (2017-10-09 14:42:45 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8847ae4cd2e3d0d73dd7d7c93c5d6da96b71d174:

  backend: don't dereference ->io_ops in reap_threads() (2017-10-10 11:54:54 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Merge branch 'pr/note-for-shmmax' of https://github.com/taghos/fio
      HOWTO: include note about increasing shared memory limits
      engines/filecreate: set data direction for stats
      blktrace: use for_each_file()

Justin Eno (1):
      backend: don't dereference ->io_ops in reap_threads()

Ricardo Nabinger Sanchez (1):
      Add note for increasing shmmax if necessary

 HOWTO                |  3 +++
 backend.c            |  6 +-----
 blktrace.c           |  4 +---
 engines/filecreate.c | 31 ++++++++++++++++++++++++++++++-
 fio.1                |  2 ++
 5 files changed, 37 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index df79e2d..d3f957b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -217,6 +217,9 @@ Command line options
 .. option:: --max-jobs=nr
 
 	Set the maximum number of threads/processes to support to `nr`.
+	NOTE: On Linux, it may be necessary to increase the shared-memory
+	limit ('/proc/sys/kernel/shmmax') if fio runs into errors while
+	creating jobs.
 
 .. option:: --server=args
 
diff --git a/backend.c b/backend.c
index ba6f585..d98e5fe 100644
--- a/backend.c
+++ b/backend.c
@@ -1929,11 +1929,7 @@ static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 	for_each_td(td, i) {
 		int flags = 0;
 
-		/*
-		 * ->io_ops is NULL for a thread that has closed its
-		 * io engine
-		 */
-		if (td->io_ops && !strcmp(td->io_ops->name, "cpuio"))
+		 if (!strcmp(td->o.ioengine, "cpuio"))
 			cputhreads++;
 		else
 			realthreads++;
diff --git a/blktrace.c b/blktrace.c
index 65b600f..4b791d7 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -500,10 +500,8 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 		handle_trace(td, &t, ios, rw_bs);
 	} while (1);
 
-	for (i = 0; i < td->files_index; i++) {
-		f = td->files[i];
+	for_each_file(td, f, i)
 		trace_add_open_close_event(td, f->fileno, FIO_LOG_CLOSE_FILE);
-	}
 
 	fifo_free(fifo);
 	close(fd);
diff --git a/engines/filecreate.c b/engines/filecreate.c
index c6b6597..0c3bcdd 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -12,6 +12,10 @@
 #include "../fio.h"
 #include "../filehash.h"
 
+struct fc_data {
+	enum fio_ddir stat_ddir;
+};
+
 static int open_file(struct thread_data *td, struct fio_file *f)
 {
 	struct timespec start;
@@ -43,10 +47,11 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 	}
 
 	if (do_lat) {
+		struct fc_data *data = td->io_ops_data;
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, DDIR_READ, nsec, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0);
 	}
 
 	return 0;
@@ -68,9 +73,33 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+static int init(struct thread_data *td)
+{
+	struct fc_data *data;
+
+	data = calloc(1, sizeof(*data));
+
+	if (td_read(td))
+		data->stat_ddir = DDIR_READ;
+	else if (td_write(td))
+		data->stat_ddir = DDIR_WRITE;
+
+	td->io_ops_data = data;
+	return 0;
+}
+
+static void cleanup(struct thread_data *td)
+{
+	struct fc_data *data = td->io_ops_data;
+
+	free(data);
+}
+
 static struct ioengine_ops ioengine = {
 	.name		= "filecreate",
 	.version	= FIO_IOOPS_VERSION,
+	.init		= init,
+	.cleanup	= cleanup,
 	.queue		= queue_io,
 	.get_file_size	= get_file_size,
 	.open_file	= open_file,
diff --git a/fio.1 b/fio.1
index 68ed3ba..6e7d1f8 100644
--- a/fio.1
+++ b/fio.1
@@ -113,6 +113,8 @@ All fio parser warnings are fatal, causing fio to exit with an error.
 .TP
 .BI \-\-max\-jobs \fR=\fPnr
 Set the maximum number of threads/processes to support to \fInr\fR.
+NOTE: On Linux, it may be necessary to increase the shared-memory limit
+(`/proc/sys/kernel/shmmax') if fio runs into errors while creating jobs.
 .TP
 .BI \-\-server \fR=\fPargs
 Start a backend server, with \fIargs\fR specifying what to listen to.
