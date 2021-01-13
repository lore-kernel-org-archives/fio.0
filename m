Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbhAMNBi (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Jan 2021 08:01:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C85C061575
        for <fio@vger.kernel.org>; Wed, 13 Jan 2021 05:00:57 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzfkq-006H3c-FR
        for fio@vger.kernel.org; Wed, 13 Jan 2021 13:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210113130002.488321BC0131@kernel.dk>
Date: Wed, 13 Jan 2021 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 674428a527931d86bfb164abcc847508b3be2742:

  Merge branch 'num2str-patch' of https://github.com/gloit042/fio (2021-01-09 15:28:44 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4008b7fc8e2bff60a4e98de0005e6bc71b1a8641:

  Merge branch 'zipf-pareto-lock' of https://github.com/aclamk/fio (2021-01-12 10:52:54 -0700)

----------------------------------------------------------------
Adam Kupczyk (1):
      distibutions: Extend flexibility of non-uniform random distributions

Jens Axboe (3):
      Merge branch 'fuzz' of https://github.com/catenacyber/fio
      Merge branch 'osx_fix' of https://github.com/sitsofe/fio
      Merge branch 'zipf-pareto-lock' of https://github.com/aclamk/fio

Philippe Antoine (2):
      fuzz: Adds fuzz target for parse_jobs_ini
      options: Fix buffer over read in fio_keyword_replace

Sitsofe Wheeler (1):
      configure: fix compilation on recent macOS Xcode versions

 HOWTO                  | 10 +++++++++-
 Makefile               | 26 +++++++++++++++++++++++++
 cconv.c                |  2 ++
 configure              | 12 ++++++------
 filesetup.c            |  6 +++---
 fio.1                  | 10 +++++++++-
 fio.h                  |  1 +
 init.c                 |  8 +++++---
 lib/gauss.c            |  8 ++++++--
 lib/gauss.h            |  3 ++-
 lib/zipf.c             | 12 +++++++-----
 lib/zipf.h             |  6 ++++--
 options.c              | 42 ++++++++++++++++++++++++++++++++++++++---
 server.h               |  2 +-
 t/fuzz/fuzz_parseini.c | 41 ++++++++++++++++++++++++++++++++++++++++
 t/fuzz/onefile.c       | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++
 t/genzipf.c            |  6 +++---
 thread_options.h       |  2 ++
 18 files changed, 217 insertions(+), 31 deletions(-)
 create mode 100644 t/fuzz/fuzz_parseini.c
 create mode 100644 t/fuzz/onefile.c

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0547c721..372f268f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1361,7 +1361,7 @@ I/O type
 	limit reads or writes to a certain rate.  If that is the case, then the
 	distribution may be skewed. Default: 50.
 
-.. option:: random_distribution=str:float[,str:float][,str:float]
+.. option:: random_distribution=str:float[:float][,str:float][,str:float]
 
 	By default, fio will use a completely uniform random distribution when asked
 	to perform random I/O. Sometimes it is useful to skew the distribution in
@@ -1396,6 +1396,14 @@ I/O type
 	map. For the **normal** distribution, a normal (Gaussian) deviation is
 	supplied as a value between 0 and 100.
 
+	The second, optional float is allowed for **pareto**, **zipf** and **normal** distributions.
+	It allows to set base of distribution in non-default place, giving more control
+	over most probable outcome. This value is in range [0-1] which maps linearly to
+	range of possible random values.
+	Defaults are: random for **pareto** and **zipf**, and 0.5 for **normal**.
+	If you wanted to use **zipf** with a `theta` of 1.2 centered on 1/4 of allowed value range,
+	you would use ``random_distibution=zipf:1.2:0.25``.
+
 	For a **zoned** distribution, fio supports specifying percentages of I/O
 	access that should fall within what range of the file or device. For
 	example, given a criteria of:
diff --git a/Makefile b/Makefile
index a838af9a..f74e59e1 100644
--- a/Makefile
+++ b/Makefile
@@ -346,6 +346,23 @@ T_MEMLOCK_PROGS = t/memlock
 T_TT_OBJS = t/time-test.o
 T_TT_PROGS = t/time-test
 
+T_FUZZ_OBJS = t/fuzz/fuzz_parseini.o
+T_FUZZ_OBJS += $(OBJS)
+ifdef CONFIG_ARITHMETIC
+T_FUZZ_OBJS += lex.yy.o y.tab.o
+endif
+# in case there is no fuzz driver defined by environment variable LIB_FUZZING_ENGINE, use a simple one
+# For instance, with compiler clang, address sanitizer and libFuzzer as a fuzzing engine, you should define
+# export CFLAGS="-fsanitize=address,fuzzer-no-link"
+# export LIB_FUZZING_ENGINE="-fsanitize=address"
+# export CC=clang
+# before running configure && make
+# You can adapt this with different compilers, sanitizers, and fuzzing engines
+ifndef LIB_FUZZING_ENGINE
+T_FUZZ_OBJS += t/fuzz/onefile.o
+endif
+T_FUZZ_PROGS = t/fuzz/fuzz_parseini
+
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
 T_OBJS += $(T_ZIPF_OBJS)
@@ -359,6 +376,7 @@ T_OBJS += $(T_PIPE_ASYNC_OBJS)
 T_OBJS += $(T_MEMLOCK_OBJS)
 T_OBJS += $(T_TT_OBJS)
 T_OBJS += $(T_IOU_RING_OBJS)
+T_OBJS += $(T_FUZZ_OBJS)
 
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
     T_DEDUPE_OBJS += $(WINDOWS_OBJS)
@@ -382,6 +400,7 @@ endif
 ifneq (,$(findstring Linux,$(CONFIG_TARGET_OS)))
 T_TEST_PROGS += $(T_IOU_RING_PROGS)
 endif
+T_TEST_PROGS += $(T_FUZZ_PROGS)
 
 PROGS += $(T_PROGS)
 
@@ -533,6 +552,13 @@ t/ieee754: $(T_IEEE_OBJS)
 fio: $(FIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(FIO_OBJS) $(LIBS) $(HDFSLIB)
 
+t/fuzz/fuzz_parseini: $(T_FUZZ_OBJS)
+ifndef LIB_FUZZING_ENGINE
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_FUZZ_OBJS) $(LIBS) $(HDFSLIB)
+else
+	$(QUIET_LINK)$(CXX) $(LDFLAGS) -o $@ $(T_FUZZ_OBJS) $(LIB_FUZZING_ENGINE) $(LIBS) $(HDFSLIB)
+endif
+
 gfio: $(GFIO_OBJS)
 	$(QUIET_LINK)$(CC) $(filter-out -static, $(LDFLAGS)) -o gfio $(GFIO_OBJS) $(LIBS) $(GFIO_LIBS) $(GTK_LDFLAGS) $(HDFSLIB)
 
diff --git a/cconv.c b/cconv.c
index 488dd799..62c2fc29 100644
--- a/cconv.c
+++ b/cconv.c
@@ -203,6 +203,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zipf_theta.u.f = fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
 	o->pareto_h.u.f = fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i));
 	o->gauss_dev.u.f = fio_uint64_to_double(le64_to_cpu(top->gauss_dev.u.i));
