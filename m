Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGPMDf (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Jul 2021 08:03:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C52C06175F
        for <fio@vger.kernel.org>; Fri, 16 Jul 2021 05:00:39 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4MVg-004S3H-HZ
        for fio@vger.kernel.org; Fri, 16 Jul 2021 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210716120001.CB50C1BC016A@kernel.dk>
Date: Fri, 16 Jul 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7a9cc9c93c1384f72ac16d1d7980e158ec5f9f0a:

  Makefile: use override directive on engine CFLAGS (2021-07-07 07:05:08 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae5c7cdd710dfa97705d965dcf001a96504e5f31:

  Merge branch 'dedupe_workset' of https://github.com/bardavid/fio (2021-07-15 09:54:03 -0600)

----------------------------------------------------------------
Bar David (1):
      dedupe: allow to generate dedupe buffers from working set

Jens Axboe (2):
      Merge branch 'cmd-test-be' of https://github.com/tuan-hoang1/fio
      Merge branch 'dedupe_workset' of https://github.com/bardavid/fio

Tuan Hoang (1):
      server: fix missing le32_to_cpu conversion when opcode is FIO_NET_CMD_TEXT

 DEDUPE-TODO      | 19 +++++++++++++++++++
 HOWTO            | 30 ++++++++++++++++++++++++++++++
 Makefile         |  2 +-
 cconv.c          |  4 ++++
 dedupe.c         | 28 ++++++++++++++++++++++++++++
 dedupe.h         |  6 ++++++
 fio.1            | 42 ++++++++++++++++++++++++++++++++++++++++++
 fio.h            |  6 ++++++
 init.c           | 26 ++++++++++++++++++++++++++
 io_u.c           | 30 ++++++++++++++++++++----------
 lib/rand.c       | 10 ++--------
 lib/rand.h       | 10 ++++++++++
 options.c        | 34 ++++++++++++++++++++++++++++++++++
 server.c         |  3 ++-
 server.h         |  2 +-
 t/dedupe.c       | 21 ++++++++++++++-------
 thread_options.h | 12 ++++++++++++
 17 files changed, 257 insertions(+), 28 deletions(-)
 create mode 100644 DEDUPE-TODO
 create mode 100644 dedupe.c
 create mode 100644 dedupe.h

---

Diff of recent changes:

diff --git a/DEDUPE-TODO b/DEDUPE-TODO
new file mode 100644
index 00000000..1f3ee9da
--- /dev/null
+++ b/DEDUPE-TODO
@@ -0,0 +1,19 @@
+- Mixed buffers of dedupe-able and compressible data.
+  Major usecase in performance benchmarking of storage subsystems.
+
+- Shifted dedup-able data.
+  Allow for dedup buffer generation to shift contents by random number
+  of sectors (fill the gaps with uncompressible data). Some storage
+  subsystems modernized the deduplication detection algorithms to look
+  for shifted data as well. For example, some databases push a timestamp
+  on the prefix of written blocks, which makes the underlying data
+  dedup-able in different alignment. FIO should be able to simulate such
+  workload.
+
+- Generation of similar data (but not exact).
+  A rising trend in enterprise storage systems.
+  Generation of "similar" data means random uncompressible buffers
+  that differ by few(configurable number of) bits from each other.
+  The storage subsystem usually identifies the similar buffers using
+  locality-sensitive hashing or other methods.
+
diff --git a/HOWTO b/HOWTO
index 86fb2964..a12bccba 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1705,6 +1705,36 @@ Buffers and memory
 	this option will also enable :option:`refill_buffers` to prevent every buffer
 	being identical.
 
+.. option:: dedupe_mode=str
+
+	If ``dedupe_percentage=<int>`` is given, then this option controls how fio
+	generates the dedupe buffers.
+
+		**repeat**
+			Generate dedupe buffers by repeating previous writes
+		**working_set**
+			Generate dedupe buffers from working set
+
+	``repeat`` is the default option for fio. Dedupe buffers are generated
+	by repeating previous unique write.
+
+	``working_set`` is a more realistic workload.
+	With ``working_set``, ``dedupe_working_set_percentage=<int>`` should be provided.
+	Given that, fio will use the initial unique write buffers as its working set.
+	Upon deciding to dedupe, fio will randomly choose a buffer from the working set.
+	Note that by using ``working_set`` the dedupe percentage will converge
+	to the desired over time while ``repeat`` maintains the desired percentage
+	throughout the job.
+
+.. option:: dedupe_working_set_percentage=int
+
+	If ``dedupe_mode=<str>`` is set to ``working_set``, then this controls
+	the percentage of size of the file or device used as the buffers
+	fio will choose to generate the dedupe buffers from
+
+	Note that size needs to be explicitly provided and only 1 file per
+	job is supported
+
 .. option:: invalidate=bool
 
 	Invalidate the buffer/page cache parts of the files to be used prior to
diff --git a/Makefile b/Makefile
index 510e07fc..cc7dada7 100644
--- a/Makefile
+++ b/Makefile
@@ -61,7 +61,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		workqueue.c rate-submit.c optgroup.c helper_thread.c \
-		steadystate.c zone-dist.c zbd.c
+		steadystate.c zone-dist.c zbd.c dedupe.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/cconv.c b/cconv.c
index 74c24106..e3a8c27c 100644
--- a/cconv.c
+++ b/cconv.c
@@ -298,6 +298,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
 	o->compress_chunk = le32_to_cpu(top->compress_chunk);
 	o->dedupe_percentage = le32_to_cpu(top->dedupe_percentage);
+	o->dedupe_mode = le32_to_cpu(top->dedupe_mode);
+	o->dedupe_working_set_percentage = le32_to_cpu(top->dedupe_working_set_percentage);
 	o->block_error_hist = le32_to_cpu(top->block_error_hist);
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
@@ -499,6 +501,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->compress_percentage = cpu_to_le32(o->compress_percentage);
 	top->compress_chunk = cpu_to_le32(o->compress_chunk);
 	top->dedupe_percentage = cpu_to_le32(o->dedupe_percentage);
+	top->dedupe_mode = cpu_to_le32(o->dedupe_mode);
+	top->dedupe_working_set_percentage = cpu_to_le32(o->dedupe_working_set_percentage);
 	top->block_error_hist = cpu_to_le32(o->block_error_hist);
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
diff --git a/dedupe.c b/dedupe.c
new file mode 100644
index 00000000..043a376c
--- /dev/null
+++ b/dedupe.c
@@ -0,0 +1,28 @@
+#include "fio.h"
+
+int init_dedupe_working_set_seeds(struct thread_data *td)
+{
+	unsigned long long i;
+	struct frand_state dedupe_working_set_state = {0};
+
+	if (!td->o.dedupe_percentage || !(td->o.dedupe_mode == DEDUPE_MODE_WORKING_SET))
+		return 0;
+
+	/*
+	 * The dedupe working set keeps seeds of unique data (generated by buf_state).
+	 * Dedupe-ed pages will be generated using those seeds.
+	 */
+	td->num_unique_pages = (td->o.size * (unsigned long long)td->o.dedupe_working_set_percentage / 100) / td->o.min_bs[DDIR_WRITE];
+	td->dedupe_working_set_states = malloc(sizeof(struct frand_state) * td->num_unique_pages);
+	if (!td->dedupe_working_set_states) {
+		log_err("fio: could not allocate dedupe working set\n");
+		return 1;
+	}
+	frand_copy(&dedupe_working_set_state, &td->buf_state);
+	for (i = 0; i < td->num_unique_pages; i++) {
+		frand_copy(&td->dedupe_working_set_states[i], &dedupe_working_set_state);
+		__get_next_seed(&dedupe_working_set_state);
+	}
+
+	return 0;
+}
diff --git a/dedupe.h b/dedupe.h
new file mode 100644
index 00000000..d4c4dc37
--- /dev/null
+++ b/dedupe.h
@@ -0,0 +1,6 @@
+#ifndef DEDUPE_H
+#define DEDUPE_H
+
+int init_dedupe_working_set_seeds(struct thread_data *td);
+
+#endif
diff --git a/fio.1 b/fio.1
index 5aa54a4d..bd315e11 100644
--- a/fio.1
+++ b/fio.1
@@ -1509,6 +1509,48 @@ all \-\- this option only controls the distribution of unique buffers. Setting
 this option will also enable \fBrefill_buffers\fR to prevent every buffer
 being identical.
 .TP
+.BI dedupe_mode \fR=\fPstr
+If \fBdedupe_percentage\fR is given, then this option controls how fio
+generates the dedupe buffers.
+.RS
+.RS
+.TP
+.B repeat
+.P
+.RS
+Generate dedupe buffers by repeating previous writes
+.RE
+.TP
+.B working_set
+.P
+.RS
+Generate dedupe buffers from working set
+.RE
+.RE
+.P
+\fBrepeat\fR is the default option for fio. Dedupe buffers are generated
+by repeating previous unique write.
+
+\fBworking_set\fR is a more realistic workload.
+With \fBworking_set\fR, \fBdedupe_working_set_percentage\fR should be provided.
+Given that, fio will use the initial unique write buffers as its working set.
+Upon deciding to dedupe, fio will randomly choose a buffer from the working set.
+Note that by using \fBworking_set\fR the dedupe percentage will converge
+to the desired over time while \fBrepeat\fR maintains the desired percentage
+throughout the job.
+.RE
+.RE
+.TP
+.BI dedupe_working_set_percentage \fR=\fPint
+If \fBdedupe_mode\fR is set to \fBworking_set\fR, then this controls
+the percentage of size of the file or device used as the buffers
+fio will choose to generate the dedupe buffers from
+.P
+.RS
+Note that \fBsize\fR needs to be explicitly provided and only 1 file
+per job is supported
+.RE
+.TP
 .BI invalidate \fR=\fPbool
 Invalidate the buffer/page cache parts of the files to be used prior to
 starting I/O if the platform and file type support it. Defaults to true.
diff --git a/fio.h b/fio.h
index 83334652..51686fd0 100644
--- a/fio.h
+++ b/fio.h
@@ -47,6 +47,7 @@
 #include "workqueue.h"
 #include "steadystate.h"
 #include "lib/nowarn_snprintf.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_SOLARISAIO
 #include <sys/asynch.h>
@@ -140,6 +141,7 @@ enum {
 	FIO_RAND_POISSON2_OFF,
 	FIO_RAND_POISSON3_OFF,
 	FIO_RAND_PRIO_CMDS,
+	FIO_RAND_DEDUPE_WORKING_SET_IX,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -263,6 +265,10 @@ struct thread_data {
 	struct frand_state dedupe_state;
 	struct frand_state zone_state;
 	struct frand_state prio_state;
+	struct frand_state dedupe_working_set_index_state;
+	struct frand_state *dedupe_working_set_states;
+
+	unsigned long long num_unique_pages;
 
 	struct zone_split_index **zone_state_index;
 	unsigned int num_open_zones;
diff --git a/init.c b/init.c
index 60c7cff4..871fb5ad 100644
--- a/init.c
+++ b/init.c
@@ -958,6 +958,28 @@ static int fixup_options(struct thread_data *td)
 
 	o->latency_target *= 1000ULL;
 
+	/*
+	 * Dedupe working set verifications
+	 */
+	if (o->dedupe_percentage && o->dedupe_mode == DEDUPE_MODE_WORKING_SET) {
+		if (!fio_option_is_set(o, size)) {
+			log_err("fio: pregenerated dedupe working set "
+					"requires size to be set\n");
+			ret |= 1;
+		} else if (o->nr_files != 1) {
+			log_err("fio: dedupe working set mode supported with "
+					"single file per job, but %d files "
+					"provided\n", o->nr_files);
+			ret |= 1;
+		} else if (o->dedupe_working_set_percentage + o->dedupe_percentage > 100) {
+			log_err("fio: impossible to reach expected dedupe percentage %u "
+					"since %u percentage of size is reserved to dedupe working set "
+					"(those are unique pages)\n",
+					o->dedupe_percentage, o->dedupe_working_set_percentage);
+			ret |= 1;
+		}
+	}
+
 	return ret;
 }
 
@@ -1031,6 +1053,7 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], false);
 	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], false);
 	init_rand_seed(&td->prio_state, td->rand_seeds[FIO_RAND_PRIO_CMDS], false);
