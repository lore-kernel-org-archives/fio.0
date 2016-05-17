Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36935 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbcEQMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 17 May 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1b2dfP-0006Bu-GG
	for fio@vger.kernel.org; Tue, 17 May 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160517120001.AD72F2C00C5@kernel.dk>
Date: Tue, 17 May 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5c8f0ba56837a0b848cbbbc5a8673589d099ded3:

  verify: unroll string copy (2016-05-10 19:50:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 15a0c8ee4e1a5434075ebc2c9f48e96e5e892196:

  Windows crash in ctime_r() (2016-05-16 19:25:48 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      stat: add blocksize to averaged log, if it's consistent
      zipf/pareto/gauss: add option to disable hashing
      Add support for non-uniformly random file service type
      options: 0.00 is a valid gauss dev
      zipf/pareto/gauss: hash cleanup

Michael Schoberg (mschoberg) (1):
      Windows crash in ctime_r()

 HOWTO              | 21 ++++++++++---
 file.h             | 17 +++++++----
 fio.1              | 18 +++++++++--
 fio.h              |  9 ++++++
 init.c             | 16 ++++++++++
 io_u.c             | 47 +++++++++++++++++++++++------
 lib/gauss.c        | 10 ++++++-
 lib/gauss.h        |  2 ++
 lib/zipf.c         | 21 +++++++++++--
 lib/zipf.h         |  2 ++
 options.c          | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 os/windows/posix.c |  6 ++--
 stat.c             | 20 ++++++++++---
 13 files changed, 240 insertions(+), 36 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 88d10a1..9ed2c5f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -673,10 +673,23 @@ file_service_type=str  Defines how fio decides which file from a job to
 				the next. Multiple files can still be
 				open depending on 'openfiles'.
 
-		The string can have a number appended, indicating how
-		often to switch to a new file. So if option random:4 is
-		given, fio will switch to a new random file after 4 ios
-		have been issued.
+			zipf	Use a zipfian distribution to decide what file
+				to access.
+
+			pareto	Use a pareto distribution to decide what file
+				to access.
+
+			gauss	Use a gaussian (normal) distribution to decide
+				what file to access.
+
+		For random, roundrobin, and sequential, a postfix can be
+		appended to tell fio how many I/Os to issue before switching
+		to a new file. For example, specifying
+		'file_service_type=random:8' would cause fio to issue 8 I/Os
+		before selecting a new file at random. For the non-uniform
+		distributions, a floating point postfix can be given to
+		influence how the distribution is skewed. See
+		'random_distribution' for a description of how that would work.
 
 ioengine=str	Defines how the job issues io to the file. The following
 		types are defined:
diff --git a/file.h b/file.h
index e7563b8..0cf622f 100644
--- a/file.h
+++ b/file.h
@@ -39,13 +39,20 @@ enum file_lock_mode {
 };
 
 /*
- * roundrobin available files, or choose one at random, or do each one
- * serially.
+ * How fio chooses what file to service next. Choice of uniformly random, or
+ * some skewed random variants, or just sequentially go through them or
+ * roundrobing.
  */
 enum {
-	FIO_FSERVICE_RANDOM	= 1,
-	FIO_FSERVICE_RR		= 2,
-	FIO_FSERVICE_SEQ	= 3,
+	FIO_FSERVICE_RANDOM		= 1,
+	FIO_FSERVICE_RR			= 2,
+	FIO_FSERVICE_SEQ		= 3,
+	__FIO_FSERVICE_NONUNIFORM	= 0x100,
+	FIO_FSERVICE_ZIPF		= __FIO_FSERVICE_NONUNIFORM | 4,
+	FIO_FSERVICE_PARETO		= __FIO_FSERVICE_NONUNIFORM | 5,
+	FIO_FSERVICE_GAUSS		= __FIO_FSERVICE_NONUNIFORM | 6,
+
+	FIO_FSERVICE_SHIFT		= 10,
 };
 
 /*
diff --git a/fio.1 b/fio.1
index ebb4899..5e4cd4f 100644
--- a/fio.1
+++ b/fio.1
@@ -566,10 +566,24 @@ Round robin over opened files (default).
 .TP
 .B sequential
 Do each file in the set sequentially.
+.TP
+.B zipf
+Use a zipfian distribution to decide what file to access.
+.TP
+.B pareto
+Use a pareto distribution to decide what file to access.
+.TP
+.B gauss
+Use a gaussian (normal) distribution to decide what file to access.
 .RE
 .P
-The number of I/Os to issue before switching to a new file can be specified by
-appending `:\fIint\fR' to the service type.
+For \fBrandom\fR, \fBroundrobin\fR, and \fBsequential\fR, a postfix can be
+appended to tell fio how many I/Os to issue before switching to a new file.
+For example, specifying \fBfile_service_type=random:8\fR would cause fio to
+issue \fI8\fR I/Os before selecting a new file at random. For the non-uniform
+distributions, a floating point postfix can be given to influence how the
+distribution is skewed. See \fBrandom_distribution\fR for a description of how
+that would work.
 .RE
 .TP
 .BI ioengine \fR=\fPstr
diff --git a/fio.h b/fio.h
index 6a244c3..8b6a272 100644
--- a/fio.h
+++ b/fio.h
@@ -170,6 +170,15 @@ struct thread_data {
 		unsigned int next_file;
 		struct frand_state next_file_state;
 	};
+	union {
+		struct zipf_state next_file_zipf;
+		struct gauss_state next_file_gauss;
+	};
+	union {
+		double zipf_theta;
+		double pareto_h;
+		double gauss_dev;
+	};
 	int error;
 	int sig;
 	int done;
diff --git a/init.c b/init.c
index c579d5c..e8c8afb 100644
--- a/init.c
+++ b/init.c
@@ -929,6 +929,22 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 
 	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
 		init_rand_seed(&td->next_file_state, td->rand_seeds[FIO_RAND_FILE_OFF], use64);
+	else if (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM) {
+		unsigned long nranges;
+
+		nranges = td->o.nr_files << FIO_FSERVICE_SHIFT;
+
+		if (td->o.file_service_type == FIO_FSERVICE_ZIPF) {
+			zipf_init(&td->next_file_zipf, nranges, td->zipf_theta, td->rand_seeds[FIO_RAND_FILE_OFF]);
+			zipf_disable_hash(&td->next_file_zipf);
+		} else if (td->o.file_service_type == FIO_FSERVICE_PARETO) {
+			pareto_init(&td->next_file_zipf, nranges, td->pareto_h, td->rand_seeds[FIO_RAND_FILE_OFF]);
+			zipf_disable_hash(&td->next_file_zipf);
+		} else if (td->o.file_service_type == FIO_FSERVICE_GAUSS) {
+			gauss_init(&td->next_file_gauss, nranges, td->gauss_dev, td->rand_seeds[FIO_RAND_FILE_OFF]);
+			gauss_disable_hash(&td->next_file_gauss);
+		}
+	}
 
 	init_rand_seed(&td->file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], use64);
 	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], use64);
diff --git a/io_u.c b/io_u.c
index f9870e7..c0790b2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -328,7 +328,8 @@ static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 	if (!get_next_rand_offset(td, f, ddir, b))
 		return 0;
 
-	if (td->o.time_based) {
+	if (td->o.time_based ||
+	    (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM)) {
 		fio_file_reset(td, f);
 		if (!get_next_rand_offset(td, f, ddir, b))
 			return 0;
@@ -1070,6 +1071,34 @@ static void io_u_mark_latency(struct thread_data *td, unsigned long usec)
 		io_u_mark_lat_msec(td, usec / 1000);
 }
 
+static unsigned int __get_next_fileno_rand(struct thread_data *td)
+{
+	unsigned long fileno;
+
+	if (td->o.file_service_type == FIO_FSERVICE_RANDOM) {
+		uint64_t frand_max = rand_max(&td->next_file_state);
+		unsigned long r;
+
+		r = __rand(&td->next_file_state);
+		return (unsigned int) ((double) td->o.nr_files
+				* (r / (frand_max + 1.0)));
+	}
+
+	if (td->o.file_service_type == FIO_FSERVICE_ZIPF)
+		fileno = zipf_next(&td->next_file_zipf);
+	else if (td->o.file_service_type == FIO_FSERVICE_PARETO)
+		fileno = pareto_next(&td->next_file_zipf);
+	else if (td->o.file_service_type == FIO_FSERVICE_GAUSS)
+		fileno = gauss_next(&td->next_file_gauss);
+	else {
+		log_err("fio: bad file service type: %d\n", td->o.file_service_type);
+		assert(0);
+		return 0;
+	}
+
+	return fileno >> FIO_FSERVICE_SHIFT;
+}
+
 /*
  * Get next file to service by choosing one at random
  */
@@ -1077,17 +1106,13 @@ static struct fio_file *get_next_file_rand(struct thread_data *td,
 					   enum fio_file_flags goodf,
 					   enum fio_file_flags badf)
 {
-	uint64_t frand_max = rand_max(&td->next_file_state);
 	struct fio_file *f;
 	int fno;
 
 	do {
 		int opened = 0;
-		unsigned long r;
 
-		r = __rand(&td->next_file_state);
-		fno = (unsigned int) ((double) td->o.nr_files
-				* (r / (frand_max + 1.0)));
+		fno = __get_next_fileno_rand(td);
 
 		f = td->files[fno];
 		if (fio_file_done(f))
@@ -1240,10 +1265,14 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 		put_file_log(td, f);
 		td_io_close_file(td, f);
 		io_u->file = NULL;
-		fio_file_set_done(f);
-		td->nr_done_files++;
-		dprint(FD_FILE, "%s: is done (%d of %d)\n", f->file_name,
+		if (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM)
+			fio_file_reset(td, f);
+		else {
+			fio_file_set_done(f);
+			td->nr_done_files++;
+			dprint(FD_FILE, "%s: is done (%d of %d)\n", f->file_name,
 					td->nr_done_files, td->o.nr_files);
+		}
 	} while (1);
 
 	return 0;
diff --git a/lib/gauss.c b/lib/gauss.c
index afd0490..f974490 100644
--- a/lib/gauss.c
+++ b/lib/gauss.c
@@ -38,7 +38,10 @@ unsigned long long gauss_next(struct gauss_state *gs)
 		sum += dev;
 	}
 
-	return __hash_u64(sum) % gs->nranges;
+	if (!gs->disable_hash)
+		sum = __hash_u64(sum);
+
+	return sum % gs->nranges;
 }
 
 void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
@@ -54,3 +57,8 @@ void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
 			gs->stddev = nranges / 2;
 	}
 }
