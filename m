Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaIQMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Sep 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XUDu1-0004MT-43
	for fio@vger.kernel.org; Wed, 17 Sep 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140917120003.691B9401E5@lyth.info>
Date: Wed, 17 Sep 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b7c88f86c9a5a92883effc1f119f6c7b36d087e0:

  options: fix single use if / for bssplit (2014-09-15 18:51:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 65ff9cd5fd5859b1547a9f7e1b2c97c6b9352f4d:

  btrace2fio: move file tracking to btrace_pid (2014-09-16 20:17:55 -0600)

----------------------------------------------------------------
Jens Axboe (7):
      Add basic tool to turn blktrace into fio job file
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      btrace2fio: set runtime
      btrace2fio: use percentage_random and add filename option
      btrace2fio: cleanups and inflight hashing
      Fixup data-direction to name translation
      btrace2fio: move file tracking to btrace_pid

Robert Elliott (1):
      fio: print io_u errors on one line

 Makefile               |   18 +-
 blktrace.c             |   71 +---
 io_ddir.h              |   12 +
 io_u.c                 |   17 +-
 iolog.c                |    9 +-
 lib/linux-dev-lookup.c |   66 ++++
 lib/linux-dev-lookup.h |    7 +
 t/btrace2fio.c         |  835 ++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 953 insertions(+), 82 deletions(-)
 create mode 100644 lib/linux-dev-lookup.c
 create mode 100644 lib/linux-dev-lookup.h
 create mode 100644 t/btrace2fio.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 8d86269..4350e5a 100644
--- a/Makefile
+++ b/Makefile
@@ -110,12 +110,13 @@ endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
-		engines/binject.c
+		engines/binject.c lib/linux-dev-lookup.c
   LIBS += -lpthread -ldl
   LDFLAGS += -rdynamic
 endif
 ifeq ($(CONFIG_TARGET_OS), Android)
-  SOURCE += diskutil.c fifo.c blktrace.c trim.c profiles/tiobench.c
+  SOURCE += diskutil.c fifo.c blktrace.c trim.c profiles/tiobench.c \
+		lib/linux-dev-lookup.c
   LIBS += -ldl
   LDFLAGS += -rdynamic
 endif
@@ -182,17 +183,25 @@ T_LFSR_TEST_OBJS = t/lfsr-test.o
 T_LFSR_TEST_OBJS += lib/lfsr.o
 T_LFSR_TEST_PROGS = t/lfsr-test
 
+ifeq ($(CONFIG_TARGET_OS), Linux)
+T_BTRACE_FIO_OBJS = t/btrace2fio.o
+T_BTRACE_FIO_OBJS += fifo.o lib/flist_sort.o t/log.o lib/linux-dev-lookup.o
+T_BTRACE_FIO_PROGS = t/btrace2fio
+endif
+
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
 T_OBJS += $(T_ZIPF_OBJS)
 T_OBJS += $(T_AXMAP_OBJS)
 T_OBJS += $(T_LFSR_TEST_OBJS)
+T_OBJS += $(T_BTRACE_FIO_OBJS)
 
 T_PROGS = $(T_SMALLOC_PROGS)
 T_PROGS += $(T_IEEE_PROGS)
 T_PROGS += $(T_ZIPF_PROGS)
 T_PROGS += $(T_AXMAP_PROGS)
 T_PROGS += $(T_LFSR_TEST_PROGS)
+T_PROGS += $(T_BTRACE_FIO_PROGS)
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
@@ -289,6 +298,11 @@ t/axmap: $(T_AXMAP_OBJS)
 t/lfsr-test: $(T_LFSR_TEST_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS)
 
+ifeq ($(CONFIG_TARGET_OS), Linux)
+t/btrace2fio: $(T_BTRACE_FIO_OBJS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_BTRACE_FIO_OBJS) $(LIBS)
+endif
+
 clean: FORCE
 	-rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h
 
diff --git a/blktrace.c b/blktrace.c
index 3c23b97..8d288b0 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -9,6 +9,7 @@
 #include "flist.h"
 #include "fio.h"
 #include "blktrace_api.h"
+#include "lib/linux-dev-lookup.h"
 
 #define TRACE_FIFO_SIZE	8192
 
@@ -108,67 +109,6 @@ int is_blktrace(const char *filename, int *need_swap)
 	return 0;
 }
 