+	init_rand_seed(&td->dedupe_working_set_index_state, td->rand_seeds[FIO_RAND_DEDUPE_WORKING_SET_IX], use64);
 
 	if (!td_random(td))
 		return;
@@ -1491,6 +1514,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (fixup_options(td))
 		goto err;
 
+	if (init_dedupe_working_set_seeds(td))
+		goto err;
+
 	/*
 	 * Belongs to fixup_options, but o->name is not necessarily set as yet
 	 */
diff --git a/io_u.c b/io_u.c
index b60488a3..9a1cd547 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2172,6 +2172,7 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 static struct frand_state *get_buf_state(struct thread_data *td)
 {
 	unsigned int v;
+	unsigned long long i;
 
 	if (!td->o.dedupe_percentage)
 		return &td->buf_state;
@@ -2182,16 +2183,25 @@ static struct frand_state *get_buf_state(struct thread_data *td)
 
 	v = rand_between(&td->dedupe_state, 1, 100);
 
-	if (v <= td->o.dedupe_percentage) {
-		/*
-		 * The caller advances the returned frand_state.
-		 * A copy of prev should be returned instead since
-		 * a subsequent intention to generate a deduped buffer
-		 * might result in generating a unique one
-		 */
-		frand_copy(&td->buf_state_ret, &td->buf_state_prev);
-		return &td->buf_state_ret;
-	}
+	if (v <= td->o.dedupe_percentage)
+		switch (td->o.dedupe_mode) {
+		case DEDUPE_MODE_REPEAT:
+			/*
+			* The caller advances the returned frand_state.
+			* A copy of prev should be returned instead since
+			* a subsequent intention to generate a deduped buffer
+			* might result in generating a unique one
+			*/
+			frand_copy(&td->buf_state_ret, &td->buf_state_prev);
+			return &td->buf_state_ret;
+		case DEDUPE_MODE_WORKING_SET:
+			i = rand_between(&td->dedupe_working_set_index_state, 0, td->num_unique_pages - 1);
+			frand_copy(&td->buf_state_ret, &td->dedupe_working_set_states[i]);
+			return &td->buf_state_ret;
+		default:
+			log_err("unexpected dedupe mode %u\n", td->o.dedupe_mode);
+			assert(0);
+		}
 
 	return &td->buf_state;
 }
