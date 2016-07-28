Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38680 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbcG1MAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 28 Jul 2016 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bSjyt-0001Dc-C9
	for fio@vger.kernel.org; Thu, 28 Jul 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160728120001.77F1F2C00D9@kernel.dk>
Date: Thu, 28 Jul 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fa3cdbb7a46e42186e8fa62d33b82b92c7c0e310:

  Add sample job file showing how to read backwards (2016-07-26 14:50:02 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c915aa3b56b72c3c9eac3b92f89f22a18ccf0047:

  examples/backwards-read.fio: add size (2016-07-27 08:33:21 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      examples/backwards-read.fio: add size

Jevon Qiao (1):
      Fix memory leak in _fio_setup_rbd_data()

Tomohiro Kusumi (14):
      Make return value type of fio_getaffinity() consistent
      Fix typos in log_err() message
      Use default CPU_COUNT() function in DragonFlyBSD
      Use sizeof(char*) instead of sizeof(void*)
      Mention default values for readwrite=/ioengine=/mem= in documentation
      Mention cpuio never finishes without real I/O in documentation
      Ignore exit_io_done= option if no I/O threads are configured
      Use correct I/O engine name "cpuio" instead of "cpu"
      Add missing --cmdhelp type string for FIO_OPT_UNSUPPORTED
      Don't malloc/memcpy ioengine_ops on td initialization
      Fix stat(2) related bugs introduced by changes made for Windows
      Rename exists_and_not_file() to exists_and_not_regfile()
      Add missing archs in fio_arch_strings[]
      Change arch_i386 to arch_x86

 HOWTO                       | 15 +++++++++-----
 arch/arch-x86.h             |  2 +-
 arch/arch.h                 |  2 +-
 engines/binject.c           | 10 +++++-----
 engines/cpu.c               |  4 ++--
 engines/e4defrag.c          |  6 +++---
 engines/glusterfs.c         | 20 +++++++++----------
 engines/glusterfs_async.c   |  8 ++++----
 engines/glusterfs_sync.c    |  4 ++--
 engines/guasi.c             | 12 ++++++------
 engines/libaio.c            | 14 ++++++-------
 engines/libhdfs.c           | 16 +++++++--------
 engines/net.c               | 42 +++++++++++++++++++--------------------
 engines/null.c              | 12 ++++++------
 engines/posixaio.c          | 10 +++++-----
 engines/rbd.c               | 23 +++++++++++++---------
 engines/rdma.c              | 48 ++++++++++++++++++++++-----------------------
 engines/sg.c                | 16 +++++++--------
 engines/solarisaio.c        | 12 ++++++------
 engines/splice.c            | 12 ++++++------
 engines/sync.c              | 20 +++++++++----------
 engines/windowsaio.c        | 16 +++++++--------
 examples/backwards-read.fio |  1 +
 filesetup.c                 |  4 +++-
 fio.1                       | 15 ++++++++------
 fio.h                       |  6 ++++++
 init.c                      | 11 ++++++++---
 ioengine.h                  |  2 --
 ioengines.c                 | 17 ++++++----------
 libfio.c                    |  8 ++++++++
 options.c                   |  2 +-
 os/os-dragonfly.h           | 24 +++++++++--------------
 os/os-linux-syscall.h       |  2 +-
 os/os-windows.h             |  5 ++++-
 os/os.h                     |  6 +++++-
 parse.c                     |  1 +
 36 files changed, 229 insertions(+), 199 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index ab25cb2..2c5896d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -405,6 +405,7 @@ rw=str		Type of io pattern. Accepted values are:
 			trimwrite	Mixed trims and writes. Blocks will be
 					trimmed first, then written to.
 
+		Fio defaults to read if the option is not specified.
 		For the mixed io types, the default is to split them 50/50.
 		For certain types of io the result may still be skewed a bit,
 		since the speed may be different. It is possible to specify
@@ -699,7 +700,8 @@ ioengine=str	Defines how the job issues io to the file. The following
 			sync	Basic read(2) or write(2) io. lseek(2) is
 				used to position the io location.
 
-			psync 	Basic pread(2) or pwrite(2) io.
+			psync 	Basic pread(2) or pwrite(2) io. Default on all
+				supported operating systems except for Windows.
 
 			vsync	Basic readv(2) or writev(2) IO.
 
@@ -717,6 +719,7 @@ ioengine=str	Defines how the job issues io to the file. The following
 			solarisaio Solaris native asynchronous io.
 
 			windowsaio Windows native asynchronous io.
+				Default on Windows.
 
 			mmap	File is memory mapped and data copied
 				to/from using memcpy(3).
@@ -754,7 +757,8 @@ ioengine=str	Defines how the job issues io to the file. The following
 				85% of the CPU. In case of SMP machines,
 				use numjobs=<no_of_cpu> to get desired CPU
 				usage, as the cpuload only loads a single
-				CPU at the desired rate.
+				CPU at the desired rate. A job never finishes
+				unless there is at least one non-cpuio job.
 
 			guasi	The GUASI IO engine is the Generic Userspace
 				Asyncronous Syscall Interface approach
@@ -1221,6 +1225,7 @@ mem=str		Fio can use various types of memory as the io unit buffer.
 		The allowed values are:
 
 			malloc	Use memory from malloc(3) as the buffers.
+				Default memory type.
 
 			shm	Use shared memory as the buffers. Allocated
 				through shmget(2).
@@ -1835,12 +1840,12 @@ that defines them is selected.
 [psyncv2] hipri		Set RWF_HIPRI on IO, indicating to the kernel that
 			it's of higher priority than normal.
 
-[cpu] cpuload=int Attempt to use the specified percentage of CPU cycles.
+[cpuio] cpuload=int Attempt to use the specified percentage of CPU cycles.
 
-[cpu] cpuchunks=int Split the load into cycles of the given time. In
+[cpuio] cpuchunks=int Split the load into cycles of the given time. In
 		microseconds.
 
-[cpu] exit_on_io_done=bool Detect when IO threads are done, then exit.
+[cpuio] exit_on_io_done=bool Detect when IO threads are done, then exit.
 
 [netsplice] hostname=str
 [net] hostname=str The host name or IP address to use for TCP or UDP based IO.
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index d3b8985..457b44c 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -12,7 +12,7 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 
 #include "arch-x86-common.h"
 
-#define FIO_ARCH	(arch_i386)
+#define FIO_ARCH	(arch_x86)
 
 #define	FIO_HUGE_PAGE		4194304
 
diff --git a/arch/arch.h b/arch/arch.h
index 043e283..00d247c 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -3,7 +3,7 @@
 
 enum {
 	arch_x86_64 = 1,
-	arch_i386,
+	arch_x86,
 	arch_ppc,
 	arch_ia64,
 	arch_s390,
diff --git a/engines/binject.c b/engines/binject.c
index f8e83cd..7d20a3f 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -94,7 +94,7 @@ static int fio_binject_getevents(struct thread_data *td, unsigned int min,
 				 unsigned int max,
 				 const struct timespec fio_unused *t)
 {
-	struct binject_data *bd = td->io_ops->data;
+	struct binject_data *bd = td->io_ops_data;
 	int left = max, ret, r = 0, ev_index = 0;
 	void *buf = bd->cmds;
 	unsigned int i, events;
@@ -185,7 +185,7 @@ static int fio_binject_doio(struct thread_data *td, struct io_u *io_u)
 
 static int fio_binject_prep(struct thread_data *td, struct io_u *io_u)
 {
-	struct binject_data *bd = td->io_ops->data;
+	struct binject_data *bd = td->io_ops_data;
 	struct b_user_cmd *buc = &io_u->buc;
 	struct binject_file *bf = FILE_ENG_DATA(io_u->file);
 
@@ -234,7 +234,7 @@ static int fio_binject_queue(struct thread_data *td, struct io_u *io_u)
 
 static struct io_u *fio_binject_event(struct thread_data *td, int event)
 {
-	struct binject_data *bd = td->io_ops->data;
+	struct binject_data *bd = td->io_ops_data;
 
 	return bd->events[event];
 }
@@ -376,7 +376,7 @@ err_close:
 
 static void fio_binject_cleanup(struct thread_data *td)
 {
-	struct binject_data *bd = td->io_ops->data;
+	struct binject_data *bd = td->io_ops_data;
 
 	if (bd) {
 		free(bd->events);
@@ -406,7 +406,7 @@ static int fio_binject_init(struct thread_data *td)
 	bd->fd_flags = malloc(sizeof(int) * td->o.nr_files);
 	memset(bd->fd_flags, 0, sizeof(int) * td->o.nr_files);
 
-	td->io_ops->data = bd;
+	td->io_ops_data = bd;
 	return 0;
 }
 
diff --git a/engines/cpu.c b/engines/cpu.c
index 7643a8c..3d855e3 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -88,8 +88,8 @@ static int fio_cpuio_init(struct thread_data *td)
 
 	o->nr_files = o->open_files = 1;
 
-	log_info("%s: ioengine=cpu, cpuload=%u, cpucycle=%u\n", td->o.name,
-						co->cpuload, co->cpucycle);
+	log_info("%s: ioengine=%s, cpuload=%u, cpucycle=%u\n",
+		td->o.name, td->io_ops->name, co->cpuload, co->cpucycle);
 
 	return 0;
 }
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index c0667fe..c599c98 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -109,7 +109,7 @@ static int fio_e4defrag_init(struct thread_data *td)
 		goto err;
 
 	ed->bsz = stub.st_blksize;
-	td->io_ops->data = ed;
+	td->io_ops_data = ed;
 	return 0;
 err:
 	td_verror(td, errno, "io_queue_init");
@@ -120,7 +120,7 @@ err:
 
 static void fio_e4defrag_cleanup(struct thread_data *td)
 {
-	struct e4defrag_data *ed = td->io_ops->data;
+	struct e4defrag_data *ed = td->io_ops_data;
 	if (ed) {
 		if (ed->donor_fd >= 0)
 			close(ed->donor_fd);
@@ -136,7 +136,7 @@ static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
 	unsigned long long len;
 	struct move_extent me;
 	struct fio_file *f = io_u->file;
-	struct e4defrag_data *ed = td->io_ops->data;
+	struct e4defrag_data *ed = td->io_ops_data;
 	struct e4defrag_options *o = td->eo;
 
 	fio_ro_check(td, io_u);
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index dec9fb5..2abc283 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -41,7 +41,7 @@ int fio_gf_setup(struct thread_data *td)
 
 	dprint(FD_IO, "fio setup\n");
 
-	if (td->io_ops->data)
+	if (td->io_ops_data)
 		return 0;
 
 	g = malloc(sizeof(struct gf_data));
@@ -77,19 +77,19 @@ int fio_gf_setup(struct thread_data *td)
 		goto cleanup;
 	}
 	dprint(FD_FILE, "fio setup %p\n", g->fs);
-	td->io_ops->data = g;
+	td->io_ops_data = g;
 	return 0;
 cleanup:
 	if (g->fs)
 		glfs_fini(g->fs);
 	free(g);
-	td->io_ops->data = NULL;
+	td->io_ops_data = NULL;
 	return r;
 }
 
 void fio_gf_cleanup(struct thread_data *td)
 {
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	if (g) {
 		if (g->aio_events)
@@ -99,7 +99,7 @@ void fio_gf_cleanup(struct thread_data *td)
 		if (g->fs)
 			glfs_fini(g->fs);
 		free(g);
-		td->io_ops->data = NULL;
+		td->io_ops_data = NULL;
 	}
 }
 
@@ -107,7 +107,7 @@ int fio_gf_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	struct stat buf;
 	int ret;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	dprint(FD_FILE, "get file size %s\n", f->file_name);
 
@@ -135,7 +135,7 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 
 	int flags = 0;
 	int ret = 0;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 	struct stat sb = { 0, };
 
 	if (td_write(td)) {
@@ -268,7 +268,7 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 int fio_gf_close_file(struct thread_data *td, struct fio_file *f)
 {
 	int ret = 0;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	dprint(FD_FILE, "fd close %s\n", f->file_name);
 
@@ -284,7 +284,7 @@ int fio_gf_close_file(struct thread_data *td, struct fio_file *f)
 int fio_gf_unlink_file(struct thread_data *td, struct fio_file *f)
 {
 	int ret = 0;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	dprint(FD_FILE, "fd unlink %s\n", f->file_name);
 
@@ -300,7 +300,7 @@ int fio_gf_unlink_file(struct thread_data *td, struct fio_file *f)
 		g->fd = NULL;
 		free(g);
 	}
-	td->io_ops->data = NULL;
+	td->io_ops_data = NULL;
 
 	return ret;
 }
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 7c2c139..8e42a84 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -13,7 +13,7 @@ struct fio_gf_iou {
 
 static struct io_u *fio_gf_event(struct thread_data *td, int event)
 {
-	struct gf_data *gf_data = td->io_ops->data;
+	struct gf_data *gf_data = td->io_ops_data;
 
 	dprint(FD_IO, "%s\n", __FUNCTION__);
 	return gf_data->aio_events[event];
@@ -22,7 +22,7 @@ static struct io_u *fio_gf_event(struct thread_data *td, int event)
 static int fio_gf_getevents(struct thread_data *td, unsigned int min,
 			    unsigned int max, const struct timespec *t)
 {
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 	unsigned int events = 0;
 	struct io_u *io_u;
 	int i;
@@ -99,7 +99,7 @@ static void gf_async_cb(glfs_fd_t * fd, ssize_t ret, void *data)
 static int fio_gf_async_queue(struct thread_data fio_unused * td,
 			      struct io_u *io_u)
 {
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 	int r;
 
 	dprint(FD_IO, "%s op %s\n", __FUNCTION__, io_ddir_name(io_u->ddir));
@@ -150,7 +150,7 @@ int fio_gf_async_setup(struct thread_data *td)
 		return r;
 
 	td->o.use_thread = 1;
-	g = td->io_ops->data;
+	g = td->io_ops_data;
 	g->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!g->aio_events) {
 		r = -ENOMEM;
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index 6de4ee2..05e184c 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -11,7 +11,7 @@
 static int fio_gf_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	dprint(FD_FILE, "fio prep\n");
 
@@ -31,7 +31,7 @@ static int fio_gf_prep(struct thread_data *td, struct io_u *io_u)
 
 static int fio_gf_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 	int ret = 0;
 
 	dprint(FD_FILE, "fio queue len %lu\n", io_u->xfer_buflen);
diff --git a/engines/guasi.c b/engines/guasi.c
index c586f09..eb12c89 100644
--- a/engines/guasi.c
+++ b/engines/guasi.c
@@ -50,7 +50,7 @@ static int fio_guasi_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 
 static struct io_u *fio_guasi_event(struct thread_data *td, int event)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 	struct io_u *io_u;
 	struct guasi_reqinfo rinf;
 
@@ -82,7 +82,7 @@ static struct io_u *fio_guasi_event(struct thread_data *td, int event)
 static int fio_guasi_getevents(struct thread_data *td, unsigned int min,
 			       unsigned int max, const struct timespec *t)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 	int n, r;
 	long timeo = -1;
 
@@ -115,7 +115,7 @@ static int fio_guasi_getevents(struct thread_data *td, unsigned int min,
 
 static int fio_guasi_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -148,7 +148,7 @@ static void fio_guasi_queued(struct thread_data *td, struct io_u **io_us, int nr
 
 static int fio_guasi_commit(struct thread_data *td)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 	int i;
 	struct io_u *io_u;
 	struct fio_file *f;
@@ -198,7 +198,7 @@ static int fio_guasi_cancel(struct thread_data fio_unused *td,
 
 static void fio_guasi_cleanup(struct thread_data *td)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 	int n;
 
 	GDBG_PRINT(("fio_guasi_cleanup(%p)\n", ld));
@@ -235,7 +235,7 @@ static int fio_guasi_init(struct thread_data *td)
 	ld->queued_nr = 0;
 	ld->reqs_nr = 0;
 
-	td->io_ops->data = ld;
+	td->io_ops_data = ld;
 	GDBG_PRINT(("fio_guasi_init(): depth=%d -> %p\n", td->o.iodepth, ld));
 
 	return 0;
diff --git a/engines/libaio.c b/engines/libaio.c
index 9d562bb..e15c519 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -83,7 +83,7 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 
 static struct io_u *fio_libaio_event(struct thread_data *td, int event)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 	struct io_event *ev;
 	struct io_u *io_u;
 
@@ -145,7 +145,7 @@ static int user_io_getevents(io_context_t aio_ctx, unsigned int max,
 static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 				unsigned int max, const struct timespec *t)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 	struct libaio_options *o = td->eo;
 	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
 	struct timespec __lt, *lt = NULL;
@@ -181,7 +181,7 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 
 static int fio_libaio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -238,7 +238,7 @@ static void fio_libaio_queued(struct thread_data *td, struct io_u **io_us,
 
 static int fio_libaio_commit(struct thread_data *td)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 	struct iocb **iocbs;
 	struct io_u **io_us;
 	struct timeval tv;
@@ -308,14 +308,14 @@ static int fio_libaio_commit(struct thread_data *td)
 
 static int fio_libaio_cancel(struct thread_data *td, struct io_u *io_u)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 
 	return io_cancel(ld->aio_ctx, &io_u->iocb, ld->aio_events);
 }
 
 static void fio_libaio_cleanup(struct thread_data *td)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 
 	if (ld) {
 		/*
@@ -363,7 +363,7 @@ static int fio_libaio_init(struct thread_data *td)
 	ld->iocbs = calloc(ld->entries, sizeof(struct iocb *));
 	ld->io_us = calloc(ld->entries, sizeof(struct io_u *));
 
-	td->io_ops->data = ld;
+	td->io_ops_data = ld;
 	return 0;
 }
 
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index faad3f8..fba17c4 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -119,7 +119,7 @@ static int get_chunck_name(char *dest, char *file_name, uint64_t chunk_id) {
 static int fio_hdfsio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct hdfsio_options *options = td->eo;
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 	unsigned long f_id;
 	char fname[CHUNCK_NAME_LENGTH_MAX];
 	int open_flags;
@@ -163,7 +163,7 @@ static int fio_hdfsio_prep(struct thread_data *td, struct io_u *io_u)
 
 static int fio_hdfsio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 	struct hdfsio_options *options = td->eo;
 	int ret;
 	unsigned long offset;
@@ -223,7 +223,7 @@ int fio_hdfsio_open_file(struct thread_data *td, struct fio_file *f)
 
 int fio_hdfsio_close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 
 	if (hd->curr_file_id != -1) {
 		if ( hdfsCloseFile(hd->fs, hd->fp) == -1) {
@@ -238,7 +238,7 @@ int fio_hdfsio_close_file(struct thread_data *td, struct fio_file *f)
 static int fio_hdfsio_init(struct thread_data *td)
 {
 	struct hdfsio_options *options = td->eo;
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 	struct fio_file *f;
 	uint64_t j,k;
 	int i, failure = 0;
@@ -309,13 +309,13 @@ static int fio_hdfsio_setup(struct thread_data *td)
 	int i;
 	uint64_t file_size, total_file_size;
 
-	if (!td->io_ops->data) {
+	if (!td->io_ops_data) {
 		hd = malloc(sizeof(*hd));
 		memset(hd, 0, sizeof(*hd));
 		
 		hd->curr_file_id = -1;
 
-		td->io_ops->data = hd;
+		td->io_ops_data = hd;
 	}
 	
 	total_file_size = 0;
@@ -346,7 +346,7 @@ static int fio_hdfsio_setup(struct thread_data *td)
 
 static int fio_hdfsio_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 	struct hdfsio_options *options = td->eo;
 	int failure;
 	struct hdfsBuilder *bld;
@@ -381,7 +381,7 @@ static int fio_hdfsio_io_u_init(struct thread_data *td, struct io_u *io_u)
 
 static void fio_hdfsio_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 
 	if (hd->fs && hdfsDisconnect(hd->fs) < 0) {
 		log_err("hdfs: disconnect failed: %d\n", errno);
diff --git a/engines/net.c b/engines/net.c
index 9301ccf..f24efc1 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -374,7 +374,7 @@ static int splice_io_u(int fdin, int fdout, unsigned int len)
  */
 static int splice_in(struct thread_data *td, struct io_u *io_u)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	return splice_io_u(io_u->file->fd, nd->pipes[1], io_u->xfer_buflen);
 }
@@ -385,7 +385,7 @@ static int splice_in(struct thread_data *td, struct io_u *io_u)
 static int splice_out(struct thread_data *td, struct io_u *io_u,
 		      unsigned int len)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	return splice_io_u(nd->pipes[0], io_u->file->fd, len);
 }
@@ -423,7 +423,7 @@ static int vmsplice_io_u(struct io_u *io_u, int fd, unsigned int len)
 static int vmsplice_io_u_out(struct thread_data *td, struct io_u *io_u,
 			     unsigned int len)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	return vmsplice_io_u(io_u, nd->pipes[0], len);
 }
@@ -433,7 +433,7 @@ static int vmsplice_io_u_out(struct thread_data *td, struct io_u *io_u,
  */
 static int vmsplice_io_u_in(struct thread_data *td, struct io_u *io_u)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	return vmsplice_io_u(io_u, nd->pipes[1], io_u->xfer_buflen);
 }
@@ -524,7 +524,7 @@ static void verify_udp_seq(struct thread_data *td, struct netio_data *nd,
 
 static int fio_netio_send(struct thread_data *td, struct io_u *io_u)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int ret, flags = 0;
 
@@ -587,7 +587,7 @@ static int is_close_msg(struct io_u *io_u, int len)
 
 static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int ret, flags = 0;
 
@@ -645,7 +645,7 @@ static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 static int __fio_netio_queue(struct thread_data *td, struct io_u *io_u,
 			     enum fio_ddir ddir)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int ret;
 
@@ -711,7 +711,7 @@ static int fio_netio_queue(struct thread_data *td, struct io_u *io_u)
 
 static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int type, domain;
 
@@ -826,7 +826,7 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 
 static int fio_netio_accept(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	socklen_t socklen;
 	int state;
@@ -878,7 +878,7 @@ err:
 
 static void fio_netio_send_close(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct udp_close_msg msg;
 	struct sockaddr *to;
@@ -913,7 +913,7 @@ static int fio_netio_close_file(struct thread_data *td, struct fio_file *f)
 
 static int fio_netio_udp_recv_open(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct udp_close_msg msg;
 	struct sockaddr *to;
@@ -947,7 +947,7 @@ static int fio_netio_udp_recv_open(struct thread_data *td, struct fio_file *f)
 
 static int fio_netio_send_open(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct udp_close_msg msg;
 	struct sockaddr *to;
@@ -1049,7 +1049,7 @@ static int fio_fill_addr(struct thread_data *td, const char *host, int af,
 static int fio_netio_setup_connect_inet(struct thread_data *td,
 					const char *host, unsigned short port)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct addrinfo *res = NULL;
 	void *dst, *src;
@@ -1099,7 +1099,7 @@ static int fio_netio_setup_connect_inet(struct thread_data *td,
 static int fio_netio_setup_connect_unix(struct thread_data *td,
 					const char *path)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct sockaddr_un *soun = &nd->addr_un;
 
 	soun->sun_family = AF_UNIX;
@@ -1120,7 +1120,7 @@ static int fio_netio_setup_connect(struct thread_data *td)
 
 static int fio_netio_setup_listen_unix(struct thread_data *td, const char *path)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct sockaddr_un *addr = &nd->addr_un;
 	mode_t mode;
 	int len, fd;
@@ -1153,7 +1153,7 @@ static int fio_netio_setup_listen_unix(struct thread_data *td, const char *path)
 
 static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct ip_mreq mr;
 	struct sockaddr_in sin;
@@ -1269,7 +1269,7 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 
 static int fio_netio_setup_listen(struct thread_data *td)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int ret;
 
@@ -1344,7 +1344,7 @@ static int fio_netio_init(struct thread_data *td)
 
 static void fio_netio_cleanup(struct thread_data *td)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	if (nd) {
 		if (nd->listenfd != -1)
@@ -1368,13 +1368,13 @@ static int fio_netio_setup(struct thread_data *td)
 		td->o.open_files++;
 	}
 
-	if (!td->io_ops->data) {
+	if (!td->io_ops_data) {
 		nd = malloc(sizeof(*nd));;
 
 		memset(nd, 0, sizeof(*nd));
 		nd->listenfd = -1;
 		nd->pipes[0] = nd->pipes[1] = -1;
-		td->io_ops->data = nd;
+		td->io_ops_data = nd;
 	}
 
 	return 0;
@@ -1392,7 +1392,7 @@ static int fio_netio_setup_splice(struct thread_data *td)
 
 	fio_netio_setup(td);
 
-	nd = td->io_ops->data;
+	nd = td->io_ops_data;
 	if (nd) {
 		if (pipe(nd->pipes) < 0)
 			return 1;
diff --git a/engines/null.c b/engines/null.c
index 41d42e0..f7ba370 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -25,7 +25,7 @@ struct null_data {
 
 static struct io_u *fio_null_event(struct thread_data *td, int event)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 
 	return nd->io_us[event];
 }
@@ -34,7 +34,7 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 			      unsigned int fio_unused max,
 			      const struct timespec fio_unused *t)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 	int ret = 0;
 	
 	if (min_events) {
@@ -47,7 +47,7 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 
 static int fio_null_commit(struct thread_data *td)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 
 	if (!nd->events) {
 #ifndef FIO_EXTERNAL_ENGINE
@@ -62,7 +62,7 @@ static int fio_null_commit(struct thread_data *td)
 
 static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -83,7 +83,7 @@ static int fio_null_open(struct thread_data fio_unused *td,
 
 static void fio_null_cleanup(struct thread_data *td)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 
 	if (nd) {
 		free(nd->io_us);
@@ -103,7 +103,7 @@ static int fio_null_init(struct thread_data *td)
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
 
-	td->io_ops->data = nd;
+	td->io_ops_data = nd;
 	return 0;
 }
 
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 29bcc5a..e5411b7 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -93,7 +93,7 @@ static int fio_posixaio_prep(struct thread_data fio_unused *td,
 static int fio_posixaio_getevents(struct thread_data *td, unsigned int min,
 				  unsigned int max, const struct timespec *t)
 {
-	struct posixaio_data *pd = td->io_ops->data;
+	struct posixaio_data *pd = td->io_ops_data;
 	os_aiocb_t *suspend_list[SUSPEND_ENTRIES];
 	struct timespec start;
 	int have_timeout = 0;
@@ -161,7 +161,7 @@ restart:
 
 static struct io_u *fio_posixaio_event(struct thread_data *td, int event)
 {
-	struct posixaio_data *pd = td->io_ops->data;
+	struct posixaio_data *pd = td->io_ops_data;
 
 	return pd->aio_events[event];
 }
@@ -169,7 +169,7 @@ static struct io_u *fio_posixaio_event(struct thread_data *td, int event)
 static int fio_posixaio_queue(struct thread_data *td,
 			      struct io_u *io_u)
 {
-	struct posixaio_data *pd = td->io_ops->data;
+	struct posixaio_data *pd = td->io_ops_data;
 	os_aiocb_t *aiocb = &io_u->aiocb;
 	int ret;
 
@@ -220,7 +220,7 @@ static int fio_posixaio_queue(struct thread_data *td,
 
 static void fio_posixaio_cleanup(struct thread_data *td)
 {
-	struct posixaio_data *pd = td->io_ops->data;
+	struct posixaio_data *pd = td->io_ops_data;
 
 	if (pd) {
 		free(pd->aio_events);
@@ -236,7 +236,7 @@ static int fio_posixaio_init(struct thread_data *td)
 	pd->aio_events = malloc(td->o.iodepth * sizeof(struct io_u *));
 	memset(pd->aio_events, 0, td->o.iodepth * sizeof(struct io_u *));
 
-	td->io_ops->data = pd;
+	td->io_ops_data = pd;
 	return 0;
 }
 
diff --git a/engines/rbd.c b/engines/rbd.c
index 87ed360..7a109ee 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -91,7 +91,7 @@ static int _fio_setup_rbd_data(struct thread_data *td,
 {
 	struct rbd_data *rbd;
 
-	if (td->io_ops->data)
+	if (td->io_ops_data)
 		return 0;
 
 	rbd = calloc(1, sizeof(struct rbd_data));
@@ -110,15 +110,20 @@ static int _fio_setup_rbd_data(struct thread_data *td,
 	return 0;
 
 failed:
-	if (rbd)
+	if (rbd) {
+		if (rbd->aio_events) 
+			free(rbd->aio_events);
+		if (rbd->sort_events)
+			free(rbd->sort_events);
 		free(rbd);
+	}
 	return 1;
 
 }
 
 static int _fio_rbd_connect(struct thread_data *td)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 	struct rbd_options *o = td->eo;
 	int r;
 
@@ -226,7 +231,7 @@ static void _fio_rbd_finish_aiocb(rbd_completion_t comp, void *data)
 
 static struct io_u *fio_rbd_event(struct thread_data *td, int event)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 
 	return rbd->aio_events[event];
 }
@@ -282,7 +287,7 @@ static int rbd_io_u_cmp(const void *p1, const void *p2)
 static int rbd_iter_events(struct thread_data *td, unsigned int *events,
 			   unsigned int min_evts, int wait)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 	unsigned int this_events = 0;
 	struct io_u *io_u;
 	int i, sidx;
@@ -361,7 +366,7 @@ static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
 
 static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 	struct fio_rbd_iou *fri = io_u->engine_data;
 	int r = -1;
 
@@ -439,7 +444,7 @@ failed:
 
 static void fio_rbd_cleanup(struct thread_data *td)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 
 	if (rbd) {
 		_fio_rbd_disconnect(rbd);
@@ -467,7 +472,7 @@ static int fio_rbd_setup(struct thread_data *td)
 		log_err("fio_setup_rbd_data failed.\n");
 		goto cleanup;
 	}
-	td->io_ops->data = rbd;
+	td->io_ops_data = rbd;
 
 	/* librbd does not allow us to run first in the main thread and later
 	 * in a fork child. It needs to be the same process context all the
@@ -526,7 +531,7 @@ static int fio_rbd_open(struct thread_data *td, struct fio_file *f)
 static int fio_rbd_invalidate(struct thread_data *td, struct fio_file *f)
 {
 #if defined(CONFIG_RBD_INVAL)
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 
 	return rbd_invalidate_cache(rbd->image);
 #else
diff --git a/engines/rdma.c b/engines/rdma.c
index 7fbfad9..fbe8434 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -191,7 +191,7 @@ struct rdmaio_data {
 
 static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	unsigned int max_bs;
 
 	if (wc->byte_len != sizeof(rd->recv_buf)) {
@@ -232,7 +232,7 @@ static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 
 static int server_recv(struct thread_data *td, struct ibv_wc *wc)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	unsigned int max_bs;
 
 	if (wc->wr_id == FIO_RDMA_MAX_IO_DEPTH) {
@@ -257,7 +257,7 @@ static int server_recv(struct thread_data *td, struct ibv_wc *wc)
 
 static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_wc wc;
 	struct rdma_io_u_data *r_io_u_d;
 	int ret;
@@ -368,7 +368,7 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
  */
 static int rdma_poll_wait(struct thread_data *td, enum ibv_wc_opcode opcode)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_cq *ev_cq;
 	void *ev_ctx;
 	int ret;
@@ -405,7 +405,7 @@ again:
 
 static int fio_rdmaio_setup_qp(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_qp_init_attr init_attr;
 	int qp_depth = td->o.iodepth * 2;	/* 2 times of io depth */
 
@@ -485,7 +485,7 @@ err1:
 
 static int fio_rdmaio_setup_control_msg_buffers(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 
 	rd->recv_mr = ibv_reg_mr(rd->pd, &rd->recv_buf, sizeof(rd->recv_buf),
 				 IBV_ACCESS_LOCAL_WRITE);
@@ -529,7 +529,7 @@ static int get_next_channel_event(struct thread_data *td,
 				  struct rdma_event_channel *channel,
 				  enum rdma_cm_event_type wait_event)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdma_cm_event *event;
 	int ret;
 
@@ -561,7 +561,7 @@ static int get_next_channel_event(struct thread_data *td,
 
 static int fio_rdmaio_prep(struct thread_data *td, struct io_u *io_u)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdma_io_u_data *r_io_u_d;
 
 	r_io_u_d = io_u->engine_data;
@@ -604,7 +604,7 @@ static int fio_rdmaio_prep(struct thread_data *td, struct io_u *io_u)
 
 static struct io_u *fio_rdmaio_event(struct thread_data *td, int event)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct io_u *io_u;
 	int i;
 
@@ -622,7 +622,7 @@ static struct io_u *fio_rdmaio_event(struct thread_data *td, int event)
 static int fio_rdmaio_getevents(struct thread_data *td, unsigned int min,
 				unsigned int max, const struct timespec *t)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	enum ibv_wc_opcode comp_opcode;
 	struct ibv_cq *ev_cq;
 	void *ev_ctx;
@@ -684,7 +684,7 @@ again:
 static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 			   unsigned int nr)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_send_wr *bad_wr;
 #if 0
 	enum ibv_wc_opcode comp_opcode;
@@ -747,7 +747,7 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 static int fio_rdmaio_recv(struct thread_data *td, struct io_u **io_us,
 			   unsigned int nr)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_recv_wr *bad_wr;
 	struct rdma_io_u_data *r_io_u_d;
 	int i;
@@ -783,7 +783,7 @@ static int fio_rdmaio_recv(struct thread_data *td, struct io_u **io_us,
 
 static int fio_rdmaio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -801,7 +801,7 @@ static int fio_rdmaio_queue(struct thread_data *td, struct io_u *io_u)
 static void fio_rdmaio_queued(struct thread_data *td, struct io_u **io_us,
 			      unsigned int nr)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct timeval now;
 	unsigned int i;
 
@@ -824,7 +824,7 @@ static void fio_rdmaio_queued(struct thread_data *td, struct io_u **io_us,
 
 static int fio_rdmaio_commit(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct io_u **io_us;
 	int ret;
 
@@ -856,7 +856,7 @@ static int fio_rdmaio_commit(struct thread_data *td)
 
 static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdma_conn_param conn_param;
 	struct ibv_send_wr *bad_wr;
 
@@ -907,7 +907,7 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 
 static int fio_rdmaio_accept(struct thread_data *td, struct fio_file *f)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdma_conn_param conn_param;
 	struct ibv_send_wr *bad_wr;
 	int ret = 0;
@@ -952,7 +952,7 @@ static int fio_rdmaio_open_file(struct thread_data *td, struct fio_file *f)
 
 static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_send_wr *bad_wr;
 
 	/* unregister rdma buffer */
@@ -1008,7 +1008,7 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 				    unsigned short port)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_recv_wr *bad_wr;
 	int err;
 
@@ -1072,7 +1072,7 @@ static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 
 static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_recv_wr *bad_wr;
 	int state = td->runstate;
 
@@ -1207,7 +1207,7 @@ bad_host:
 
 static int fio_rdmaio_init(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdmaio_options *o = td->eo;
 	unsigned int max_bs;
 	int ret, i;
@@ -1316,7 +1316,7 @@ static int fio_rdmaio_init(struct thread_data *td)
 
 static void fio_rdmaio_cleanup(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 
 	if (rd)
 		free(rd);
@@ -1332,12 +1332,12 @@ static int fio_rdmaio_setup(struct thread_data *td)
 		td->o.open_files++;
 	}
 
-	if (!td->io_ops->data) {
+	if (!td->io_ops_data) {
 		rd = malloc(sizeof(*rd));
 
 		memset(rd, 0, sizeof(*rd));
 		init_rand_seed(&rd->rand_state, (unsigned int) GOLDEN_RATIO_PRIME, 0);
-		td->io_ops->data = rd;
+		td->io_ops_data = rd;
 	}
 
 	return 0;
diff --git a/engines/sg.c b/engines/sg.c
index 360775f..c1fe602 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -102,7 +102,7 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 			      unsigned int max,
 			      const struct timespec fio_unused *t)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	int left = max, eventNum, ret, r = 0;
 	void *buf = sd->sgbuf;
 	unsigned int i, events;
@@ -207,7 +207,7 @@ re_read:
 static int fio_sgio_ioctl_doio(struct thread_data *td,
 			       struct fio_file *f, struct io_u *io_u)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	struct sg_io_hdr *hdr = &io_u->hdr;
 	int ret;
 
@@ -268,7 +268,7 @@ static int fio_sgio_doio(struct thread_data *td, struct io_u *io_u, int do_sync)
 static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	long long nr_blocks, lba;
 
 	if (io_u->xfer_buflen & (sd->bs - 1)) {
@@ -366,7 +366,7 @@ static int fio_sgio_queue(struct thread_data *td, struct io_u *io_u)
 
 static struct io_u *fio_sgio_event(struct thread_data *td, int event)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 
 	return sd->events[event];
 }
@@ -463,7 +463,7 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 
 static void fio_sgio_cleanup(struct thread_data *td)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 
 	if (sd) {
 		free(sd->events);
@@ -492,7 +492,7 @@ static int fio_sgio_init(struct thread_data *td)
 	sd->sgbuf = malloc(sizeof(struct sg_io_hdr) * td->o.iodepth);
 	memset(sd->sgbuf, 0, sizeof(struct sg_io_hdr) * td->o.iodepth);
 	sd->type_checked = 0;
-	td->io_ops->data = sd;
+	td->io_ops_data = sd;
 
 	/*
 	 * we want to do it, regardless of whether odirect is set or not
@@ -503,7 +503,7 @@ static int fio_sgio_init(struct thread_data *td)
 
 static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	unsigned int bs = 0;
 	unsigned long long max_lba = 0;
 
@@ -552,7 +552,7 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 
 static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	int ret;
 
 	ret = generic_open_file(td, f);
diff --git a/engines/solarisaio.c b/engines/solarisaio.c
index 55a0cb9..151f31d 100644
--- a/engines/solarisaio.c
+++ b/engines/solarisaio.c
@@ -28,7 +28,7 @@ static int fio_solarisaio_cancel(struct thread_data fio_unused *td,
 static int fio_solarisaio_prep(struct thread_data fio_unused *td,
 			    struct io_u *io_u)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 
 	io_u->resultp.aio_return = AIO_INPROGRESS;
 	io_u->engine_data = sd;
@@ -75,7 +75,7 @@ static void wait_for_event(struct timeval *tv)
 static int fio_solarisaio_getevents(struct thread_data *td, unsigned int min,
 				    unsigned int max, const struct timespec *t)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 	struct timeval tv;
 	int ret;
 
@@ -100,7 +100,7 @@ static int fio_solarisaio_getevents(struct thread_data *td, unsigned int min,
 
 static struct io_u *fio_solarisaio_event(struct thread_data *td, int event)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 
 	return sd->aio_events[event];
 }
@@ -108,7 +108,7 @@ static struct io_u *fio_solarisaio_event(struct thread_data *td, int event)
 static int fio_solarisaio_queue(struct thread_data fio_unused *td,
 			      struct io_u *io_u)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 	struct fio_file *f = io_u->file;
 	off_t off;
 	int ret;
@@ -155,7 +155,7 @@ static int fio_solarisaio_queue(struct thread_data fio_unused *td,
 
 static void fio_solarisaio_cleanup(struct thread_data *td)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 
 	if (sd) {
 		free(sd->aio_events);
@@ -204,7 +204,7 @@ static int fio_solarisaio_init(struct thread_data *td)
 	fio_solarisaio_init_sigio();
 #endif
 
-	td->io_ops->data = sd;
+	td->io_ops_data = sd;
 	return 0;
 }
 
diff --git a/engines/splice.c b/engines/splice.c
index f35ae17..eba093e 100644
--- a/engines/splice.c
+++ b/engines/splice.c
@@ -28,7 +28,7 @@ struct spliceio_data {
  */
 static int fio_splice_read_old(struct thread_data *td, struct io_u *io_u)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 	struct fio_file *f = io_u->file;
 	int ret, ret2, buflen;
 	off_t offset;
@@ -72,7 +72,7 @@ static int fio_splice_read_old(struct thread_data *td, struct io_u *io_u)
  */
 static int fio_splice_read(struct thread_data *td, struct io_u *io_u)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 	struct fio_file *f = io_u->file;
 	struct iovec iov;
 	int ret , buflen, mmap_len;
@@ -166,7 +166,7 @@ static int fio_splice_read(struct thread_data *td, struct io_u *io_u)
  */
 static int fio_splice_write(struct thread_data *td, struct io_u *io_u)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 	struct iovec iov = {
 		.iov_base = io_u->xfer_buf,
 		.iov_len = io_u->xfer_buflen,
@@ -201,7 +201,7 @@ static int fio_splice_write(struct thread_data *td, struct io_u *io_u)
 
 static int fio_spliceio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 	int ret = 0;
 
 	fio_ro_check(td, io_u);
@@ -247,7 +247,7 @@ static int fio_spliceio_queue(struct thread_data *td, struct io_u *io_u)
 
 static void fio_spliceio_cleanup(struct thread_data *td)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 
 	if (sd) {
 		close(sd->pipe[0]);
@@ -284,7 +284,7 @@ static int fio_spliceio_init(struct thread_data *td)
 	if (td_read(td))
 		td->o.mem_align = 1;
 
-	td->io_ops->data = sd;
+	td->io_ops_data = sd;
 	return 0;
 }
 
diff --git a/engines/sync.c b/engines/sync.c
index 433e4fa..1726b8e 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -97,7 +97,7 @@ static int fio_io_end(struct thread_data *td, struct io_u *io_u, int ret)
 #ifdef CONFIG_PWRITEV
 static int fio_pvsyncio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	struct iovec *iov = &sd->iovecs[0];
 	struct fio_file *f = io_u->file;
 	int ret;
@@ -124,7 +124,7 @@ static int fio_pvsyncio_queue(struct thread_data *td, struct io_u *io_u)
 #ifdef FIO_HAVE_PWRITEV2
 static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	struct psyncv2_options *o = td->eo;
 	struct iovec *iov = &sd->iovecs[0];
 	struct fio_file *f = io_u->file;
@@ -197,7 +197,7 @@ static int fio_vsyncio_getevents(struct thread_data *td, unsigned int min,
 				 unsigned int max,
 				 const struct timespec fio_unused *t)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	int ret;
 
 	if (min) {
@@ -212,14 +212,14 @@ static int fio_vsyncio_getevents(struct thread_data *td, unsigned int min,
 
 static struct io_u *fio_vsyncio_event(struct thread_data *td, int event)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 
 	return sd->io_us[event];
 }
 
 static int fio_vsyncio_append(struct thread_data *td, struct io_u *io_u)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 
 	if (ddir_sync(io_u->ddir))
 		return 0;
@@ -246,7 +246,7 @@ static void fio_vsyncio_set_iov(struct syncio_data *sd, struct io_u *io_u,
 
 static int fio_vsyncio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -286,7 +286,7 @@ static int fio_vsyncio_queue(struct thread_data *td, struct io_u *io_u)
  */
 static int fio_vsyncio_end(struct thread_data *td, ssize_t bytes)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	struct io_u *io_u;
 	unsigned int i;
 	int err;
@@ -326,7 +326,7 @@ static int fio_vsyncio_end(struct thread_data *td, ssize_t bytes)
 
 static int fio_vsyncio_commit(struct thread_data *td)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	struct fio_file *f;
 	ssize_t ret;
 
@@ -364,13 +364,13 @@ static int fio_vsyncio_init(struct thread_data *td)
 	sd->iovecs = malloc(td->o.iodepth * sizeof(struct iovec));
 	sd->io_us = malloc(td->o.iodepth * sizeof(struct io_u *));
 
-	td->io_ops->data = sd;
+	td->io_ops_data = sd;
 	return 0;
 }
 
 static void fio_vsyncio_cleanup(struct thread_data *td)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 
 	if (sd) {
 		free(sd->iovecs);
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index cbbed6a..0e164b6 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -84,7 +84,7 @@ static int fio_windowsaio_init(struct thread_data *td)
 		}
 	}
 
-	td->io_ops->data = wd;
+	td->io_ops_data = wd;
 
 	if (!rc) {
 		struct thread_ctx *ctx;
@@ -97,7 +97,7 @@ static int fio_windowsaio_init(struct thread_data *td)
 			rc = 1;
 		}
 
-		wd = td->io_ops->data;
+		wd = td->io_ops_data;
 		wd->iothread_running = TRUE;
 		wd->iocp = hFile;
 
@@ -131,7 +131,7 @@ static void fio_windowsaio_cleanup(struct thread_data *td)
 {
 	struct windowsaio_data *wd;
 
-	wd = td->io_ops->data;
+	wd = td->io_ops_data;
 
 	if (wd != NULL) {
 		wd->iothread_running = FALSE;
@@ -143,7 +143,7 @@ static void fio_windowsaio_cleanup(struct thread_data *td)
 		free(wd->aio_events);
 		free(wd);
 
-		td->io_ops->data = NULL;
+		td->io_ops_data = NULL;
 	}
 }
 
@@ -203,10 +203,10 @@ static int fio_windowsaio_open_file(struct thread_data *td, struct fio_file *f)
 
 	/* Only set up the completion port and thread if we're not just
 	 * querying the device size */
-	if (!rc && td->io_ops->data != NULL) {
+	if (!rc && td->io_ops_data != NULL) {
 		struct windowsaio_data *wd;
 
-		wd = td->io_ops->data;
+		wd = td->io_ops_data;
 
 		if (CreateIoCompletionPort(f->hFile, wd->iocp, 0, 0) == NULL) {
 			log_err("windowsaio: failed to create io completion port\n");
@@ -251,7 +251,7 @@ static BOOL timeout_expired(DWORD start_count, DWORD end_count)
 
 static struct io_u* fio_windowsaio_event(struct thread_data *td, int event)
 {
-	struct windowsaio_data *wd = td->io_ops->data;
+	struct windowsaio_data *wd = td->io_ops_data;
 	return wd->aio_events[event];
 }
 
@@ -259,7 +259,7 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 				    unsigned int max,
 				    const struct timespec *t)
 {
-	struct windowsaio_data *wd = td->io_ops->data;
+	struct windowsaio_data *wd = td->io_ops_data;
 	unsigned int dequeued = 0;
 	struct io_u *io_u;
 	int i;
diff --git a/examples/backwards-read.fio b/examples/backwards-read.fio
index ddd47e4..0fe35a2 100644
--- a/examples/backwards-read.fio
+++ b/examples/backwards-read.fio
@@ -5,3 +5,4 @@ bs=4k
 # seek -8k back for every IO
 rw=read:-8k
 filename=128m
+size=128m
diff --git a/filesetup.c b/filesetup.c
index 012773b..a48faf5 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -329,7 +329,7 @@ static int char_size(struct thread_data *td, struct fio_file *f)
 	int r;
 
 	if (td->io_ops->open_file(td, f)) {
-		log_err("fio: failed opening blockdev %s for size check\n",
+		log_err("fio: failed opening chardev %s for size check\n",
 			f->file_name);
 		return 1;
 	}
@@ -1225,10 +1225,12 @@ static void get_file_type(struct fio_file *f)
 	else
 		f->filetype = FIO_TYPE_FILE;
 
+#ifdef WIN32
 	/* \\.\ is the device namespace in Windows, where every file is
 	 * a block device */
 	if (strncmp(f->file_name, "\\\\.\\", 4) == 0)
 		f->filetype = FIO_TYPE_BD;
+#endif
 
 	if (!stat(f->file_name, &sb)) {
 		if (S_ISBLK(sb.st_mode))
diff --git a/fio.1 b/fio.1
index e89c3d1..85eb0fe 100644
--- a/fio.1
+++ b/fio.1
@@ -309,6 +309,7 @@ Trim and write mixed workload. Blocks will be trimmed first, then the same
 blocks will be written to.
 .RE
 .P
+Fio defaults to read if the option is not specified.
 For mixed I/O, the default split is 50/50. For certain types of io the result
 may still be skewed a bit, since the speed may be different. It is possible to
 specify a number of IO's to do before getting a new offset, this is done by
@@ -602,6 +603,7 @@ position the I/O location.
 .TP
 .B psync
 Basic \fBpread\fR\|(2) or \fBpwrite\fR\|(2) I/O.
+Default on all supported operating systems except for Windows.
 .TP
 .B vsync
 Basic \fBreadv\fR\|(2) or \fBwritev\fR\|(2) I/O. Will emulate queuing by
@@ -623,7 +625,7 @@ POSIX asynchronous I/O using \fBaio_read\fR\|(3) and \fBaio_write\fR\|(3).
 Solaris native asynchronous I/O.
 .TP
 .B windowsaio
-Windows native asynchronous I/O.
+Windows native asynchronous I/O. Default on Windows.
 .TP
 .B mmap
 File is memory mapped with \fBmmap\fR\|(2) and data copied using
@@ -654,7 +656,8 @@ and send/receive. This ioengine defines engine specific options.
 .TP
 .B cpuio
 Doesn't transfer any data, but burns CPU cycles according to \fBcpuload\fR and
-\fBcpuchunks\fR parameters.
+\fBcpuchunks\fR parameters. A job never finishes unless there is at least one
+non-cpuio job.
 .TP
 .B guasi
 The GUASI I/O engine is the Generic Userspace Asynchronous Syscall Interface
@@ -1149,7 +1152,7 @@ Allocation method for I/O unit buffer.  Allowed values are:
 .RS
 .TP
 .B malloc
-Allocate memory with \fBmalloc\fR\|(3).
+Allocate memory with \fBmalloc\fR\|(3). Default memory type.
 .TP
 .B shm
 Use shared memory buffers allocated through \fBshmget\fR\|(2).
@@ -1692,13 +1695,13 @@ Some parameters are only valid when a specific ioengine is in use. These are
 used identically to normal parameters, with the caveat that when used on the
 command line, they must come after the ioengine.
 .TP
-.BI (cpu)cpuload \fR=\fPint
+.BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles.
 .TP
-.BI (cpu)cpuchunks \fR=\fPint
+.BI (cpuio)cpuchunks \fR=\fPint
 Split the load into cycles of the given time. In microseconds.
 .TP
-.BI (cpu)exit_on_io_done \fR=\fPbool
+.BI (cpuio)exit_on_io_done \fR=\fPbool
 Detect when IO threads are done, then exit.
 .TP
 .BI (libaio)userspace_reap
diff --git a/fio.h b/fio.h
index 8a0ebe3..87a94f6 100644
--- a/fio.h
+++ b/fio.h
@@ -227,6 +227,12 @@ struct thread_data {
 	struct ioengine_ops *io_ops;
 
 	/*
+	 * IO engine private data and dlhandle.
+	 */
+	void *io_ops_data;
+	void *io_ops_dlhandle;
+
+	/*
 	 * Queue depth of io_u's that fio MIGHT do
 	 */
 	unsigned int cur_depth;
diff --git a/init.c b/init.c
index 065a71a..f81db3c 100644
--- a/init.c
+++ b/init.c
@@ -860,7 +860,7 @@ static int fixup_options(struct thread_data *td)
 		td->loops = 1;
 
 	if (td->o.block_error_hist && td->o.nr_files != 1) {
-		log_err("fio: block error histogram only available with "
+		log_err("fio: block error histogram only available "
 			"with a single file per job, but %d files "
 			"provided\n", td->o.nr_files);
 		ret = 1;
@@ -904,17 +904,22 @@ static const char *get_engine_name(const char *str)
 	return p;
 }
 
-static int exists_and_not_file(const char *filename)
+static int exists_and_not_regfile(const char *filename)
 {
 	struct stat sb;
 
 	if (lstat(filename, &sb) == -1)
 		return 0;
 
+#ifndef WIN32 /* NOT Windows */
+	if (S_ISREG(sb.st_mode))
+		return 0;
+#else
 	/* \\.\ is the device namespace in Windows, where every file
 	 * is a device node */
 	if (S_ISREG(sb.st_mode) && strncmp(filename, "\\\\.\\", 4) != 0)
 		return 0;
+#endif
 
 	return 1;
 }
@@ -1342,7 +1347,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (!o->filename && !td->files_index && !o->read_iolog_file) {
 		file_alloced = 1;
 
-		if (o->nr_files == 1 && exists_and_not_file(jobname))
+		if (o->nr_files == 1 && exists_and_not_regfile(jobname))
 			add_file(td, jobname, job_add_num, 0);
 		else {
 			for (i = 0; i < o->nr_files; i++)
diff --git a/ioengine.h b/ioengine.h
index 161acf5..0effade 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -163,8 +163,6 @@ struct ioengine_ops {
 	void (*io_u_free)(struct thread_data *, struct io_u *);
 	int option_struct_size;
 	struct fio_option *options;
-	void *data;
-	void *dlhandle;
 };
 
 enum fio_ioengine_flags {
diff --git a/ioengines.c b/ioengines.c
index e2e7280..918b50a 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -119,13 +119,13 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 		return NULL;
 	}
 
-	ops->dlhandle = dlhandle;
+	td->io_ops_dlhandle = dlhandle;
 	return ops;
 }
 
 struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
 {
-	struct ioengine_ops *ops, *ret;
+	struct ioengine_ops *ops;
 	char engine[16];
 
 	dprint(FD_IO, "load ioengine %s\n", name);
@@ -153,11 +153,7 @@ struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
 	if (check_engine_ops(ops))
 		return NULL;
 
-	ret = malloc(sizeof(*ret));
-	memcpy(ret, ops, sizeof(*ret));
-	ret->data = NULL;
-
-	return ret;
+	return ops;
 }
 
 /*
@@ -173,10 +169,9 @@ void free_ioengine(struct thread_data *td)
 		td->eo = NULL;
 	}
 
-	if (td->io_ops->dlhandle)
-		dlclose(td->io_ops->dlhandle);
+	if (td->io_ops_dlhandle)
+		dlclose(td->io_ops_dlhandle);
 
-	free(td->io_ops);
 	td->io_ops = NULL;
 }
 
@@ -186,7 +181,7 @@ void close_ioengine(struct thread_data *td)
 
 	if (td->io_ops->cleanup) {
 		td->io_ops->cleanup(td);
-		td->io_ops->data = NULL;
+		td->io_ops_data = NULL;
 	}
 
 	free_ioengine(td);
diff --git a/libfio.c b/libfio.c
index 55762d7..fb7d35a 100644
--- a/libfio.c
+++ b/libfio.c
@@ -47,6 +47,7 @@ unsigned long arch_flags = 0;
 uintptr_t page_mask = 0;
 uintptr_t page_size = 0;
 
+/* see os/os.h */
 static const char *fio_os_strings[os_nr] = {
 	"Invalid",
 	"Linux",
@@ -62,6 +63,7 @@ static const char *fio_os_strings[os_nr] = {
 	"DragonFly",
 };
 
+/* see arch/arch.h */
 static const char *fio_arch_strings[arch_nr] = {
 	"Invalid",
 	"x86-64",
@@ -75,6 +77,8 @@ static const char *fio_arch_strings[arch_nr] = {
 	"arm",
 	"sh",
 	"hppa",
+	"mips",
+	"aarch64",
 	"generic"
 };
 
@@ -274,14 +278,18 @@ int fio_running_or_pending_io_threads(void)
 {
 	struct thread_data *td;
 	int i;
+	int nr_io_threads = 0;
 
 	for_each_td(td, i) {
 		if (td->flags & TD_F_NOIO)
 			continue;
+		nr_io_threads++;
 		if (td->runstate < TD_EXITED)
 			return 1;
 	}
 
+	if (!nr_io_threads)
+		return -1; /* we only had cpuio threads to begin with */
 	return 0;
 }
 
diff --git a/options.c b/options.c
index 4461643..4c56dbe 100644
--- a/options.c
+++ b/options.c
@@ -258,7 +258,7 @@ static int str2error(char *str)
 			    "EINVAL", "ENFILE", "EMFILE", "ENOTTY",
 			    "ETXTBSY","EFBIG", "ENOSPC", "ESPIPE",
 			    "EROFS","EMLINK", "EPIPE", "EDOM", "ERANGE" };
-	int i = 0, num = sizeof(err) / sizeof(void *);
+	int i = 0, num = sizeof(err) / sizeof(char *);
 
 	while (i < num) {
 		if (!strcmp(err[i], str))
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 187330b..c799817 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -70,8 +70,7 @@ typedef cpumask_t os_cpu_mask_t;
 
 /*
  * Define USCHED_GET_CPUMASK as the macro didn't exist until release 4.5.
- * usched_set(2) returns EINVAL if the kernel doesn't support it, though
- * fio_getaffinity() returns void.
+ * usched_set(2) returns EINVAL if the kernel doesn't support it.
  *
  * Also note usched_set(2) works only for the current thread regardless of
  * the command type. It doesn't work against another thread regardless of
@@ -82,6 +81,9 @@ typedef cpumask_t os_cpu_mask_t;
 #define USCHED_GET_CPUMASK	5
 #endif
 
+/* No CPU_COUNT(), but use the default function defined in os/os.h */
+#define fio_cpu_count(mask)             CPU_COUNT((mask))
+
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
 	CPUMASK_ASSZERO(*mask);
@@ -111,17 +113,6 @@ static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
 	return 0;
 }
 
-static inline int fio_cpu_count(os_cpu_mask_t *mask)
-{
-	int i, n = 0;
-
-	for (i = 0; i < FIO_MAX_CPUS; i++)
-		if (CPUMASK_TESTBIT(*mask, i))
-			n++;
-
-	return n;
-}
-
 static inline int fio_setaffinity(int pid, os_cpu_mask_t mask)
 {
 	int i, firstcall = 1;
@@ -145,12 +136,15 @@ static inline int fio_setaffinity(int pid, os_cpu_mask_t mask)
 	return 0;
 }
 
-static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
+static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 {
 	/* 0 for the current thread, see BUGS in usched_set(2) */
 	pid = 0;
 
-	usched_set(pid, USCHED_GET_CPUMASK, mask, sizeof(*mask));
+	if (usched_set(pid, USCHED_GET_CPUMASK, mask, sizeof(*mask)))
+		return -1;
+
+	return 0;
 }
 
 /* fio code is Linux based, so rename macros to Linux style */
diff --git a/os/os-linux-syscall.h b/os/os-linux-syscall.h
index 2de02f1..c399b2f 100644
--- a/os/os-linux-syscall.h
+++ b/os/os-linux-syscall.h
@@ -3,7 +3,7 @@
 
 #include "../arch/arch.h"
 
-/* Linux syscalls for i386 */
+/* Linux syscalls for x86 */
 #if defined(ARCH_X86_H)
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		289
diff --git a/os/os-windows.h b/os/os-windows.h
index d049531..616ad43 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -193,7 +193,7 @@ static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
 	return (bSuccess)? 0 : -1;
 }
 
-static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
+static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 {
 	os_cpu_mask_t systemMask;
 
@@ -204,7 +204,10 @@ static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
 		CloseHandle(h);
 	} else {
 		log_err("fio_getaffinity failed: failed to get handle for pid %d\n", pid);
+		return -1;
 	}
+
+	return 0;
 }
 
 static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
diff --git a/os/os.h b/os/os.h
index 9877383..4f267c2 100644
--- a/os/os.h
+++ b/os/os.h
@@ -84,7 +84,6 @@ typedef struct aiocb os_aiocb_t;
 #endif
 
 #ifndef FIO_HAVE_CPU_AFFINITY
-#define fio_getaffinity(pid, mask)	do { } while (0)
 #define fio_cpu_clear(mask, cpu)	do { } while (0)
 typedef unsigned long os_cpu_mask_t;
 
@@ -93,6 +92,11 @@ static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
 	return 0;
 }
 
+static inline int fio_getaffinity(int pid, os_cpu_mask_t *cpumask)
+{
+	return -1;
+}
+
 static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
 {
 	return -1;
diff --git a/parse.c b/parse.c
index bb16bc1..086f786 100644
--- a/parse.c
+++ b/parse.c
@@ -109,6 +109,7 @@ static void show_option_help(struct fio_option *o, int is_err)
 		"list of floating point values separated by ':' (opt=5.9:7.8)",
 		"no argument (opt)",
 		"deprecated",
+		"unsupported",
 	};
 	size_t (*logger)(const char *format, ...);
 
