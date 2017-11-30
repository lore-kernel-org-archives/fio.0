Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34840 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdK3NAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Nov 2017 08:00:14 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eKORp-0007qY-Js
        for fio@vger.kernel.org; Thu, 30 Nov 2017 13:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171130130002.9FFDF2C0137@kernel.dk>
Date: Thu, 30 Nov 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1201b24acd347d6daaad969e6abfe0975cb86bc8:

  init: did_arg cleanup (2017-11-28 16:00:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6c3fb04c80c3c241162e743a54761e5e896d4ba2:

  options: correct parser type for max_latency (2017-11-29 22:27:05 -0700)

----------------------------------------------------------------
Jens Axboe (13):
      options: don't quicksort zoned distribution series
      Add support for absolute random zones
      examples/rand-zones.fio: add zoned_abs example
      io_u: cleanup and simplify __get_next_rand_offset_zoned_abs()
      Unify max split zone support
      io_u: don't do expensive int divide for buffer scramble
      io_u: do nsec -> usec converison in one spot in account_io_completion()
      options: make it clear that max_latency is in usecs
      options: make max_latency a 64-bit variable
      Change latency targets to be in nsec values internally
      verify: kill unneeded forward declaration
      verify: convert hdr time to sec+nsec
      options: correct parser type for max_latency

Tomohiro Kusumi (1):
      Revert "Avoid irrelevant "offset extend ends" error message for chrdev"

 HOWTO                   |  24 +++++++--
 cconv.c                 |   4 +-
 examples/rand-zones.fio |   8 +++
 filesetup.c             |  26 ++++-----
 fio.1                   |  24 ++++++++-
 fio.h                   |   3 ++
 init.c                  |   7 +++
 io_u.c                  |  83 +++++++++++++++++++++++++----
 libfio.c                |   1 +
 options.c               | 136 ++++++++++++++++++++++++++++--------------------
 profiles/act.c          |   3 +-
 server.h                |   2 +-
 thread_options.h        |  14 ++---
 verify.c                |   5 +-
 verify.h                |   2 +-
 15 files changed, 240 insertions(+), 102 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 164ba2b..dc99e99 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1254,6 +1254,9 @@ I/O type
 		**zoned**
 				Zoned random distribution
 
+		**zoned_abs**
+				Zone absolute random distribution
+
 	When using a **zipf** or **pareto** distribution, an input value is also
 	needed to define the access pattern. For **zipf**, this is the `Zipf
 	theta`. For **pareto**, it's the `Pareto power`. Fio includes a test
@@ -1278,10 +1281,23 @@ I/O type
 
 		random_distribution=zoned:60/10:30/20:8/30:2/40
 
-	similarly to how :option:`bssplit` works for setting ranges and percentages
-	of block sizes. Like :option:`bssplit`, it's possible to specify separate
-	zones for reads, writes, and trims. If just one set is given, it'll apply to
-	all of them.
+	A **zoned_abs** distribution works exactly like the **zoned**, except
+	that it takes absolute sizes. For example, let's say you wanted to
+	define access according to the following criteria:
+
+		* 60% of accesses should be to the first 20G
+		* 30% of accesses should be to the next 100G
+		* 10% of accesses should be to the next 500G
+
+	we can define an absolute zoning distribution with:
+
+		random_distribution=zoned_abs=60/20G:30/100G:10/500g
+
+	Similarly to how :option:`bssplit` works for setting ranges and
+	percentages of block sizes. Like :option:`bssplit`, it's possible to
+	specify separate zones for reads, writes, and trims. If just one set
+	is given, it'll apply to all of them. This goes for both **zoned**
+	**zoned_abs** distributions.
 
 .. option:: percentage_random=int[,int][,int]
 
diff --git a/cconv.c b/cconv.c
index 1a41dc3..5ed4640 100644
--- a/cconv.c
+++ b/cconv.c
@@ -234,7 +234,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->loops = le32_to_cpu(top->loops);
 	o->mem_type = le32_to_cpu(top->mem_type);
 	o->mem_align = le32_to_cpu(top->mem_align);
-	o->max_latency = le32_to_cpu(top->max_latency);
 	o->stonewall = le32_to_cpu(top->stonewall);
 	o->new_group = le32_to_cpu(top->new_group);
 	o->numjobs = le32_to_cpu(top->numjobs);
@@ -283,6 +282,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->sync_file_range = le32_to_cpu(top->sync_file_range);
 	o->latency_target = le64_to_cpu(top->latency_target);
 	o->latency_window = le64_to_cpu(top->latency_window);
+	o->max_latency = le64_to_cpu(top->max_latency);
 	o->latency_percentile.u.f = fio_uint64_to_double(le64_to_cpu(top->latency_percentile.u.i));
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
 	o->compress_chunk = le32_to_cpu(top->compress_chunk);
@@ -423,7 +423,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->loops = cpu_to_le32(o->loops);
 	top->mem_type = cpu_to_le32(o->mem_type);
 	top->mem_align = cpu_to_le32(o->mem_align);
-	top->max_latency = cpu_to_le32(o->max_latency);
 	top->stonewall = cpu_to_le32(o->stonewall);
 	top->new_group = cpu_to_le32(o->new_group);
 	top->numjobs = cpu_to_le32(o->numjobs);
@@ -472,6 +471,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->sync_file_range = cpu_to_le32(o->sync_file_range);
 	top->latency_target = __cpu_to_le64(o->latency_target);
 	top->latency_window = __cpu_to_le64(o->latency_window);
+	top->max_latency = __cpu_to_le64(o->max_latency);
 	top->latency_percentile.u.i = __cpu_to_le64(fio_double_to_uint64(o->latency_percentile.u.f));
 	top->compress_percentage = cpu_to_le32(o->compress_percentage);
 	top->compress_chunk = cpu_to_le32(o->compress_chunk);
diff --git a/examples/rand-zones.fio b/examples/rand-zones.fio
index da13fa3..169137d 100644
--- a/examples/rand-zones.fio
+++ b/examples/rand-zones.fio
@@ -10,6 +10,14 @@ rw=randread
 norandommap
 random_distribution=zoned:50/5:30/15:20/
 
+# It's also possible to use zoned_abs to specify absolute sizes. For
+# instance, if you do:
+#
+# random_distribution=zoned_abs:50/10G:30/100G:20/500G
+#
+# Then 50% of the access will be to the first 10G of the drive, 30%
+# will be to the next 100G, and 20% will be to the next 500G.
+
 # The above applies to all of reads/writes/trims. If we wanted to do
 # something differently for writes, let's say 50% for the first 10%
 # and 50% for the remaining 90%, we could do it by adding a new section
diff --git a/filesetup.c b/filesetup.c
index 4d29b70..1d586b1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -435,8 +435,12 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		ret = bdev_size(td, f);
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
-	else
-		f->real_file_size = -1ULL;
+	else {
+		f->real_file_size = -1;
+		log_info("%s: failed to get file size of %s\n", td->o.name,
+					f->file_name);
+		return 1; /* avoid offset extends end error message */
+	}
 
 	/*
 	 * Leave ->real_file_size with 0 since it could be expectation
@@ -446,22 +450,10 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		return ret;
 
 	/*
-	 * If ->real_file_size is -1, a conditional for the message
-	 * "offset extends end" is always true, but it makes no sense,
-	 * so just return the same value here.
-	 */
-	if (f->real_file_size == -1ULL) {
-		log_info("%s: failed to get file size of %s\n", td->o.name,
-					f->file_name);
-		return 1;
-	}
-
-	if (td->o.start_offset && f->file_offset == 0)
-		dprint(FD_FILE, "offset of file %s not initialized yet\n",
-					f->file_name);
-	/*
 	 * ->file_offset normally hasn't been initialized yet, so this
-	 * is basically always false.
+	 * is basically always false unless ->real_file_size is -1, but
+	 * if ->real_file_size is -1 this message doesn't make sense.
+	 * As a result, this message is basically useless.
 	 */
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
diff --git a/fio.1 b/fio.1
index a4b0ea6..01b4db6 100644
--- a/fio.1
+++ b/fio.1
@@ -1033,6 +1033,8 @@ Normal (Gaussian) distribution
 .TP
 .B zoned
 Zoned random distribution
+.B zoned_abs
+Zoned absolute random distribution
 .RE
 .P
 When using a \fBzipf\fR or \fBpareto\fR distribution, an input value is also
@@ -1068,7 +1070,27 @@ example, the user would do:
 random_distribution=zoned:60/10:30/20:8/30:2/40
 .RE
 .P
-similarly to how \fBbssplit\fR works for setting ranges and percentages
+A \fBzoned_abs\fR distribution works exactly like the\fBzoned\fR, except that
+it takes absolute sizes. For example, let's say you wanted to define access
+according to the following criteria:
+.RS
+.P
+.PD 0
+60% of accesses should be to the first 20G
+.P
+30% of accesses should be to the next 100G
+.P
+10% of accesses should be to the next 500G
+.PD
+.RE
+.P
+we can define an absolute zoning distribution with:
+.RS
+.P
+random_distribution=zoned:60/10:30/20:8/30:2/40
+.RE
+.P
+Similarly to how \fBbssplit\fR works for setting ranges and percentages
 of block sizes. Like \fBbssplit\fR, it's possible to specify separate
 zones for reads, writes, and trims. If just one set is given, it'll apply to
 all of them.
diff --git a/fio.h b/fio.h
index 8ca934d..a44f1aa 100644
--- a/fio.h
+++ b/fio.h
@@ -158,6 +158,8 @@ void sk_out_drop(void);
 struct zone_split_index {
 	uint8_t size_perc;
 	uint8_t size_perc_prev;
+	uint64_t size;
+	uint64_t size_prev;
 };
 
 /*
@@ -813,6 +815,7 @@ enum {
 	FIO_RAND_DIST_PARETO,
 	FIO_RAND_DIST_GAUSS,
 	FIO_RAND_DIST_ZONED,
+	FIO_RAND_DIST_ZONED_ABS,
 };
 
 #define FIO_DEF_ZIPF		1.1
diff --git a/init.c b/init.c
index acbbd48..7c16b06 100644
--- a/init.c
+++ b/init.c
@@ -925,6 +925,13 @@ static int fixup_options(struct thread_data *td)
 		ret = 1;
 	}
 
+	/*
+	 * Fix these up to be nsec internally
+	 */
+	o->max_latency *= 1000ULL;
+	o->latency_target *= 1000ULL;
+	o->latency_window *= 1000ULL;
+
 	return ret;
 }
 
