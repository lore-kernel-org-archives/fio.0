Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbeD0MA3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 Apr 2018 08:00:29 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fC23B-0008Jx-5V
        for fio@vger.kernel.org; Fri, 27 Apr 2018 12:00:29 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180427120001.E18002C00CF@kernel.dk>
Date: Fri, 27 Apr 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ca0a0b521e8650ed736246c00092094a4d5c9829:

  t/*: missing statics (2018-04-24 14:03:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 43864deb3b4e24d5570ee4cb16cb626e94ec0465:

  iolog: default to good return (2018-04-26 22:45:04 -0600)

----------------------------------------------------------------
Jens Axboe (12):
      blktrace: don't re-clear ipo
      blktrace: ignore 0 byte writes
      iolog: always use calloc() and always init both lists
      blktrace: change barrier to a flush
      blktrace: handle flush/sync replay
      blktrace: kill zero sized write test
      blktrace: add 'reply_skip' option
      Makefile: ensure we kill all object files
      Update documentation for 'replay_skip'
      blktrace: make sure to account SYNC/TRIM at load time
      iolog/blktrace: boolean conversion
      iolog: default to good return

 HOWTO            |  8 +++++
 Makefile         |  2 +-
 backend.c        |  2 +-
 blktrace.c       | 94 ++++++++++++++++++++++++++++++++++++++------------------
 blktrace.h       | 14 ++++-----
 blktrace_api.h   |  2 +-
 cconv.c          |  2 ++
 fio.1            |  6 ++++
 iolog.c          | 36 ++++++++++++----------
 iolog.h          |  4 +--
 options.c        | 48 +++++++++++++++++++++++++++++
 server.h         |  2 +-
 thread_options.h |  2 ++
 13 files changed, 162 insertions(+), 60 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 8ee00fd..d200700 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2346,6 +2346,14 @@ I/O replay
 
 	Scale sector offsets down by this factor when replaying traces.
 
+.. option:: replay_skip=str
+
+	Sometimes it's useful to skip certain IO types in a replay trace.
+	This could be, for instance, eliminating the writes in the trace.
+	Or not replaying the trims/discards, if you are redirecting to
+	a device that doesn't support them. This option takes a comma
+	separated list of read, write, trim, sync.
+
 
 Threads, processes and job synchronization
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/Makefile b/Makefile
index 357ae98..20d3ec1 100644
--- a/Makefile
+++ b/Makefile
@@ -462,7 +462,7 @@ t/time-test: $(T_TT_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_TT_OBJS) $(LIBS)
 
 clean: FORCE
-	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d oslib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
+	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] profiles/*.[do] t/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 	@rm -rf  doc/output
 
 distclean: clean FORCE
diff --git a/backend.c b/backend.c
index d5cb6ef..033d5a7 100644
--- a/backend.c
+++ b/backend.c
@@ -1670,7 +1670,7 @@ static void *thread_main(void *data)
 	 * May alter parameters that init_io_u() will use, so we need to
 	 * do this first.
 	 */
-	if (init_iolog(td))
+	if (!init_iolog(td))
 		goto err;
 
 	if (init_io_u(td))
