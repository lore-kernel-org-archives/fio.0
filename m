Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730930AbgIHPzg (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Sep 2020 11:55:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E029C061786
        for <fio@vger.kernel.org>; Tue,  8 Sep 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFcI8-0002EM-HY
        for fio@vger.kernel.org; Tue, 08 Sep 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200908120001.D3F561BC0142@kernel.dk>
Date: Tue,  8 Sep 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 03eabd8a7a53c80a6c9d1376b38a9b7ddce2268a:

  Merge branch 'guasi_fixes' of https://github.com/sitsofe/fio into master (2020-09-06 16:14:58 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to be23e6be4fadb723f925824f88fbaedbd3502251:

  Kill off old GUASI IO engine (2020-09-07 13:38:03 -0600)

----------------------------------------------------------------
Alexey Dobriyan (1):
      fio: cap io_size=N% at 100%, update man page

Jens Axboe (1):
      Kill off old GUASI IO engine

 HOWTO           |   8 --
 Makefile        |   5 --
 configure       |  22 -----
 engines/guasi.c | 270 --------------------------------------------------------
 fio.1           |   8 +-
 io_u.h          |   6 --
 options.c       |  11 ++-
 parse.h         |   5 ++
 8 files changed, 12 insertions(+), 323 deletions(-)
 delete mode 100644 engines/guasi.c

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 5dc571f8..d8586723 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1901,14 +1901,6 @@ I/O engine
 			single CPU at the desired rate. A job never finishes unless there is
 			at least one non-cpuio job.
 
-		**guasi**
-			The GUASI I/O engine is the Generic Userspace Asynchronous Syscall
-			Interface approach to async I/O. See
-
-			http://www.xmailserver.org/guasi-lib.html
-
-			for more info on GUASI.
-
 		**rdma**
 			The RDMA I/O engine supports both RDMA memory semantics
 			(RDMA_WRITE/RDMA_READ) and channel semantics (Send/Recv) for the
diff --git a/Makefile b/Makefile
index 6678c2fd..b00daca2 100644
--- a/Makefile
+++ b/Makefile
@@ -106,11 +106,6 @@ endif
 ifdef CONFIG_LINUX_SPLICE
   SOURCE += engines/splice.c
 endif
-ifdef CONFIG_GUASI
-  guasi_SRCS = engines/guasi.c
-  guasi_LIBS = -lguasi
-  ENGINES += guasi
-endif
 ifdef CONFIG_SOLARISAIO
   SOURCE += engines/solarisaio.c
 endif
diff --git a/configure b/configure
index 81bfb270..08571fb0 100755
--- a/configure
+++ b/configure
@@ -1311,25 +1311,6 @@ if compile_prog "" "" "linux splice"; then
 fi
 print_config "Linux splice(2)" "$linux_splice"
 
-##########################################
-# GUASI probe
-if test "$guasi" != "yes" ; then
-  guasi="no"
-fi
-cat > $TMPC << EOF
-#include <guasi.h>
-#include <guasi_syscalls.h>
-int main(int argc, char **argv)
-{
-  guasi_t ctx = guasi_create(0, 0, 0);
-  return 0;
-}
-EOF
-if compile_prog "" "-lguasi" "guasi"; then
-  guasi="yes"
-fi
-print_config "GUASI" "$guasi"
-
 ##########################################
 # libnuma probe
 if test "$libnuma" != "yes" ; then
@@ -2847,9 +2828,6 @@ fi
 if test "$linux_splice" = "yes" ; then
   output_sym "CONFIG_LINUX_SPLICE"
 fi
-if test "$guasi" = "yes" ; then
-  output_sym "CONFIG_GUASI"
-fi
 if test "$libnuma_v2" = "yes" ; then
   output_sym "CONFIG_LIBNUMA"
 fi
diff --git a/engines/guasi.c b/engines/guasi.c
deleted file mode 100644
index d4121757..00000000
--- a/engines/guasi.c
+++ /dev/null
@@ -1,270 +0,0 @@
-/*
- * guasi engine
- *
- * IO engine using the GUASI library.
- *
- * Before running make. You'll need the GUASI lib as well:
- *
- * http://www.xmailserver.org/guasi-lib.html
- *
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <errno.h>
-#include <assert.h>
-
-#include "../fio.h"
-
-#define GFIO_MIN_THREADS 32
-#ifndef GFIO_MAX_THREADS
-#define GFIO_MAX_THREADS 2000
-#endif
-
-#include <guasi.h>
-#include <guasi_syscalls.h>
-
-#ifdef GFIO_DEBUG
-#define GDBG_PRINT(a) printf a
-#else
-#define GDBG_PRINT(a) (void) 0
-#endif
-
-struct guasi_data {
-	guasi_t hctx;
-	int max_reqs;
-	guasi_req_t *reqs;
-	struct io_u **io_us;
-	int queued_nr;
-	int reqs_nr;
-};
-
-static int fio_guasi_prep(struct thread_data fio_unused *td, struct io_u *io_u)
-{
-
-	GDBG_PRINT(("fio_guasi_prep(%p)\n", io_u));
-	io_u->greq = NULL;
-
-	return 0;
-}
-
-static struct io_u *fio_guasi_event(struct thread_data *td, int event)
-{
-	struct guasi_data *ld = td->io_ops_data;
-	struct io_u *io_u;
-	struct guasi_reqinfo rinf;
-
-	GDBG_PRINT(("fio_guasi_event(%d)\n", event));
-	if (guasi_req_info(ld->reqs[event], &rinf) < 0) {
-		log_err("guasi_req_info(%d) FAILED!\n", event);
-		return NULL;
-	}
-	io_u = rinf.asid;
-	io_u->error = EINPROGRESS;
-	GDBG_PRINT(("fio_guasi_event(%d) -> %p\n", event, io_u));
-	if (rinf.status == GUASI_STATUS_COMPLETE) {
-		io_u->error = rinf.result;
-		if (io_u->ddir == DDIR_READ ||
-		    io_u->ddir == DDIR_WRITE) {
-			io_u->error = 0;
-			if (rinf.result != (long) io_u->xfer_buflen) {
-				if (rinf.result >= 0)
-					io_u->resid = io_u->xfer_buflen - rinf.result;
-				else
-					io_u->error = rinf.error;
-			}
-		}
-	}
-
-	return io_u;
-}
-
-static int fio_guasi_getevents(struct thread_data *td, unsigned int min,
-			       unsigned int max, const struct timespec *t)
-{
-	struct guasi_data *ld = td->io_ops_data;
-	int n, r;
-	long timeo = -1;
-
-	GDBG_PRINT(("fio_guasi_getevents(%d, %d)\n", min, max));
-	if (min > ld->max_reqs)
-		min = ld->max_reqs;
-	if (max > ld->max_reqs)
-		max = ld->max_reqs;
-	if (t)
-		timeo = t->tv_sec * 1000L + t->tv_nsec / 1000000L;
-	for (n = 0; n < ld->reqs_nr; n++)
-		guasi_req_free(ld->reqs[n]);
-	n = 0;
-	do {
-		r = guasi_fetch(ld->hctx, ld->reqs + n, min - n,
-				max - n, timeo);
-		if (r < 0) {
-			log_err("guasi_fetch() FAILED! (%d)\n", r);
-			break;
-		}
-		n += r;
-		if (n >= min)
-			break;
-	} while (1);
-	ld->reqs_nr = n;
-	GDBG_PRINT(("fio_guasi_getevents() -> %d\n", n));
-
-	return n;
-}
-
-static enum fio_q_status fio_guasi_queue(struct thread_data *td,
-					 struct io_u *io_u)
-{
-	struct guasi_data *ld = td->io_ops_data;
-
-	fio_ro_check(td, io_u);
-
-	GDBG_PRINT(("fio_guasi_queue(%p)\n", io_u));
-	if (ld->queued_nr == (int) td->o.iodepth)
-		return FIO_Q_BUSY;
-
-	ld->io_us[ld->queued_nr] = io_u;
-	ld->queued_nr++;
-	return FIO_Q_QUEUED;
-}
-
-static void fio_guasi_queued(struct thread_data *td, struct io_u **io_us, int nr)
-{
-	int i;
-	struct io_u *io_u;
-	struct timespec now;
-
-	if (!fio_fill_issue_time(td))
-		return;
-
-	io_u_mark_submit(td, nr);
-	fio_gettime(&now, NULL);
-	for (i = 0; i < nr; i++) {
-		io_u = io_us[i];
-		memcpy(&io_u->issue_time, &now, sizeof(now));
-		io_u_queued(td, io_u);
-	}
-}
-
-static int fio_guasi_commit(struct thread_data *td)
-{
-	struct guasi_data *ld = td->io_ops_data;
-	int i;
-	struct io_u *io_u;
-	struct fio_file *f;
-
-	GDBG_PRINT(("fio_guasi_commit(%d)\n", ld->queued_nr));
-	for (i = 0; i < ld->queued_nr; i++) {
-		io_u = ld->io_us[i];
-		GDBG_PRINT(("fio_guasi_commit(%d) --> %p\n", i, io_u));
-		f = io_u->file;
-		io_u->greq = NULL;
-		if (io_u->ddir == DDIR_READ)
-			io_u->greq = guasi__pread(ld->hctx, ld, io_u, 0,
-						  f->fd, io_u->xfer_buf, io_u->xfer_buflen,
-						  io_u->offset);
-		else if (io_u->ddir == DDIR_WRITE)
-			io_u->greq = guasi__pwrite(ld->hctx, ld, io_u, 0,
-						   f->fd, io_u->xfer_buf, io_u->xfer_buflen,
-						   io_u->offset);
-		else if (ddir_sync(io_u->ddir))
-			io_u->greq = guasi__fsync(ld->hctx, ld, io_u, 0, f->fd);
-		else {
-			log_err("fio_guasi_commit() FAILED: unknow request %d\n",
-				io_u->ddir);
-		}
-		if (io_u->greq == NULL) {
-			log_err("fio_guasi_commit() FAILED: submit failed (%s)\n",
-				strerror(errno));
-			return -1;
-		}
-	}
-	fio_guasi_queued(td, ld->io_us, i);
-	ld->queued_nr = 0;
-	GDBG_PRINT(("fio_guasi_commit() -> %d\n", i));
-
-	return 0;
-}
-
-static int fio_guasi_cancel(struct thread_data fio_unused *td,
-			    struct io_u *io_u)
-{
-	GDBG_PRINT(("fio_guasi_cancel(%p) req=%p\n", io_u, io_u->greq));
-	if (io_u->greq != NULL)
-		guasi_req_cancel(io_u->greq);
-
-	return 0;
-}
-
-static void fio_guasi_cleanup(struct thread_data *td)
-{
-	struct guasi_data *ld = td->io_ops_data;
-	int n;
-
-	GDBG_PRINT(("fio_guasi_cleanup(%p)\n", ld));
-	if (ld) {
-		for (n = 0; n < ld->reqs_nr; n++)
-			guasi_req_free(ld->reqs[n]);
-		guasi_free(ld->hctx);
-		free(ld->reqs);
-		free(ld->io_us);
-		free(ld);
-	}
-	GDBG_PRINT(("fio_guasi_cleanup(%p) DONE\n", ld));
-}
-
-static int fio_guasi_init(struct thread_data *td)
-{
-	int maxthr;
-	struct guasi_data *ld = malloc(sizeof(*ld));
-
-	GDBG_PRINT(("fio_guasi_init(): depth=%d\n", td->o.iodepth));
-	memset(ld, 0, sizeof(*ld));
-	maxthr = td->o.iodepth > GFIO_MIN_THREADS ? td->o.iodepth: GFIO_MIN_THREADS;
-	if (maxthr > GFIO_MAX_THREADS)
-		maxthr = GFIO_MAX_THREADS;
-	if ((ld->hctx = guasi_create(GFIO_MIN_THREADS, maxthr, 1)) == NULL) {
-		td_verror(td, errno, "guasi_create");
-		free(ld);
-		return 1;
-	}
-	ld->max_reqs = td->o.iodepth;
-	ld->reqs = malloc(ld->max_reqs * sizeof(guasi_req_t));
-	ld->io_us = malloc(ld->max_reqs * sizeof(struct io_u *));
-	memset(ld->io_us, 0, ld->max_reqs * sizeof(struct io_u *));
-	ld->queued_nr = 0;
-	ld->reqs_nr = 0;
-
-	td->io_ops_data = ld;
-	GDBG_PRINT(("fio_guasi_init(): depth=%d -> %p\n", td->o.iodepth, ld));
-
-	return 0;
-}
-
-FIO_STATIC struct ioengine_ops ioengine = {
-	.name		= "guasi",
-	.version	= FIO_IOOPS_VERSION,
-	.init		= fio_guasi_init,
-	.prep		= fio_guasi_prep,
-	.queue		= fio_guasi_queue,
-	.commit		= fio_guasi_commit,
-	.cancel		= fio_guasi_cancel,
-	.getevents	= fio_guasi_getevents,
-	.event		= fio_guasi_event,
-	.cleanup	= fio_guasi_cleanup,
-	.open_file	= generic_open_file,
-	.close_file	= generic_close_file,
-	.get_file_size	= generic_get_file_size,
-};
-
-static void fio_init fio_guasi_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_guasi_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
-
diff --git a/fio.1 b/fio.1
index f15194ff..74509bbd 100644
--- a/fio.1
+++ b/fio.1
@@ -1561,7 +1561,8 @@ if \fBsize\fR is set to 20GiB and \fBio_size\fR is set to 5GiB, fio
 will perform I/O within the first 20GiB but exit when 5GiB have been
 done. The opposite is also possible \-\- if \fBsize\fR is set to 20GiB,
 and \fBio_size\fR is set to 40GiB, then fio will do 40GiB of I/O within
-the 0..20GiB region.
+the 0..20GiB region. Value can be set as percentage: \fBio_size\fR=N%.
+In this case \fBio_size\fR multiplies \fBsize\fR= value.
 .TP
 .BI filesize \fR=\fPirange(int)
 Individual file sizes. May be a range, in which case fio will select sizes
@@ -1674,11 +1675,6 @@ to get desired CPU usage, as the cpuload only loads a
 single CPU at the desired rate. A job never finishes unless there is
 at least one non-cpuio job.
 .TP
-.B guasi
-The GUASI I/O engine is the Generic Userspace Asynchronous Syscall
-Interface approach to async I/O. See \fIhttp://www.xmailserver.org/guasi-lib.html\fR
-for more info on GUASI.
-.TP
 .B rdma
 The RDMA I/O engine supports both RDMA memory semantics
 (RDMA_WRITE/RDMA_READ) and channel semantics (Send/Recv) for the
diff --git a/io_u.h b/io_u.h
index 5a28689c..d4c5be43 100644
--- a/io_u.h
+++ b/io_u.h
@@ -11,9 +11,6 @@
 #ifdef CONFIG_LIBAIO
 #include <libaio.h>
 #endif
-#ifdef CONFIG_GUASI
-#include <guasi.h>
-#endif
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -125,9 +122,6 @@ struct io_u {
 #ifdef FIO_HAVE_SGIO
 		struct sg_io_hdr hdr;
 #endif
-#ifdef CONFIG_GUASI
-		guasi_req_t greq;
-#endif
 #ifdef CONFIG_SOLARISAIO
 		aio_result_t resultp;
 #endif
diff --git a/options.c b/options.c
index e27bb9cb..b497d973 100644
--- a/options.c
+++ b/options.c
@@ -1481,9 +1481,13 @@ static int str_io_size_cb(void *data, unsigned long long *__val)
 	struct thread_data *td = cb_data_to_td(data);
 	unsigned long long v = *__val;
 
-	if (parse_is_percent(v)) {
+	if (parse_is_percent_uncapped(v)) {
 		td->o.io_size = 0;
 		td->o.io_size_percent = -1ULL - v;
+		if (td->o.io_size_percent > 100) {
+			log_err("fio: io_size values greater than 100%% aren't supported\n");
+			return 1;
+		}
 		dprint(FD_PARSE, "SET io_size_percent %d\n",
 					td->o.io_size_percent);
 	} else
@@ -1868,11 +1872,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  { .ival = "cpuio",
 			    .help = "CPU cycle burner engine",
 			  },
-#ifdef CONFIG_GUASI
-			  { .ival = "guasi",
-			    .help = "GUASI IO engine",
-			  },
-#endif
 #ifdef CONFIG_RDMA
 			  { .ival = "rdma",
 			    .help = "RDMA IO engine",
diff --git a/parse.h b/parse.h
index 5828654f..1d2cbf74 100644
--- a/parse.h
+++ b/parse.h
@@ -133,6 +133,11 @@ static inline int parse_is_percent(unsigned long long val)
 	return val <= -1ULL && val >= (-1ULL - 100ULL);
 }
 
+static inline int parse_is_percent_uncapped(unsigned long long val)
+{
+	return (long long)val <= -1;
+}
+
 struct print_option {
 	struct flist_head list;
 	char *name;