diff --git a/io_u.c b/io_u.c
index 81ee724..ebe82e1 100644
--- a/io_u.c
+++ b/io_u.c
@@ -157,6 +157,66 @@ static int __get_next_rand_offset_gauss(struct thread_data *td,
 	return 0;
 }
 
+static int __get_next_rand_offset_zoned_abs(struct thread_data *td,
+					    struct fio_file *f,
+					    enum fio_ddir ddir, uint64_t *b)
+{
+	struct zone_split_index *zsi;
+	uint64_t lastb, send, stotal;
+	static int warned;
+	unsigned int v;
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
+	v = rand32_between(&td->zone_state, 1, 100);
+
+	/*
+	 * Find our generated table. 'send' is the end block of this zone,
+	 * 'stotal' is our start offset.
+	 */
+	zsi = &td->zone_state_index[ddir][v - 1];
+	stotal = zsi->size_prev / td->o.ba[ddir];
+	send = zsi->size / td->o.ba[ddir];
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
+	} else if (send > lastb) {
+		/*
+		 * This happens if the user specifies ranges that exceed
+		 * the file/device size. We can't handle that gracefully,
+		 * so error and exit.
+		 */
+		log_err("fio: zoned_abs sizes exceed file size\n");
+		return 1;
+	}
+
+	/*
+	 * Generate index from 0..send-stotal
+	 */
+	if (__get_next_rand_offset(td, f, ddir, b, send - stotal) == 1)
+		return 1;
+
+	*b += stotal;
+	return 0;
+}
+
 static int __get_next_rand_offset_zoned(struct thread_data *td,
 					struct fio_file *f, enum fio_ddir ddir,
 					uint64_t *b)
