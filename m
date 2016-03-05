Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbcCENAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 5 Mar 2016 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1acBoS-0000TU-88
	for fio@vger.kernel.org; Sat, 05 Mar 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160305130001.879662C05EE@kernel.dk>
Date: Sat,  5 Mar 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8116fd24b737c9d878ccb6a4cc13cc4f974dc2dc:

  Update documentation for random_distribution=gauss (2016-03-03 14:00:54 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7c4d0fb7e9e038000978b43b5674f9ad049d36b9:

  Fix double free of td zone state index (2016-03-04 19:50:41 -0700)

----------------------------------------------------------------
Alan C (1):
      Log to parent instead of twice to child td

Jens Axboe (3):
      Add support for zones of random IO, with varying frequency of access
      options: clean number of zones if we fail parsing
      Fix double free of td zone state index

 HOWTO                   |  20 ++++
 backend.c               |   9 ++
 cconv.c                 |  32 +++++++
 examples/rand-zones.fio |  18 ++++
 fio.1                   |  34 ++++++-
 fio.h                   |  10 ++
 init.c                  |   1 +
 io_u.c                  | 108 ++++++++++++++++-----
 lib/rand.h              |  11 +++
 options.c               | 248 ++++++++++++++++++++++++++++++++++++++++++++++++
 server.h                |   2 +-
 thread_options.h        |  13 ++-
 12 files changed, 477 insertions(+), 29 deletions(-)
 create mode 100644 examples/rand-zones.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d70c9af..e2a4b15 100644
--- a/HOWTO
+++ b/HOWTO
@@ -964,6 +964,7 @@ random_distribution=str:float	By default, fio will use a completely uniform
 		zipf		Zipf distribution
 		pareto		Pareto distribution
 		gauss		Normal (guassian) distribution
+		zoned		Zoned random distribution
 
 		When using a zipf or pareto distribution, an input value
 		is also needed to define the access pattern. For zipf, this
@@ -976,6 +977,25 @@ random_distribution=str:float	By default, fio will use a completely uniform
 		the gauss distribution, a normal deviation is supplied as
 		a value between 0 and 100.
 
+		For a zoned distribution, fio supports specifying percentages
+		of IO access that should fall within what range of the file or
+		device. For example, given a criteria of:
+
+			60% of accesses should be to the first 10%
+			30% of accesses should be to the next 20%
+			8% of accesses should be to to the next 30%
+			2% of accesses should be to the next 40%
+
+		we can define that through zoning of the random accesses. For
+		the above example, the user would do:
+
+			random_distribution=zoned:60/10:30/20:8/30:2/40
+
+		similarly to how bssplit works for setting ranges and
+		percentages of block sizes. Like bssplit, it's possible to
+		specify separate zones for reads, writes, and trims. If just
+		one set is given, it'll apply to all of them.
+
 percentage_random=int	For a random workload, set how big a percentage should
 		be random. This defaults to 100%, in which case the workload
 		is fully random. It can be set from anywhere from 0 to 100.
diff --git a/backend.c b/backend.c
index 6083a51..7f57c65 100644
--- a/backend.c
+++ b/backend.c
@@ -1711,6 +1711,15 @@ err:
 	cgroup_shutdown(td, &cgroup_mnt);
 	verify_free_state(td);
 
+	if (td->zone_state_index) {
+		int i;
+
+		for (i = 0; i < DDIR_RWDIR_CNT; i++)
+			free(td->zone_state_index[i]);
+		free(td->zone_state_index);
+		td->zone_state_index = NULL;
+	}
+
 	if (fio_option_is_set(o, cpumask)) {
 		ret = fio_cpuset_exit(&o->cpumask);
 		if (ret)
diff --git a/cconv.c b/cconv.c
index 6f57d90..0c3a36c 100644
--- a/cconv.c
+++ b/cconv.c
@@ -23,6 +23,8 @@ static void __string_to_net(uint8_t *dst, const char *src, size_t dst_size)
 
 static void free_thread_options_to_cpu(struct thread_options *o)
 {
+	int i;
+
 	free(o->description);
 	free(o->name);
 	free(o->wait_for);
@@ -43,6 +45,11 @@ static void free_thread_options_to_cpu(struct thread_options *o)
 	free(o->ioscheduler);
 	free(o->profile);
 	free(o->cgroup);
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		free(o->bssplit[i]);
+		free(o->zone_split[i]);
+	}
 }
 
 void convert_thread_options_to_cpu(struct thread_options *o,
@@ -111,6 +118,16 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 			}
 		}
 
