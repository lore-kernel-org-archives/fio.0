Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbcCKNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Mar 2016 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aeMfk-0005xQ-JG
	for fio@vger.kernel.org; Fri, 11 Mar 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160311130002.633082C00D0@kernel.dk>
Date: Fri, 11 Mar 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9d0ad2a56d63e7f59473f31708358a4b65d2a5e3:

  t/gen-rand: remove compile warning on 32-bit (2016-03-09 14:15:11 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5f2f35697b1559cc4fff47c7c94cb983e6f2a460:

  lib/rand: make __init_randX() static (2016-03-10 12:12:09 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      Fix compile of test programs on archs that use arch_flags at runtime
      t/gen-rand: use 32-bit random generator
      Use 32-bit rand for parts that use rand_between()
      lib/rand: make __init_randX() static

 Makefile      |  6 +++---
 init.c        | 22 +++++++++++++---------
 io_u.c        |  8 ++++----
 lib/rand.h    | 15 +++++++--------
 t/arch.c      |  5 +++++
 t/dedupe.c    |  1 +
 t/gen-rand.c  |  4 ++--
 t/lfsr-test.c |  2 ++
 t/stest.c     |  2 ++
 9 files changed, 39 insertions(+), 26 deletions(-)
 create mode 100644 t/arch.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 6b4c9db..a2502dc 100644
--- a/Makefile
+++ b/Makefile
@@ -191,7 +191,7 @@ endif
 -include $(OBJS:.o=.d)
 
 T_SMALLOC_OBJS = t/stest.o
-T_SMALLOC_OBJS += gettime.o mutex.o smalloc.o t/log.o t/debug.o
+T_SMALLOC_OBJS += gettime.o mutex.o smalloc.o t/log.o t/debug.o t/arch.o
 T_SMALLOC_PROGS = t/stest
 
 T_IEEE_OBJS = t/ieee754.o
@@ -208,7 +208,7 @@ T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o
 T_AXMAP_PROGS = t/axmap
 
 T_LFSR_TEST_OBJS = t/lfsr-test.o
-T_LFSR_TEST_OBJS += lib/lfsr.o gettime.o t/log.o t/debug.o
+T_LFSR_TEST_OBJS += lib/lfsr.o gettime.o t/log.o t/debug.o t/arch.o
 T_LFSR_TEST_PROGS = t/lfsr-test
 
 T_GEN_RAND_OBJS = t/gen-rand.o
@@ -223,7 +223,7 @@ endif
 
 T_DEDUPE_OBJS = t/dedupe.o
 T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
-		lib/memalign.o lib/bloom.o t/debug.o crc/xxhash.o \
+		lib/memalign.o lib/bloom.o t/debug.o crc/xxhash.o t/arch.o \
 		crc/murmur3.o crc/crc32c.o crc/crc32c-intel.o crc/fnv.o
 T_DEDUPE_PROGS = t/fio-dedupe
 
diff --git a/init.c b/init.c
index 149029a..9052add 100644
--- a/init.c
+++ b/init.c
@@ -919,11 +919,13 @@ static int exists_and_not_file(const char *filename)
 	return 1;
 }
 
-static void td_fill_rand_seeds_internal(struct thread_data *td, int use64)
+static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 {
+	int i;
+
 	init_rand_seed(&td->bsrange_state, td->rand_seeds[FIO_RAND_BS_OFF], use64);
 	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF], use64);
-	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF], use64);
+	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF], false);
 
 	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
 		init_rand_seed(&td->next_file_state, td->rand_seeds[FIO_RAND_FILE_OFF], use64);
@@ -932,6 +934,8 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, int use64)
 	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], use64);
 	init_rand_seed(&td->delay_state, td->rand_seeds[FIO_RAND_START_DELAY], use64);
 	init_rand_seed(&td->poisson_state, td->rand_seeds[FIO_RAND_POISSON_OFF], 0);
+	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], false);
+	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], false);
 
 	if (!td_random(td))
 		return;
@@ -940,14 +944,17 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, int use64)
 		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
 
 	init_rand_seed(&td->random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF], use64);
-	init_rand_seed(&td->seq_rand_state[DDIR_READ], td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF], use64);
-	init_rand_seed(&td->seq_rand_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_SEQ_RAND_WRITE_OFF], use64);
-	init_rand_seed(&td->seq_rand_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_SEQ_RAND_TRIM_OFF], use64);
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		struct frand_state *s = &td->seq_rand_state[i];
+
+		init_rand_seed(s, td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF], false);
+	}
 }
 
 void td_fill_rand_seeds(struct thread_data *td)
 {
-	int use64;
+	bool use64;
 
 	if (td->o.allrand_repeatable) {
 		unsigned int i;
@@ -966,9 +973,6 @@ void td_fill_rand_seeds(struct thread_data *td)
 
 	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF], use64);
 	frand_copy(&td->buf_state_prev, &td->buf_state);
