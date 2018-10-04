Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbeJDSxL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Oct 2018 14:53:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g82If-0007qW-Sp
        for fio@vger.kernel.org; Thu, 04 Oct 2018 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181004120002.004912C288F@kernel.dk>
Date: Thu,  4 Oct 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 21f277b89029e7729d2dc631572244361ea7718c:

  engines/rados: use fio provided file names (2018-10-01 08:18:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8772acb0435c6a378951458d8fd9b18e1ab1add0:

  Fio 3.11 (2018-10-03 12:30:40 -0600)

----------------------------------------------------------------
Dennis Zhou (2):
      Revert "blktrace: support for non-512b sector sizes"
      update replay_align and replay_scale documentation

Jens Axboe (3):
      iolog: fix up some style issues
      iolog: fix leak for unsupported iolog version
      Fio 3.11

 FIO-VERSION-GEN |  2 +-
 HOWTO           |  7 +++---
 blktrace.c      | 75 +++++++++++++++------------------------------------------
 file.h          |  1 -
 fio.1           |  7 +++---
 iolog.c         | 48 +++++++++++++++++++++---------------
 6 files changed, 57 insertions(+), 83 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index f1d25d0..17b215d 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.10
+DEF_VER=fio-3.11
 
 LF='
 '
diff --git a/HOWTO b/HOWTO
index 9528904..a2503e9 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2559,12 +2559,13 @@ I/O replay
 
 .. option:: replay_align=int
 
-	Force alignment of I/O offsets and lengths in a trace to this power of 2
-	value.
+	Force alignment of the byte offsets in a trace to this value. The value
+	must be a power of 2.
 
 .. option:: replay_scale=int
 
-	Scale sector offsets down by this factor when replaying traces.
+	Scale byte offsets down by this factor when replaying traces. Should most
+	likely use :option:`replay_align` as well.
 
 .. option:: replay_skip=str
 
diff --git a/blktrace.c b/blktrace.c
index 772a0c7..efe9ce2 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -3,9 +3,7 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
-#include <sys/ioctl.h>
 #include <unistd.h>
-#include <linux/fs.h>
 
 #include "flist.h"
 #include "fio.h"
@@ -129,37 +127,17 @@ static void trace_add_open_close_event(struct thread_data *td, int fileno, enum
 	flist_add_tail(&ipo->list, &td->io_log_list);
 }
 
-static int get_dev_blocksize(const char *dev, unsigned int *bs)
+static int trace_add_file(struct thread_data *td, __u32 device)
 {
-	int fd;
-
-	fd = open(dev, O_RDONLY);
-	if (fd < 0)
-		return 1;
-
-	if (ioctl(fd, BLKSSZGET, bs) < 0) {
-		close(fd);
-		return 1;
-	}
-
-	close(fd);
-	return 0;
-}
-
-static int trace_add_file(struct thread_data *td, __u32 device,
-			  unsigned int *bs)
-{
-	static unsigned int last_maj, last_min, last_fileno, last_bs;
+	static unsigned int last_maj, last_min, last_fileno;
 	unsigned int maj = FMAJOR(device);
 	unsigned int min = FMINOR(device);
 	struct fio_file *f;
-	unsigned int i;
 	char dev[256];
+	unsigned int i;
 
-	if (last_maj == maj && last_min == min) {
-		*bs = last_bs;
+	if (last_maj == maj && last_min == min)
 		return last_fileno;
-	}
 
 	last_maj = maj;
 	last_min = min;
@@ -167,17 +145,14 @@ static int trace_add_file(struct thread_data *td, __u32 device,
 	/*
 	 * check for this file in our list
 	 */
-	for_each_file(td, f, i) {
+	for_each_file(td, f, i)
 		if (f->major == maj && f->minor == min) {
 			last_fileno = f->fileno;
-			last_bs = f->bs;
-			goto out;
+			return last_fileno;
 		}
-	}
 
 	strcpy(dev, "/dev");
 	if (blktrace_lookup_device(td->o.replay_redirect, dev, maj, min)) {
-		unsigned int this_bs;
 		int fileno;
 
 		if (td->o.replay_redirect)
@@ -189,22 +164,13 @@ static int trace_add_file(struct thread_data *td, __u32 device,
 
 		dprint(FD_BLKTRACE, "add devices %s\n", dev);
 		fileno = add_file_exclusive(td, dev);
-
-		if (get_dev_blocksize(dev, &this_bs))
-			this_bs = 512;
-
 		td->o.open_files++;
 		td->files[fileno]->major = maj;
 		td->files[fileno]->minor = min;
-		td->files[fileno]->bs = this_bs;
 		trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
-
 		last_fileno = fileno;
-		last_bs = this_bs;
 	}
 
-out:
-	*bs = last_bs;
 	return last_fileno;
 }
 
@@ -221,14 +187,14 @@ static void t_bytes_align(struct thread_options *o, struct blk_io_trace *t)
  */
 static void store_ipo(struct thread_data *td, unsigned long long offset,
 		      unsigned int bytes, int rw, unsigned long long ttime,
-		      int fileno, unsigned int bs)
+		      int fileno)
 {
 	struct io_piece *ipo;
 
 	ipo = calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
 
-	ipo->offset = offset * bs;
+	ipo->offset = offset * 512;
 	if (td->o.replay_scale)
 		ipo->offset = ipo->offset / td->o.replay_scale;
 	ipo_bytes_align(td->o.replay_align, ipo);
@@ -268,10 +234,9 @@ static void handle_trace_notify(struct blk_io_trace *t)
 static void handle_trace_discard(struct thread_data *td,
 				 struct blk_io_trace *t,
 				 unsigned long long ttime,
-				 unsigned long *ios, unsigned int *rw_bs)
+				 unsigned long *ios, unsigned int *bs)
 {
 	struct io_piece *ipo;
-	unsigned int bs;
 	int fileno;
 
 	if (td->o.replay_skip & (1u << DDIR_TRIM))
@@ -279,17 +244,17 @@ static void handle_trace_discard(struct thread_data *td,
 
 	ipo = calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
-	fileno = trace_add_file(td, t->device, &bs);
+	fileno = trace_add_file(td, t->device);
 
 	ios[DDIR_TRIM]++;
-	if (t->bytes > rw_bs[DDIR_TRIM])
-		rw_bs[DDIR_TRIM] = t->bytes;
+	if (t->bytes > bs[DDIR_TRIM])
+		bs[DDIR_TRIM] = t->bytes;
 
 	td->o.size += t->bytes;
 
 	INIT_FLIST_HEAD(&ipo->list);
 
-	ipo->offset = t->sector * bs;
+	ipo->offset = t->sector * 512;
 	if (td->o.replay_scale)
 		ipo->offset = ipo->offset / td->o.replay_scale;
 	ipo_bytes_align(td->o.replay_align, ipo);
@@ -311,13 +276,12 @@ static void dump_trace(struct blk_io_trace *t)
 
 static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 			    unsigned long long ttime, unsigned long *ios,
-			    unsigned int *rw_bs)
+			    unsigned int *bs)
 {
-	unsigned int bs;
 	int rw;
 	int fileno;
 
-	fileno = trace_add_file(td, t->device, &bs);
+	fileno = trace_add_file(td, t->device);
 
 	rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
 
@@ -335,19 +299,18 @@ static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 		return;
 	}
 
-	if (t->bytes > rw_bs[rw])
-		rw_bs[rw] = t->bytes;
+	if (t->bytes > bs[rw])
+		bs[rw] = t->bytes;
 
 	ios[rw]++;
 	td->o.size += t->bytes;
-	store_ipo(td, t->sector, t->bytes, rw, ttime, fileno, bs);
+	store_ipo(td, t->sector, t->bytes, rw, ttime, fileno);
 }
 
 static void handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
 			       unsigned long long ttime, unsigned long *ios)
 {
 	struct io_piece *ipo;
-	unsigned int bs;
 	int fileno;
 
 	if (td->o.replay_skip & (1u << DDIR_SYNC))
@@ -355,7 +318,7 @@ static void handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
 
 	ipo = calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
-	fileno = trace_add_file(td, t->device, &bs);
+	fileno = trace_add_file(td, t->device);
 
 	ipo->delay = ttime / 1000;
 	ipo->ddir = DDIR_SYNC;
diff --git a/file.h b/file.h
index 446a1fb..e50c0f9 100644
--- a/file.h
+++ b/file.h
@@ -89,7 +89,6 @@ struct fio_file {
 	 */
 	unsigned int major, minor;
 	int fileno;
-	unsigned long long bs;
 	char *file_name;
 
 	/*
diff --git a/fio.1 b/fio.1
index 5c11d96..bf181b3 100644
--- a/fio.1
+++ b/fio.1
@@ -2257,11 +2257,12 @@ Unfortunately this also breaks the strict time ordering between multiple
 device accesses.
 .TP
 .BI replay_align \fR=\fPint
-Force alignment of I/O offsets and lengths in a trace to this power of 2
-value.
+Force alignment of the byte offsets in a trace to this value. The value
+must be a power of 2.
 .TP
 .BI replay_scale \fR=\fPint
-Scale sector offsets down by this factor when replaying traces.
+Scale bye offsets down by this factor when replaying traces. Should most
+likely use \fBreplay_align\fR as well.
 .SS "Threads, processes and job synchronization"
 .TP
 .BI replay_skip \fR=\fPstr
diff --git a/iolog.c b/iolog.c
index 26c3458..b72dcf9 100644
--- a/iolog.c
+++ b/iolog.c
@@ -566,7 +566,9 @@ static bool read_iolog2(struct thread_data *td)
 static bool is_socket(const char *path)
 {
 	struct stat buf;
-	int r = stat(path, &buf);
+	int r;
+
+	r = stat(path, &buf);
 	if (r == -1)
 		return false;
 
@@ -575,19 +577,25 @@ static bool is_socket(const char *path)
 
 static int open_socket(const char *path)
 {
-	int fd = socket(AF_UNIX, SOCK_STREAM, 0);
 	struct sockaddr_un addr;
+	int ret, fd;
+
+	fd = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (fd < 0)
 		return fd;
+
 	addr.sun_family = AF_UNIX;
 	if (snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", path) >=
-	    sizeof(addr.sun_path))
+	    sizeof(addr.sun_path)) {
 		log_err("%s: path name %s is too long for a Unix socket\n",
 			__func__, path);
-	if (connect(fd, (const struct sockaddr *)&addr, strlen(path) + sizeof(addr.sun_family)) == 0)
+	}
+
+	ret = connect(fd, (const struct sockaddr *)&addr, strlen(path) + sizeof(addr.sun_family));
+	if (!ret)
 		return fd;
-	else
-		close(fd);
+
+	close(fd);
 	return -1;
 }
 
@@ -596,20 +604,23 @@ static int open_socket(const char *path)
  */
 static bool init_iolog_read(struct thread_data *td)
 {
-	char buffer[256], *p;
+	char buffer[256], *p, *fname;
 	FILE *f = NULL;
-	bool ret;
-	char* fname = get_name_by_idx(td->o.read_iolog_file, td->subjob_number);
+
+	fname = get_name_by_idx(td->o.read_iolog_file, td->subjob_number);
 	dprint(FD_IO, "iolog: name=%s\n", fname);
 
 	if (is_socket(fname)) {
-		int fd = open_socket(fname);
-		if (fd >= 0) {
+		int fd;
+
+		fd = open_socket(fname);
+		if (fd >= 0)
 			f = fdopen(fd, "r");
-		}
 	} else
 		f = fopen(fname, "r");
+
 	free(fname);
+
 	if (!f) {
 		perror("fopen read iolog");
 		return false;
@@ -622,21 +633,20 @@ static bool init_iolog_read(struct thread_data *td)
 		fclose(f);
 		return false;
 	}
-	td->io_log_rfile = f;
+
 	/*
 	 * version 2 of the iolog stores a specific string as the
 	 * first line, check for that
 	 */
 	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2))) {
 		free_release_files(td);
-		ret = read_iolog2(td);
-	}
-	else {
-		log_err("fio: iolog version 1 is no longer supported\n");
-		ret = false;
+		td->io_log_rfile = f;
+		return read_iolog2(td);
 	}
 
-	return ret;
+	log_err("fio: iolog version 1 is no longer supported\n");
+	fclose(f);
+	return false;
 }
 
 /*