+		o->zone_split_nr[i] = le32_to_cpu(top->zone_split_nr[i]);
+
+		if (o->zone_split_nr[i]) {
+			o->zone_split[i] = malloc(o->zone_split_nr[i] * sizeof(struct zone_split));
+			for (j = 0; j < o->zone_split_nr[i]; j++) {
+				o->zone_split[i][j].access_perc = top->zone_split[i][j].access_perc;
+				o->zone_split[i][j].size_perc = top->zone_split[i][j].size_perc;
+			}
+		}
+
 		o->rwmix[i] = le32_to_cpu(top->rwmix[i]);
 		o->rate[i] = le32_to_cpu(top->rate[i]);
 		o->ratemin[i] = le32_to_cpu(top->ratemin[i]);
@@ -453,6 +470,21 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 			}
 		}
 
+		top->zone_split_nr[i] = cpu_to_le32(o->zone_split_nr[i]);
+
+		if (o->zone_split_nr[i]) {
+			unsigned int zone_split_nr = o->zone_split_nr[i];
+
+			if (zone_split_nr > ZONESPLIT_MAX) {
+				log_err("fio: ZONESPLIT_MAX is too small\n");
+				zone_split_nr = ZONESPLIT_MAX;
+			}
+			for (j = 0; j < zone_split_nr; j++) {
+				top->zone_split[i][j].access_perc = o->zone_split[i][j].access_perc;
+				top->zone_split[i][j].size_perc = o->zone_split[i][j].size_perc;
+			}
+		}
+
 		top->rwmix[i] = cpu_to_le32(o->rwmix[i]);
 		top->rate[i] = cpu_to_le32(o->rate[i]);
 		top->ratemin[i] = cpu_to_le32(o->ratemin[i]);
diff --git a/examples/rand-zones.fio b/examples/rand-zones.fio
new file mode 100644
index 0000000..da13fa3
--- /dev/null
+++ b/examples/rand-zones.fio
@@ -0,0 +1,18 @@
+# Sample job file demonstrating how to use zoned random distributionss
+# to have skewed random accesses. This example has 50% of the accesses
+# to the first 5% of the file (50/5), 30% to the next 15% (30/15), and
+# finally 20% of the IO will end up in the remaining 80%.
+[zones]
+size=2g
+direct=1
+bs=4k
+rw=randread
+norandommap
+random_distribution=zoned:50/5:30/15:20/
+
+# The above applies to all of reads/writes/trims. If we wanted to do
+# something differently for writes, let's say 50% for the first 10%
+# and 50% for the remaining 90%, we could do it by adding a new section
+# after a a comma.
+
+# random_distribution=zoned:50/5:30/15:20/,50/10:50/90
diff --git a/fio.1 b/fio.1
index 81c266b..87404c1 100644
--- a/fio.1
+++ b/fio.1
@@ -877,8 +877,10 @@ Pareto distribution
 .B gauss
 Normal (gaussian) distribution
 .TP
+.B zoned
+Zoned random distribution
+.TP
 .RE
-.P
 When using a \fBzipf\fR or \fBpareto\fR distribution, an input value is also
 needed to define the access pattern. For \fBzipf\fR, this is the zipf theta.
 For \fBpareto\fR, it's the pareto power. Fio includes a test program, genzipf,