+	o->random_center.u.f = fio_uint64_to_double(le64_to_cpu(top->random_center.u.i));
 	o->random_generator = le32_to_cpu(top->random_generator);
 	o->hugepage_size = le32_to_cpu(top->hugepage_size);
 	o->rw_min_bs = le64_to_cpu(top->rw_min_bs);
@@ -423,6 +424,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->zipf_theta.u.i = __cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
 	top->pareto_h.u.i = __cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
 	top->gauss_dev.u.i = __cpu_to_le64(fio_double_to_uint64(o->gauss_dev.u.f));
+	top->random_center.u.i = __cpu_to_le64(fio_double_to_uint64(o->random_center.u.f));
 	top->random_generator = cpu_to_le32(o->random_generator);
 	top->hugepage_size = cpu_to_le32(o->hugepage_size);
 	top->rw_min_bs = __cpu_to_le64(o->rw_min_bs);
diff --git a/configure b/configure
index e3e37d56..1306f1b3 100755
--- a/configure
+++ b/configure
@@ -45,6 +45,7 @@ print_config() {
 
 # Default CFLAGS
 CFLAGS="-D_GNU_SOURCE -include config-host.h $CFLAGS"
+CONFIGURE_CFLAGS="-Werror-implicit-function-declaration"
 BUILD_CFLAGS=""
 
 # Print a helpful header at the top of config.log
@@ -88,14 +89,14 @@ do_cc() {
 }
 
 compile_object() {
-  do_cc $CFLAGS -Werror-implicit-function-declaration -c -o $TMPO $TMPC
+  do_cc $CFLAGS $CONFIGURE_CFLAGS -c -o $TMPO $TMPC
 }
 
 compile_prog() {
   local_cflags="$1"
   local_ldflags="$2 $LIBS"
   echo "Compiling test case $3" >> config.log
-  do_cc $CFLAGS -Werror-implicit-function-declaration $local_cflags -o $TMPE $TMPC $LDFLAGS $local_ldflags
+  do_cc $CFLAGS $CONFIGURE_CFLAGS $local_cflags -o $TMPE $TMPC $LDFLAGS $local_ldflags
 }
 
 feature_not_found() {
@@ -360,16 +361,15 @@ Darwin)
   if test -z "$cpu" && test "$(sysctl -n hw.optional.x86_64)" = "1"; then
     cpu="x86_64"
   fi
-  # Error at compile time linking of weak/partial symbols if possible...
+  # Avoid configure feature detection of features provided by weak symbols
 cat > $TMPC <<EOF
 int main(void)
 {
   return 0;
 }
 EOF
-  if compile_prog "" "-Wl,-no_weak_imports" "disable weak symbols"; then
-    echo "Disabling weak symbols"
-    LDFLAGS="$LDFLAGS -Wl,-no_weak_imports"
+  if compile_prog "" "-Werror=partial-availability" "error on weak symbols"; then
+    CONFIGURE_CFLAGS="$CONFIGURE_CFLAGS -Werror=partial-availability"
   fi
   ;;
 SunOS)