-
-	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], use64);
-	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], use64);
 }
 
 /*
diff --git a/io_u.c b/io_u.c
index 3299f29..ea08c92 100644
--- a/io_u.c
+++ b/io_u.c
@@ -177,7 +177,7 @@ bail:
 	/*
 	 * Generate a value, v, between 1 and 100, both inclusive
 	 */
-	v = rand_between(&td->zone_state, 1, 100);
+	v = rand32_between(&td->zone_state, 1, 100);
 
 	zsi = &td->zone_state_index[ddir][v - 1];
 	stotal = zsi->size_perc_prev;
@@ -279,7 +279,7 @@ static bool should_do_random(struct thread_data *td, enum fio_ddir ddir)
 	if (td->o.perc_rand[ddir] == 100)
 		return true;
 
-	v = rand_between(&td->seq_rand_state[ddir], 1, 100);
+	v = rand32_between(&td->seq_rand_state[ddir], 1, 100);
 
 	return v <= td->o.perc_rand[ddir];
 }
@@ -601,7 +601,7 @@ static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 {
 	unsigned int v;
 
-	v = rand_between(&td->rwmix_state, 1, 100);
+	v = rand32_between(&td->rwmix_state, 1, 100);
 
 	if (v <= td->o.rwmix[DDIR_READ])
 		return DDIR_READ;
@@ -1964,7 +1964,7 @@ static struct frand_state *get_buf_state(struct thread_data *td)
 		return &td->buf_state;
 	}
 
-	v = rand_between(&td->dedupe_state, 1, 100);
+	v = rand32_between(&td->dedupe_state, 1, 100);
 
 	if (v <= td->o.dedupe_percentage)
 		return &td->buf_state_prev;
diff --git a/lib/rand.h b/lib/rand.h
index 24fac23..bff4a35 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -2,6 +2,7 @@
 #define FIO_RAND_H
 
 #include <inttypes.h>
+#include <assert.h>
 #include "types.h"
 #include "../arch/arch.h"
 
@@ -24,10 +25,6 @@ struct frand_state {
 	};
 };
 
-struct frand64_state {
-	uint64_t s1, s2, s3, s4, s5;
-};
-
 static inline uint64_t rand_max(struct frand_state *state)
 {
 	if (state->use64)
@@ -121,12 +118,14 @@ static inline double __rand_0_1(struct frand_state *state)
 /*
  * Generate a random value between 'start' and 'end', both inclusive
  */
-static inline int rand_between(struct frand_state *state, int start, int end)
+static inline int rand32_between(struct frand_state *state, int start, int end)
 {
-	uint64_t r;
+	uint32_t r;
+
+	assert(!state->use64);
 
-	r = __rand(state);
-	return start + (int) ((double)end * (r / (rand_max(state) + 1.0)));
+	r = __rand32(&state->state32);
+	return start + (int) ((double)end * (r / (FRAND32_MAX + 1.0)));
 }
 
 extern void init_rand(struct frand_state *, bool);
diff --git a/t/arch.c b/t/arch.c
new file mode 100644
index 0000000..befb7c7
--- /dev/null
+++ b/t/arch.c
@@ -0,0 +1,5 @@
+#include "../arch/arch.h"
+
+unsigned long arch_flags = 0;
+int tsc_reliable;
+int arch_random;
diff --git a/t/dedupe.c b/t/dedupe.c
index 3a66820..7856da1 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -537,6 +537,7 @@ int main(int argc, char *argv[])
 	uint64_t nextents = 0, nchunks = 0;
 	int c, ret;
 
+	arch_init(argv);
 	debug_init();
 
 	while ((c = getopt(argc, argv, "b:t:d:o:c:p:B:")) != -1) {
diff --git a/t/gen-rand.c b/t/gen-rand.c
index a03646a..6c31f92 100644
--- a/t/gen-rand.c
+++ b/t/gen-rand.c
@@ -37,10 +37,10 @@ int main(int argc, char *argv[])
 
 	nvalues = strtoul(argv[3], NULL, 10);
 
-	init_rand(&s, true);
+	init_rand(&s, false);
 
 	for (i = 0; i < nvalues; i++) {
-		int v = rand_between(&s, start, end);
+		int v = rand32_between(&s, start, end);
 
 		buckets[v - start]++;
 	}
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 4352b89..bad5097 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -38,6 +38,8 @@ int main(int argc, char *argv[])
 	void *v = NULL, *v_start;
 	double total, mean;
 
+	arch_init(argv);
+
 	/* Read arguments */
 	switch (argc) {
 		case 5: if (strncmp(argv[4], "verify", 7) == 0)
diff --git a/t/stest.c b/t/stest.c
index fb51989..0e0d8b0 100644
--- a/t/stest.c
+++ b/t/stest.c
@@ -4,6 +4,7 @@
 
 #include "../smalloc.h"
 #include "../flist.h"
+#include "../arch/arch.h"
 #include "debug.h"
 
 #define MAGIC1	0xa9b1c8d2
@@ -69,6 +70,7 @@ static int do_specific_alloc(unsigned long size)
 
 int main(int argc, char *argv[])
 {
+	arch_init(argv);
 	sinit();
 	debug_init();
 