@@ -887,6 +889,36 @@ hit rates. If you wanted to use \fBzipf\fR with a theta of 1.2, you would use
 random_distribution=zipf:1.2 as the option. If a non-uniform model is used,
 fio will disable use of the random map. For the \fBgauss\fR distribution, a
 normal deviation is supplied as a value between 0 and 100.
+.P
+.RS
+For a \fBzoned\fR distribution, fio supports specifying percentages of IO
+access that should fall within what range of the file or device. For example,
+given a criteria of:
+.P
+.RS
+60% of accesses should be to the first 10%
+.RE
+.RS
+30% of accesses should be to the next 20%
+.RE
+.RS
+8% of accesses should be to to the next 30%
+.RE
+.RS
+2% of accesses should be to the next 40%
+.RE
+.P
+we can define that through zoning of the random accesses. For the above
+example, the user would do:
+.P
+.RS
+.B random_distribution=zoned:60/10:30/20:8/30:2/40
+.RE
+.P
+similarly to how \fBbssplit\fR works for setting ranges and percentages of block
+sizes. Like \fBbssplit\fR, it's possible to specify separate zones for reads,
+writes, and trims. If just one set is given, it'll apply to all of them.
+.RE
 .TP
 .BI percentage_random \fR=\fPint
 For a random workload, set how big a percentage should be random. This defaults
diff --git a/fio.h b/fio.h
index b71a486..30fbde0 100644
--- a/fio.h
+++ b/fio.h
@@ -96,6 +96,7 @@ enum {
 	FIO_RAND_START_DELAY,
 	FIO_DEDUPE_OFF,
 	FIO_RAND_POISSON_OFF,
+	FIO_RAND_ZONE_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -115,6 +116,11 @@ struct sk_out;
 void sk_out_assign(struct sk_out *);
 void sk_out_drop(void);
 
+struct zone_split_index {
+	uint8_t size_perc;
+	uint8_t size_perc_prev;
+};
+
 /*
  * This describes a single thread/process executing a fio job.
  */
@@ -200,6 +206,9 @@ struct thread_data {
 	struct frand_state buf_state;
 	struct frand_state buf_state_prev;
 	struct frand_state dedupe_state;
+	struct frand_state zone_state;
+
+	struct zone_split_index **zone_state_index;
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
@@ -712,6 +721,7 @@ enum {
 	FIO_RAND_DIST_ZIPF,
 	FIO_RAND_DIST_PARETO,
 	FIO_RAND_DIST_GAUSS,
+	FIO_RAND_DIST_ZONED,
 };
 
 #define FIO_DEF_ZIPF		1.1
diff --git a/init.c b/init.c
index c7ce2cc..149029a 100644
--- a/init.c
+++ b/init.c
@@ -968,6 +968,7 @@ void td_fill_rand_seeds(struct thread_data *td)
 	frand_copy(&td->buf_state_prev, &td->buf_state);
 
 	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], use64);