diff --git a/blktrace.c b/blktrace.c
index 71ac412..cda111a 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -73,29 +73,29 @@ static int discard_pdu(struct thread_data *td, struct fifo *fifo, int fd,
  * Check if this is a blktrace binary data file. We read a single trace
  * into memory and check for the magic signature.
  */
-int is_blktrace(const char *filename, int *need_swap)
+bool is_blktrace(const char *filename, int *need_swap)
 {
 	struct blk_io_trace t;
 	int fd, ret;
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0)
-		return 0;
+		return false;
 
 	ret = read(fd, &t, sizeof(t));
 	close(fd);
 
 	if (ret < 0) {
 		perror("read blktrace");
-		return 0;
+		return false;
 	} else if (ret != sizeof(t)) {
 		log_err("fio: short read on blktrace file\n");
-		return 0;
+		return false;
 	}
 
 	if ((t.magic & 0xffffff00) == BLK_IO_TRACE_MAGIC) {
 		*need_swap = 0;
-		return 1;
+		return true;
 	}
 
 	/*
@@ -104,10 +104,10 @@ int is_blktrace(const char *filename, int *need_swap)
 	t.magic = fio_swap32(t.magic);
 	if ((t.magic & 0xffffff00) == BLK_IO_TRACE_MAGIC) {
 		*need_swap = 1;
-		return 1;
+		return true;
 	}
 
-	return 0;
+	return false;
 }
 
 #define FMINORBITS	20
@@ -222,8 +222,9 @@ static void store_ipo(struct thread_data *td, unsigned long long offset,
 		      unsigned int bytes, int rw, unsigned long long ttime,
 		      int fileno, unsigned int bs)
 {
-	struct io_piece *ipo = malloc(sizeof(*ipo));
+	struct io_piece *ipo;
 
+	ipo = calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
 
 	ipo->offset = offset * bs;
@@ -268,10 +269,14 @@ static void handle_trace_discard(struct thread_data *td,
 				 unsigned long long ttime,
 				 unsigned long *ios, unsigned int *rw_bs)
 {
-	struct io_piece *ipo = malloc(sizeof(*ipo));
+	struct io_piece *ipo;
 	unsigned int bs;
 	int fileno;
 
+	if (td->o.replay_skip & (1u << DDIR_TRIM))
+		return;
+
+	ipo = calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
 	fileno = trace_add_file(td, t->device, &bs);
 
@@ -281,7 +286,6 @@ static void handle_trace_discard(struct thread_data *td,
 
 	td->o.size += t->bytes;
 
-	memset(ipo, 0, sizeof(*ipo));
 	INIT_FLIST_HEAD(&ipo->list);
 
 	ipo->offset = t->sector * bs;
@@ -311,6 +315,16 @@ static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 
 	rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
 
+	if (rw) {
+		if (td->o.replay_skip & (1u << DDIR_WRITE))
+			return;
+	} else {
+		if (td->o.replay_skip & (1u << DDIR_READ))
+			return;
+	}
+
+	assert(t->bytes);
+
 	if (t->bytes > rw_bs[rw])
 		rw_bs[rw] = t->bytes;
 
@@ -319,6 +333,29 @@ static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 	store_ipo(td, t->sector, t->bytes, rw, ttime, fileno, bs);
 }
 
+static void handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
+			       unsigned long long ttime, unsigned long *ios)
+{
+	struct io_piece *ipo;
+	unsigned int bs;
+	int fileno;
+
+	if (td->o.replay_skip & (1u << DDIR_SYNC))
+		return;
+
+	ipo = calloc(1, sizeof(*ipo));
+	init_ipo(ipo);
+	fileno = trace_add_file(td, t->device, &bs);
+
+	ipo->delay = ttime / 1000;
+	ipo->ddir = DDIR_SYNC;
+	ipo->fileno = fileno;
+
+	ios[DDIR_SYNC]++;
+	dprint(FD_BLKTRACE, "store flush delay=%lu\n", ipo->delay);
+	queue_io_piece(td, ipo);
+}
+
 /*
  * We only care for queue traces, most of the others are side effects
  * due to internal workings of the block layer.
@@ -354,6 +391,8 @@ static void handle_trace(struct thread_data *td, struct blk_io_trace *t,
 		handle_trace_notify(t);
 	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
 		handle_trace_discard(td, t, delay, ios, bs);
+	else if (t->action & BLK_TC_ACT(BLK_TC_FLUSH))
+		handle_trace_flush(td, t, delay, ios);
 	else
 		handle_trace_fs(td, t, delay, ios, bs);
 }
@@ -373,7 +412,7 @@ static void byteswap_trace(struct blk_io_trace *t)
 	t->pdu_len = fio_swap16(t->pdu_len);
 }
 
-static int t_is_write(struct blk_io_trace *t)
+static bool t_is_write(struct blk_io_trace *t)
 {
 	return (t->action & BLK_TC_ACT(BLK_TC_WRITE | BLK_TC_DISCARD)) != 0;
 }
@@ -423,20 +462,22 @@ static void depth_end(struct blk_io_trace *t, int *this_depth, int *depth)
  * Load a blktrace file by reading all the blk_io_trace entries, and storing
  * them as io_pieces like the fio text version would do.
  */
-int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
+bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 {
 	struct blk_io_trace t;
-	unsigned long ios[DDIR_RWDIR_CNT], skipped_writes;
-	unsigned int rw_bs[DDIR_RWDIR_CNT];
+	unsigned long ios[DDIR_RWDIR_SYNC_CNT] = { };
+	unsigned int rw_bs[DDIR_RWDIR_CNT] = { };
+	unsigned long skipped_writes;
 	struct fifo *fifo;
-	int fd, i, old_state;
+	int fd, i, old_state, max_depth;
 	struct fio_file *f;
-	int this_depth[DDIR_RWDIR_CNT], depth[DDIR_RWDIR_CNT], max_depth;
+	int this_depth[DDIR_RWDIR_CNT] = { };
+	int depth[DDIR_RWDIR_CNT] = { };
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
 		td_verror(td, errno, "open blktrace file");
-		return 1;
+		return false;
 	}
 
 	fifo = fifo_alloc(TRACE_FIFO_SIZE);
@@ -444,14 +485,6 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	old_state = td_bump_runstate(td, TD_SETTING_UP);
 
 	td->o.size = 0;
-
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		ios[i] = 0;
-		rw_bs[i] = 0;
-		this_depth[i] = 0;
-		depth[i] = 0;
-	}
-
 	skipped_writes = 0;
 	do {
 		int ret = trace_fifo_get(td, fifo, fd, &t, sizeof(t));
@@ -514,7 +547,7 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 
 	if (!td->files_index) {
 		log_err("fio: did not find replay device(s)\n");
-		return 1;
+		return false;
 	}
 
 	/*
@@ -534,9 +567,10 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 		log_err("fio: %s skips replay of %lu writes due to read-only\n",
 						td->o.name, skipped_writes);
 
-	if (!ios[DDIR_READ] && !ios[DDIR_WRITE]) {
+	if (!ios[DDIR_READ] && !ios[DDIR_WRITE] && !ios[DDIR_TRIM] &&
+	    !ios[DDIR_SYNC]) {
 		log_err("fio: found no ios in blktrace data\n");
-		return 1;
+		return false;
 	} else if (ios[DDIR_READ] && !ios[DDIR_WRITE]) {
 		td->o.td_ddir = TD_DDIR_READ;
 		td->o.max_bs[DDIR_READ] = rw_bs[DDIR_READ];
@@ -564,9 +598,9 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	if (!fio_option_is_set(&td->o, iodepth))
 		td->o.iodepth = td->o.iodepth_low = max_depth;
 
-	return 0;
+	return true;
 err:
 	close(fd);
 	fifo_free(fifo);
-	return 1;
+	return false;
 }
diff --git a/blktrace.h b/blktrace.h
index 8656a95..096993e 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -3,20 +3,20 @@
 
 #ifdef FIO_HAVE_BLKTRACE
 
-int is_blktrace(const char *, int *);
-int load_blktrace(struct thread_data *, const char *, int);
+bool is_blktrace(const char *, int *);
+bool load_blktrace(struct thread_data *, const char *, int);
 
 #else
 
-static inline int is_blktrace(const char *fname, int *need_swap)
+static inline bool is_blktrace(const char *fname, int *need_swap)
 {
-	return 0;
+	return false;
 }
 
-static inline int load_blktrace(struct thread_data *td, const char *fname,
-				int need_swap)
+static inline bool load_blktrace(struct thread_data *td, const char *fname,
+				 int need_swap)
 {
-	return 1;
+	return false;
 }
 
 #endif
diff --git a/blktrace_api.h b/blktrace_api.h
index e2d8cb3..32ce1d8 100644
--- a/blktrace_api.h
+++ b/blktrace_api.h
@@ -9,7 +9,7 @@
 enum {
 	BLK_TC_READ	= 1 << 0,	/* reads */
 	BLK_TC_WRITE	= 1 << 1,	/* writes */
-	BLK_TC_BARRIER	= 1 << 2,	/* barrier */
+	BLK_TC_FLUSH	= 1 << 2,	/* flush */
 	BLK_TC_SYNC	= 1 << 3,	/* sync */
 	BLK_TC_QUEUE	= 1 << 4,	/* queueing/merging */
 	BLK_TC_REQUEUE	= 1 << 5,	/* requeueing */
diff --git a/cconv.c b/cconv.c
index 9e163b3..bfd699d 100644
--- a/cconv.c
+++ b/cconv.c
@@ -290,6 +290,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
 	o->replay_time_scale = le32_to_cpu(top->replay_time_scale);
+	o->replay_skip = le32_to_cpu(top->replay_skip);
 	o->per_job_logs = le32_to_cpu(top->per_job_logs);
 	o->write_bw_log = le32_to_cpu(top->write_bw_log);
 	o->write_lat_log = le32_to_cpu(top->write_lat_log);
@@ -479,6 +480,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
 	top->replay_time_scale = cpu_to_le32(o->replay_time_scale);
+	top->replay_skip = cpu_to_le32(o->replay_skip);
 	top->per_job_logs = cpu_to_le32(o->per_job_logs);
 	top->write_bw_log = cpu_to_le32(o->write_bw_log);
 	top->write_lat_log = cpu_to_le32(o->write_lat_log);
diff --git a/fio.1 b/fio.1
index 24bdcdb..7d5d8be 100644
--- a/fio.1
+++ b/fio.1
@@ -2067,6 +2067,12 @@ value.
 Scale sector offsets down by this factor when replaying traces.
 .SS "Threads, processes and job synchronization"
 .TP
+.BI replay_skip \fR=\fPstr
+Sometimes it's useful to skip certain IO types in a replay trace. This could
+be, for instance, eliminating the writes in the trace. Or not replaying the
+trims/discards, if you are redirecting to a device that doesn't support them.
+This option takes a comma separated list of read, write, trim, sync.
+.TP
 .BI thread
 Fio defaults to creating jobs by using fork, however if this option is
 given, fio will create jobs by using POSIX Threads' function
diff --git a/iolog.c b/iolog.c
index 74c89f0..6e44119 100644
--- a/iolog.c
+++ b/iolog.c
@@ -211,7 +211,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	struct fio_rb_node **p, *parent;
 	struct io_piece *ipo, *__ipo;
 
-	ipo = malloc(sizeof(struct io_piece));
+	ipo = calloc(1, sizeof(struct io_piece));
 	init_ipo(ipo);
 	ipo->file = io_u->file;
 	ipo->offset = io_u->offset;
@@ -338,7 +338,7 @@ void write_iolog_close(struct thread_data *td)
  * Read version 2 iolog data. It is enhanced to include per-file logging,
  * syncs, etc.
  */
-static int read_iolog2(struct thread_data *td, FILE *f)
+static bool read_iolog2(struct thread_data *td, FILE *f)
 {
 	unsigned long long offset;
 	unsigned int bytes;
@@ -440,7 +440,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 		/*
 		 * Make note of file
 		 */
-		ipo = malloc(sizeof(*ipo));
+		ipo = calloc(1, sizeof(*ipo));
 		init_ipo(ipo);
 		ipo->ddir = rw;
 		if (rw == DDIR_WAIT) {
@@ -474,7 +474,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 	}
 
 	if (!reads && !writes && !waits)
-		return 1;
+		return false;
 	else if (reads && !writes)
 		td->o.td_ddir = TD_DDIR_READ;
 	else if (!reads && writes)
@@ -482,22 +482,22 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 	else
 		td->o.td_ddir = TD_DDIR_RW;
 
-	return 0;
+	return true;
 }
 
 /*
  * open iolog, check version, and call appropriate parser
  */
-static int init_iolog_read(struct thread_data *td)
+static bool init_iolog_read(struct thread_data *td)
 {
 	char buffer[256], *p;
 	FILE *f;
-	int ret;
+	bool ret;
 
 	f = fopen(td->o.read_iolog_file, "r");
 	if (!f) {
 		perror("fopen read iolog");
-		return 1;
+		return false;
 	}
 
 	p = fgets(buffer, sizeof(buffer), f);
@@ -505,7 +505,7 @@ static int init_iolog_read(struct thread_data *td)
 		td_verror(td, errno, "iolog read");
 		log_err("fio: unable to read iolog\n");
 		fclose(f);
-		return 1;
+		return false;
 	}
 
 	/*
@@ -516,7 +516,7 @@ static int init_iolog_read(struct thread_data *td)
 		ret = read_iolog2(td, f);
 	else {
 		log_err("fio: iolog version 1 is no longer supported\n");
-		ret = 1;
+		ret = false;
 	}
 
 	fclose(f);
@@ -526,7 +526,7 @@ static int init_iolog_read(struct thread_data *td)
 /*
  * Set up a log for storing io patterns.
  */
-static int init_iolog_write(struct thread_data *td)
+static bool init_iolog_write(struct thread_data *td)
 {
 	struct fio_file *ff;
 	FILE *f;
@@ -535,7 +535,7 @@ static int init_iolog_write(struct thread_data *td)
 	f = fopen(td->o.write_iolog_file, "a");
 	if (!f) {
 		perror("fopen write iolog");
-		return 1;
+		return false;
 	}
 
 	/*
@@ -550,7 +550,7 @@ static int init_iolog_write(struct thread_data *td)
 	 */
 	if (fprintf(f, "%s\n", iolog_ver2) < 0) {
 		perror("iolog init\n");
-		return 1;
+		return false;
 	}
 
 	/*
@@ -559,12 +559,12 @@ static int init_iolog_write(struct thread_data *td)
 	for_each_file(td, ff, i)
 		log_file(td, ff, FIO_LOG_ADD_FILE);
 
-	return 0;
+	return true;
 }
 
-int init_iolog(struct thread_data *td)
+bool init_iolog(struct thread_data *td)
 {
-	int ret = 0;
+	bool ret;
 
 	if (td->o.read_iolog_file) {
 		int need_swap;
@@ -579,8 +579,10 @@ int init_iolog(struct thread_data *td)
 			ret = init_iolog_read(td);
 	} else if (td->o.write_iolog_file)
 		ret = init_iolog_write(td);
+	else
+		ret = true;
 
-	if (ret)
+	if (!ret)
 		td_verror(td, EINVAL, "failed initializing iolog");
 
 	return ret;
diff --git a/iolog.h b/iolog.h
index f70eb61..60b4f01 100644
--- a/iolog.h
+++ b/iolog.h
@@ -234,7 +234,7 @@ struct io_u;
 extern int __must_check read_iolog_get(struct thread_data *, struct io_u *);
 extern void log_io_u(const struct thread_data *, const struct io_u *);
 extern void log_file(struct thread_data *, struct fio_file *, enum file_log_act);
-extern int __must_check init_iolog(struct thread_data *td);
+extern bool __must_check init_iolog(struct thread_data *td);
 extern void log_io_piece(struct thread_data *, struct io_u *);
 extern void unlog_io_piece(struct thread_data *, struct io_u *);
 extern void trim_io_piece(struct thread_data *, const struct io_u *);
@@ -296,7 +296,7 @@ extern int iolog_cur_flush(struct io_log *, struct io_logs *);
 
 static inline void init_ipo(struct io_piece *ipo)
 {
-	memset(ipo, 0, sizeof(*ipo));
+	INIT_FLIST_HEAD(&ipo->list);
 	INIT_FLIST_HEAD(&ipo->trim_list);
 }
 
diff --git a/options.c b/options.c
index 0b3a895..047e493 100644
--- a/options.c
+++ b/options.c
@@ -342,6 +342,43 @@ static int ignore_error_type(struct thread_data *td, enum error_type_bit etype,
 
 }
 
+static int str_replay_skip_cb(void *data, const char *input)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	char *str, *p, *n;
+	int ret = 0;
+
+	if (parse_dryrun())
+		return 0;
+
+	p = str = strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	while (p) {
+		n = strchr(p, ',');
+		if (n)
+			*n++ = '\0';
+		if (!strcmp(p, "read"))
+			td->o.replay_skip |= 1u << DDIR_READ;
+		else if (!strcmp(p, "write"))
+			td->o.replay_skip |= 1u << DDIR_WRITE;
+		else if (!strcmp(p, "trim"))
+			td->o.replay_skip |= 1u << DDIR_TRIM;
+		else if (!strcmp(p, "sync"))
+			td->o.replay_skip |= 1u << DDIR_SYNC;
+		else {
+			log_err("Unknown skip type: %s\n", p);
+			ret = 1;
+			break;
+		}
+		p = n;
+	}
+	free(str);
+	return ret;
+}
+
 static int str_ignore_error_cb(void *data, const char *input)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -3159,6 +3196,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IOLOG,
 	},
 	{
+		.name	= "replay_skip",
+		.lname	= "Replay Skip",
+		.type	= FIO_OPT_STR,
+		.cb	= str_replay_skip_cb,
+		.off1	= offsetof(struct thread_options, replay_skip),
+		.parent	= "read_iolog",
+		.help	= "Skip certain IO types (read,write,trim,flush)",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IOLOG,
+	},
+	{
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
 		.type	= FIO_OPT_STR_STORE,
diff --git a/server.h b/server.h
index 4896860..b48bbe1 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 72,
+	FIO_SERVER_VER			= 73,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 4ec570d..52026e3 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -316,6 +316,7 @@ struct thread_options {
 	unsigned int replay_align;
 	unsigned int replay_scale;
 	unsigned int replay_time_scale;
+	unsigned int replay_skip;
 
 	unsigned int per_job_logs;
 
@@ -590,6 +591,7 @@ struct thread_options_pack {
 	uint32_t replay_align;
 	uint32_t replay_scale;
 	uint32_t replay_time_scale;
+	uint32_t replay_skip;
 
 	uint32_t per_job_logs;
 