@@ -249,6 +309,8 @@ static int get_off_from_method(struct thread_data *td, struct fio_file *f,
 		return __get_next_rand_offset_gauss(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED)
 		return __get_next_rand_offset_zoned(td, f, ddir, b);
+	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
+		return __get_next_rand_offset_zoned_abs(td, f, ddir, b);
 
 	log_err("fio: unknown random distribution: %d\n", td->o.random_distribution);
 	return 1;
@@ -1347,10 +1409,10 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 }
 
 static void lat_fatal(struct thread_data *td, struct io_completion_data *icd,
-		      unsigned long tusec, unsigned long max_usec)
+		      unsigned long long tnsec, unsigned long long max_nsec)
 {
 	if (!td->error)
-		log_err("fio: latency of %lu usec exceeds specified max (%lu usec)\n", tusec, max_usec);
+		log_err("fio: latency of %llu nsec exceeds specified max (%llu nsec)\n", tnsec, max_nsec);
 	td_verror(td, ETIMEDOUT, "max latency exceeded");
 	icd->error = ETIMEDOUT;
 }
@@ -1611,7 +1673,7 @@ static bool check_get_verify(struct thread_data *td, struct io_u *io_u)
 static void small_content_scramble(struct io_u *io_u)
 {
 	unsigned int i, nr_blocks = io_u->buflen / 512;
-	uint64_t boffset;
+	uint64_t boffset, usec;
 	unsigned int offset;
 	char *p, *end;
 
@@ -1622,13 +1684,16 @@ static void small_content_scramble(struct io_u *io_u)
 	boffset = io_u->offset;
 	io_u->buf_filled_len = 0;
 
+	/* close enough for this purpose */
+	usec = io_u->start_time.tv_nsec >> 10;
+
 	for (i = 0; i < nr_blocks; i++) {
 		/*
 		 * Fill the byte offset into a "random" start offset of
 		 * the buffer, given by the product of the usec time
 		 * and the actual offset.
 		 */
-		offset = ((io_u->start_time.tv_nsec/1000) ^ boffset) & 511;
+		offset = (usec ^ boffset) & 511;
 		offset &= ~(sizeof(uint64_t) - 1);
 		if (offset >= 512 - sizeof(uint64_t))
 			offset -= sizeof(uint64_t);
@@ -1806,14 +1871,14 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 			struct prof_io_ops *ops = &td->prof_io_ops;
 
 			if (ops->io_u_lat)
-				icd->error = ops->io_u_lat(td, tnsec/1000);
+				icd->error = ops->io_u_lat(td, tnsec);
 		}
 
-		if (td->o.max_latency && tnsec/1000 > td->o.max_latency)
-			lat_fatal(td, icd, tnsec/1000, td->o.max_latency);
-		if (td->o.latency_target && tnsec/1000 > td->o.latency_target) {
+		if (td->o.max_latency && tnsec > td->o.max_latency)
+			lat_fatal(td, icd, tnsec, td->o.max_latency);
+		if (td->o.latency_target && tnsec > td->o.latency_target) {
 			if (lat_target_failed(td))
-				lat_fatal(td, icd, tnsec/1000, td->o.latency_target);
+				lat_fatal(td, icd, tnsec, td->o.latency_target);
 		}
 	}
 
diff --git a/libfio.c b/libfio.c
index d9900ad..c9bb8f3 100644
--- a/libfio.c
+++ b/libfio.c
@@ -366,6 +366,7 @@ int initialize_fio(char *envp[])
 	compiletime_assert((offsetof(struct jobs_eta, m_rate) % 8) == 0, "m_rate");
 
 	compiletime_assert(__TD_F_LAST <= TD_ENG_FLAG_SHIFT, "TD_ENG_FLAG_SHIFT");
+	compiletime_assert(BSSPLIT_MAX == ZONESPLIT_MAX, "bsssplit/zone max");
 
 	err = endian_check();
 	if (err) {
diff --git a/options.c b/options.c
index 7caccb3..a224e7b 100644
--- a/options.c
+++ b/options.c
@@ -56,14 +56,15 @@ static int bs_cmp(const void *p1, const void *p2)
 
 struct split {
 	unsigned int nr;
-	unsigned int val1[100];
-	unsigned int val2[100];
+	unsigned int val1[ZONESPLIT_MAX];
+	unsigned long long val2[ZONESPLIT_MAX];
 };
 
 static int split_parse_ddir(struct thread_options *o, struct split *split,
-			    enum fio_ddir ddir, char *str)
+			    enum fio_ddir ddir, char *str, bool absolute)
 {
-	unsigned int i, perc;
+	unsigned long long perc;
+	unsigned int i;
 	long long val;
 	char *fname;
 
@@ -80,23 +81,35 @@ static int split_parse_ddir(struct thread_options *o, struct split *split,
 		if (perc_str) {
 			*perc_str = '\0';
 			perc_str++;
-			perc = atoi(perc_str);
-			if (perc > 100)
-				perc = 100;
-			else if (!perc)
+			if (absolute) {
+				if (str_to_decimal(perc_str, &val, 1, o, 0, 0)) {
+					log_err("fio: split conversion failed\n");
+					return 1;
+				}
+				perc = val;
+			} else {
+				perc = atoi(perc_str);
+				if (perc > 100)
+					perc = 100;
+				else if (!perc)
+					perc = -1U;
+			}
+		} else {
+			if (absolute)
+				perc = 0;
+			else
 				perc = -1U;
-		} else
-			perc = -1U;
+		}
 
 		if (str_to_decimal(fname, &val, 1, o, 0, 0)) {
-			log_err("fio: bssplit conversion failed\n");
+			log_err("fio: split conversion failed\n");
 			return 1;
 		}
 
 		split->val1[i] = val;
 		split->val2[i] = perc;
 		i++;
-		if (i == 100)
+		if (i == ZONESPLIT_MAX)
 			break;
 	}
 
@@ -104,7 +117,8 @@ static int split_parse_ddir(struct thread_options *o, struct split *split,
 	return 0;
 }
 
-static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str)
+static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
+			bool data)
 {
 	unsigned int i, perc, perc_missing;
 	unsigned int max_bs, min_bs;
@@ -112,7 +126,7 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str)
 
 	memset(&split, 0, sizeof(split));
 