+	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], use64);
 }
 
 /*
diff --git a/io_u.c b/io_u.c
index 8d34912..0a39886 100644
--- a/io_u.c
+++ b/io_u.c
@@ -86,24 +86,19 @@ struct rand_off {
 };
 
 static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
-				  enum fio_ddir ddir, uint64_t *b)
+				  enum fio_ddir ddir, uint64_t *b,
+				  uint64_t lastb)
 {
 	uint64_t r;
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE ||
 	    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64) {
-		uint64_t frand_max, lastb;
 
-		lastb = last_block(td, f, ddir);
-		if (!lastb)
-			return 1;
-
-		frand_max = rand_max(&td->random_state);
 		r = __rand(&td->random_state);
 
 		dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
 
-		*b = lastb * (r / ((uint64_t) frand_max + 1.0));
+		*b = lastb * (r / (rand_max(&td->random_state) + 1.0));
 	} else {
 		uint64_t off = 0;
 
@@ -161,6 +156,70 @@ static int __get_next_rand_offset_gauss(struct thread_data *td,
 	return 0;
 }
 
+static int __get_next_rand_offset_zoned(struct thread_data *td,
+					struct fio_file *f, enum fio_ddir ddir,
+					uint64_t *b)
+{
+	unsigned int v, send, stotal;
+	uint64_t offset, lastb;
+	static int warned;
+	struct zone_split_index *zsi;
+
+	lastb = last_block(td, f, ddir);
+	if (!lastb)
+		return 1;
+
+	if (!td->o.zone_split_nr[ddir]) {
+bail:
+		return __get_next_rand_offset(td, f, ddir, b, lastb);
+	}
+
+	/*
+	 * Generate a value, v, between 1 and 100, both inclusive
+	 */
+	v = rand_between(&td->zone_state, 1, 100);
+
+	zsi = &td->zone_state_index[ddir][v - 1];
+	stotal = zsi->size_perc_prev;
+	send = zsi->size_perc;
+
+	/*
+	 * Should never happen
+	 */
+	if (send == -1U) {
+		if (!warned) {
+			log_err("fio: bug in zoned generation\n");
+			warned = 1;
+		}
+		goto bail;
+	}
+
+	/*
+	 * 'send' is some percentage below or equal to 100 that
+	 * marks the end of the current IO range. 'stotal' marks
+	 * the start, in percent.
+	 */
+	if (stotal)
+		offset = stotal * lastb / 100ULL;
+	else
+		offset = 0;
+
+	lastb = lastb * (send - stotal) / 100ULL;
+
+	/*
+	 * Generate index from 0..send-of-lastb
+	 */
+	if (__get_next_rand_offset(td, f, ddir, b, lastb) == 1)
+		return 1;
+
+	/*
+	 * Add our start offset, if any
+	 */
+	if (offset)
+		*b += offset;
+
+	return 0;
+}
 
 static int flist_cmp(void *data, struct flist_head *a, struct flist_head *b)
 {
@@ -173,14 +232,22 @@ static int flist_cmp(void *data, struct flist_head *a, struct flist_head *b)
 static int get_off_from_method(struct thread_data *td, struct fio_file *f,
 			       enum fio_ddir ddir, uint64_t *b)
 {
-	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM)
-		return __get_next_rand_offset(td, f, ddir, b);
-	else if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
+	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM) {
+		uint64_t lastb;
+
+		lastb = last_block(td, f, ddir);
+		if (!lastb)
+			return 1;
+
+		return __get_next_rand_offset(td, f, ddir, b, lastb);
+	} else if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
 		return __get_next_rand_offset_zipf(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_PARETO)
 		return __get_next_rand_offset_pareto(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
 		return __get_next_rand_offset_gauss(td, f, ddir, b);
+	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED)
+		return __get_next_rand_offset_zoned(td, f, ddir, b);
 
 	log_err("fio: unknown random distribution: %d\n", td->o.random_distribution);
 	return 1;
@@ -207,16 +274,12 @@ static inline bool should_sort_io(struct thread_data *td)
 
 static bool should_do_random(struct thread_data *td, enum fio_ddir ddir)
 {
-	uint64_t frand_max;
 	unsigned int v;
-	unsigned long r;
 
 	if (td->o.perc_rand[ddir] == 100)
 		return true;
 
-	frand_max = rand_max(&td->seq_rand_state[ddir]);
-	r = __rand(&td->seq_rand_state[ddir]);
-	v = 1 + (int) (100.0 * (r / (frand_max + 1.0)));
+	v = rand_between(&td->seq_rand_state[ddir], 1, 100);
 
 	return v <= td->o.perc_rand[ddir];
 }