diff --git a/filesetup.c b/filesetup.c
index 76b3f935..9d033757 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1319,11 +1319,11 @@ static void __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 		seed = td->rand_seeds[4];
 
 	if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
-		zipf_init(&f->zipf, nranges, td->o.zipf_theta.u.f, seed);
+		zipf_init(&f->zipf, nranges, td->o.zipf_theta.u.f, td->o.random_center.u.f, seed);
 	else if (td->o.random_distribution == FIO_RAND_DIST_PARETO)
-		pareto_init(&f->zipf, nranges, td->o.pareto_h.u.f, seed);
+		pareto_init(&f->zipf, nranges, td->o.pareto_h.u.f, td->o.random_center.u.f, seed);
 	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
-		gauss_init(&f->gauss, nranges, td->o.gauss_dev.u.f, seed);
+		gauss_init(&f->gauss, nranges, td->o.gauss_dev.u.f, td->o.random_center.u.f, seed);
 }
 
 static bool init_rand_distribution(struct thread_data *td)
diff --git a/fio.1 b/fio.1
index e361b05f..d477b508 100644
--- a/fio.1
+++ b/fio.1
@@ -1132,7 +1132,7 @@ first. This may interfere with a given rate setting, if fio is asked to
 limit reads or writes to a certain rate. If that is the case, then the
 distribution may be skewed. Default: 50.
 .TP