-	if (split_parse_ddir(o, &split, ddir, str))
+	if (split_parse_ddir(o, &split, ddir, str, data))
 		return 1;
 	if (!split.nr)
 		return 0;
@@ -176,9 +190,10 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str)
 	return 0;
 }
 
-typedef int (split_parse_fn)(struct thread_options *, enum fio_ddir, char *);
+typedef int (split_parse_fn)(struct thread_options *, enum fio_ddir, char *, bool);
 
-static int str_split_parse(struct thread_data *td, char *str, split_parse_fn *fn)
+static int str_split_parse(struct thread_data *td, char *str,
+			   split_parse_fn *fn, bool data)
 {
 	char *odir, *ddir;
 	int ret = 0;
@@ -187,37 +202,37 @@ static int str_split_parse(struct thread_data *td, char *str, split_parse_fn *fn
 	if (odir) {
 		ddir = strchr(odir + 1, ',');
 		if (ddir) {
-			ret = fn(&td->o, DDIR_TRIM, ddir + 1);
+			ret = fn(&td->o, DDIR_TRIM, ddir + 1, data);
 			if (!ret)
 				*ddir = '\0';
 		} else {
 			char *op;
 
 			op = strdup(odir + 1);
-			ret = fn(&td->o, DDIR_TRIM, op);
+			ret = fn(&td->o, DDIR_TRIM, op, data);
 
 			free(op);
 		}
 		if (!ret)
-			ret = fn(&td->o, DDIR_WRITE, odir + 1);
+			ret = fn(&td->o, DDIR_WRITE, odir + 1, data);
 		if (!ret) {
 			*odir = '\0';
-			ret = fn(&td->o, DDIR_READ, str);
+			ret = fn(&td->o, DDIR_READ, str, data);
 		}
 	} else {
 		char *op;
 
 		op = strdup(str);
-		ret = fn(&td->o, DDIR_WRITE, op);
+		ret = fn(&td->o, DDIR_WRITE, op, data);
 		free(op);
 
 		if (!ret) {
 			op = strdup(str);
-			ret = fn(&td->o, DDIR_TRIM, op);
+			ret = fn(&td->o, DDIR_TRIM, op, data);
 			free(op);
 		}
 		if (!ret)
-			ret = fn(&td->o, DDIR_READ, str);
+			ret = fn(&td->o, DDIR_READ, str, data);
 	}
 
 	return ret;
@@ -234,7 +249,7 @@ static int str_bssplit_cb(void *data, const char *input)
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	ret = str_split_parse(td, str, bssplit_ddir);
+	ret = str_split_parse(td, str, bssplit_ddir, false);
 
 	if (parse_dryrun()) {
 		int i;
@@ -823,23 +838,15 @@ static int str_sfr_cb(void *data, const char *str)
 }
 #endif
 
-static int zone_cmp(const void *p1, const void *p2)
-{
-	const struct zone_split *zsp1 = p1;
-	const struct zone_split *zsp2 = p2;
-
-	return (int) zsp2->access_perc - (int) zsp1->access_perc;
-}
-
 static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
-			   char *str)
+			   char *str, bool absolute)
 {
 	unsigned int i, perc, perc_missing, sperc, sperc_missing;
 	struct split split;
 
 	memset(&split, 0, sizeof(split));
 
-	if (split_parse_ddir(o, &split, ddir, str))
+	if (split_parse_ddir(o, &split, ddir, str, absolute))
 		return 1;
 	if (!split.nr)
 		return 0;
@@ -848,7 +855,10 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 	o->zone_split_nr[ddir] = split.nr;
 	for (i = 0; i < split.nr; i++) {
 		o->zone_split[ddir][i].access_perc = split.val1[i];
-		o->zone_split[ddir][i].size_perc = split.val2[i];
+		if (absolute)
+			o->zone_split[ddir][i].size = split.val2[i];
+		else
+			o->zone_split[ddir][i].size_perc = split.val2[i];
 	}
 
 	/*
@@ -864,11 +874,12 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 		else
 			perc += zsp->access_perc;
 
-		if (zsp->size_perc == (uint8_t) -1U)
-			sperc_missing++;
-		else
-			sperc += zsp->size_perc;
-
+		if (!absolute) {
+			if (zsp->size_perc == (uint8_t) -1U)
+				sperc_missing++;
+			else
+				sperc += zsp->size_perc;
+		}
 	}
 
 	if (perc > 100 || sperc > 100) {
@@ -910,20 +921,17 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 		}
 	}
 
-	/*
-	 * now sort based on percentages, for ease of lookup
-	 */
-	qsort(o->zone_split[ddir], o->zone_split_nr[ddir], sizeof(struct zone_split), zone_cmp);
 	return 0;
 }
 
 static void __td_zone_gen_index(struct thread_data *td, enum fio_ddir ddir)
 {
 	unsigned int i, j, sprev, aprev;
+	uint64_t sprev_sz;
 
 	td->zone_state_index[ddir] = malloc(sizeof(struct zone_split_index) * 100);
 
-	sprev = aprev = 0;
+	sprev_sz = sprev = aprev = 0;
 	for (i = 0; i < td->o.zone_split_nr[ddir]; i++) {
 		struct zone_split *zsp = &td->o.zone_split[ddir][i];
 
@@ -932,10 +940,14 @@ static void __td_zone_gen_index(struct thread_data *td, enum fio_ddir ddir)
 
 			zsi->size_perc = sprev + zsp->size_perc;
 			zsi->size_perc_prev = sprev;
+
+			zsi->size = sprev_sz + zsp->size;
+			zsi->size_prev = sprev_sz;
 		}
 
 		aprev += zsp->access_perc;
 		sprev += zsp->size_perc;
+		sprev_sz += zsp->size;
 	}
 }
 