+
+void gauss_disable_hash(struct gauss_state *gs)
+{
+	gs->disable_hash = true;
+}
diff --git a/lib/gauss.h b/lib/gauss.h
index a76df3f..478aa14 100644
--- a/lib/gauss.h
+++ b/lib/gauss.h
@@ -8,10 +8,12 @@ struct gauss_state {
 	struct frand_state r;
 	uint64_t nranges;
 	unsigned int stddev;
+	bool disable_hash;
 };
 
 void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
 		unsigned int seed);
 unsigned long long gauss_next(struct gauss_state *gs);
+void gauss_disable_hash(struct gauss_state *gs);
 
 #endif
diff --git a/lib/zipf.c b/lib/zipf.c
index d8e72b1..681df70 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -69,7 +69,12 @@ unsigned long long zipf_next(struct zipf_state *zs)
 	else
 		val = 1 + (unsigned long long)(n * pow(eta*rand_uni - eta + 1.0, alpha));
 
-	return (__hash_u64(val - 1) + zs->rand_off) % zs->nranges;
+	val--;
+
+	if (!zs->disable_hash)
+		val = __hash_u64(val);
+
+	return (val + zs->rand_off) % zs->nranges;
 }
 
 void pareto_init(struct zipf_state *zs, unsigned long nranges, double h,
@@ -82,7 +87,17 @@ void pareto_init(struct zipf_state *zs, unsigned long nranges, double h,
 unsigned long long pareto_next(struct zipf_state *zs)
 {
 	double rand = (double) __rand(&zs->rand) / (double) FRAND32_MAX;
-	unsigned long long n = zs->nranges - 1;
+	unsigned long long n;
+
+	n = (zs->nranges - 1) * pow(rand, zs->pareto_pow);
+
+	if (!zs->disable_hash)
+		n = __hash_u64(n);
 
-	return (__hash_u64(n * pow(rand, zs->pareto_pow)) + zs->rand_off) % zs->nranges;
+	return (n + zs->rand_off)  % zs->nranges;
+}
+
+void zipf_disable_hash(struct zipf_state *zs)
+{
+	zs->disable_hash = true;
 }
diff --git a/lib/zipf.h b/lib/zipf.h
index f98ad81..af2d0e6 100644
--- a/lib/zipf.h
+++ b/lib/zipf.h
@@ -12,6 +12,7 @@ struct zipf_state {
 	double pareto_pow;
 	struct frand_state rand;
 	uint64_t rand_off;
+	bool disable_hash;
 };
 
 void zipf_init(struct zipf_state *zs, unsigned long nranges, double theta, unsigned int seed);
@@ -19,5 +20,6 @@ unsigned long long zipf_next(struct zipf_state *zs);
 
 void pareto_init(struct zipf_state *zs, unsigned long nranges, double h, unsigned int seed);
 unsigned long long pareto_next(struct zipf_state *zs);
+void zipf_disable_hash(struct zipf_state *zs);
 
 #endif
diff --git a/options.c b/options.c
index 980b7e5..a925663 100644
--- a/options.c
+++ b/options.c
@@ -724,12 +724,77 @@ out:
 static int str_fst_cb(void *data, const char *str)
 {
 	struct thread_data *td = data;
-	char *nr = get_opt_postfix(str);
+	double val;
+	bool done = false;
+	char *nr;
 
 	td->file_service_nr = 1;
-	if (nr) {
-		td->file_service_nr = atoi(nr);
+
+	switch (td->o.file_service_type) {
+	case FIO_FSERVICE_RANDOM:
+	case FIO_FSERVICE_RR:
+	case FIO_FSERVICE_SEQ:
+		nr = get_opt_postfix(str);
+		if (nr) {
+			td->file_service_nr = atoi(nr);
+			free(nr);
+		}
+		done = true;
+		break;
+	case FIO_FSERVICE_ZIPF:
+		val = FIO_DEF_ZIPF;
+		break;
+	case FIO_FSERVICE_PARETO:
+		val = FIO_DEF_PARETO;
+		break;
+	case FIO_FSERVICE_GAUSS:
+		val = 0.0;
+		break;
+	default:
+		log_err("fio: bad file service type: %d\n", td->o.file_service_type);
+		return 1;
+	}
+
+	if (done)
+		return 0;
+
+	nr = get_opt_postfix(str);
+	if (nr && !str_to_float(nr, &val, 0)) {
+		log_err("fio: file service type random postfix parsing failed\n");
 		free(nr);
+		return 1;
+	}
+
+	free(nr);
+
+	switch (td->o.file_service_type) {
+	case FIO_FSERVICE_ZIPF:
+		if (val == 1.00) {
+			log_err("fio: zipf theta must be different than 1.0\n");
+			return 1;
+		}
+		if (parse_dryrun())
+			return 0;
+		td->zipf_theta = val;
+		break;
+	case FIO_FSERVICE_PARETO:
+		if (val <= 0.00 || val >= 1.00) {
+                          log_err("fio: pareto input out of range (0 < input < 1.0)\n");
+                          return 1;
+		}
+		if (parse_dryrun())
+			return 0;
+		td->pareto_h = val;
+		break;
+	case FIO_FSERVICE_GAUSS:
+		if (val < 0.00 || val >= 100.00) {
+                          log_err("fio: normal deviation out of range (0 < input < 100.0  )\n");
+                          return 1;
+		}
+		if (parse_dryrun())
+			return 0;
+		td->gauss_dev = val;
+		break;
 	}
 
 	return 0;
@@ -982,7 +1047,7 @@ static int str_random_distribution_cb(void *data, const char *str)
 			return 0;
 		td->o.pareto_h.u.f = val;
 	} else {
-		if (val <= 0.00 || val >= 100.0) {
+		if (val < 0.00 || val >= 100.0) {
 			log_err("fio: normal deviation out of range (0 < input < 100.0)\n");
 			return 1;
 		}
@@ -2020,7 +2085,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.posval	= {
 			  { .ival = "random",
 			    .oval = FIO_FSERVICE_RANDOM,
-			    .help = "Choose a file at random",
+			    .help = "Choose a file at random (uniform)",
+			  },
+			  { .ival = "zipf",
+			    .oval = FIO_FSERVICE_ZIPF,
+			    .help = "Zipf randomized",
+			  },
+			  { .ival = "pareto",
+			    .oval = FIO_FSERVICE_PARETO,
+			    .help = "Pareto randomized",
+			  },
+			  { .ival = "gauss",
+			    .oval = FIO_FSERVICE_GAUSS,
+			    .help = "Normal (guassian) distribution",
 			  },
 			  { .ival = "roundrobin",
 			    .oval = FIO_FSERVICE_RR,
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 41fc480..fd3d9ab 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -243,12 +243,12 @@ void Time_tToSystemTime(time_t dosTime, SYSTEMTIME *systemTime)
 char* ctime_r(const time_t *t, char *buf)
 {
     SYSTEMTIME systime;
-    const char * const dayOfWeek[] = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };
+    const char * const dayOfWeek[] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
     const char * const monthOfYear[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
 
     Time_tToSystemTime(*t, &systime);
     /* We don't know how long `buf` is, but assume it's rounded up from the minimum of 25 to 32 */
-    StringCchPrintfA(buf, 32, "%s %s %d %02d:%02d:%02d %04d", dayOfWeek[systime.wDayOfWeek - 1], monthOfYear[systime.wMonth - 1],
+    StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d", dayOfWeek[systime.wDayOfWeek % 7], monthOfYear[(systime.wMonth - 1) % 12],
 										 systime.wDay, systime.wHour, systime.wMinute, systime.wSecond, systime.wYear);
     return buf;
 }
@@ -888,7 +888,7 @@ struct dirent *readdir(DIR *dirp)
 
 	if (dirp->find_handle == INVALID_HANDLE_VALUE) {
 		char search_pattern[MAX_PATH];
-		StringCchPrintfA(search_pattern, MAX_PATH, "%s\\*", dirp->dirname);
+		StringCchPrintfA(search_pattern, MAX_PATH-1, "%s\\*", dirp->dirname);
 		dirp->find_handle = FindFirstFileA(search_pattern, &find_data);
 		if (dirp->find_handle == INVALID_HANDLE_VALUE)
 			return NULL;
diff --git a/stat.c b/stat.c
index 95f206e..4d87c29 100644
--- a/stat.c
+++ b/stat.c
@@ -2169,8 +2169,14 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 
 		add_stat_sample(&ts->bw_stat[ddir], rate);
 
-		if (td->bw_log)
-			add_log_sample(td, td->bw_log, rate, ddir, 0, 0);
+		if (td->bw_log) {
+			unsigned int bs = 0;
+
+			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
+				bs = td->o.min_bs[ddir];
+
+			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+		}
 
 		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
 	}
@@ -2234,8 +2240,14 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 
 		add_stat_sample(&ts->iops_stat[ddir], iops);
 
-		if (td->iops_log)
-			add_log_sample(td, td->iops_log, iops, ddir, 0, 0);
+		if (td->iops_log) {
+			unsigned int bs = 0;
+
+			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
+				bs = td->o.min_bs[ddir];
+
+			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+		}
 
 		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
 	}