-.BI random_distribution \fR=\fPstr:float[,str:float][,str:float]
+.BI random_distribution \fR=\fPstr:float[:float][,str:float][,str:float]
 By default, fio will use a completely uniform random distribution when asked
 to perform random I/O. Sometimes it is useful to skew the distribution in
 specific ways, ensuring that some parts of the data is more hot than others.
@@ -1168,6 +1168,14 @@ option. If a non\-uniform model is used, fio will disable use of the random
 map. For the \fBnormal\fR distribution, a normal (Gaussian) deviation is
 supplied as a value between 0 and 100.
 .P
+The second, optional float is allowed for \fBpareto\fR, \fBzipf\fR and \fBnormal\fR
+distributions. It allows to set base of distribution in non-default place, giving
+more control over most probable outcome. This value is in range [0-1] which maps linearly to
+range of possible random values.
+Defaults are: random for \fBpareto\fR and \fBzipf\fR, and 0.5 for \fBnormal\fR.
+If you wanted to use \fBzipf\fR with a `theta` of 1.2 centered on 1/4 of allowed value range,
+you would use `random_distibution=zipf:1.2:0.25`.
+.P
 For a \fBzoned\fR distribution, fio supports specifying percentages of I/O
 access that should fall within what range of the file or device. For
 example, given a criteria of:
diff --git a/fio.h b/fio.h
index fffec001..4d439d98 100644
--- a/fio.h
+++ b/fio.h
@@ -229,6 +229,7 @@ struct thread_data {
 		double pareto_h;
 		double gauss_dev;
 	};
+	double random_center;
 	int error;
 	int sig;
 	int done;
diff --git a/init.c b/init.c
index f9c20bdb..1d14df16 100644
--- a/init.c
+++ b/init.c
@@ -327,6 +327,7 @@ void free_threads_shm(void)
 
 static void free_shm(void)
 {
+#ifndef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
 	if (nr_segments) {
 		flow_exit();
 		fio_debug_jobp = NULL;
@@ -343,6 +344,7 @@ static void free_shm(void)
 	fio_filelock_exit();
 	file_hash_exit();
 	scleanup();
+#endif
 }
 
 static int add_thread_segment(void)
@@ -971,13 +973,13 @@ static void init_rand_file_service(struct thread_data *td)
 	const unsigned int seed = td->rand_seeds[FIO_RAND_FILE_OFF];
 
 	if (td->o.file_service_type == FIO_FSERVICE_ZIPF) {
-		zipf_init(&td->next_file_zipf, nranges, td->zipf_theta, seed);
+		zipf_init(&td->next_file_zipf, nranges, td->zipf_theta, td->random_center, seed);
 		zipf_disable_hash(&td->next_file_zipf);
 	} else if (td->o.file_service_type == FIO_FSERVICE_PARETO) {
-		pareto_init(&td->next_file_zipf, nranges, td->pareto_h, seed);
+		pareto_init(&td->next_file_zipf, nranges, td->pareto_h, td->random_center, seed);
 		zipf_disable_hash(&td->next_file_zipf);
 	} else if (td->o.file_service_type == FIO_FSERVICE_GAUSS) {
-		gauss_init(&td->next_file_gauss, nranges, td->gauss_dev, seed);
+		gauss_init(&td->next_file_gauss, nranges, td->gauss_dev, td->random_center, seed);
 		gauss_disable_hash(&td->next_file_gauss);
 	}
 }
diff --git a/lib/gauss.c b/lib/gauss.c
index 3f84dbc6..c64f61e7 100644
--- a/lib/gauss.c
+++ b/lib/gauss.c
@@ -40,11 +40,11 @@ unsigned long long gauss_next(struct gauss_state *gs)
 	if (!gs->disable_hash)
 		sum = __hash_u64(sum);
 
-	return sum % gs->nranges;
+	return (sum + gs->rand_off) % gs->nranges;
 }
 
 void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