@@ -954,8 +966,10 @@ static void td_zone_gen_index(struct thread_data *td)
 		__td_zone_gen_index(td, i);
 }
 
-static int parse_zoned_distribution(struct thread_data *td, const char *input)
+static int parse_zoned_distribution(struct thread_data *td, const char *input,
+				    bool absolute)
 {
+	const char *pre = absolute ? "zoned_abs:" : "zoned:";
 	char *str, *p;
 	int i, ret = 0;
 
@@ -965,14 +979,14 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input)
 	strip_blank_end(str);
 
 	/* We expect it to start like that, bail if not */
-	if (strncmp(str, "zoned:", 6)) {
+	if (strncmp(str, pre, strlen(pre))) {
 		log_err("fio: mismatch in zoned input <%s>\n", str);
 		free(p);
 		return 1;
 	}
-	str += strlen("zoned:");
+	str += strlen(pre);
 
-	ret = str_split_parse(td, str, zone_split_ddir);
+	ret = str_split_parse(td, str, zone_split_ddir, absolute);
 
 	free(p);
 
@@ -984,8 +998,15 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input)
 		for (j = 0; j < td->o.zone_split_nr[i]; j++) {
 			struct zone_split *zsp = &td->o.zone_split[i][j];
 
-			dprint(FD_PARSE, "\t%d: %u/%u\n", j, zsp->access_perc,
-								zsp->size_perc);
+			if (absolute) {
+				dprint(FD_PARSE, "\t%d: %u/%llu\n", j,
+						zsp->access_perc,
+						(unsigned long long) zsp->size);
+			} else {
+				dprint(FD_PARSE, "\t%d: %u/%u\n", j,
+						zsp->access_perc,
+						zsp->size_perc);
+			}
 		}
 	}
 