-static int lookup_device(struct thread_data *td, char *path, unsigned int maj,
-			 unsigned int min)
-{
-	struct dirent *dir;
-	struct stat st;
-	int found = 0;
-	DIR *D;
-
-	D = opendir(path);
-	if (!D)
-		return 0;
-
-	while ((dir = readdir(D)) != NULL) {
-		char full_path[256];
-
-		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
-			continue;
-
-		sprintf(full_path, "%s%s%s", path, FIO_OS_PATH_SEPARATOR, dir->d_name);
-		if (lstat(full_path, &st) == -1) {
-			perror("lstat");
-			break;
-		}
-
-		if (S_ISDIR(st.st_mode)) {
-			found = lookup_device(td, full_path, maj, min);
-			if (found) {
-				strcpy(path, full_path);
-				break;
-			}
-		}
-
-		if (!S_ISBLK(st.st_mode))
-			continue;
-
-		/*
-		 * If replay_redirect is set then always return this device
-		 * upon lookup which overrides the device lookup based on
-		 * major minor in the actual blktrace
-		 */
-		if (td->o.replay_redirect) {
-			dprint(FD_BLKTRACE, "device lookup: %d/%d\n overridden"
-					" with: %s\n", maj, min,
-					td->o.replay_redirect);
-			strcpy(path, td->o.replay_redirect);
-			found = 1;
-			break;
-		}
-
-		if (maj == major(st.st_rdev) && min == minor(st.st_rdev)) {
-			dprint(FD_BLKTRACE, "device lookup: %d/%d\n", maj, min);
-			strcpy(path, full_path);
-			found = 1;
-			break;
-		}
-	}
-
-	closedir(D);
-	return found;
-}
-
 #define FMINORBITS	20
 #define FMINORMASK	((1U << FMINORBITS) - 1)
 #define FMAJOR(dev)	((unsigned int) ((dev) >> FMINORBITS))
@@ -212,9 +152,16 @@ static int trace_add_file(struct thread_data *td, __u32 device)
 		}
 
 	strcpy(dev, "/dev");