-		unsigned int seed)
+		double center, unsigned int seed)
 {
 	memset(gs, 0, sizeof(*gs));
 	init_rand_seed(&gs->r, seed, 0);
@@ -55,6 +55,10 @@ void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
 		if (gs->stddev > nranges / 2)
 			gs->stddev = nranges / 2;
 	}
+	if (center == -1)
+	  gs->rand_off = 0;
+	else
+	  gs->rand_off = nranges * (center - 0.5);
 }
 
 void gauss_disable_hash(struct gauss_state *gs)
diff --git a/lib/gauss.h b/lib/gauss.h
index 478aa146..19e3a666 100644
--- a/lib/gauss.h
+++ b/lib/gauss.h
@@ -8,11 +8,12 @@ struct gauss_state {
 	struct frand_state r;
 	uint64_t nranges;
 	unsigned int stddev;
+	unsigned int rand_off;
 	bool disable_hash;
 };
 
 void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
-		unsigned int seed);
+		double center, unsigned int seed);
 unsigned long long gauss_next(struct gauss_state *gs);
 void gauss_disable_hash(struct gauss_state *gs);
 
diff --git a/lib/zipf.c b/lib/zipf.c
index 321a4fb9..14d7928f 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -23,19 +23,21 @@ static void zipf_update(struct zipf_state *zs)
 }
 
 static void shared_rand_init(struct zipf_state *zs, uint64_t nranges,
-			     unsigned int seed)
+			     double center, unsigned int seed)
 {
 	memset(zs, 0, sizeof(*zs));
 	zs->nranges = nranges;
 
 	init_rand_seed(&zs->rand, seed, 0);
 	zs->rand_off = __rand(&zs->rand);
+	if (center != -1)
+		zs->rand_off = nranges * center;
 }
 
 void zipf_init(struct zipf_state *zs, uint64_t nranges, double theta,
-	       unsigned int seed)
+	       double center, unsigned int seed)
 {
-	shared_rand_init(zs, nranges, seed);
+	shared_rand_init(zs, nranges, center, seed);
 
 	zs->theta = theta;
 	zs->zeta2 = pow(1.0, zs->theta) + pow(0.5, zs->theta);
@@ -71,9 +73,9 @@ uint64_t zipf_next(struct zipf_state *zs)
 }
 
 void pareto_init(struct zipf_state *zs, uint64_t nranges, double h,
-		 unsigned int seed)
+		 double center, unsigned int seed)
 {
-	shared_rand_init(zs, nranges, seed);
+	shared_rand_init(zs, nranges, center, seed);
 	zs->pareto_pow = log(h) / log(1.0 - h);
 }
 
diff --git a/lib/zipf.h b/lib/zipf.h
index 16b65f57..332e3b2f 100644
--- a/lib/zipf.h
+++ b/lib/zipf.h
@@ -16,10 +16,12 @@ struct zipf_state {
 	bool disable_hash;
 };
 
-void zipf_init(struct zipf_state *zs, uint64_t nranges, double theta, unsigned int seed);
+void zipf_init(struct zipf_state *zs, uint64_t nranges, double theta,
+	       double center, unsigned int seed);
 uint64_t zipf_next(struct zipf_state *zs);
 
-void pareto_init(struct zipf_state *zs, uint64_t nranges, double h, unsigned int seed);
+void pareto_init(struct zipf_state *zs, uint64_t nranges, double h,
+		 double center, unsigned int seed);
 uint64_t pareto_next(struct zipf_state *zs);
 void zipf_disable_hash(struct zipf_state *zs);
 
diff --git a/options.c b/options.c
index 4c472589..47b20c24 100644
--- a/options.c
+++ b/options.c
@@ -44,6 +44,27 @@ static char *get_opt_postfix(const char *str)
 	return strdup(p);
 }
 