@@ -536,12 +599,9 @@ static void set_rwmix_bytes(struct thread_data *td)
 
 static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 {
-	uint64_t frand_max = rand_max(&td->rwmix_state);
 	unsigned int v;
-	unsigned long r;
 
-	r = __rand(&td->rwmix_state);
-	v = 1 + (int) (100.0 * (r / (frand_max + 1.0)));
+	v = rand_between(&td->rwmix_state, 1, 100);
 
 	if (v <= td->o.rwmix[DDIR_READ])
 		return DDIR_READ;
@@ -1607,7 +1667,7 @@ void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 {
 	__io_u_log_error(td, io_u);
 	if (td->parent)
-		__io_u_log_error(td, io_u);
+		__io_u_log_error(td->parent, io_u);
 }
 
 static inline bool gtod_reduce(struct thread_data *td)
@@ -1895,9 +1955,7 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
  */
 static struct frand_state *get_buf_state(struct thread_data *td)
 {
-	uint64_t frand_max;
 	unsigned int v;
-	unsigned long r;
 
 	if (!td->o.dedupe_percentage)
 		return &td->buf_state;
@@ -1906,9 +1964,7 @@ static struct frand_state *get_buf_state(struct thread_data *td)
 		return &td->buf_state;
 	}
 
-	frand_max = rand_max(&td->dedupe_state);
-	r = __rand(&td->dedupe_state);
-	v = 1 + (int) (100.0 * (r / (frand_max + 1.0)));
+	v = rand_between(&td->dedupe_state, 1, 100);
 
 	if (v <= td->o.dedupe_percentage)
 		return &td->buf_state_prev;
diff --git a/lib/rand.h b/lib/rand.h
index a95bd28..49773b0 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -117,6 +117,17 @@ static inline double __rand_0_1(struct frand_state *state)
 	}
 }
 
+/*
+ * Generate a random value between 'start' and 'end', both inclusive
+ */
+static inline int rand_between(struct frand_state *state, int start, int end)
+{
+	uint64_t r;
+
+	r = __rand(state);
+	return start + (int) ((double)end * (r / (rand_max(state) + 1.0)));
+}
+
 extern void init_rand(struct frand_state *, int);
 extern void init_rand_seed(struct frand_state *, unsigned int seed, int);
 extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
diff --git a/options.c b/options.c
index ac2da71..bc2d0ed 100644
--- a/options.c
+++ b/options.c
@@ -706,6 +706,247 @@ static int str_sfr_cb(void *data, const char *str)
 }
 #endif
 
