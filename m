Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57898 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388244AbeGXNGa (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Jul 2018 09:06:30 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fhvzI-0008Ue-Fe
        for fio@vger.kernel.org; Tue, 24 Jul 2018 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180724120002.D6BFA2C013E@kernel.dk>
Date: Tue, 24 Jul 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit edfca254378e729035073af6ac0d9156565afebe:

  axmap: optimize ulog64 usage in axmap_handler() (2018-07-12 08:33:14 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 464b6f76a69a1937d87a604346fa9c2b430f7465:

  libpmem: update print statement for bs now being ULL (2018-07-23 10:12:54 -0600)

----------------------------------------------------------------
Jeff Furlong (1):
      Add support for >= 4G block sizes

Jens Axboe (6):
      gfio: cleanup includes
      Fio 3.8
      Use stdlib.h instead of malloc.h
      parse: mark fall-through switch case
      parse: mark another fall-through switch case
      libpmem: update print statement for bs now being ULL

 FIO-VERSION-GEN          |  2 +-
 backend.c                | 10 +++----
 cconv.c                  | 24 +++++++--------
 client.c                 |  6 ++--
 engines/glusterfs_sync.c |  4 +--
 engines/libpmem.c        |  2 +-
 file.h                   |  2 +-
 filesetup.c              |  6 ++--
 fio.h                    |  8 ++---
 gclient.c                |  2 +-
 gerror.c                 |  2 +-
 gfio.c                   |  3 +-
 goptions.c               |  2 +-
 graph.c                  |  2 +-
 init.c                   |  4 +--
 io_u.c                   | 34 ++++++++++-----------
 io_u.h                   | 14 ++++-----
 ioengines.c              |  2 +-
 iolog.c                  | 16 +++++-----
 iolog.h                  |  2 +-
 options.c                | 10 +++----
 os/windows/posix.c       |  0
 parse.c                  | 78 +++++++++++++++++++++++++++++++++++-------------
 parse.h                  |  6 ++--
 server.c                 |  2 +-
 server.h                 |  2 +-
 stat.c                   | 20 +++++++------
 stat.h                   |  8 ++---
 thread_options.h         | 24 ++++++++-------
 tickmarks.c              |  2 +-
 verify.c                 |  2 +-
 31 files changed, 172 insertions(+), 129 deletions(-)
 mode change 100755 => 100644 os/windows/posix.c

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index b28a1f3..99261fb 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.7
+DEF_VER=fio-3.8
 
 LF='
 '
diff --git a/backend.c b/backend.c
index a7e9184..3c45e78 100644
--- a/backend.c
+++ b/backend.c
@@ -454,7 +454,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 			*ret = -io_u->error;
 			clear_io_u(td, io_u);
 		} else if (io_u->resid) {
-			int bytes = io_u->xfer_buflen - io_u->resid;
+			long long bytes = io_u->xfer_buflen - io_u->resid;
 			struct fio_file *f = io_u->file;
 
 			if (bytes_issued)
@@ -583,7 +583,7 @@ static bool in_flight_overlap(struct io_u_queue *q, struct io_u *io_u)
 
 			if (x1 < y2 && y1 < x2) {
 				overlap = true;
-				dprint(FD_IO, "in-flight overlap: %llu/%lu, %llu/%lu\n",
+				dprint(FD_IO, "in-flight overlap: %llu/%llu, %llu/%llu\n",
 						x1, io_u->buflen,
 						y1, check_io_u->buflen);
 				break;
@@ -1033,7 +1033,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			log_io_piece(td, io_u);
 
 		if (td->o.io_submit_mode == IO_MODE_OFFLOAD) {
-			const unsigned long blen = io_u->xfer_buflen;
+			const unsigned long long blen = io_u->xfer_buflen;
 			const enum fio_ddir __ddir = acct_ddir(io_u);
 
 			if (td->error)
@@ -1199,7 +1199,7 @@ static void cleanup_io_u(struct thread_data *td)
 static int init_io_u(struct thread_data *td)
 {
 	struct io_u *io_u;
-	unsigned int max_bs, min_write;
+	unsigned long long max_bs, min_write;
 	int cl_align, i, max_units;
 	int data_xfer = 1, err;
 	char *p;
@@ -1234,7 +1234,7 @@ static int init_io_u(struct thread_data *td)
 		td->orig_buffer_size += page_mask + td->o.mem_align;
 
 	if (td->o.mem_type == MEM_SHMHUGE || td->o.mem_type == MEM_MMAPHUGE) {
-		unsigned long bs;
+		unsigned long long bs;
 
 		bs = td->orig_buffer_size + td->o.hugepage_size - 1;
 		td->orig_buffer_size = bs & ~(td->o.hugepage_size - 1);
diff --git a/cconv.c b/cconv.c
index bfd699d..534bfb0 100644
--- a/cconv.c
+++ b/cconv.c
@@ -110,16 +110,16 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->start_offset_percent = le32_to_cpu(top->start_offset_percent);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		o->bs[i] = le32_to_cpu(top->bs[i]);
-		o->ba[i] = le32_to_cpu(top->ba[i]);
-		o->min_bs[i] = le32_to_cpu(top->min_bs[i]);
-		o->max_bs[i] = le32_to_cpu(top->max_bs[i]);
+		o->bs[i] = le64_to_cpu(top->bs[i]);
+		o->ba[i] = le64_to_cpu(top->ba[i]);
+		o->min_bs[i] = le64_to_cpu(top->min_bs[i]);
+		o->max_bs[i] = le64_to_cpu(top->max_bs[i]);
 		o->bssplit_nr[i] = le32_to_cpu(top->bssplit_nr[i]);
 
 		if (o->bssplit_nr[i]) {
 			o->bssplit[i] = malloc(o->bssplit_nr[i] * sizeof(struct bssplit));
 			for (j = 0; j < o->bssplit_nr[i]; j++) {
-				o->bssplit[i][j].bs = le32_to_cpu(top->bssplit[i][j].bs);
+				o->bssplit[i][j].bs = le64_to_cpu(top->bssplit[i][j].bs);
 				o->bssplit[i][j].perc = le32_to_cpu(top->bssplit[i][j].perc);
 			}
 		}
@@ -203,7 +203,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->gauss_dev.u.f = fio_uint64_to_double(le64_to_cpu(top->gauss_dev.u.i));
 	o->random_generator = le32_to_cpu(top->random_generator);
 	o->hugepage_size = le32_to_cpu(top->hugepage_size);
-	o->rw_min_bs = le32_to_cpu(top->rw_min_bs);
+	o->rw_min_bs = le64_to_cpu(top->rw_min_bs);
 	o->thinktime = le32_to_cpu(top->thinktime);
 	o->thinktime_spin = le32_to_cpu(top->thinktime_spin);
 	o->thinktime_blocks = le32_to_cpu(top->thinktime_blocks);
@@ -410,7 +410,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->gauss_dev.u.i = __cpu_to_le64(fio_double_to_uint64(o->gauss_dev.u.f));
 	top->random_generator = cpu_to_le32(o->random_generator);
 	top->hugepage_size = cpu_to_le32(o->hugepage_size);
-	top->rw_min_bs = cpu_to_le32(o->rw_min_bs);
+	top->rw_min_bs = __cpu_to_le64(o->rw_min_bs);
 	top->thinktime = cpu_to_le32(o->thinktime);
 	top->thinktime_spin = cpu_to_le32(o->thinktime_spin);
 	top->thinktime_blocks = cpu_to_le32(o->thinktime_blocks);
@@ -488,10 +488,10 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->write_hist_log = cpu_to_le32(o->write_hist_log);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		top->bs[i] = cpu_to_le32(o->bs[i]);
-		top->ba[i] = cpu_to_le32(o->ba[i]);
-		top->min_bs[i] = cpu_to_le32(o->min_bs[i]);
-		top->max_bs[i] = cpu_to_le32(o->max_bs[i]);
+		top->bs[i] = __cpu_to_le64(o->bs[i]);
+		top->ba[i] = __cpu_to_le64(o->ba[i]);
+		top->min_bs[i] = __cpu_to_le64(o->min_bs[i]);
+		top->max_bs[i] = __cpu_to_le64(o->max_bs[i]);
 		top->bssplit_nr[i] = cpu_to_le32(o->bssplit_nr[i]);
 
 		if (o->bssplit_nr[i]) {
@@ -502,7 +502,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 				bssplit_nr = BSSPLIT_MAX;
 			}
 			for (j = 0; j < bssplit_nr; j++) {
-				top->bssplit[i][j].bs = cpu_to_le32(o->bssplit[i][j].bs);
+				top->bssplit[i][j].bs = cpu_to_le64(o->bssplit[i][j].bs);
 				top->bssplit[i][j].perc = cpu_to_le32(o->bssplit[i][j].perc);
 			}
 		}
diff --git a/client.c b/client.c
index 2a86ea9..e2525c8 100644
--- a/client.c
+++ b/client.c
@@ -1357,8 +1357,8 @@ static void client_flush_hist_samples(FILE *f, int hist_coarseness, void *sample
 		entry = s->data.plat_entry;
 		io_u_plat = entry->io_u_plat;
 
-		fprintf(f, "%lu, %u, %u, ", (unsigned long) s->time,
-						io_sample_ddir(s), s->bs);
+		fprintf(f, "%lu, %u, %llu, ", (unsigned long) s->time,
+						io_sample_ddir(s), (unsigned long long) s->bs);
 		for (j = 0; j < FIO_IO_U_PLAT_NR - stride; j += stride) {
 			fprintf(f, "%llu, ", (unsigned long long)hist_sum(j, stride, io_u_plat, NULL));
 		}
@@ -1647,7 +1647,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		s->time		= le64_to_cpu(s->time);
 		s->data.val	= le64_to_cpu(s->data.val);
 		s->__ddir	= le32_to_cpu(s->__ddir);
-		s->bs		= le32_to_cpu(s->bs);
+		s->bs		= le64_to_cpu(s->bs);
 
 		if (ret->log_offset) {
 			struct io_sample_offset *so = (void *) s;
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index a10e0ed..099a5af 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -34,7 +34,7 @@ static enum fio_q_status fio_gf_queue(struct thread_data *td, struct io_u *io_u)
 	struct gf_data *g = td->io_ops_data;
 	int ret = 0;
 
-	dprint(FD_FILE, "fio queue len %lu\n", io_u->xfer_buflen);
+	dprint(FD_FILE, "fio queue len %llu\n", io_u->xfer_buflen);
 	fio_ro_check(td, io_u);
 
 	if (io_u->ddir == DDIR_READ)
@@ -50,7 +50,7 @@ static enum fio_q_status fio_gf_queue(struct thread_data *td, struct io_u *io_u)
 		io_u->error = EINVAL;
 		return FIO_Q_COMPLETED;
 	}
-	dprint(FD_FILE, "fio len %lu ret %d\n", io_u->xfer_buflen, ret);
+	dprint(FD_FILE, "fio len %llu ret %d\n", io_u->xfer_buflen, ret);
 	if (io_u->file && ret >= 0 && ddir_rw(io_u->ddir))
 		LAST_POS(io_u->file) = io_u->offset + ret;
 
diff --git a/engines/libpmem.c b/engines/libpmem.c
index 21ff4f6..4ef3094 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -499,7 +499,7 @@ static int fio_libpmem_init(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
 
-	dprint(FD_IO,"o->rw_min_bs %d \n o->fsync_blocks %d \n o->fdatasync_blocks %d \n",
+	dprint(FD_IO,"o->rw_min_bs %llu \n o->fsync_blocks %d \n o->fdatasync_blocks %d \n",
 			o->rw_min_bs,o->fsync_blocks,o->fdatasync_blocks);
 	dprint(FD_IO, "DEBUG fio_libpmem_init\n");
 
diff --git a/file.h b/file.h
index 8fd34b1..c0a547e 100644
--- a/file.h
+++ b/file.h
@@ -86,7 +86,7 @@ struct fio_file {
 	 */
 	unsigned int major, minor;
 	int fileno;
-	int bs;
+	unsigned long long bs;
 	char *file_name;
 
 	/*
diff --git a/filesetup.c b/filesetup.c
index a2427a1..accb67a 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -107,7 +107,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 {
 	int new_layout = 0, unlink_file = 0, flags;
 	unsigned long long left;
-	unsigned int bs;
+	unsigned long long bs;
 	char *b = NULL;
 
 	if (read_only) {
@@ -260,7 +260,7 @@ static bool pre_read_file(struct thread_data *td, struct fio_file *f)
 {
 	int r, did_open = 0, old_runstate;
 	unsigned long long left;
-	unsigned int bs;
+	unsigned long long bs;
 	bool ret = true;
 	char *b;
 
@@ -900,7 +900,7 @@ int setup_files(struct thread_data *td)
 	unsigned int i, nr_fs_extra = 0;
 	int err = 0, need_extend;
 	int old_state;
-	const unsigned int bs = td_min_bs(td);
+	const unsigned long long bs = td_min_bs(td);
 	uint64_t fs = 0;
 
 	dprint(FD_FILE, "setup files\n");
diff --git a/fio.h b/fio.h
index 3ac552b..685aab1 100644
--- a/fio.h
+++ b/fio.h
@@ -736,17 +736,17 @@ static inline bool should_check_rate(struct thread_data *td)
 	return ddir_rw_sum(td->bytes_done) != 0;
 }
 
-static inline unsigned int td_max_bs(struct thread_data *td)
+static inline unsigned long long td_max_bs(struct thread_data *td)
 {
-	unsigned int max_bs;
+	unsigned long long max_bs;
 
 	max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
 	return max(td->o.max_bs[DDIR_TRIM], max_bs);
 }
 
-static inline unsigned int td_min_bs(struct thread_data *td)
+static inline unsigned long long td_min_bs(struct thread_data *td)
 {
-	unsigned int min_bs;
+	unsigned long long min_bs;
 
 	min_bs = min(td->o.min_bs[DDIR_READ], td->o.min_bs[DDIR_WRITE]);
 	return min(td->o.min_bs[DDIR_TRIM], min_bs);
diff --git a/gclient.c b/gclient.c
index bcd7a88..7e5071d 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1,4 +1,4 @@
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 
 #include <glib.h>
diff --git a/gerror.c b/gerror.c
index 43bdaba..1ebcb27 100644
--- a/gerror.c
+++ b/gerror.c
@@ -1,5 +1,5 @@
 #include <locale.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 #include <stdarg.h>
 
diff --git a/gfio.c b/gfio.c
index d222a1c..f59238c 100644
--- a/gfio.c
+++ b/gfio.c
@@ -22,8 +22,9 @@
  *
  */
 #include <locale.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
+#include <libgen.h>
 
 #include <glib.h>
 #include <cairo.h>
diff --git a/goptions.c b/goptions.c
index 16938ed..f44254b 100644
--- a/goptions.c
+++ b/goptions.c
@@ -1,5 +1,5 @@
 #include <locale.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 
 #include <glib.h>
diff --git a/graph.c b/graph.c
index f82b52a..7a17417 100644
--- a/graph.c
+++ b/graph.c
@@ -21,7 +21,7 @@
  *
  */
 #include <string.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <math.h>
 #include <assert.h>
 #include <stdlib.h>
diff --git a/init.c b/init.c
index af4cc6b..8cb8117 100644
--- a/init.c
+++ b/init.c
@@ -531,7 +531,7 @@ static void put_job(struct thread_data *td)
 
 static int __setup_rate(struct thread_data *td, enum fio_ddir ddir)
 {
-	unsigned int bs = td->o.min_bs[ddir];
+	unsigned long long bs = td->o.min_bs[ddir];
 
 	assert(ddir_rw(ddir));
 
@@ -891,7 +891,7 @@ static int fixup_options(struct thread_data *td)
 	 * If size is set but less than the min block size, complain
 	 */
 	if (o->size && o->size < td_min_bs(td)) {
-		log_err("fio: size too small, must not be less than minimum block size: %llu < %u\n",
+		log_err("fio: size too small, must not be less than minimum block size: %llu < %llu\n",
 			(unsigned long long) o->size, td_min_bs(td));
 		ret |= 1;
 	}
diff --git a/io_u.c b/io_u.c
index 5221a78..c58dcf0 100644
--- a/io_u.c
+++ b/io_u.c
@@ -33,9 +33,9 @@ static bool random_map_free(struct fio_file *f, const uint64_t block)
  */
 static void mark_random_map(struct thread_data *td, struct io_u *io_u)
 {
-	unsigned int min_bs = td->o.min_bs[io_u->ddir];
+	unsigned long long min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
-	unsigned int nr_blocks;
+	unsigned long long nr_blocks;
 	uint64_t block;
 
 	block = (io_u->offset - f->file_offset) / (uint64_t) min_bs;
@@ -503,19 +503,19 @@ static int get_next_offset(struct thread_data *td, struct io_u *io_u,
 }
 
 static inline bool io_u_fits(struct thread_data *td, struct io_u *io_u,
-			     unsigned int buflen)
+			     unsigned long long buflen)
 {
 	struct fio_file *f = io_u->file;
 
 	return io_u->offset + buflen <= f->io_size + get_start_offset(td, f);
 }
 
-static unsigned int get_next_buflen(struct thread_data *td, struct io_u *io_u,
+static unsigned long long get_next_buflen(struct thread_data *td, struct io_u *io_u,
 				    bool is_random)
 {
 	int ddir = io_u->ddir;
-	unsigned int buflen = 0;
-	unsigned int minbs, maxbs;
+	unsigned long long buflen = 0;
+	unsigned long long minbs, maxbs;
 	uint64_t frand_max, r;
 	bool power_2;
 
@@ -541,7 +541,7 @@ static unsigned int get_next_buflen(struct thread_data *td, struct io_u *io_u,
 		r = __rand(&td->bsrange_state[ddir]);
 
 		if (!td->o.bssplit_nr[ddir]) {
-			buflen = minbs + (unsigned int) ((double) maxbs *
+			buflen = minbs + (unsigned long long) ((double) maxbs *
 					(r / (frand_max + 1.0)));
 		} else {
 			long long perc = 0;
@@ -891,7 +891,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
-		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%lx exceeds file size=0x%llx\n",
+		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
 			io_u,
 			(unsigned long long) io_u->offset, io_u->buflen,
 			(unsigned long long) io_u->file->real_file_size);
@@ -1582,7 +1582,7 @@ static bool check_get_verify(struct thread_data *td, struct io_u *io_u)
  */
 static void small_content_scramble(struct io_u *io_u)
 {
-	unsigned int i, nr_blocks = io_u->buflen >> 9;
+	unsigned long long i, nr_blocks = io_u->buflen >> 9;
 	unsigned int offset;
 	uint64_t boffset, *iptr;
 	char *p;
@@ -1726,7 +1726,7 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 	if (td_non_fatal_error(td, eb, io_u->error) && !td->o.error_dump)
 		return;
 
-	log_err("fio: io_u error%s%s: %s: %s offset=%llu, buflen=%lu\n",
+	log_err("fio: io_u error%s%s: %s: %s offset=%llu, buflen=%llu\n",
 		io_u->file ? " on file " : "",
 		io_u->file ? io_u->file->file_name : "",
 		strerror(io_u->error),
@@ -1892,7 +1892,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	td->last_ddir = ddir;
 
 	if (!io_u->error && ddir_rw(ddir)) {
-		unsigned int bytes = io_u->buflen - io_u->resid;
+		unsigned long long bytes = io_u->buflen - io_u->resid;
 		int ret;
 
 		td->io_blocks[ddir]++;
@@ -2082,8 +2082,8 @@ static void save_buf_state(struct thread_data *td, struct frand_state *rs)
 		frand_copy(&td->buf_state_prev, rs);
 }
 
-void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
-		    unsigned int max_bs)
+void fill_io_buffer(struct thread_data *td, void *buf, unsigned long long min_write,
+		    unsigned long long max_bs)
 {
 	struct thread_options *o = &td->o;
 
@@ -2093,8 +2093,8 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 	if (o->compress_percentage || o->dedupe_percentage) {
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
-		unsigned int left = max_bs;
-		unsigned int this_write;
+		unsigned long long left = max_bs;
+		unsigned long long this_write;
 
 		do {
 			rs = get_buf_state(td);
@@ -2103,7 +2103,7 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 
 			if (perc) {
 				this_write = min_not_zero(min_write,
-							td->o.compress_chunk);
+							(unsigned long long) td->o.compress_chunk);
 
 				fill_random_buf_percentage(rs, buf, perc,
 					this_write, this_write,
@@ -2130,7 +2130,7 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
  * "randomly" fill the buffer contents
  */
 void io_u_fill_buffer(struct thread_data *td, struct io_u *io_u,
-		      unsigned int min_write, unsigned int max_bs)
+		      unsigned long long min_write, unsigned long long max_bs)
 {
 	io_u->buf_filled_len = 0;
 	fill_io_buffer(td, io_u->buf, min_write, max_bs);
diff --git a/io_u.h b/io_u.h
index 4f433c3..9a423b2 100644
--- a/io_u.h
+++ b/io_u.h
@@ -51,7 +51,7 @@ struct io_u {
 	/*
 	 * Allocated/set buffer and length
 	 */
-	unsigned long buflen;
+	unsigned long long buflen;
 	unsigned long long offset;
 	void *buf;
 
@@ -65,13 +65,13 @@ struct io_u {
 	 * partial transfers / residual data counts
 	 */
 	void *xfer_buf;
-	unsigned long xfer_buflen;
+	unsigned long long xfer_buflen;
 
 	/*
 	 * Parameter related to pre-filled buffers and
 	 * their size to handle variable block sizes.
 	 */
-	unsigned long buf_filled_len;
+	unsigned long long buf_filled_len;
 
 	struct io_piece *ipo;
 
@@ -134,8 +134,8 @@ extern void io_u_queued(struct thread_data *, struct io_u *);
 extern int io_u_quiesce(struct thread_data *);
 extern void io_u_log_error(struct thread_data *, struct io_u *);
 extern void io_u_mark_depth(struct thread_data *, unsigned int);
-extern void fill_io_buffer(struct thread_data *, void *, unsigned int, unsigned int);
-extern void io_u_fill_buffer(struct thread_data *td, struct io_u *, unsigned int, unsigned int);
+extern void fill_io_buffer(struct thread_data *, void *, unsigned long long, unsigned long long);
+extern void io_u_fill_buffer(struct thread_data *td, struct io_u *, unsigned long long, unsigned long long);
 void io_u_mark_complete(struct thread_data *, unsigned int);
 void io_u_mark_submit(struct thread_data *, unsigned int);
 bool queue_full(const struct thread_data *);
@@ -149,13 +149,13 @@ static inline void dprint_io_u(struct io_u *io_u, const char *p)
 	struct fio_file *f = io_u->file;
 
 	if (f)
-		dprint(FD_IO, "%s: io_u %p: off=0x%llx,len=0x%lx,ddir=%d,file=%s\n",
+		dprint(FD_IO, "%s: io_u %p: off=0x%llx,len=0x%llx,ddir=%d,file=%s\n",
 				p, io_u,
 				(unsigned long long) io_u->offset,
 				io_u->buflen, io_u->ddir,
 				f->file_name);
 	else
-		dprint(FD_IO, "%s: io_u %p: off=0x%llx,len=0x%lx,ddir=%d\n",
+		dprint(FD_IO, "%s: io_u %p: off=0x%llx,len=0x%llx,ddir=%d\n",
 				p, io_u,
 				(unsigned long long) io_u->offset,
 				io_u->buflen, io_u->ddir);
diff --git a/ioengines.c b/ioengines.c
index d579682..bce65ea 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -279,7 +279,7 @@ out:
 enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 {
 	const enum fio_ddir ddir = acct_ddir(io_u);
-	unsigned long buflen = io_u->xfer_buflen;
+	unsigned long long buflen = io_u->xfer_buflen;
 	enum fio_q_status ret;
 
 	dprint_io_u(io_u, "queue");
diff --git a/iolog.c b/iolog.c
index 5be3e84..d51e49c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -35,7 +35,7 @@ void log_io_u(const struct thread_data *td, const struct io_u *io_u)
 	if (!td->o.write_iolog_file)
 		return;
 
-	fprintf(td->iolog_f, "%s %s %llu %lu\n", io_u->file->file_name,
+	fprintf(td->iolog_f, "%s %s %llu %llu\n", io_u->file->file_name,
 						io_ddir_name(io_u->ddir),
 						io_u->offset, io_u->buflen);
 }
@@ -161,7 +161,7 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 			io_u->buflen = ipo->len;
 			io_u->file = td->files[ipo->fileno];
 			get_file(io_u->file);
-			dprint(FD_IO, "iolog: get %llu/%lu/%s\n", io_u->offset,
+			dprint(FD_IO, "iolog: get %llu/%llu/%s\n", io_u->offset,
 						io_u->buflen, io_u->file->file_name);
 			if (ipo->delay)
 				iolog_delay(td, ipo->delay);
@@ -737,8 +737,8 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 		entry_before = flist_first_entry(&entry->list, struct io_u_plat_entry, list);
 		io_u_plat_before = entry_before->io_u_plat;
 
-		fprintf(f, "%lu, %u, %u, ", (unsigned long) s->time,
-						io_sample_ddir(s), s->bs);
+		fprintf(f, "%lu, %u, %llu, ", (unsigned long) s->time,
+						io_sample_ddir(s), (unsigned long long) s->bs);
 		for (j = 0; j < FIO_IO_U_PLAT_NR - stride; j += stride) {
 			fprintf(f, "%llu, ", (unsigned long long)
 			        hist_sum(j, stride, io_u_plat, io_u_plat_before));
@@ -770,17 +770,17 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 		s = __get_sample(samples, log_offset, i);
 
 		if (!log_offset) {
-			fprintf(f, "%lu, %" PRId64 ", %u, %u\n",
+			fprintf(f, "%lu, %" PRId64 ", %u, %llu\n",
 					(unsigned long) s->time,
 					s->data.val,
-					io_sample_ddir(s), s->bs);
+					io_sample_ddir(s), (unsigned long long) s->bs);
 		} else {
 			struct io_sample_offset *so = (void *) s;
 
-			fprintf(f, "%lu, %" PRId64 ", %u, %u, %llu\n",
+			fprintf(f, "%lu, %" PRId64 ", %u, %llu, %llu\n",
 					(unsigned long) s->time,
 					s->data.val,
-					io_sample_ddir(s), s->bs,
+					io_sample_ddir(s), (unsigned long long) s->bs,
 					(unsigned long long) so->offset);
 		}
 	}
diff --git a/iolog.h b/iolog.h
index a4e335a..3b8c901 100644
--- a/iolog.h
+++ b/iolog.h
@@ -42,7 +42,7 @@ struct io_sample {
 	uint64_t time;
 	union io_sample_data data;
 	uint32_t __ddir;
-	uint32_t bs;
+	uint64_t bs;
 };
 
 struct io_sample_offset {
diff --git a/options.c b/options.c
index a174e2c..4b46402 100644
--- a/options.c
+++ b/options.c
@@ -52,7 +52,7 @@ static int bs_cmp(const void *p1, const void *p2)
 
 struct split {
 	unsigned int nr;
-	unsigned int val1[ZONESPLIT_MAX];
+	unsigned long long val1[ZONESPLIT_MAX];
 	unsigned long long val2[ZONESPLIT_MAX];
 };
 
@@ -119,7 +119,7 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
 			bool data)
 {
 	unsigned int i, perc, perc_missing;
-	unsigned int max_bs, min_bs;
+	unsigned long long max_bs, min_bs;
 	struct split split;
 
 	memset(&split, 0, sizeof(split));
@@ -2112,7 +2112,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "bs",
 		.lname	= "Block size",
 		.alias	= "blocksize",
-		.type	= FIO_OPT_INT,
+		.type	= FIO_OPT_ULL,
 		.off1	= offsetof(struct thread_options, bs[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, bs[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, bs[DDIR_TRIM]),
@@ -2129,7 +2129,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "ba",
 		.lname	= "Block size align",
 		.alias	= "blockalign",
-		.type	= FIO_OPT_INT,
+		.type	= FIO_OPT_ULL,
 		.off1	= offsetof(struct thread_options, ba[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, ba[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, ba[DDIR_TRIM]),
@@ -2163,7 +2163,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "bssplit",
 		.lname	= "Block size split",
-		.type	= FIO_OPT_STR,
+		.type	= FIO_OPT_STR_ULL,
 		.cb	= str_bssplit_cb,
 		.off1	= offsetof(struct thread_options, bssplit),
 		.help	= "Set a specific mix of block sizes",
diff --git a/os/windows/posix.c b/os/windows/posix.c
old mode 100755
new mode 100644
diff --git a/parse.c b/parse.c
index 6261fca..194ad59 100644
--- a/parse.c
+++ b/parse.c
@@ -26,12 +26,14 @@
 static const char *opt_type_names[] = {
 	"OPT_INVALID",
 	"OPT_STR",
+	"OPT_STR_ULL",
 	"OPT_STR_MULTI",
 	"OPT_STR_VAL",
 	"OPT_STR_VAL_TIME",
 	"OPT_STR_STORE",
 	"OPT_RANGE",
 	"OPT_INT",
+	"OPT_ULL",
 	"OPT_BOOL",
 	"OPT_FLOAT_LIST",
 	"OPT_STR_SET",
@@ -438,7 +440,7 @@ void strip_blank_end(char *p)
 	*(s + 1) = '\0';
 }
 
-static int check_range_bytes(const char *str, long *val, void *data)
+static int check_range_bytes(const char *str, long long *val, void *data)
 {
 	long long __val;
 
@@ -507,7 +509,8 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 	int il=0, *ilp;
 	fio_fp64_t *flp;
 	long long ull, *ullp;
-	long ul1, ul2;
+	long ul2;
+	long long ull1, ull2;
 	double uf;
 	char **cp = NULL;
 	int ret = 0, is_time = 0;
@@ -525,6 +528,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 
 	switch (o->type) {
 	case FIO_OPT_STR:
+	case FIO_OPT_STR_ULL:
 	case FIO_OPT_STR_MULTI: {
 		fio_opt_str_fn *fn = o->cb;
 
@@ -540,7 +544,11 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 				break;
 			if (!strncmp(vp->ival, ptr, str_match_len(vp, ptr))) {
 				ret = 0;
-				if (o->off1)
+				if (!o->off1)
+					continue;
+				if (o->type == FIO_OPT_STR_ULL)
+					val_store(ullp, vp->oval, o->off1, vp->orval, data, o);
+				else
 					val_store(ilp, vp->oval, o->off1, vp->orval, data, o);
 				continue;
 			}
@@ -554,6 +562,8 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 	}
 	case FIO_OPT_STR_VAL_TIME:
 		is_time = 1;
+		/* fall through */
+	case FIO_OPT_ULL:
 	case FIO_OPT_INT:
 	case FIO_OPT_STR_VAL: {
 		fio_opt_str_val_fn *fn = o->cb;
@@ -584,7 +594,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 
 		if (o->maxval && ull > o->maxval) {
 			log_err("max value out of range: %llu"
-					" (%u max)\n", ull, o->maxval);
+					" (%llu max)\n", ull, o->maxval);
 			return 1;
 		}
 		if (o->minval && ull < o->minval) {
@@ -636,6 +646,27 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 							val_store(ilp, ull, o->off3, 0, data, o);
 					}
 				}
+			} else if (o->type == FIO_OPT_ULL) {
+				if (first)
+					val_store(ullp, ull, o->off1, 0, data, o);
+				if (curr == 1) {
+					if (o->off2)
+						val_store(ullp, ull, o->off2, 0, data, o);
+				}
+				if (curr == 2) {
+					if (o->off3)
+						val_store(ullp, ull, o->off3, 0, data, o);
+				}
+				if (!more) {
+					if (curr < 1) {
+						if (o->off2)
+							val_store(ullp, ull, o->off2, 0, data, o);
+					}
+					if (curr < 2) {
+						if (o->off3)
+							val_store(ullp, ull, o->off3, 0, data, o);
+					}
+				}
 			} else {
 				if (first)
 					val_store(ullp, ull, o->off1, 0, data, o);
@@ -790,43 +821,43 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 		p1 = tmp;
 
 		ret = 1;
-		if (!check_range_bytes(p1, &ul1, data) &&
-		    !check_range_bytes(p2, &ul2, data)) {
+		if (!check_range_bytes(p1, &ull1, data) &&
+			!check_range_bytes(p2, &ull2, data)) {
 			ret = 0;
-			if (ul1 > ul2) {
-				unsigned long foo = ul1;
+			if (ull1 > ull2) {
+				unsigned long long foo = ull1;
 
-				ul1 = ul2;
-				ul2 = foo;
+				ull1 = ull2;
+				ull2 = foo;
 			}
 
 			if (first) {
-				val_store(ilp, ul1, o->off1, 0, data, o);
-				val_store(ilp, ul2, o->off2, 0, data, o);
+				val_store(ullp, ull1, o->off1, 0, data, o);
+				val_store(ullp, ull2, o->off2, 0, data, o);
 			}
 			if (curr == 1) {
 				if (o->off3 && o->off4) {
-					val_store(ilp, ul1, o->off3, 0, data, o);
-					val_store(ilp, ul2, o->off4, 0, data, o);
+					val_store(ullp, ull1, o->off3, 0, data, o);
+					val_store(ullp, ull2, o->off4, 0, data, o);
 				}
 			}
 			if (curr == 2) {
 				if (o->off5 && o->off6) {
-					val_store(ilp, ul1, o->off5, 0, data, o);
-					val_store(ilp, ul2, o->off6, 0, data, o);
+					val_store(ullp, ull1, o->off5, 0, data, o);
+					val_store(ullp, ull2, o->off6, 0, data, o);
 				}
 			}
 			if (!more) {
 				if (curr < 1) {
 					if (o->off3 && o->off4) {
-						val_store(ilp, ul1, o->off3, 0, data, o);
-						val_store(ilp, ul2, o->off4, 0, data, o);
+						val_store(ullp, ull1, o->off3, 0, data, o);
+						val_store(ullp, ull2, o->off4, 0, data, o);
 					}
 				}
 				if (curr < 2) {
 					if (o->off5 && o->off6) {
-						val_store(ilp, ul1, o->off5, 0, data, o);
-						val_store(ilp, ul2, o->off6, 0, data, o);
+						val_store(ullp, ull1, o->off5, 0, data, o);
+						val_store(ullp, ull2, o->off6, 0, data, o);
 					}
 				}
 			}
@@ -851,7 +882,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 			break;
 
 		if (o->maxval && il > (int) o->maxval) {
-			log_err("max value out of range: %d (%d max)\n",
+			log_err("max value out of range: %d (%llu max)\n",
 								il, o->maxval);
 			return 1;
 		}
@@ -878,6 +909,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 	}
 	case FIO_OPT_DEPRECATED:
 		ret = 1;
+		/* fall through */
 	case FIO_OPT_SOFT_DEPRECATED:
 		log_info("Option %s is deprecated\n", o->name);
 		break;
@@ -1325,6 +1357,10 @@ static void option_init(struct fio_option *o)
 		if (!o->maxval)
 			o->maxval = UINT_MAX;
 	}
+	if (o->type == FIO_OPT_ULL) {
+		if (!o->maxval)
+			o->maxval = ULLONG_MAX;
+	}
 	if (o->type == FIO_OPT_STR_SET && o->def && !o->no_warn_def) {
 		log_err("Option %s: string set option with"
 				" default will always be true\n", o->name);
diff --git a/parse.h b/parse.h
index 4de5e77..b47a02c 100644
--- a/parse.h
+++ b/parse.h
@@ -10,12 +10,14 @@
 enum fio_opt_type {
 	FIO_OPT_INVALID = 0,
 	FIO_OPT_STR,
+	FIO_OPT_STR_ULL,
 	FIO_OPT_STR_MULTI,
 	FIO_OPT_STR_VAL,
 	FIO_OPT_STR_VAL_TIME,
 	FIO_OPT_STR_STORE,
 	FIO_OPT_RANGE,
 	FIO_OPT_INT,
+	FIO_OPT_ULL,
 	FIO_OPT_BOOL,
 	FIO_OPT_FLOAT_LIST,
 	FIO_OPT_STR_SET,
@@ -29,7 +31,7 @@ enum fio_opt_type {
  */
 struct value_pair {
 	const char *ival;		/* string option */
-	unsigned int oval;		/* output value */
+	unsigned long long oval;/* output value */
 	const char *help;		/* help text for sub option */
 	int orval;			/* OR value */
 	void *cb;			/* sub-option callback */
@@ -52,7 +54,7 @@ struct fio_option {
 	unsigned int off4;
 	unsigned int off5;
 	unsigned int off6;
-	unsigned int maxval;		/* max and min value */
+	unsigned long long maxval;		/* max and min value */
 	int minval;
 	double maxfp;			/* max and min floating value */
 	double minfp;
diff --git a/server.c b/server.c
index 7e7ffed..b966c66 100644
--- a/server.c
+++ b/server.c
@@ -1985,7 +1985,7 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 			s->time		= cpu_to_le64(s->time);
 			s->data.val	= cpu_to_le64(s->data.val);
 			s->__ddir	= cpu_to_le32(s->__ddir);
-			s->bs		= cpu_to_le32(s->bs);
+			s->bs		= cpu_to_le64(s->bs);
 
 			if (log->log_offset) {
 				struct io_sample_offset *so = (void *) s;
diff --git a/server.h b/server.h
index b48bbe1..37d2f76 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 73,
+	FIO_SERVER_VER			= 74,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index a308eb8..8de4835 100644
--- a/stat.c
+++ b/stat.c
@@ -619,8 +619,8 @@ static int block_state_category(int block_state)
 
 static int compare_block_infos(const void *bs1, const void *bs2)
 {
-	uint32_t block1 = *(uint32_t *)bs1;
-	uint32_t block2 = *(uint32_t *)bs2;
+	uint64_t block1 = *(uint64_t *)bs1;
+	uint64_t block2 = *(uint64_t *)bs2;
 	int state1 = BLOCK_INFO_STATE(block1);
 	int state2 = BLOCK_INFO_STATE(block2);
 	int bscat1 = block_state_category(state1);
@@ -2220,7 +2220,7 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 }
 
 static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
-			     enum fio_ddir ddir, unsigned int bs,
+			     enum fio_ddir ddir, unsigned long long bs,
 			     unsigned long t, uint64_t offset)
 {
 	struct io_logs *cur_log;
@@ -2338,7 +2338,7 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 static unsigned long add_log_sample(struct thread_data *td,
 				    struct io_log *iolog,
 				    union io_sample_data data,
-				    enum fio_ddir ddir, unsigned int bs,
+				    enum fio_ddir ddir, unsigned long long bs,
 				    uint64_t offset)
 {
 	unsigned long elapsed, this_window;
@@ -2400,7 +2400,7 @@ void finalize_logs(struct thread_data *td, bool unit_logs)
 		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
 }
 
-void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned int bs)
+void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned long long bs)
 {
 	struct io_log *iolog;
 
@@ -2430,7 +2430,8 @@ static void add_clat_percentile_sample(struct thread_stat *ts,
 }
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long long nsec, unsigned int bs, uint64_t offset)
+		     unsigned long long nsec, unsigned long long bs,
+		     uint64_t offset)
 {
 	unsigned long elapsed, this_window;
 	struct thread_stat *ts = &td->ts;
@@ -2489,7 +2490,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long usec, unsigned int bs, uint64_t offset)
+		     unsigned long usec, unsigned long long bs, uint64_t offset)
 {
 	struct thread_stat *ts = &td->ts;
 
@@ -2507,7 +2508,8 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 }
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
-		    unsigned long long nsec, unsigned int bs, uint64_t offset)
+		    unsigned long long nsec, unsigned long long bs,
+		    uint64_t offset)
 {
 	struct thread_stat *ts = &td->ts;
 
@@ -2590,7 +2592,7 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 		add_stat_sample(&stat[ddir], rate);
 
 		if (log) {
-			unsigned int bs = 0;
+			unsigned long long bs = 0;
 
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
diff --git a/stat.h b/stat.h
index c5b8185..5dcaae0 100644
--- a/stat.h
+++ b/stat.h
@@ -308,12 +308,12 @@ extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
 
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned int, uint64_t);
+				unsigned long long, uint64_t);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned int, uint64_t);
+				unsigned long long, uint64_t);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int, uint64_t);
-extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned int);
+				unsigned long long, uint64_t);
+extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long);
 extern void add_iops_sample(struct thread_data *, struct io_u *,
 				unsigned int);
 extern void add_bw_sample(struct thread_data *, struct io_u *,
diff --git a/thread_options.h b/thread_options.h
index 8d13b79..8adba48 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -29,7 +29,7 @@ enum fio_memtype {
 #define ZONESPLIT_MAX	256
 
 struct bssplit {
-	uint32_t bs;
+	uint64_t bs;
 	uint32_t perc;
 };
 
@@ -82,10 +82,10 @@ struct thread_options {
 	unsigned long long start_offset;
 	unsigned long long start_offset_align;
 
-	unsigned int bs[DDIR_RWDIR_CNT];
-	unsigned int ba[DDIR_RWDIR_CNT];
-	unsigned int min_bs[DDIR_RWDIR_CNT];
-	unsigned int max_bs[DDIR_RWDIR_CNT];
+	unsigned long long bs[DDIR_RWDIR_CNT];
+	unsigned long long ba[DDIR_RWDIR_CNT];
+	unsigned long long min_bs[DDIR_RWDIR_CNT];
+	unsigned long long max_bs[DDIR_RWDIR_CNT];
 	struct bssplit *bssplit[DDIR_RWDIR_CNT];
 	unsigned int bssplit_nr[DDIR_RWDIR_CNT];
 
@@ -164,7 +164,8 @@ struct thread_options {
 	unsigned int perc_rand[DDIR_RWDIR_CNT];
 
 	unsigned int hugepage_size;
-	unsigned int rw_min_bs;
+	unsigned long long rw_min_bs;
+	unsigned int pad2;
 	unsigned int thinktime;
 	unsigned int thinktime_spin;
 	unsigned int thinktime_blocks;
@@ -363,10 +364,10 @@ struct thread_options_pack {
 	uint64_t start_offset;
 	uint64_t start_offset_align;
 
-	uint32_t bs[DDIR_RWDIR_CNT];
-	uint32_t ba[DDIR_RWDIR_CNT];
-	uint32_t min_bs[DDIR_RWDIR_CNT];
-	uint32_t max_bs[DDIR_RWDIR_CNT];
+	uint64_t bs[DDIR_RWDIR_CNT];
+	uint64_t ba[DDIR_RWDIR_CNT];
+	uint64_t min_bs[DDIR_RWDIR_CNT];
+	uint64_t max_bs[DDIR_RWDIR_CNT];
 	struct bssplit bssplit[DDIR_RWDIR_CNT][BSSPLIT_MAX];
 	uint32_t bssplit_nr[DDIR_RWDIR_CNT];
 
@@ -443,7 +444,8 @@ struct thread_options_pack {
 	uint32_t perc_rand[DDIR_RWDIR_CNT];
 
 	uint32_t hugepage_size;
-	uint32_t rw_min_bs;
+	uint64_t rw_min_bs;
+	uint32_t pad2;
 	uint32_t thinktime;
 	uint32_t thinktime_spin;
 	uint32_t thinktime_blocks;
diff --git a/tickmarks.c b/tickmarks.c
index 808de67..88bace0 100644
--- a/tickmarks.c
+++ b/tickmarks.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <math.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 
 /*
diff --git a/verify.c b/verify.c
index 40d484b..0f2c118 100644
--- a/verify.c
+++ b/verify.c
@@ -801,7 +801,7 @@ static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
 
 	mem_is_zero_slow(io_u->buf, io_u->buflen, &offset);
 
-	log_err("trim: verify failed at file %s offset %llu, length %lu"
+	log_err("trim: verify failed at file %s offset %llu, length %llu"
 		", block offset %lu\n",
 			io_u->file->file_name, io_u->offset, io_u->buflen,
 			(unsigned long) offset);
