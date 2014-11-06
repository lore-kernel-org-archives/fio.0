Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKFNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Nov 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XmMfV-0003Zb-9C
	for fio@vger.kernel.org; Thu, 06 Nov 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141106130002.E242D40152@lyth.info>
Date: Thu,  6 Nov 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 239b2882f467676b232e9e20b72c287b77bd3daa:

  Add basic DragonFly support (2014-11-04 19:53:04 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d6b72507e72d3f2ed334fa5665880b0ab59dbfdd:

  Get rid of __ prefix for internal frand state (2014-11-05 18:39:23 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Remove use of OS provided random functions
      Get rid of __ prefix for internal frand state

 HOWTO            |    6 ------
 backend.c        |    4 ++--
 cconv.c          |    2 --
 filesetup.c      |   13 +++---------
 fio.1            |    6 ------
 fio.h            |   43 ++++++++-----------------------------
 init.c           |   62 ++++++++++++------------------------------------------
 io_u.c           |   58 +++++++++++---------------------------------------
 options.c        |    8 ++-----
 thread_options.h |    4 ++--
 trim.c           |    9 ++------
 verify.c         |    6 +++---
 12 files changed, 49 insertions(+), 172 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index e18eadb..73be9d7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -439,12 +439,6 @@ randseed=int	Seed the random number generators based on this seed value, to
 		If not set, the random sequence depends on the randrepeat
 		setting.
 
-use_os_rand=bool Fio can either use the random generator supplied by the OS
-		to generator random offsets, or it can use it's own internal
-		generator (based on Tausworthe). Default is to use the
-		internal generator, which is often of better quality and
-		faster.
-
 fallocate=str	Whether pre-allocation is performed when laying down files.
 		Accepted values are:
 
diff --git a/backend.c b/backend.c
index d19d870..cae4e38 100644
--- a/backend.c
+++ b/backend.c
@@ -753,9 +753,9 @@ static uint64_t do_io(struct thread_data *td)
 		    ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
 
 			if (!td->o.verify_pattern_bytes) {
-				io_u->rand_seed = __rand(&td->__verify_state);
+				io_u->rand_seed = __rand(&td->verify_state);
 				if (sizeof(int) != sizeof(long *))
-					io_u->rand_seed *= __rand(&td->__verify_state);
+					io_u->rand_seed *= __rand(&td->verify_state);
 			}
 
 			if (td->o.verify_async)
diff --git a/cconv.c b/cconv.c
index 4a40ed0..607cede 100644
--- a/cconv.c
+++ b/cconv.c
@@ -149,7 +149,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->rand_repeatable = le32_to_cpu(top->rand_repeatable);
 	o->allrand_repeatable = le32_to_cpu(top->allrand_repeatable);
 	o->rand_seed = le64_to_cpu(top->rand_seed);
-	o->use_os_rand = le32_to_cpu(top->use_os_rand);
 	o->log_avg_msec = le32_to_cpu(top->log_avg_msec);
 	o->log_offset = le32_to_cpu(top->log_offset);
 	o->log_gz = le32_to_cpu(top->log_gz);
@@ -323,7 +322,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->rand_repeatable = cpu_to_le32(o->rand_repeatable);
 	top->allrand_repeatable = cpu_to_le32(o->allrand_repeatable);
 	top->rand_seed = __cpu_to_le64(o->rand_seed);
-	top->use_os_rand = cpu_to_le32(o->use_os_rand);
 	top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
 	top->log_offset = cpu_to_le32(o->log_offset);
 	top->log_gz = cpu_to_le32(o->log_gz);
diff --git a/filesetup.c b/filesetup.c
index 43146ba..4026f4d 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -261,16 +261,9 @@ static unsigned long long get_rand_file_size(struct thread_data *td)
 	unsigned long long ret, sized;
 	unsigned long r;
 
-	if (td->o.use_os_rand) {
-		r = os_random_long(&td->file_size_state);
-		sized = td->o.file_size_high - td->o.file_size_low;
-		ret = (unsigned long long) ((double) sized * (r / (OS_RAND_MAX + 1.0)));
-	} else {
-		r = __rand(&td->__file_size_state);
-		sized = td->o.file_size_high - td->o.file_size_low;
-		ret = (unsigned long long) ((double) sized * (r / (FRAND_MAX + 1.0)));
-	}
-
+	r = __rand(&td->file_size_state);
+	sized = td->o.file_size_high - td->o.file_size_low;
+	ret = (unsigned long long) ((double) sized * (r / (FRAND_MAX + 1.0)));
 	ret += td->o.file_size_low;
 	ret -= (ret % td->o.rw_min_bs);
 	return ret;
diff --git a/fio.1 b/fio.1
index 8d02632..82868a8 100644
--- a/fio.1
+++ b/fio.1
@@ -347,12 +347,6 @@ Seed the random number generators based on this seed value, to be able to
 control what sequence of output is being generated. If not set, the random
 sequence depends on the \fBrandrepeat\fR setting.
 .TP
-.BI use_os_rand \fR=\fPbool
-Fio can either use the random generator supplied by the OS to generate random
-offsets, or it can use its own internal generator (based on Tausworthe).
-Default is to use the internal generator, which is often of better quality and
-faster. Default: false.
-.TP
 .BI fallocate \fR=\fPstr
 Whether pre-allocation is performed when laying down files. Accepted values
 are:
diff --git a/fio.h b/fio.h
index f453d92..28f4597 100644
--- a/fio.h
+++ b/fio.h
@@ -137,8 +137,7 @@ struct thread_data {
 	unsigned int nr_normal_files;
 	union {
 		unsigned int next_file;
-		os_random_state_t next_file_state;
-		struct frand_state __next_file_state;
+		struct frand_state next_file_state;
 	};
 	int error;
 	int sig;
@@ -160,22 +159,10 @@ struct thread_data {
 
 	unsigned long rand_seeds[FIO_RAND_NR_OFFS];
 
-	union {
-		os_random_state_t bsrange_state;
-		struct frand_state __bsrange_state;
-	};
-	union {
-		os_random_state_t verify_state;
-		struct frand_state __verify_state;
-	};
-	union {
-		os_random_state_t trim_state;
-		struct frand_state __trim_state;
-	};
-	union {
-		os_random_state_t delay_state;
-		struct frand_state __delay_state;
-	};
+	struct frand_state bsrange_state;
+	struct frand_state verify_state;
+	struct frand_state trim_state;
+	struct frand_state delay_state;
 
 	struct frand_state buf_state;
 	struct frand_state buf_state_prev;
@@ -249,10 +236,7 @@ struct thread_data {
 	/*
 	 * State for random io, a bitmap of blocks done vs not done
 	 */
-	union {
-		os_random_state_t random_state;
-		struct frand_state __random_state;
-	};
+	struct frand_state random_state;
 
 	struct timeval start;	/* start of this loop */
 	struct timeval epoch;	/* time job was started */
@@ -277,10 +261,7 @@ struct thread_data {
 	/*
 	 * read/write mixed workload state
 	 */
-	union {
-		os_random_state_t rwmix_state;
-		struct frand_state __rwmix_state;
-	};
+	struct frand_state rwmix_state;
 	unsigned long rwmix_issues;
 	enum fio_ddir rwmix_ddir;
 	unsigned int ddir_seq_nr;
@@ -288,10 +269,7 @@ struct thread_data {
 	/*
 	 * rand/seq mixed workload state
 	 */
-	union {
-		os_random_state_t seq_rand_state[DDIR_RWDIR_CNT];
-		struct frand_state __seq_rand_state[DDIR_RWDIR_CNT];
-	};
+	struct frand_state seq_rand_state[DDIR_RWDIR_CNT];
 
 	/*
 	 * IO history logs for verification. We use a tree for sorting,
@@ -326,10 +304,7 @@ struct thread_data {
 	/*
 	 * For generating file sizes
 	 */
-	union {
-		os_random_state_t file_size_state;
-		struct frand_state __file_size_state;
-	};
+	struct frand_state file_size_state;
 
 	/*
 	 * Error counts
diff --git a/init.c b/init.c
index 1768478..c2c126b 100644
--- a/init.c
+++ b/init.c
@@ -470,13 +470,8 @@ static unsigned long long get_rand_start_delay(struct thread_data *td)
 
 	delayrange = td->o.start_delay_high - td->o.start_delay;
 
-	if (td->o.use_os_rand) {
-		r = os_random_long(&td->delay_state);
-		delayrange = (unsigned long long) ((double) delayrange * (r / (OS_RAND_MAX + 1.0)));
-	} else {
-		r = __rand(&td->__delay_state);
-		delayrange = (unsigned long long) ((double) delayrange * (r / (FRAND_MAX + 1.0)));
-	}
+	r = __rand(&td->delay_state);
+	delayrange = (unsigned long long) ((double) delayrange * (r / (FRAND_MAX + 1.0)));
 
 	delayrange += td->o.start_delay;
 	return delayrange;
@@ -787,44 +782,18 @@ static int exists_and_not_file(const char *filename)
 	return 1;
 }
 
-static void td_fill_rand_seeds_os(struct thread_data *td)
-{
-	os_random_seed(td->rand_seeds[FIO_RAND_BS_OFF], &td->bsrange_state);
-	os_random_seed(td->rand_seeds[FIO_RAND_VER_OFF], &td->verify_state);
-	os_random_seed(td->rand_seeds[FIO_RAND_MIX_OFF], &td->rwmix_state);
-
-	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
-		os_random_seed(td->rand_seeds[FIO_RAND_FILE_OFF], &td->next_file_state);
-
-	os_random_seed(td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], &td->file_size_state);
-	os_random_seed(td->rand_seeds[FIO_RAND_TRIM_OFF], &td->trim_state);
-	os_random_seed(td->rand_seeds[FIO_RAND_START_DELAY], &td->delay_state);
-
-	if (!td_random(td))
-		return;
-
-	if (td->o.rand_repeatable)
-		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
-
-	os_random_seed(td->rand_seeds[FIO_RAND_BLOCK_OFF], &td->random_state);
-
-	os_random_seed(td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF], &td->seq_rand_state[DDIR_READ]);
-	os_random_seed(td->rand_seeds[FIO_RAND_SEQ_RAND_WRITE_OFF], &td->seq_rand_state[DDIR_WRITE]);
-	os_random_seed(td->rand_seeds[FIO_RAND_SEQ_RAND_TRIM_OFF], &td->seq_rand_state[DDIR_TRIM]);
-}
-
 static void td_fill_rand_seeds_internal(struct thread_data *td)
 {
-	init_rand_seed(&td->__bsrange_state, td->rand_seeds[FIO_RAND_BS_OFF]);
-	init_rand_seed(&td->__verify_state, td->rand_seeds[FIO_RAND_VER_OFF]);
-	init_rand_seed(&td->__rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF]);
+	init_rand_seed(&td->bsrange_state, td->rand_seeds[FIO_RAND_BS_OFF]);
+	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF]);
+	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF]);
 
 	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
-		init_rand_seed(&td->__next_file_state, td->rand_seeds[FIO_RAND_FILE_OFF]);
+		init_rand_seed(&td->next_file_state, td->rand_seeds[FIO_RAND_FILE_OFF]);
 
-	init_rand_seed(&td->__file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF]);
-	init_rand_seed(&td->__trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF]);
-	init_rand_seed(&td->__delay_state, td->rand_seeds[FIO_RAND_START_DELAY]);
+	init_rand_seed(&td->file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF]);
+	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF]);
+	init_rand_seed(&td->delay_state, td->rand_seeds[FIO_RAND_START_DELAY]);
 
 	if (!td_random(td))
 		return;
@@ -832,10 +801,10 @@ static void td_fill_rand_seeds_internal(struct thread_data *td)
 	if (td->o.rand_repeatable)
 		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
 
-	init_rand_seed(&td->__random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
-	init_rand_seed(&td->__seq_rand_state[DDIR_READ], td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF]);
-	init_rand_seed(&td->__seq_rand_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_SEQ_RAND_WRITE_OFF]);
-	init_rand_seed(&td->__seq_rand_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_SEQ_RAND_TRIM_OFF]);
+	init_rand_seed(&td->random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
+	init_rand_seed(&td->seq_rand_state[DDIR_READ], td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF]);
+	init_rand_seed(&td->seq_rand_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_SEQ_RAND_WRITE_OFF]);
+	init_rand_seed(&td->seq_rand_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_SEQ_RAND_TRIM_OFF]);
 }
 
 void td_fill_rand_seeds(struct thread_data *td)
@@ -848,10 +817,7 @@ void td_fill_rand_seeds(struct thread_data *td)
 			       	+ i;
 	}
 
-	if (td->o.use_os_rand)
-		td_fill_rand_seeds_os(td);
-	else
-		td_fill_rand_seeds_internal(td);
+	td_fill_rand_seeds_internal(td);
 
 	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF]);
 	frand_copy(&td->buf_state_prev, &td->buf_state);
diff --git a/io_u.c b/io_u.c
index 612057d..d815ad9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -90,21 +90,11 @@ static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 		return 1;
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE) {
-		uint64_t rmax;
-
-		rmax = td->o.use_os_rand ? OS_RAND_MAX : FRAND_MAX;
-
-		if (td->o.use_os_rand) {
-			rmax = OS_RAND_MAX;
-			r = os_random_long(&td->random_state);
-		} else {
-			rmax = FRAND_MAX;
-			r = __rand(&td->__random_state);
-		}
+		r = __rand(&td->random_state);
 
 		dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
 
-		*b = lastb * (r / ((uint64_t) rmax + 1.0));
+		*b = lastb * (r / ((uint64_t) FRAND_MAX + 1.0));
 	} else {
 		uint64_t off = 0;
 
@@ -200,13 +190,8 @@ static int should_do_random(struct thread_data *td, enum fio_ddir ddir)
 	if (td->o.perc_rand[ddir] == 100)
 		return 1;
 
-	if (td->o.use_os_rand) {
-		r = os_random_long(&td->seq_rand_state[ddir]);
-		v = 1 + (int) (100.0 * (r / (OS_RAND_MAX + 1.0)));
-	} else {
-		r = __rand(&td->__seq_rand_state[ddir]);
-		v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
-	}
+	r = __rand(&td->seq_rand_state[ddir]);
+	v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
 
 	return v <= td->o.perc_rand[ddir];
 }
@@ -436,7 +421,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	int ddir = io_u->ddir;
 	unsigned int buflen = 0;
 	unsigned int minbs, maxbs;
-	unsigned long r, rand_max;
+	unsigned long r;
 
 	assert(ddir_rw(ddir));
 
@@ -455,20 +440,12 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	if (!io_u_fits(td, io_u, minbs))
 		return 0;
 
-	if (td->o.use_os_rand)
-		rand_max = OS_RAND_MAX;
-	else
-		rand_max = FRAND_MAX;
-
 	do {
-		if (td->o.use_os_rand)
-			r = os_random_long(&td->bsrange_state);
-		else
-			r = __rand(&td->__bsrange_state);
+		r = __rand(&td->bsrange_state);
 
 		if (!td->o.bssplit_nr[ddir]) {
 			buflen = 1 + (unsigned int) ((double) maxbs *
-					(r / (rand_max + 1.0)));
+					(r / (FRAND_MAX + 1.0)));
 			if (buflen < minbs)
 				buflen = minbs;
 		} else {
@@ -480,7 +457,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 
 				buflen = bsp->bs;
 				perc += bsp->perc;
-				if ((r <= ((rand_max / 100L) * perc)) &&
+				if ((r <= ((FRAND_MAX / 100L) * perc)) &&
 				    io_u_fits(td, io_u, buflen))
 					break;
 			}
@@ -529,13 +506,8 @@ static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 	unsigned int v;
 	unsigned long r;
 
-	if (td->o.use_os_rand) {
-		r = os_random_long(&td->rwmix_state);
-		v = 1 + (int) (100.0 * (r / (OS_RAND_MAX + 1.0)));
-	} else {
-		r = __rand(&td->__rwmix_state);
-		v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
-	}
+	r = __rand(&td->rwmix_state);
+	v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
 
 	if (v <= td->o.rwmix[DDIR_READ])
 		return DDIR_READ;
@@ -987,15 +959,9 @@ static struct fio_file *get_next_file_rand(struct thread_data *td,
 		int opened = 0;
 		unsigned long r;
 
-		if (td->o.use_os_rand) {
-			r = os_random_long(&td->next_file_state);
-			fno = (unsigned int) ((double) td->o.nr_files
-				* (r / (OS_RAND_MAX + 1.0)));
-		} else {
-			r = __rand(&td->__next_file_state);
-			fno = (unsigned int) ((double) td->o.nr_files
+		r = __rand(&td->next_file_state);
+		fno = (unsigned int) ((double) td->o.nr_files
 				* (r / (FRAND_MAX + 1.0)));
-		}
 
 		f = td->files[fno];
 		if (fio_file_done(f))
diff --git a/options.c b/options.c
index 918de8e..529b8f0 100644
--- a/options.c
+++ b/options.c
@@ -1842,12 +1842,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "use_os_rand",
 		.lname	= "Use OS random",
-		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(use_os_rand),
-		.help	= "Set to use OS random generator",
-		.def	= "0",
-		.parent = "rw",
-		.hide	= 1,
+		.type	= FIO_OPT_DEPRECATED,
+		.off1	= td_var_offset(dep_use_os_rand),
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
 	},
diff --git a/thread_options.h b/thread_options.h
index ecf4e47..74c3e99 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -106,7 +106,7 @@ struct thread_options {
 	unsigned int rand_repeatable;
 	unsigned int allrand_repeatable;
 	unsigned long long rand_seed;
-	unsigned int use_os_rand;
+	unsigned int dep_use_os_rand;
 	unsigned int log_avg_msec;
 	unsigned int log_offset;
 	unsigned int log_gz;
@@ -337,7 +337,7 @@ struct thread_options_pack {
 	uint32_t rand_repeatable;
 	uint32_t allrand_repeatable;
 	uint64_t rand_seed;
-	uint32_t use_os_rand;
+	uint32_t dep_use_os_rand;
 	uint32_t log_avg_msec;
 	uint32_t log_offset;
 	uint32_t log_gz;
diff --git a/trim.c b/trim.c
index a7f1b86..95c433b 100644
--- a/trim.c
+++ b/trim.c
@@ -75,13 +75,8 @@ int io_u_should_trim(struct thread_data *td, struct io_u *io_u)
 	if (!td->o.trim_percentage)
 		return 0;
 
-	if (td->o.use_os_rand) {
-		r = os_random_long(&td->trim_state);
-		val = (OS_RAND_MAX / 100ULL);
-	} else {
-		r = __rand(&td->__trim_state);
-		val = (FRAND_MAX / 100ULL);
-	}
+	r = __rand(&td->trim_state);
+	val = (FRAND_MAX / 100ULL);
 
 	val *= (unsigned long long) td->o.trim_percentage;
 	return r <= val;
diff --git a/verify.c b/verify.c
index 35d8969..f5c009c 100644
--- a/verify.c
+++ b/verify.c
@@ -73,7 +73,7 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		if (use_seed)
 			__fill_random_buf(p, len, seed);
 		else
-			io_u->rand_seed = fill_random_buf(&td->__verify_state, p, len);
+			io_u->rand_seed = fill_random_buf(&td->verify_state, p, len);
 		return;
 	}
 
@@ -1140,9 +1140,9 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n", io_u);
 
 		if (!td->o.verify_pattern_bytes) {
-			io_u->rand_seed = __rand(&td->__verify_state);
+			io_u->rand_seed = __rand(&td->verify_state);
 			if (sizeof(int) != sizeof(long *))
-				io_u->rand_seed *= __rand(&td->__verify_state);
+				io_u->rand_seed *= __rand(&td->verify_state);
 		}
 		return 0;
 	}