+static int zone_cmp(const void *p1, const void *p2)
+{
+	const struct zone_split *zsp1 = p1;
+	const struct zone_split *zsp2 = p2;
+
+	return (int) zsp2->access_perc - (int) zsp1->access_perc;
+}
+
+static int zone_split_ddir(struct thread_options *o, int ddir, char *str)
+{
+	struct zone_split *zsplit;
+	unsigned int i, perc, perc_missing, sperc, sperc_missing;
+	long long val;
+	char *fname;
+
+	o->zone_split_nr[ddir] = 4;
+	zsplit = malloc(4 * sizeof(struct zone_split));
+
+	i = 0;
+	while ((fname = strsep(&str, ":")) != NULL) {
+		char *perc_str;
+
+		if (!strlen(fname))
+			break;
+
+		/*
+		 * grow struct buffer, if needed
+		 */
+		if (i == o->zone_split_nr[ddir]) {
+			o->zone_split_nr[ddir] <<= 1;
+			zsplit = realloc(zsplit, o->zone_split_nr[ddir]
+						  * sizeof(struct zone_split));
+		}
+
+		perc_str = strstr(fname, "/");
+		if (perc_str) {
+			*perc_str = '\0';
+			perc_str++;
+			perc = atoi(perc_str);
+			if (perc > 100)
+				perc = 100;
+			else if (!perc)
+				perc = -1U;
+		} else
+			perc = -1U;
+
+		if (str_to_decimal(fname, &val, 1, o, 0, 0)) {
+			log_err("fio: zone_split conversion failed\n");
+			free(zsplit);
+			return 1;
+		}
+
+		zsplit[i].access_perc = val;
+		zsplit[i].size_perc = perc;
+		i++;
+	}
+
+	o->zone_split_nr[ddir] = i;
+
+	/*
+	 * Now check if the percentages add up, and how much is missing
+	 */
+	perc = perc_missing = 0;
+	sperc = sperc_missing = 0;
+	for (i = 0; i < o->zone_split_nr[ddir]; i++) {
+		struct zone_split *zsp = &zsplit[i];
+
+		if (zsp->access_perc == (uint8_t) -1U)
+			perc_missing++;
+		else
+			perc += zsp->access_perc;
+
+		if (zsp->size_perc == (uint8_t) -1U)
+			sperc_missing++;
+		else
+			sperc += zsp->size_perc;
+
+	}
+
+	if (perc > 100 || sperc > 100) {
+		log_err("fio: zone_split percentages add to more than 100%%\n");
+		free(zsplit);
+		return 1;
+	}
+	if (perc < 100) {
+		log_err("fio: access percentage don't add up to 100 for zoned "
+			"random distribution (got=%u)\n", perc);
+		free(zsplit);
+		return 1;
+	}
+
+	/*
+	 * If values didn't have a percentage set, divide the remains between
+	 * them.
+	 */
+	if (perc_missing) {
+		if (perc_missing == 1 && o->zone_split_nr[ddir] == 1)
+			perc = 100;
+		for (i = 0; i < o->zone_split_nr[ddir]; i++) {
+			struct zone_split *zsp = &zsplit[i];
+
+			if (zsp->access_perc == (uint8_t) -1U)
+				zsp->access_perc = (100 - perc) / perc_missing;
+		}
+	}
+	if (sperc_missing) {
+		if (sperc_missing == 1 && o->zone_split_nr[ddir] == 1)
+			sperc = 100;
+		for (i = 0; i < o->zone_split_nr[ddir]; i++) {
+			struct zone_split *zsp = &zsplit[i];
+
+			if (zsp->size_perc == (uint8_t) -1U)
+				zsp->size_perc = (100 - sperc) / sperc_missing;
+		}
+	}
+
+	/*
+	 * now sort based on percentages, for ease of lookup
+	 */
+	qsort(zsplit, o->zone_split_nr[ddir], sizeof(struct zone_split), zone_cmp);
+	o->zone_split[ddir] = zsplit;
+	return 0;
+}
+
+static void __td_zone_gen_index(struct thread_data *td, enum fio_ddir ddir)
+{
+	unsigned int i, j, sprev, aprev;
+
+	td->zone_state_index[ddir] = malloc(sizeof(struct zone_split_index) * 100);
+
+	sprev = aprev = 0;
+	for (i = 0; i < td->o.zone_split_nr[ddir]; i++) {
+		struct zone_split *zsp = &td->o.zone_split[ddir][i];
+
+		for (j = aprev; j < aprev + zsp->access_perc; j++) {
+			struct zone_split_index *zsi = &td->zone_state_index[ddir][j];
+
+			zsi->size_perc = sprev + zsp->size_perc;
+			zsi->size_perc_prev = sprev;
+		}
+
+		aprev += zsp->access_perc;
+		sprev += zsp->size_perc;
+	}
+}
+
+/*
+ * Generate state table for indexes, so we don't have to do it inline from
+ * the hot IO path
+ */
+static void td_zone_gen_index(struct thread_data *td)
+{
+	int i;
+
+	td->zone_state_index = malloc(DDIR_RWDIR_CNT *
+					sizeof(struct zone_split_index *));
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++)
+		__td_zone_gen_index(td, i);
+}
+
+static int parse_zoned_distribution(struct thread_data *td, const char *input)
+{
+	char *str, *p, *odir, *ddir;
+	int i, ret = 0;
+
+	p = str = strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	/* We expect it to start like that, bail if not */
+	if (strncmp(str, "zoned:", 6)) {
+		log_err("fio: mismatch in zoned input <%s>\n", str);
+		free(p);
+		return 1;
+	}
+	str += strlen("zoned:");
+
+	odir = strchr(str, ',');
+	if (odir) {
+		ddir = strchr(odir + 1, ',');
+		if (ddir) {
+			ret = zone_split_ddir(&td->o, DDIR_TRIM, ddir + 1);
+			if (!ret)
+				*ddir = '\0';
+		} else {
+			char *op;
+
+			op = strdup(odir + 1);
+			ret = zone_split_ddir(&td->o, DDIR_TRIM, op);
+
+			free(op);
+		}
+		if (!ret)
+			ret = zone_split_ddir(&td->o, DDIR_WRITE, odir + 1);
+		if (!ret) {
+			*odir = '\0';
+			ret = zone_split_ddir(&td->o, DDIR_READ, str);
+		}
+	} else {
+		char *op;
+
+		op = strdup(str);
+		ret = zone_split_ddir(&td->o, DDIR_WRITE, op);
+		free(op);
+
+		if (!ret) {
+			op = strdup(str);
+			ret = zone_split_ddir(&td->o, DDIR_TRIM, op);
+			free(op);
+		}
+		if (!ret)
+			ret = zone_split_ddir(&td->o, DDIR_READ, str);
+	}
+
+	free(p);
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		int j;
+
+		dprint(FD_PARSE, "zone ddir %d (nr=%u): \n", i, td->o.zone_split_nr[i]);
+
+		for (j = 0; j < td->o.zone_split_nr[i]; j++) {
+			struct zone_split *zsp = &td->o.zone_split[i][j];
+
+			dprint(FD_PARSE, "\t%d: %u/%u\n", j, zsp->access_perc,
+								zsp->size_perc);
+		}
+	}
+
+	if (!ret)
+		td_zone_gen_index(td);
+	else {
+		for (i = 0; i < DDIR_RWDIR_CNT; i++)
+			td->o.zone_split_nr[i] = 0;
+	}
+
+	return ret;
+}
+
 static int str_random_distribution_cb(void *data, const char *str)
 {
 	struct thread_data *td = data;
@@ -721,6 +962,8 @@ static int str_random_distribution_cb(void *data, const char *str)
 		val = FIO_DEF_PARETO;
 	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
 		val = 0.0;
+	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED)
+		return parse_zoned_distribution(td, str);
 	else
 		return 0;
 