-	if (lookup_device(td, dev, maj, min)) {
+	if (blktrace_lookup_device(td->o.replay_redirect, dev, maj, min)) {
 		int fileno;
 
+		if (td->o.replay_redirect)
+			dprint(FD_BLKTRACE, "device lookup: %d/%d\n overridden"
+					" with: %s\n", maj, min,
+					td->o.replay_redirect);
+		else
+			dprint(FD_BLKTRACE, "device lookup: %d/%d\n", maj, min);
+
 		dprint(FD_BLKTRACE, "add devices %s\n", dev);
 		fileno = add_file_exclusive(td, dev);
 		td->o.open_files++;
diff --git a/io_ddir.h b/io_ddir.h
index eb25c50..a23ea62 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -10,9 +10,21 @@ enum fio_ddir {
 	DDIR_DATASYNC,
 	DDIR_SYNC_FILE_RANGE,
 	DDIR_WAIT,
+	DDIR_LAST,
 	DDIR_INVAL = -1,
 };
 
+static inline const char *io_ddir_name(enum fio_ddir ddir)
+{
+	const char *name[] = { "read", "write", "trim", "sync", "datasync",
+				"sync_file_range", "write", };
+
+	if (ddir < DDIR_LAST)
+		return name[ddir];
+
+	return "invalid";
+}
+
 enum td_ddir {
 	TD_DDIR_READ		= 1 << 0,
 	TD_DDIR_WRITE		= 1 << 1,
diff --git a/io_u.c b/io_u.c
index be2f242..7cbdb91 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1528,21 +1528,16 @@ err_put:
 void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 {
 	enum error_type_bit eb = td_error_type(io_u->ddir, io_u->error);
-	const char *msg[] = { "read", "write", "sync", "datasync",
-				"sync_file_range", "wait", "trim" };
 
 	if (td_non_fatal_error(td, eb, io_u->error) && !td->o.error_dump)
 		return;
 
-	log_err("fio: io_u error");
-
-	if (io_u->file)
-		log_err(" on file %s", io_u->file->file_name);
-
-	log_err(": %s\n", strerror(io_u->error));
-
-	log_err("     %s offset=%llu, buflen=%lu\n", msg[io_u->ddir],
-					io_u->offset, io_u->xfer_buflen);
+	log_err("fio: io_u error%s%s: %s: %s offset=%llu, buflen=%lu\n",
+		io_u->file ? " on file " : "",
+		io_u->file ? io_u->file->file_name : "",
+		strerror(io_u->error),
+		io_ddir_name(io_u->ddir),
+		io_u->offset, io_u->xfer_buflen);
 
 	if (!td->error)
 		td_verror(td, io_u->error, "io_u error");
diff --git a/iolog.c b/iolog.c
index f9e835d..ef8b841 100644
--- a/iolog.c
+++ b/iolog.c
@@ -30,17 +30,12 @@ void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
 
 void log_io_u(struct thread_data *td, struct io_u *io_u)
 {
-	const char *act[] = { "read", "write", "sync", "datasync",
-				"sync_file_range", "wait", "trim" };
-
-	assert(io_u->ddir <= 6);
-
 	if (!td->o.write_iolog_file)
 		return;
 
 	fprintf(td->iolog_f, "%s %s %llu %lu\n", io_u->file->file_name,
-						act[io_u->ddir], io_u->offset,
-						io_u->buflen);
+						io_ddir_name(io_u->ddir),
+						io_u->offset, io_u->buflen);
 }
 
 void log_file(struct thread_data *td, struct fio_file *f,
diff --git a/lib/linux-dev-lookup.c b/lib/linux-dev-lookup.c
new file mode 100644
index 0000000..4d5f356
--- /dev/null
+++ b/lib/linux-dev-lookup.c
@@ -0,0 +1,66 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <dirent.h>
+#include <string.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include "../os/os.h"
+
+int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
+			   unsigned int min)
+{
+	struct dirent *dir;
+	struct stat st;
+	int found = 0;
+	DIR *D;
+
+	D = opendir(path);
+	if (!D)
+		return 0;
+
+	while ((dir = readdir(D)) != NULL) {
+		char full_path[256];
+
+		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
+			continue;
+
+		sprintf(full_path, "%s%s%s", path, FIO_OS_PATH_SEPARATOR, dir->d_name);
+		if (lstat(full_path, &st) == -1) {
+			perror("lstat");
+			break;
+		}
+
+		if (S_ISDIR(st.st_mode)) {
+			found = blktrace_lookup_device(redirect, full_path,
+								maj, min);
+			if (found) {
+				strcpy(path, full_path);
+				break;
+			}
+		}
+
+		if (!S_ISBLK(st.st_mode))
+			continue;
+
+		/*
+		 * If replay_redirect is set then always return this device
+		 * upon lookup which overrides the device lookup based on
+		 * major minor in the actual blktrace
+		 */
+		if (redirect) {
+			strcpy(path, redirect);
+			found = 1;
+			break;
+		}
+
+		if (maj == major(st.st_rdev) && min == minor(st.st_rdev)) {
+			strcpy(path, full_path);
+			found = 1;
+			break;
+		}
+	}
+
+	closedir(D);
+	return found;
+}
diff --git a/lib/linux-dev-lookup.h b/lib/linux-dev-lookup.h
new file mode 100644
index 0000000..144f33a
--- /dev/null
+++ b/lib/linux-dev-lookup.h
@@ -0,0 +1,7 @@
+#ifndef LINUX_DEV_LOOKUP
+#define LINUX_DEV_LOOKUP
+
+int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
+			   unsigned int min);
+
+#endif
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
new file mode 100644
index 0000000..bda3c0b
--- /dev/null
+++ b/t/btrace2fio.c
@@ -0,0 +1,835 @@
+#include <stdio.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <inttypes.h>
+#include <assert.h>
+
+#include "../io_ddir.h"
+#include "../flist.h"
+#include "../hash.h"
+#include "../fifo.h"
+#include "../blktrace_api.h"
+#include "../os/os.h"
+#include "../log.h"
+#include "../lib/linux-dev-lookup.h"
+
+#define TRACE_FIFO_SIZE	8192
+
+static unsigned int rt_threshold = 1000000;
+static unsigned int ios_threshold = 10;
+static int output_ascii = 1;
+static char *filename;
+
+struct bs {
+	unsigned int bs;
+	unsigned int nr;
+	int merges;
+};
+
+struct trace_file {
+	char *name;
+	int major, minor;
+};
+
+struct btrace_out {
+	unsigned long ios[DDIR_RWDIR_CNT];
+	unsigned long rw_bs[DDIR_RWDIR_CNT];
+	unsigned long merges[DDIR_RWDIR_CNT];
+
+	uint64_t last_end[DDIR_RWDIR_CNT];
+	uint64_t seq[DDIR_RWDIR_CNT];
+
+	struct bs *bs[DDIR_RWDIR_CNT];
+	unsigned int nr_bs[DDIR_RWDIR_CNT];
+
+	int inflight;
+	unsigned int depth;
+	uint64_t first_ttime;
+	uint64_t last_ttime;
+
+	uint64_t start_delay;
+};
+
+struct btrace_pid {
+	struct flist_head hash_list;
+	struct flist_head pid_list;
+	pid_t pid;
+
+	struct trace_file *files;
+	int nr_files;
+	unsigned int last_major, last_minor;
+
+	struct btrace_out o;
+};
+
+struct inflight {
+	struct flist_head list;
+	struct btrace_pid *p;
+	uint64_t end_sector;
+};
+
+#define PID_HASH_BITS	10
+#define PID_HASH_SIZE	(1U << PID_HASH_BITS)
+
+static struct flist_head pid_hash[PID_HASH_SIZE];
+static FLIST_HEAD(pid_list);
+
+#define INFLIGHT_HASH_BITS	8
+#define INFLIGHT_HASH_SIZE	(1U << INFLIGHT_HASH_BITS)
+static struct flist_head inflight_hash[INFLIGHT_HASH_SIZE];
+
+static uint64_t first_ttime = -1ULL;
+
+static struct inflight *inflight_find(uint64_t sector)
+{
+	struct flist_head *inflight_list;
+	struct flist_head *e;
+
+	inflight_list = &inflight_hash[hash_long(sector, INFLIGHT_HASH_BITS)];
+
+	flist_for_each(e, inflight_list) {
+		struct inflight *i = flist_entry(e, struct inflight, list);
+
+		if (i->end_sector == sector)
+			return i;
+	}
+
+	return NULL;
+}
+
+static void inflight_remove(struct inflight *i)
+{
+	struct btrace_out *o = &i->p->o;
+
+	o->inflight--;
+	assert(o->inflight >= 0);
+	flist_del(&i->list);
+	free(i);
+}
+
+static void __inflight_add(struct inflight *i)
+{
+	struct flist_head *list;
+
+	list = &inflight_hash[hash_long(i->end_sector, INFLIGHT_HASH_BITS)];
+	flist_add_tail(&i->list, list);
+}
+
+static void inflight_add(struct btrace_pid *p, uint64_t sector, uint32_t len)
+{
+	struct btrace_out *o = &p->o;
+	struct inflight *i;
+
+	i = calloc(1, sizeof(*i));
+	i->p = p;
+	o->inflight++;
+	o->depth = max((int) o->depth, o->inflight);
+	i->end_sector = sector + (len >> 9);
+	__inflight_add(i);
+}
+
+static void inflight_merge(struct inflight *i, int rw, unsigned int size)
+{
+	i->p->o.merges[rw]++;
+	if (size) {
+		i->end_sector += (size >> 9);
+		flist_del(&i->list);
+		__inflight_add(i);
+	}
+}
+
+/*
+ * fifo refill frontend, to avoid reading data in trace sized bites
+ */
+static int refill_fifo(struct fifo *fifo, int fd)
+{
+	char buf[TRACE_FIFO_SIZE];
+	unsigned int total;
+	int ret;
+
+	total = sizeof(buf);
+	if (total > fifo_room(fifo))
+		total = fifo_room(fifo);
+
+	ret = read(fd, buf, total);
+	if (ret < 0) {
+		perror("read refill");
+		return -1;
+	}
+
+	if (ret > 0)
+		ret = fifo_put(fifo, buf, ret);
+
+	return ret;
+}
+
+/*
+ * Retrieve 'len' bytes from the fifo, refilling if necessary.
+ */
+static int trace_fifo_get(struct fifo *fifo, int fd, void *buf,
+			  unsigned int len)
+{
+	if (fifo_len(fifo) < len) {
+		int ret = refill_fifo(fifo, fd);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	return fifo_get(fifo, buf, len);
+}
+
+/*
+ * Just discard the pdu by seeking past it.
+ */
+static int discard_pdu(struct fifo *fifo, int fd, struct blk_io_trace *t)
+{
+	if (t->pdu_len == 0)
+		return 0;
+
+	return trace_fifo_get(fifo, fd, NULL, t->pdu_len);
+}
+
+static void handle_trace_notify(struct blk_io_trace *t)
+{
+	switch (t->action) {
+	case BLK_TN_PROCESS:
+		//printf("got process notify: %x, %d\n", t->action, t->pid);
+		break;
+	case BLK_TN_TIMESTAMP:
+		//printf("got timestamp notify: %x, %d\n", t->action, t->pid);
+		break;
+	case BLK_TN_MESSAGE:
+		break;
+	default:
+		log_err("unknown trace act %x\n", t->action);
+		break;
+	}
+}
+
+static void __add_bs(struct btrace_out *o, unsigned int len, int rw)
+{
+	o->bs[rw] = realloc(o->bs[rw], (o->nr_bs[rw] + 1) * sizeof(struct bs));
+	o->bs[rw][o->nr_bs[rw]].bs = len;
+	o->bs[rw][o->nr_bs[rw]].nr = 1;
+	o->nr_bs[rw]++;
+}
+
+static void add_bs(struct btrace_out *o, unsigned int len, int rw)
+{
+	struct bs *bs = o->bs[rw];
+	int i;
+
+	if (!o->nr_bs[rw]) {
+		__add_bs(o, len, rw);
+		return;
+	}
+
+	for (i = 0; i < o->nr_bs[rw]; i++) {
+		if (bs[i].bs == len) {
+			bs[i].nr++;
+			return;
+		}
+	}
+
+	__add_bs(o, len, rw);
+}
+
+#define FMINORBITS	20
+#define FMINORMASK	((1U << FMINORBITS) - 1)
+#define FMAJOR(dev)	((unsigned int) ((dev) >> FMINORBITS))
+#define FMINOR(dev)	((unsigned int) ((dev) & FMINORMASK))
+
+static void btrace_add_file(struct btrace_pid *p, uint32_t devno)
+{
+	unsigned int maj = FMAJOR(devno);
+	unsigned int min = FMINOR(devno);
+	struct trace_file *f;
+	unsigned int i;
+	char dev[256];
+
+	if (filename)
+		return;
+	if (p->last_major == maj && p->last_minor == min)
+		return;
+
+	p->last_major = maj;
+	p->last_minor = min;
+
+	/*
+	 * check for this file in our list
+	 */
+	for (i = 0; i < p->nr_files; i++) {
+		f = &p->files[i];
+
+		if (f->major == maj && f->minor == min)
+			return;
+	}
+
+	strcpy(dev, "/dev");
+	if (!blktrace_lookup_device(NULL, dev, maj, min)) {
+		log_err("fio: failed to find device %u/%u\n", maj, min);
+		return;
+	}
+
+	p->files = realloc(p->files, (p->nr_files + 1) * sizeof(*f));
+	f = &p->files[p->nr_files];
+	f->name = strdup(dev);
+	f->major = maj;
+	f->minor = min;
+	p->nr_files++;
+}
+
+static void handle_trace_discard(struct blk_io_trace *t, struct btrace_pid *p)
+{
+	struct btrace_out *o = &p->o;
+
+	btrace_add_file(p, t->device);
+
+	if (o->first_ttime == -1ULL)
+		o->first_ttime = t->time;
+
+	o->ios[DDIR_TRIM]++;
+	add_bs(o, t->bytes, DDIR_TRIM);
+}
+
+static void handle_trace_fs(struct blk_io_trace *t, struct btrace_pid *p)
+{
+	struct btrace_out *o = &p->o;
+	int rw;
+
+	btrace_add_file(p, t->device);
+
+	first_ttime = min(first_ttime, (uint64_t) t->time);
+
+	if (o->first_ttime == -1ULL)
+		o->first_ttime = t->time;
+
+	rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
+
+	add_bs(o, t->bytes, rw);
+	o->ios[rw]++;
+
+	if (t->sector == o->last_end[rw] || o->last_end[rw] == -1ULL)
+		o->seq[rw]++;
+
+	o->last_end[rw] = t->sector + (t->bytes >> 9);
+}
+
+static void handle_queue_trace(struct blk_io_trace *t, struct btrace_pid *p)
+{
+	if (t->action & BLK_TC_ACT(BLK_TC_NOTIFY))
+		handle_trace_notify(t);
+	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
+		handle_trace_discard(t, p);
+	else
+		handle_trace_fs(t, p);
+}
+
+static void handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
+{
+	unsigned int act = t->action & 0xffff;
+
+	if (act == __BLK_TA_QUEUE) {
+		inflight_add(p, t->sector, t->bytes);
+		handle_queue_trace(t, p);
+	} else if (act == __BLK_TA_REQUEUE) {
+		p->o.inflight--;
+	} else if (act == __BLK_TA_BACKMERGE) {
+		struct inflight *i;
+
+		i = inflight_find(t->sector + (t->bytes >> 9));
+		if (i)
+			inflight_remove(i);
+
+		i = inflight_find(t->sector);
+		if (i) {
+			int rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
+
+			inflight_merge(i, rw, t->bytes);
+		}
+	} else if (act == __BLK_TA_FRONTMERGE) {
+		struct inflight *i;
+
+		i = inflight_find(t->sector + (t->bytes >> 9));
+		if (i)
+			inflight_remove(i);
+
+		i = inflight_find(t->sector);
+		if (i) {
+			int rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
+
+			inflight_merge(i, rw, 0);
+		}
+	} else if (act == __BLK_TA_COMPLETE) {
+		struct inflight *i;
+
+		i = inflight_find(t->sector + (t->bytes >> 9));
+		if (i)
+			inflight_remove(i);
+	}
+}
+
+static void byteswap_trace(struct blk_io_trace *t)
+{
+	t->magic = fio_swap32(t->magic);
+	t->sequence = fio_swap32(t->sequence);
+	t->time = fio_swap64(t->time);
+	t->sector = fio_swap64(t->sector);
+	t->bytes = fio_swap32(t->bytes);
+	t->action = fio_swap32(t->action);
+	t->pid = fio_swap32(t->pid);
+	t->device = fio_swap32(t->device);
+	t->cpu = fio_swap32(t->cpu);
+	t->error = fio_swap16(t->error);
+	t->pdu_len = fio_swap16(t->pdu_len);
+}
+
+static struct btrace_pid *pid_hash_find(pid_t pid, struct flist_head *list)
+{
+	struct flist_head *e;
+	struct btrace_pid *p;
+
+	flist_for_each(e, list) {
+		p = flist_entry(e, struct btrace_pid, hash_list);
+		if (p->pid == pid)
+			return p;
+	}
+
+	return NULL;
+}
+
+static struct btrace_pid *pid_hash_get(pid_t pid)
+{
+	struct flist_head *hash_list;
+	struct btrace_pid *p;
+
+	hash_list = &pid_hash[hash_long(pid, PID_HASH_BITS)];
+
+	p = pid_hash_find(pid, hash_list);
+	if (!p) {
+		int i;
+
+		p = calloc(1, sizeof(*p));
+		p->o.first_ttime = -1ULL;
+		p->o.last_ttime = -1ULL;
+
+		for (i = 0; i < DDIR_RWDIR_CNT; i++)
+			p->o.last_end[i] = -1ULL;
+
+		p->pid = pid;
+		flist_add_tail(&p->hash_list, hash_list);
+		flist_add_tail(&p->pid_list, &pid_list);
+	}
+
+	return p;
+}
+
+/*
+ * Load a blktrace file by reading all the blk_io_trace entries, and storing
+ * them as io_pieces like the fio text version would do.
+ */
+static int load_blktrace(const char *filename, int need_swap)
+{
+	struct btrace_pid *p;
+	unsigned long traces;
+	struct blk_io_trace t;
+	struct fifo *fifo;
+	int fd;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0) {
+		perror("open trace file\n");
+		return 1;
+	}
+
+	fifo = fifo_alloc(TRACE_FIFO_SIZE);
+
+	traces = 0;
+	do {
+		int ret = trace_fifo_get(fifo, fd, &t, sizeof(t));
+
+		if (ret < 0)
+			goto err;
+		else if (!ret)
+			break;
+		else if (ret < (int) sizeof(t)) {
+			log_err("fio: short fifo get\n");
+			break;
+		}
+
+		if (need_swap)
+			byteswap_trace(&t);
+
+		if ((t.magic & 0xffffff00) != BLK_IO_TRACE_MAGIC) {
+			log_err("fio: bad magic in blktrace data: %x\n", t.magic);
+			goto err;
+		}
+		if ((t.magic & 0xff) != BLK_IO_TRACE_VERSION) {
+			log_err("fio: bad blktrace version %d\n", t.magic & 0xff);
+			goto err;
+		}
+		ret = discard_pdu(fifo, fd, &t);
+		if (ret < 0) {
+			log_err("blktrace lseek\n");
+			goto err;
+		} else if (t.pdu_len != ret) {
+			log_err("fio: discarded %d of %d\n", ret, t.pdu_len);
+			goto err;
+		}
+
+		p = pid_hash_get(t.pid);
+		handle_trace(&t, p);
+		p->o.last_ttime = t.time;
+		traces++;
+	} while (1);
+
+	fifo_free(fifo);
+	close(fd);
+
+	if (output_ascii)
+		printf("Traces loaded: %lu\n", traces);
+
+	return 0;
+err:
+	close(fd);
+	fifo_free(fifo);
+	return 1;
+}
+
+static int bs_cmp(const void *ba, const void *bb)
+{
+	const struct bs *bsa = ba;
+	const struct bs *bsb = bb;
+
+	return bsb->nr - bsa->nr;
+}
+
+static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
+{
+	const char *msg[] = { "reads", "writes", "trims" };
+	struct btrace_out *o = &p->o;
+	unsigned long total;
+	int i, j;
+
+	printf("[pid:\t%u]\n", p->pid);
+
+	total = ddir_rw_sum(o->ios);
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		float perc;
+
+		if (!o->ios[i])
+			continue;
+
+		ios[i] += o->ios[i] + o->merges[i];
+		printf("%s\n", msg[i]);
+		perc = ((float) o->ios[i] * 100.0) / (float) total;
+		printf("\tios:    %lu (perc=%3.2f%%)\n", o->ios[i], perc);
+		perc = ((float) o->merges[i] * 100.0) / (float) total;
+		printf("\tmerges: %lu (perc=%3.2f%%)\n", o->merges[i], perc);
+		perc = ((float) o->seq[i] * 100.0) / (float) o->ios[i];
+		printf("\tseq:    %lu (perc=%3.2f%%)\n", o->seq[i], perc);
+
+		for (j = 0; j < o->nr_bs[i]; j++) {
+			struct bs *bs = &o->bs[i][j];
+
+			perc = (((float) bs->nr * 100.0) / (float) o->ios[i]);
+			printf("\tbs=%u, perc=%3.2f%%\n", bs->bs, perc);
+		}
+	}
+
+	printf("depth:\t%u\n", o->depth);
+	printf("usec:\t%llu (delay=%llu)\n", (o->last_ttime - o->first_ttime) / 1000ULL, (unsigned long long) o->start_delay);
+
+	printf("files:\t");
+	for (i = 0; i < p->nr_files; i++)
+		printf("%s,", p->files[i].name);
+	printf("\n");
+
+	printf("\n");
+}
+
+static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
+{
+	struct btrace_out *o = &p->o;
+	unsigned long total;
+	unsigned long long time;
+	float perc;
+	int i, j;
+
+	if ((o->ios[0] + o->ios[1]) && o->ios[2]) {
+		log_err("fio: trace has both read/write and trim\n");
+		return 1;
+	}
+
+	printf("[pid%u]\n", p->pid);
+	printf("direct=1\n");
+	if (o->depth == 1)
+		printf("ioengine=sync\n");
+	else
+		printf("ioengine=libaio\niodepth=%u\n", o->depth);
+
+	if (o->ios[0] && !o->ios[1])
+		printf("rw=randread\n");
+	else if (!o->ios[0] && o->ios[1])
+		printf("rw=randwrite\n");
+	else if (o->ios[2])
+		printf("rw=randtrim\n");
+	else {
+		printf("rw=randrw\n");
+		total = ddir_rw_sum(o->ios);
+		perc = ((float) o->ios[0] * 100.0) / (float) total;
+		printf("rwmixread=%u\n", (int) (perc + 0.99));
+	}
+
+	printf("percentage_random=");
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		if (o->seq[i] && o->ios[i]) {
+			perc = ((float) o->seq[i] * 100.0) / (float) o->ios[i];
+			if (perc >= 99.0)
+				perc = 100.0;
+		} else
+			perc = 100.0;
+
+		if (i)
+			printf(",");
+		perc = 100.0 - perc;
+		printf("%u", (int) perc);
+	}
+	printf("\n");
+
+	printf("filename=");
+	for (i = 0; i < p->nr_files; i++) {
+		if (i)
+			printf(":");
+		printf("%s", p->files[i].name);
+	}
+	printf("\n");
+
+	printf("startdelay=%llus\n", o->start_delay / 1000000ULL);
+
+	time = o->last_ttime - o->first_ttime;
+	time = (time + 1000000000ULL - 1) / 1000000000ULL;
+	printf("runtime=%llus\n", time);
+
+	printf("bssplit=");
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+
+		if (i && o->nr_bs[i - 1] && o->nr_bs[i])
+			printf(",");
+
+		for (j = 0; j < o->nr_bs[i]; j++) {
+			struct bs *bs = &o->bs[i][j];
+
+			perc = (((float) bs->nr * 100.0) / (float) o->ios[i]);
+			if (perc < 1.00)
+				continue;
+			if (j)
+				printf(":");
+			if (j + 1 == o->nr_bs[i])
+				printf("%u/", bs->bs);
+			else
+				printf("%u/%u", bs->bs, (int) perc);
+		}
+	}
+	printf("\n\n");
+
+	return 0;
+}
+
+static int __output_p(struct btrace_pid *p, unsigned long *ios)
+{
+	struct btrace_out *o = &p->o;
+	int i, ret = 0;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		if (o->nr_bs[i] <= 1)
+			continue;
+		qsort(o->bs[i], o->nr_bs[i], sizeof(struct bs), bs_cmp);
+	}
+
+	if (filename) {
+		p->files = malloc(sizeof(struct trace_file));
+		p->nr_files++;
+		p->files[0].name = filename;
+	}
+
+	if (output_ascii)
+		__output_p_ascii(p, ios);
+	else
+		ret = __output_p_fio(p, ios);
+
+	return ret;
+}
+
+static int prune_entry(struct btrace_out *o)
+{
+	uint64_t time;
+
+	if (ddir_rw_sum(o->ios) < ios_threshold)
+		return 1;
+
+	time = (o->last_ttime - o->first_ttime) / 1000ULL;
+	if (time < rt_threshold)
+		return 1;
+
+	return 0;
+}
+
+static int entry_cmp(void *priv, struct flist_head *a, struct flist_head *b)
+{
+	struct btrace_pid *pa = flist_entry(a, struct btrace_pid, pid_list);
+	struct btrace_pid *pb = flist_entry(b, struct btrace_pid, pid_list);
+
+	return ddir_rw_sum(pb->o.ios) - ddir_rw_sum(pa->o.ios);
+}
+
+static void free_p(struct btrace_pid *p)
+{
+	struct btrace_out *o = &p->o;
+	int i;
+
+	for (i = 0; i < p->nr_files; i++) {
+		if (p->files[i].name && p->files[i].name != filename)
+			free(p->files[i].name);
+	}
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++)
+		free(o->bs[i]);
+
+	free(p->files);
+	flist_del(&p->pid_list);
+	flist_del(&p->hash_list);
+	free(p);
+}
+
+static int output_p(void)
+{
+	unsigned long ios[DDIR_RWDIR_CNT];
+	struct flist_head *e, *tmp;
+	int ret = 0;
+
+	flist_for_each_safe(e, tmp, &pid_list) {
+		struct btrace_pid *p;
+
+		p = flist_entry(e, struct btrace_pid, pid_list);
+		if (prune_entry(&p->o)) {
+			free_p(p);
+			continue;
+		}
+		p->o.start_delay = (p->o.first_ttime / 1000ULL) - first_ttime;
+	}
+
+	memset(ios, 0, sizeof(ios));
+
+	flist_sort(NULL, &pid_list, entry_cmp);
+
+	flist_for_each(e, &pid_list) {
+		struct btrace_pid *p;
+
+		p = flist_entry(e, struct btrace_pid, pid_list);
+		ret |= __output_p(p, ios);
+	}
+
+	if (output_ascii)
+		printf("Total: reads=%lu, writes=%lu\n", ios[0], ios[1]);
+
+	return ret;
+}
+
+static int usage(char *argv[])
+{
+	log_err("%s: <blktrace bin file>\n", argv[0]);
+	log_err("\t-t\tUsec threshold to ignore task\n");
+	log_err("\t-n\tNumber IOS threshold to ignore task\n");
+	log_err("\t-f\tFio job file output\n");
+	log_err("\t-d\tUse this file/device for replay\n");
+	return 1;
+}
+
+static int trace_needs_swap(const char *trace_file, int *swap)
+{
+	struct blk_io_trace t;
+	int fd, ret;
+
+	*swap = -1;
+	
+	fd = open(trace_file, O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return 1;
+	}
+
+	ret = read(fd, &t, sizeof(t));
+	if (ret < 0) {
+		perror("read");
+		return 1;
+	} else if (ret != sizeof(t)) {
+		log_err("fio: short read on trace file\n");
+		return 1;
+	}
+
+	close(fd);
+
+	if ((t.magic & 0xffffff00) == BLK_IO_TRACE_MAGIC)
+		*swap = 0;
+	else {
+		/*
+		 * Maybe it needs to be endian swapped...
+		 */
+		t.magic = fio_swap32(t.magic);
+		if ((t.magic & 0xffffff00) == BLK_IO_TRACE_MAGIC)
+			*swap = 1;
+	}
+
+	if (*swap == -1) {
+		log_err("fio: blktrace appears corrupt\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int need_swap, i, c;
+
+	if (argc < 2)
+		return usage(argv);
+
+	while ((c = getopt(argc, argv, "t:n:fd:")) != -1) {
+		switch (c) {
+		case 't':
+			rt_threshold = atoi(optarg);
+			break;
+		case 'n':
+			ios_threshold = atoi(optarg);
+			break;
+		case 'f':
+			output_ascii = 0;
+			break;
+		case 'd':
+			filename = strdup(optarg);
+			break;
+		case '?':
+		default:
+			return usage(argv);
+		}
+	}
+
+	if (argc == optind)
+		return usage(argv);
+
+	if (trace_needs_swap(argv[optind], &need_swap))
+		return 1;
+
+	for (i = 0; i < PID_HASH_SIZE; i++)
+		INIT_FLIST_HEAD(&pid_hash[i]);
+	for (i = 0; i < INFLIGHT_HASH_SIZE; i++)
+		INIT_FLIST_HEAD(&inflight_hash[i]);
+
+	load_blktrace(argv[optind], need_swap);
+	first_ttime /= 1000ULL;
+
+	return output_p();
+}