@@ -1024,7 +1045,9 @@ static int str_random_distribution_cb(void *data, const char *str)
 	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
 		val = 0.0;
 	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED)
-		return parse_zoned_distribution(td, str);
+		return parse_zoned_distribution(td, str, false);
+	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
+		return parse_zoned_distribution(td, str, true);
 	else
 		return 0;
 
@@ -2253,7 +2276,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_RAND_DIST_ZONED,
 			    .help = "Zoned random distribution",
 			  },
-
+			  { .ival = "zoned_abs",
+			    .oval = FIO_RAND_DIST_ZONED_ABS,
+			    .help = "Zoned absolute random distribution",
+			  },
 		},
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
@@ -3432,8 +3458,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "max_latency",
-		.lname	= "Max Latency",
-		.type	= FIO_OPT_INT,
+		.lname	= "Max Latency (usec)",
+		.type	= FIO_OPT_STR_VAL_TIME,
 		.off1	= offsetof(struct thread_options, max_latency),
 		.help	= "Maximum tolerated IO latency (usec)",
 		.is_time = 1,
diff --git a/profiles/act.c b/profiles/act.c
index 4669535..3fa5afa 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -288,10 +288,11 @@ static int act_prep_cmdline(void)
 	return 0;
 }
 
-static int act_io_u_lat(struct thread_data *td, uint64_t usec)
+static int act_io_u_lat(struct thread_data *td, uint64_t nsec)
 {
 	struct act_prof_data *apd = td->prof_data;
 	struct act_slice *slice;
+	uint64_t usec = nsec / 1000ULL;
 	int i, ret = 0;
 	double perm;
 
diff --git a/server.h b/server.h
index ba3abfe..dbd5c27 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 66,
+	FIO_SERVER_VER			= 67,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index ca549b5..3532300 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -36,6 +36,8 @@ struct bssplit {
 struct zone_split {
 	uint8_t access_perc;
 	uint8_t size_perc;
+	uint8_t pad[6];
+	uint64_t size;
 };
 
 #define NR_OPTS_SZ	(FIO_MAX_OPTS / (8 * sizeof(uint64_t)))
@@ -190,7 +192,7 @@ struct thread_options {
 	enum fio_memtype mem_type;
 	unsigned int mem_align;
 
-	unsigned int max_latency;
+	unsigned long long max_latency;
 
 	unsigned int stonewall;
 	unsigned int new_group;
@@ -427,7 +429,8 @@ struct thread_options_pack {
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
-	uint32_t pad;
+
+	uint32_t sync_file_range;
 
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
@@ -467,8 +470,6 @@ struct thread_options_pack {
 	uint32_t mem_type;
 	uint32_t mem_align;
 
-	uint32_t max_latency;
-
 	uint32_t stonewall;
 	uint32_t new_group;
 	uint32_t numjobs;
@@ -519,6 +520,7 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
+	uint32_t pad;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
@@ -579,11 +581,9 @@ struct thread_options_pack {
 	uint64_t offset_increment;
 	uint64_t number_ios;
 
-	uint32_t sync_file_range;
-	uint32_t pad2;
-
 	uint64_t latency_target;
 	uint64_t latency_window;
+	uint64_t max_latency;
 	fio_fp64_t latency_percentile;
 
 	uint32_t sig_figs;
diff --git a/verify.c b/verify.c
index db6e17e..2faeaad 100644
--- a/verify.c
+++ b/verify.c
@@ -30,9 +30,6 @@
 static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 struct verify_header *hdr, unsigned int header_num,
 			 unsigned int header_len);
-static void fill_hdr(struct thread_data *td, struct io_u *io_u,
-		     struct verify_header *hdr, unsigned int header_num,
-		     unsigned int header_len, uint64_t rand_seed);
 static void __fill_hdr(struct thread_data *td, struct io_u *io_u,
 		       struct verify_header *hdr, unsigned int header_num,
 		       unsigned int header_len, uint64_t rand_seed);
@@ -1167,7 +1164,7 @@ static void __fill_hdr(struct thread_data *td, struct io_u *io_u,
 	hdr->rand_seed = rand_seed;
 	hdr->offset = io_u->offset + header_num * td->o.verify_interval;
 	hdr->time_sec = io_u->start_time.tv_sec;
-	hdr->time_usec = io_u->start_time.tv_nsec / 1000;
+	hdr->time_nsec = io_u->start_time.tv_nsec;
 	hdr->thread = td->thread_number;
 	hdr->numberio = io_u->numberio;
 	hdr->crc32 = fio_crc32c(p, offsetof(struct verify_header, crc32));
diff --git a/verify.h b/verify.h
index 5aae2e7..321e648 100644
--- a/verify.h
+++ b/verify.h
@@ -43,7 +43,7 @@ struct verify_header {
 	uint64_t rand_seed;
 	uint64_t offset;
 	uint32_t time_sec;
-	uint32_t time_usec;
+	uint32_t time_nsec;
 	uint16_t thread;
 	uint16_t numberio;
 	uint32_t crc32;