@@ -1709,6 +1952,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_RAND_DIST_GAUSS,
 			    .help = "Normal (gaussian) distribution",
 			  },
+			  { .ival = "zoned",
+			    .oval = FIO_RAND_DIST_ZONED,
+			    .help = "Zoned random distribution",
+			  },
+
 		},
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
diff --git a/server.h b/server.h
index a726894..fd0a0ce 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 52,
+	FIO_SERVER_VER			= 53,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 384534a..10d7ba6 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -25,12 +25,18 @@ enum fio_memtype {
 #define ERROR_STR_MAX	128
 
 #define BSSPLIT_MAX	64
+#define ZONESPLIT_MAX	64
 
 struct bssplit {
 	uint32_t bs;
 	uint32_t perc;
 };
 
+struct zone_split {
+	uint8_t access_perc;
+	uint8_t size_perc;
+};
+
 #define NR_OPTS_SZ	(FIO_MAX_OPTS / (8 * sizeof(uint64_t)))
 
 #define OPT_MAGIC	0x4f50544e
@@ -135,6 +141,9 @@ struct thread_options {
 	unsigned int random_distribution;
 	unsigned int exitall_error;
 
+	struct zone_split *zone_split[DDIR_RWDIR_CNT];
+	unsigned int zone_split_nr[DDIR_RWDIR_CNT];
+
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 	fio_fp64_t gauss_dev;
@@ -382,7 +391,9 @@ struct thread_options_pack {
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
-	uint32_t pad0;
+
+	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
+	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