diff --git a/lib/rand.c b/lib/rand.c
index 5eb6e60a..e74da609 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -125,10 +125,7 @@ void __fill_random_buf(void *buf, unsigned int len, uint64_t seed)
 uint64_t fill_random_buf(struct frand_state *fs, void *buf,
 			 unsigned int len)
 {
-	uint64_t r = __rand(fs);
-
-	if (sizeof(int) != sizeof(long *))
-		r *= (unsigned long) __rand(fs);
+	uint64_t r = __get_next_seed(fs);
 
 	__fill_random_buf(buf, len, r);
 	return r;
@@ -188,10 +185,7 @@ uint64_t fill_random_buf_percentage(struct frand_state *fs, void *buf,
 				    unsigned int segment, unsigned int len,
 				    char *pattern, unsigned int pbytes)
 {
-	uint64_t r = __rand(fs);
-
-	if (sizeof(int) != sizeof(long *))
-		r *= (unsigned long) __rand(fs);
+	uint64_t r = __get_next_seed(fs);
 
 	__fill_random_buf_percentage(r, buf, percentage, segment, len,
 					pattern, pbytes);
diff --git a/lib/rand.h b/lib/rand.h
index 46c1c5e0..a8060045 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -150,6 +150,16 @@ static inline uint64_t rand_between(struct frand_state *state, uint64_t start,
 		return start + rand32_upto(state, end - start);
 }
 
+static inline uint64_t __get_next_seed(struct frand_state *fs)
+{
+	uint64_t r = __rand(fs);
+
+	if (sizeof(int) != sizeof(long *))
+		r *= (unsigned long) __rand(fs);
+
+	return r;
+}
+
 extern void init_rand(struct frand_state *, bool);
 extern void init_rand_seed(struct frand_state *, uint64_t seed, bool);
 extern void __fill_random_buf(void *buf, unsigned int len, uint64_t seed);
diff --git a/options.c b/options.c
index a8986d11..8c2ab7cc 100644
--- a/options.c
+++ b/options.c
@@ -4497,6 +4497,40 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_BUF,
 	},
+	{
+		.name	= "dedupe_mode",
+		.lname	= "Dedupe mode",
+		.help	= "Mode for the deduplication buffer generation",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, dedupe_mode),
+		.parent	= "dedupe_percentage",
+		.def	= "repeat",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BUF,
+		.posval	= {
+			   { .ival = "repeat",
+			     .oval = DEDUPE_MODE_REPEAT,
+			     .help = "repeat previous page",
+			   },
+			   { .ival = "working_set",
+			     .oval = DEDUPE_MODE_WORKING_SET,
+			     .help = "choose a page randomly from limited working set defined in dedupe_working_set_percentage",
+			   },
+		},
+	},
+	{
+		.name	= "dedupe_working_set_percentage",
+		.lname	= "Dedupe working set percentage",
+		.help	= "Dedupe working set size in percentages from file or device size used to generate dedupe patterns from",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, dedupe_working_set_percentage),
+		.parent	= "dedupe_percentage",
+		.def	= "5",
+		.maxval	= 100,
+		.minval	= 0,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BUF,
+	},
 	{
 		.name	= "clat_percentiles",
 		.lname	= "Completion latency percentiles",
diff --git a/server.c b/server.c
index 8daefbab..42eaa4b1 100644
--- a/server.c
+++ b/server.c
@@ -409,8 +409,9 @@ struct fio_net_cmd *fio_net_recv_cmd(int sk, bool wait)
 			if (cmdret->opcode == FIO_NET_CMD_TEXT) {
 				struct cmd_text_pdu *__pdu = (struct cmd_text_pdu *) cmdret->payload;
 				char *buf = (char *) __pdu->buf;
+				int len = le32_to_cpu(__pdu->buf_len);
 
-				buf[__pdu->buf_len] = '\0';
+				buf[len] = '\0';
 			} else if (cmdret->opcode == FIO_NET_CMD_JOB) {
 				struct cmd_job_pdu *__pdu = (struct cmd_job_pdu *) cmdret->payload;
 				char *buf = (char *) __pdu->buf;
diff --git a/server.h b/server.h
index c128df28..daed057a 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 91,
+	FIO_SERVER_VER			= 92,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/dedupe.c b/t/dedupe.c
index 68d31f19..8b659c76 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -473,11 +473,14 @@ static void show_chunk(struct chunk *c)
 	}
 }
 