+static bool split_parse_distr(const char *str, double *val, double *center)
+{
+	char *cp, *p;
+	bool r;
+
+	p = strdup(str);
+	if (!p)
+		return false;
+
+	cp = strstr(p, ":");
+	r = true;
+	if (cp) {
+		*cp = '\0';
+		cp++;
+		r = str_to_float(cp, center, 0);
+	}
+	r = r && str_to_float(p, val, 0);
+	free(p);
+	return r;
+}
+
 static int bs_cmp(const void *p1, const void *p2)
 {
 	const struct bssplit *bsp1 = p1;
@@ -787,6 +808,7 @@ static int str_fst_cb(void *data, const char *str)
 {
 	struct thread_data *td = cb_data_to_td(data);
 	double val;
+	double center = -1;
 	bool done = false;
 	char *nr;
 
@@ -821,7 +843,7 @@ static int str_fst_cb(void *data, const char *str)
 		return 0;
 
 	nr = get_opt_postfix(str);
-	if (nr && !str_to_float(nr, &val, 0)) {
+	if (nr && !split_parse_distr(nr, &val, &center)) {
 		log_err("fio: file service type random postfix parsing failed\n");
 		free(nr);
 		return 1;
@@ -829,6 +851,12 @@ static int str_fst_cb(void *data, const char *str)
 
 	free(nr);
 
+	if (center != -1 && (center < 0.00 || center > 1.00)) {
+		log_err("fio: distribution center out of range (0 <= center <= 1.0)\n");
+		return 1;
+	}
+	td->random_center = center;
+
 	switch (td->o.file_service_type) {
 	case FIO_FSERVICE_ZIPF:
 		if (val == 1.00) {
@@ -1030,6 +1058,7 @@ static int str_random_distribution_cb(void *data, const char *str)
 {
 	struct thread_data *td = cb_data_to_td(data);
 	double val;
+	double center = -1;
 	char *nr;
 
 	if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
@@ -1046,7 +1075,7 @@ static int str_random_distribution_cb(void *data, const char *str)
 		return 0;
 
 	nr = get_opt_postfix(str);
-	if (nr && !str_to_float(nr, &val, 0)) {
+	if (nr && !split_parse_distr(nr, &val, &center)) {
 		log_err("fio: random postfix parsing failed\n");
 		free(nr);
 		return 1;
@@ -1054,6 +1083,12 @@ static int str_random_distribution_cb(void *data, const char *str)
 
 	free(nr);
 
+	if (center != -1 && (center < 0.00 || center > 1.00)) {
+		log_err("fio: distribution center out of range (0 <= center <= 1.0)\n");
+		return 1;
+	}
+	td->o.random_center.u.f = center;
+
 	if (td->o.random_distribution == FIO_RAND_DIST_ZIPF) {
 		if (val == 1.00) {
 			log_err("fio: zipf theta must different than 1.0\n");
@@ -5064,7 +5099,7 @@ static char *fio_keyword_replace(char *opt)
 		struct fio_keyword *kw = &fio_keywords[i];
 
 		while ((s = strstr(opt, kw->word)) != NULL) {
-			char *new = malloc(strlen(opt) + 1);
+			char *new = calloc(strlen(opt) + 1, 1);
 			char *o_org = opt;
 			int olen = s - opt;
 			int len;
@@ -5081,6 +5116,7 @@ static char *fio_keyword_replace(char *opt)
 			 * in too
 			 */
 			opt += strlen(kw->word) + olen;
+			/* keeps final zero thanks to calloc */
 			if (strlen(opt))
 				memcpy(new + olen + len, opt, opt - o_org - 1);
 
diff --git a/server.h b/server.h
index 6d444749..9256d44c 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 86,
+	FIO_SERVER_VER			= 87,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/fuzz/fuzz_parseini.c b/t/fuzz/fuzz_parseini.c
new file mode 100644
index 00000000..7e422c18
--- /dev/null
+++ b/t/fuzz/fuzz_parseini.c
@@ -0,0 +1,41 @@
+#include "fio.h"
+
+static int initialized = 0;
+
+const char *const fakeargv[] = {(char *) "fuzz",
+	(char *) "--output", (char *) "/dev/null",
+	(char *) "--parse-only",
+	0};
+
+int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size)
+{
+	char *fuzzedini;
+
+	if (size < 2)
+		return 0;
+
+	if (initialized == 0) {
+		if (fio_init_options()) {
+			printf("Failed fio_init_options\n");
+			return 1;
+		}
+
+		parse_cmd_line(4, (char **) fakeargv, 0);
+		sinit();
+
+		initialized = 1;
+	}
+	fuzzedini = malloc(size);
+	if (!fuzzedini) {
+		printf("Failed malloc\n");
+		return 1;
+	}
+	/* final character is type for parse_jobs_ini */
+	memcpy(fuzzedini, data, size - 1);
+	/* ensures final 0 */
+	fuzzedini[size - 1] = 0;
+
+	parse_jobs_ini(fuzzedini, 1, 0, data[size - 1]);
+	free(fuzzedini);
+	return 0;
+}
diff --git a/t/fuzz/onefile.c b/t/fuzz/onefile.c
new file mode 100644
index 00000000..2ed3bbe6
--- /dev/null
+++ b/t/fuzz/onefile.c
@@ -0,0 +1,51 @@
+#include <stdint.h>
+#include <stdlib.h>
+#include <stdio.h>
+
+int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size);
+
+int main(int argc, char** argv)
+{
+	FILE *fp;
+	uint8_t *data;
+	size_t size;
+
+	if (argc != 2)
+		return 1;
+
+	/* opens the file, get its size, and reads it into a buffer */
+	fp = fopen(argv[1], "rb");
+	if (fp == NULL)
+		return 2;
+
+	if (fseek(fp, 0L, SEEK_END) != 0) {
+		fclose(fp);
+		return 2;
+	}
+	size = ftell(fp);
+	if (size == (size_t) -1) {
+		fclose(fp);
+		return 2;
+	}
+	if (fseek(fp, 0L, SEEK_SET) != 0) {
+		fclose(fp);
+		return 2;
+	}
+	data = malloc(size);
+	if (data == NULL) {
+		fclose(fp);
+		return 2;
+	}
+	if (fread(data, size, 1, fp) != 1) {
+		fclose(fp);
+		free(data);
+		return 2;
+	}
+
+	/* launch fuzzer */
+	LLVMFuzzerTestOneInput(data, size);
+	free(data);
+	fclose(fp);
+
+	return 0;
+}
diff --git a/t/genzipf.c b/t/genzipf.c
index 4fc10ae7..cd62e584 100644
--- a/t/genzipf.c
+++ b/t/genzipf.c
@@ -297,11 +297,11 @@ int main(int argc, char *argv[])
 	nranges /= block_size;
 
 	if (dist_type == TYPE_ZIPF)
-		zipf_init(&zs, nranges, dist_val, 1);
+		zipf_init(&zs, nranges, dist_val, -1, 1);
 	else if (dist_type == TYPE_PARETO)
-		pareto_init(&zs, nranges, dist_val, 1);
+		pareto_init(&zs, nranges, dist_val, -1, 1);
 	else
-		gauss_init(&gs, nranges, dist_val, 1);
+		gauss_init(&gs, nranges, dist_val, -1, 1);
 
 	hash_bits = 0;
 	hash_size = nranges;
diff --git a/thread_options.h b/thread_options.h
index 97c400fe..0a033430 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -166,6 +166,7 @@ struct thread_options {
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 	fio_fp64_t gauss_dev;
+	fio_fp64_t random_center;
 
 	unsigned int random_generator;
 
@@ -467,6 +468,7 @@ struct thread_options_pack {
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 	fio_fp64_t gauss_dev;
+	fio_fp64_t random_center;
 
 	uint32_t random_generator;
 

