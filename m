Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaIWMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Sep 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XWOlH-0003ev-UV
	for fio@vger.kernel.org; Tue, 23 Sep 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140923120002.F3247401E7@lyth.info>
Date: Tue, 23 Sep 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8fc46b4d03bc61c4e72b69c3bc59bd50c4943e03:

  btrace2fio: expand rate options, bug fixes (2014-09-18 17:23:55 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c0b69b92fb155424946b19228da9be0924e9e96c:

  dedupe: if percentage is 100, don't go through random + math (2014-09-22 14:20:05 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Basic support for dedupe
      dedupe: if percentage is 100, don't go through random + math

 HOWTO            |   20 ++++++++++++++------
 cconv.c          |    2 ++
 fio.1            |    7 +++++++
 fio.h            |    3 +++
 init.c           |    7 ++++++-
 io_u.c           |   41 +++++++++++++++++++++++++++++++++++++----
 lib/rand.h       |    8 ++++++++
 options.c        |   22 ++++++++++++++++++++++
 server.h         |    2 +-
 thread_options.h |    6 ++++--
 10 files changed, 104 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 73e58ff..23746ce 100644
--- a/HOWTO
+++ b/HOWTO
@@ -565,12 +565,20 @@ buffer_compress_chunk=int	See buffer_compress_percentage. This
 		alternate random and zeroed data throughout the IO
 		buffer.
 
-buffer_pattern=str	If set, fio will fill the io buffers with this pattern.
-		If not set, the contents of io buffers is defined by the other
-		options related to buffer contents. The setting can be any
-		pattern of bytes, and can be prefixed with 0x for hex values.
-		It may also be a string, where the string must then be
-		wrapped with "".
+buffer_pattern=str	If set, fio will fill the io buffers with this
+		pattern. If not set, the contents of io buffers is defined by
+		the other options related to buffer contents. The setting can
+		be any pattern of bytes, and can be prefixed with 0x for hex
+		values. It may also be a string, where the string must then
+		be wrapped with "".
+
+dedupe_percentage=int	If set, fio will generate this percentage of
+		identical buffers when writing. These buffers will be
+		naturally dedupable. The contents of the buffers depend on
+		what other buffer compression settings have been set. It's
+		possible to have the individual buffers either fully
+		compressible, or not at all. This option only controls the
+		distribution of unique buffers.
 
 nrfiles=int	Number of files to use for this job. Defaults to 1.
 
diff --git a/cconv.c b/cconv.c
index d4fb158..4a40ed0 100644
--- a/cconv.c
+++ b/cconv.c
@@ -241,6 +241,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->latency_percentile.u.f = fio_uint64_to_double(le64_to_cpu(top->latency_percentile.u.i));
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
 	o->compress_chunk = le32_to_cpu(top->compress_chunk);
+	o->dedupe_percentage = le32_to_cpu(top->dedupe_percentage);
 
 	o->trim_backlog = le64_to_cpu(top->trim_backlog);
 
@@ -401,6 +402,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->latency_percentile.u.i = __cpu_to_le64(fio_double_to_uint64(o->latency_percentile.u.f));
 	top->compress_percentage = cpu_to_le32(o->compress_percentage);
 	top->compress_chunk = cpu_to_le32(o->compress_chunk);
+	top->dedupe_percentage = cpu_to_le32(o->dedupe_percentage);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		top->bs[i] = cpu_to_le32(o->bs[i]);
diff --git a/fio.1 b/fio.1
index e3334bd..bc6c9fa 100644
--- a/fio.1
+++ b/fio.1
@@ -481,6 +481,13 @@ setting can be any pattern of bytes, and can be prefixed with 0x for hex
 values. It may also be a string, where the string must then be wrapped with
 "".
 .TP
+.BI dedupe_percentage \fR=\fPint
+If set, fio will generate this percentage of identical buffers when writing.
+These buffers will be naturally dedupable. The contents of the buffers depend
+on what other buffer compression settings have been set. It's possible to have
+the individual buffers either fully compressible, or not at all. This option
+only controls the distribution of unique buffers.
+.TP
 .BI nrfiles \fR=\fPint
 Number of files to use for this job.  Default: 1.
 .TP
diff --git a/fio.h b/fio.h
index dfbad6d..136b430 100644
--- a/fio.h
+++ b/fio.h
@@ -89,6 +89,7 @@ enum {
 	FIO_RAND_SEQ_RAND_WRITE_OFF,
 	FIO_RAND_SEQ_RAND_TRIM_OFF,
 	FIO_RAND_START_DELAY,
+	FIO_DEDUPE_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -177,6 +178,8 @@ struct thread_data {
 	};
 
 	struct frand_state buf_state;
+	struct frand_state buf_state_prev;
+	struct frand_state dedupe_state;
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
diff --git a/init.c b/init.c
index 62c7dc2..5b0290d 100644
--- a/init.c
+++ b/init.c
@@ -836,7 +836,9 @@ static void td_fill_rand_seeds_internal(struct thread_data *td)
 void td_fill_rand_seeds(struct thread_data *td)
 {
 	if (td->o.allrand_repeatable) {
-		for (int i = 0; i < FIO_RAND_NR_OFFS; i++)
+		unsigned int i;
+
+		for (i = 0; i < FIO_RAND_NR_OFFS; i++)
 			td->rand_seeds[i] = FIO_RANDSEED * td->thread_number
 			       	+ i;
 	}
@@ -847,6 +849,9 @@ void td_fill_rand_seeds(struct thread_data *td)
 		td_fill_rand_seeds_internal(td);
 
 	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF]);
+	frand_copy(&td->buf_state_prev, &td->buf_state);
+
+	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF]);
 }
 
 /*
diff --git a/io_u.c b/io_u.c
index 7cbdb91..eac871b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1828,6 +1828,34 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 	}
 }
 
+/*
+ * See if we should reuse the last seed, if dedupe is enabled
+ */
+static struct frand_state *get_buf_state(struct thread_data *td)
+{
+	unsigned int v;
+	unsigned long r;
+
+	if (!td->o.dedupe_percentage)
+		return &td->buf_state;
+	else if (td->o.dedupe_percentage == 100)
+		return &td->buf_state_prev;
+
+	r = __rand(&td->dedupe_state);
+	v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
+
+	if (v <= td->o.dedupe_percentage)
+		return &td->buf_state_prev;
+
+	return &td->buf_state;
+}
+
+static void save_buf_state(struct thread_data *td, struct frand_state *rs)
+{
+	if (rs == &td->buf_state)
+		frand_copy(&td->buf_state_prev, rs);
+}
+
 void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 		    unsigned int max_bs)
 {
@@ -1835,6 +1863,9 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 		fill_buffer_pattern(td, buf, max_bs);
 	else if (!td->o.zero_buffers) {
 		unsigned int perc = td->o.compress_percentage;
+		struct frand_state *rs;
+
+		rs = get_buf_state(td);
 
 		if (perc) {
 			unsigned int seg = min_write;
@@ -1843,10 +1874,12 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 			if (!seg)
 				seg = min_write;
 
-			fill_random_buf_percentage(&td->buf_state, buf,
-						perc, seg, max_bs);
-		} else
-			fill_random_buf(&td->buf_state, buf, max_bs);
+			fill_random_buf_percentage(rs, buf, perc, seg,max_bs);
+			save_buf_state(td, rs);
+		} else {
+			fill_random_buf(rs, buf, max_bs);
+			save_buf_state(td, rs);
+		}
 	} else
 		memset(buf, 0, max_bs);
 }