-static void show_stat(uint64_t nextents, uint64_t nchunks)
+static void show_stat(uint64_t nextents, uint64_t nchunks, uint64_t ndupextents)
 {
 	double perc, ratio;
 
-	printf("Extents=%lu, Unique extents=%lu\n", (unsigned long) nextents, (unsigned long) nchunks);
+	printf("Extents=%lu, Unique extents=%lu", (unsigned long) nextents, (unsigned long) nchunks);
+	if (!bloom)
+		printf(" Duplicated extents=%lu", (unsigned long) ndupextents);
+	printf("\n");
 
 	if (nchunks) {
 		ratio = (double) nextents / (double) nchunks;
@@ -485,17 +488,20 @@ static void show_stat(uint64_t nextents, uint64_t nchunks)
 	} else
 		printf("De-dupe ratio: 1:infinite\n");
 
+	if (ndupextents)
+		printf("De-dupe working set at least: %3.2f%%\n", 100.0 * (double) ndupextents / (double) nextents);
+
 	perc = 1.00 - ((double) nchunks / (double) nextents);
 	perc *= 100.0;
 	printf("Fio setting: dedupe_percentage=%u\n", (int) (perc + 0.50));
 
 }
 
-static void iter_rb_tree(uint64_t *nextents, uint64_t *nchunks)
+static void iter_rb_tree(uint64_t *nextents, uint64_t *nchunks, uint64_t *ndupextents)
 {
 	struct fio_rb_node *n;
 
-	*nchunks = *nextents = 0;
+	*nchunks = *nextents = *ndupextents = 0;
 
 	n = rb_first(&rb_root);
 	if (!n)
@@ -507,6 +513,7 @@ static void iter_rb_tree(uint64_t *nextents, uint64_t *nchunks)
 		c = rb_entry(n, struct chunk, rb_node);
 		(*nchunks)++;
 		*nextents += c->count;
+		*ndupextents += (c->count > 1);
 
 		if (dump_output)
 			show_chunk(c);
@@ -530,7 +537,7 @@ static int usage(char *argv[])
 
 int main(int argc, char *argv[])
 {
-	uint64_t nextents = 0, nchunks = 0;
+	uint64_t nextents = 0, nchunks = 0, ndupextents = 0;
 	int c, ret;
 
 	arch_init(argv);
@@ -583,9 +590,9 @@ int main(int argc, char *argv[])
 
 	if (!ret) {
 		if (!bloom)
-			iter_rb_tree(&nextents, &nchunks);
+			iter_rb_tree(&nextents, &nchunks, &ndupextents);
 
-		show_stat(nextents, nchunks);
+		show_stat(nextents, nchunks, ndupextents);
 	}
 
 	fio_sem_remove(rb_lock);
diff --git a/thread_options.h b/thread_options.h
index 05c2d138..4b4ecfe1 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -31,6 +31,14 @@ enum fio_memtype {
 	MEM_CUDA_MALLOC,/* use GPU memory */
 };
 
+/*
+ * What mode to use for deduped data generation
+ */
+enum dedupe_mode {
+	DEDUPE_MODE_REPEAT = 0,
+	DEDUPE_MODE_WORKING_SET = 1,
+};
+
 #define ERROR_STR_MAX	128
 
 #define BSSPLIT_MAX	64
@@ -243,6 +251,8 @@ struct thread_options {
 	unsigned int compress_percentage;
 	unsigned int compress_chunk;
 	unsigned int dedupe_percentage;
+	unsigned int dedupe_mode;
+	unsigned int dedupe_working_set_percentage;
 	unsigned int time_based;
 	unsigned int disable_lat;
 	unsigned int disable_clat;
@@ -549,6 +559,8 @@ struct thread_options_pack {
 	uint32_t compress_percentage;
 	uint32_t compress_chunk;
 	uint32_t dedupe_percentage;
+	uint32_t dedupe_mode;
+	uint32_t dedupe_working_set_percentage;
 	uint32_t time_based;
 	uint32_t disable_lat;
 	uint32_t disable_clat;