diff --git a/lib/rand.h b/lib/rand.h
index d62ebe5..8c35ab1 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -7,6 +7,14 @@ struct frand_state {
 	unsigned int s1, s2, s3;
 };
 
+static inline void frand_copy(struct frand_state *dst,
+			      struct frand_state *src)
+{
+	dst->s1 = src->s1;
+	dst->s2 = src->s2;
+	dst->s3 = src->s3;
+}
+
 static inline unsigned int __rand(struct frand_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
diff --git a/options.c b/options.c
index ce95513..593f717 100644
--- a/options.c
+++ b/options.c
@@ -1050,6 +1050,16 @@ static int str_buffer_compress_cb(void *data, unsigned long long *il)
 	return 0;
 }
 
+static int str_dedupe_cb(void *data, unsigned long long *il)
+{
+	struct thread_data *td = data;
+
+	td->flags |= TD_F_COMPRESS;
+	td->o.dedupe_percentage = *il;
+	td->o.refill_buffers = 1;
+	return 0;
+}
+
 static int str_verify_pattern_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
@@ -3257,6 +3267,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_BUF,
 	},
 	{
+		.name	= "dedupe_percentage",
+		.lname	= "Dedupe percentage",
+		.type	= FIO_OPT_INT,
+		.cb	= str_dedupe_cb,
+		.maxval	= 100,
+		.minval	= 0,
+		.help	= "Percentage of buffers that are dedupable",
+		.interval = 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BUF,
+	},
+	{
 		.name	= "clat_percentiles",
 		.lname	= "Completion latency percentiles",
 		.type	= FIO_OPT_BOOL,
diff --git a/server.h b/server.h
index cc4c5b4..1b131b9 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 35,
+	FIO_SERVER_VER			= 36,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index e545a8f..a45d7b7 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -184,6 +184,7 @@ struct thread_options {
 	unsigned int buffer_pattern_bytes;
 	unsigned int compress_percentage;
 	unsigned int compress_chunk;
+	unsigned int dedupe_percentage;
 	unsigned int time_based;
 	unsigned int disable_lat;
 	unsigned int disable_clat;
@@ -403,8 +404,9 @@ struct thread_options_pack {
 	uint32_t scramble_buffers;
 	uint8_t buffer_pattern[MAX_PATTERN_SIZE];
 	uint32_t buffer_pattern_bytes;
-	unsigned int compress_percentage;
-	unsigned int compress_chunk;
+	uint32_t compress_percentage;
+	uint32_t compress_chunk;
+	uint32_t dedupe_percentage;
 	uint32_t time_based;
 	uint32_t disable_lat;
 	uint32_t disable_clat;
