Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbbE3MAL (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 May 2015 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YyfQv-0007uC-FE
	for fio@vger.kernel.org; Sat, 30 May 2015 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150530120001.81A012C00F5@kernel.dk>
Date: Sat, 30 May 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 68d96e515825185b232bbc8d2e5b5136b90514be:

  treat error in addr conversion to string as non-fatal (2015-05-26 15:12:46 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 37fbd7e9dd4f041b858507b3db06753614083770:

  filesetup: print warning if chosen random generator can't cover range (2015-05-29 19:40:21 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Add Intel rdrand support
      rand: add 64-bit tausworthe variant with a 2^258 cycle
      filesetup: print warning if chosen random generator can't cover range

 HOWTO                  |  2 +
 arch/arch-x86-common.h | 33 ++++++++++-------
 arch/arch-x86_64.h     | 30 +++++++++++++++
 backend.c              |  5 ++-
 crc/test.c             |  2 +-
 filesetup.c            | 14 ++++++-
 fio.1                  |  3 ++
 fio.h                  |  1 +
 init.c                 | 41 +++++++++++++--------
 io_u.c                 | 31 +++++++++++-----
 lib/gauss.c            |  4 +-
 lib/rand.c             | 42 +++++++++++++++++----
 lib/rand.h             | 92 ++++++++++++++++++++++++++++++++++++++++++----
 lib/zipf.c             |  6 +--
 options.c              |  5 +++
 server.c               |  4 +-
 server.h               |  2 +-
 trim.c                 |  4 +-
 verify.c               | 99 +++++++++++++++++++++++++++++++++++++++++---------
 verify.h               | 39 +++++++++++++++++---
 20 files changed, 369 insertions(+), 90 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index ab0250c..291327d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -961,6 +961,8 @@ random_generator=str	Fio supports the following engines for generating
 
 		tausworthe	Strong 2^88 cycle random number generator
 		lfsr		Linear feedback shift register generator
+		tausworthe64	Strong 64-bit 2^258 cycle random number
+				generator
 
 		Tausworthe is a strong random number generator, but it
 		requires tracking on the side if we want to ensure that
diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index 31aa79f..cbf66b8 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -15,8 +15,9 @@ static inline void cpuid(unsigned int op,
 #define ARCH_HAVE_INIT
 
 extern int tsc_reliable;
+extern int arch_random;
 
-static inline int arch_init_intel(unsigned int level)
+static inline void arch_init_intel(unsigned int level)
 {
 	unsigned int eax, ebx, ecx = 0, edx;
 
@@ -26,47 +27,51 @@ static inline int arch_init_intel(unsigned int level)
 	eax = 1;
 	do_cpuid(&eax, &ebx, &ecx, &edx);
 	if (!(edx & (1U << 4)))
-		return 0;
+		return;
 
 	/*
 	 * Check for constant rate and synced (across cores) TSC
 	 */
 	eax = 0x80000007;
 	do_cpuid(&eax, &ebx, &ecx, &edx);
-	return edx & (1U << 8);
+	tsc_reliable = (edx & (1U << 8)) != 0;
+
+	/*
+	 * Check for FDRAND
+	 */
+	eax = 0x1;
+	do_cpuid(&eax, &ebx, &ecx, &edx);
+	arch_random = (ecx & (1U << 30)) != 0;
 }
 
-static inline int arch_init_amd(unsigned int level)
+static inline void arch_init_amd(unsigned int level)
 {
 	unsigned int eax, ebx, ecx, edx;
 
 	cpuid(0x80000000, &eax, &ebx, &ecx, &edx);
 	if (eax < 0x80000007)
-		return 0;
+		return;
 
 	cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
-	if (edx & (1 << 8))
-		return 1;
-
-	return 0;
+	tsc_reliable = (edx & (1U << 8)) != 0;
 }
 
-static inline int arch_init(char *envp[])
+static inline void arch_init(char *envp[])
 {
 	unsigned int level;
 	char str[13];
 
+	arch_random = tsc_reliable = 0;
+
 	cpuid(0, &level, (unsigned int *) &str[0],
 			 (unsigned int *) &str[8],
 			 (unsigned int *) &str[4]);
 
 	str[12] = '\0';
 	if (!strcmp(str, "GenuineIntel"))
-		tsc_reliable = arch_init_intel(level);
+		arch_init_intel(level);
 	else if (!strcmp(str, "AuthenticAMD"))
-		tsc_reliable = arch_init_amd(level);
-
-	return 0;
+		arch_init_amd(level);
 }
 
 #endif
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 61ac75e..8f33fc5 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -60,4 +60,34 @@ static inline unsigned long long get_cpu_clock(void)
 #define ARCH_HAVE_SSE4_2
 #define ARCH_HAVE_CPU_CLOCK
 
+#define RDRAND_LONG	".byte 0x48,0x0f,0xc7,0xf0"
+#define RDSEED_LONG	".byte 0x48,0x0f,0xc7,0xf8"
+#define RDRAND_RETRY	100
+
+static inline int arch_rand_long(unsigned long *val)
+{
+	int ok;
+
+	asm volatile("1: " RDRAND_LONG "\n\t"
+		     "jc 2f\n\t"
+		     "decl %0\n\t"
+		     "jnz 1b\n\t"
+		     "2:"
+		     : "=r" (ok), "=a" (*val)
+		     : "0" (RDRAND_RETRY));
+
+	return ok;
+}
+
+static inline int arch_rand_seed(unsigned long *seed)
+{
+	unsigned char ok;
+
+	asm volatile(RDSEED_LONG "\n\t"
+			"setc %0"
+			: "=qm" (ok), "=a" (*seed));
+
+	return 0;
+}
+
 #endif
diff --git a/backend.c b/backend.c
index ef5003e..2aa8840 100644
--- a/backend.c
+++ b/backend.c
@@ -1878,11 +1878,12 @@ static int fio_verify_load_state(struct thread_data *td)
 
 	if (is_backend) {
 		void *data;
+		int ver;
 
 		ret = fio_server_get_verify_state(td->o.name,
-					td->thread_number - 1, &data);
+					td->thread_number - 1, &data, &ver);
 		if (!ret)
-			verify_convert_assign_state(td, data);
+			verify_convert_assign_state(td, data, ver);
 	} else
 		ret = verify_load_state(td, "local");
 
diff --git a/crc/test.c b/crc/test.c
index dbc5653..05ea73e 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -306,7 +306,7 @@ int fio_crctest(const char *type)
 	}
 
 	buf = malloc(CHUNK);
-	init_rand_seed(&state, 0x8989);
+	init_rand_seed(&state, 0x8989, 0);
 	fill_random_buf(&state, buf, CHUNK);
 
 	for (i = 0; t[i].name; i++) {
diff --git a/filesetup.c b/filesetup.c
index cf8ae94..51efdf7 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -267,11 +267,13 @@ error:
 static unsigned long long get_rand_file_size(struct thread_data *td)
 {
 	unsigned long long ret, sized;
+	uint64_t frand_max;
 	unsigned long r;
 
+	frand_max = rand_max(&td->file_size_state);
 	r = __rand(&td->file_size_state);
 	sized = td->o.file_size_high - td->o.file_size_low;
-	ret = (unsigned long long) ((double) sized * (r / (FRAND_MAX + 1.0)));
+	ret = (unsigned long long) ((double) sized * (r / (frand_max + 1.0)));
 	ret += td->o.file_size_low;
 	ret -= (ret % td->o.rw_min_bs);
 	return ret;
@@ -1065,6 +1067,16 @@ int init_random_map(struct thread_data *td)
 
 		blocks = fsize / (unsigned long long) td->o.rw_min_bs;
 
+		if (blocks > FRAND32_MAX &&
+		    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE &&
+		    !fio_option_is_set(&td->o, random_generator)) {
+			log_err("fio: file %s exceeds 32-bit tausworthe "
+				 "random generator. Use lfsr or "
+				 "tausworthe64.\n", f->file_name);
+			td_verror(td, EINVAL, "init file random");
+			return 1;
+		}
+
 		if (td->o.random_generator == FIO_RAND_GEN_LFSR) {
 			unsigned long seed;
 
diff --git a/fio.1 b/fio.1
index 36f80d6..1657082 100644
--- a/fio.1
+++ b/fio.1
@@ -843,6 +843,9 @@ Strong 2^88 cycle random number generator
 .B lfsr
 Linear feedback shift register generator
 .TP
+.B tausworthe64
+Strong 64-bit 2^258 cycle random number generator
+.TP
 .RE
 .P
 Tausworthe is a strong random number generator, but it requires tracking on the
diff --git a/fio.h b/fio.h
index 6659e28..4e2532f 100644
--- a/fio.h
+++ b/fio.h
@@ -686,6 +686,7 @@ enum {
 enum {
 	FIO_RAND_GEN_TAUSWORTHE = 0,
 	FIO_RAND_GEN_LFSR,
+	FIO_RAND_GEN_TAUSWORTHE64,
 };
 
 enum {
diff --git a/init.c b/init.c
index f34e818..9f1041c 100644
--- a/init.c
+++ b/init.c
@@ -496,12 +496,14 @@ static int fixed_block_size(struct thread_options *o)
 static unsigned long long get_rand_start_delay(struct thread_data *td)
 {
 	unsigned long long delayrange;
+	uint64_t frand_max;
 	unsigned long r;
 
 	delayrange = td->o.start_delay_high - td->o.start_delay;
 
+	frand_max = rand_max(&td->delay_state);
 	r = __rand(&td->delay_state);
-	delayrange = (unsigned long long) ((double) delayrange * (r / (FRAND_MAX + 1.0)));
+	delayrange = (unsigned long long) ((double) delayrange * (r / (frand_max + 1.0)));
 
 	delayrange += td->o.start_delay;
 	return delayrange;
@@ -827,18 +829,18 @@ static int exists_and_not_file(const char *filename)
 	return 1;
 }
 
-static void td_fill_rand_seeds_internal(struct thread_data *td)
+static void td_fill_rand_seeds_internal(struct thread_data *td, int use64)
 {
-	init_rand_seed(&td->bsrange_state, td->rand_seeds[FIO_RAND_BS_OFF]);
-	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF]);
-	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF]);
+	init_rand_seed(&td->bsrange_state, td->rand_seeds[FIO_RAND_BS_OFF], use64);
+	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF], use64);
+	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF], use64);
 
 	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
-		init_rand_seed(&td->next_file_state, td->rand_seeds[FIO_RAND_FILE_OFF]);
+		init_rand_seed(&td->next_file_state, td->rand_seeds[FIO_RAND_FILE_OFF], use64);
 
-	init_rand_seed(&td->file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF]);
-	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF]);
-	init_rand_seed(&td->delay_state, td->rand_seeds[FIO_RAND_START_DELAY]);
+	init_rand_seed(&td->file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], use64);
+	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], use64);
+	init_rand_seed(&td->delay_state, td->rand_seeds[FIO_RAND_START_DELAY], use64);
 
 	if (!td_random(td))
 		return;
@@ -846,14 +848,16 @@ static void td_fill_rand_seeds_internal(struct thread_data *td)
 	if (td->o.rand_repeatable)
 		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
 
-	init_rand_seed(&td->random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
-	init_rand_seed(&td->seq_rand_state[DDIR_READ], td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF]);
-	init_rand_seed(&td->seq_rand_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_SEQ_RAND_WRITE_OFF]);
-	init_rand_seed(&td->seq_rand_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_SEQ_RAND_TRIM_OFF]);
+	init_rand_seed(&td->random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF], use64);
+	init_rand_seed(&td->seq_rand_state[DDIR_READ], td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF], use64);
+	init_rand_seed(&td->seq_rand_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_SEQ_RAND_WRITE_OFF], use64);
+	init_rand_seed(&td->seq_rand_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_SEQ_RAND_TRIM_OFF], use64);
 }
 
 void td_fill_rand_seeds(struct thread_data *td)
 {
+	int use64;
+
 	if (td->o.allrand_repeatable) {
 		unsigned int i;
 
@@ -862,12 +866,17 @@ void td_fill_rand_seeds(struct thread_data *td)
 			       	+ i;
 	}
 
-	td_fill_rand_seeds_internal(td);
+	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
+		use64 = 1;
+	else
+		use64 = 0;
+
+	td_fill_rand_seeds_internal(td, use64);
 
-	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF]);
+	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF], use64);
 	frand_copy(&td->buf_state_prev, &td->buf_state);
 
-	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF]);
+	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], use64);
 }
 
 /*
diff --git a/io_u.c b/io_u.c
index e67149d..63a176f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -89,18 +89,20 @@ static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 {
 	uint64_t r;
 
-	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE) {
-		uint64_t lastb;
+	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE ||
+	    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64) {
+		uint64_t frand_max, lastb;
 
 		lastb = last_block(td, f, ddir);
 		if (!lastb)
 			return 1;
 
+		frand_max = rand_max(&td->random_state);
 		r = __rand(&td->random_state);
 
 		dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
 
-		*b = lastb * (r / ((uint64_t) FRAND_MAX + 1.0));
+		*b = lastb * (r / ((uint64_t) frand_max + 1.0));
 	} else {
 		uint64_t off = 0;
 
@@ -195,7 +197,8 @@ static inline int should_sort_io(struct thread_data *td)
 		return 0;
 	if (td->runstate != TD_VERIFYING)
 		return 0;
-	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE)
+	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE ||
+	    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
 		return 0;
 
 	return 1;
@@ -203,14 +206,16 @@ static inline int should_sort_io(struct thread_data *td)
 
 static int should_do_random(struct thread_data *td, enum fio_ddir ddir)
 {
+	uint64_t frand_max;
 	unsigned int v;
 	unsigned long r;
 
 	if (td->o.perc_rand[ddir] == 100)
 		return 1;
 
+	frand_max = rand_max(&td->seq_rand_state[ddir]);
 	r = __rand(&td->seq_rand_state[ddir]);
-	v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
+	v = 1 + (int) (100.0 * (r / (frand_max + 1.0)));
 
 	return v <= td->o.perc_rand[ddir];
 }
@@ -439,6 +444,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	int ddir = io_u->ddir;
 	unsigned int buflen = 0;
 	unsigned int minbs, maxbs;
+	uint64_t frand_max;
 	unsigned long r;
 
 	assert(ddir_rw(ddir));
@@ -458,12 +464,13 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	if (!io_u_fits(td, io_u, minbs))
 		return 0;
 
+	frand_max = rand_max(&td->bsrange_state);
 	do {
 		r = __rand(&td->bsrange_state);
 
 		if (!td->o.bssplit_nr[ddir]) {
 			buflen = 1 + (unsigned int) ((double) maxbs *
-					(r / (FRAND_MAX + 1.0)));
+					(r / (frand_max + 1.0)));
 			if (buflen < minbs)
 				buflen = minbs;
 		} else {
@@ -475,7 +482,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 
 				buflen = bsp->bs;
 				perc += bsp->perc;
-				if ((r <= ((FRAND_MAX / 100L) * perc)) &&
+				if ((r <= ((frand_max / 100L) * perc)) &&
 				    io_u_fits(td, io_u, buflen))
 					break;
 			}
@@ -521,11 +528,12 @@ static void set_rwmix_bytes(struct thread_data *td)
 
 static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 {
+	uint64_t frand_max = rand_max(&td->rwmix_state);
 	unsigned int v;
 	unsigned long r;
 
 	r = __rand(&td->rwmix_state);
-	v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
+	v = 1 + (int) (100.0 * (r / (frand_max + 1.0)));
 
 	if (v <= td->o.rwmix[DDIR_READ])
 		return DDIR_READ;
@@ -992,6 +1000,7 @@ static struct fio_file *get_next_file_rand(struct thread_data *td,
 					   enum fio_file_flags goodf,
 					   enum fio_file_flags badf)
 {
+	uint64_t frand_max = rand_max(&td->next_file_state);
 	struct fio_file *f;
 	int fno;
 
@@ -1001,7 +1010,7 @@ static struct fio_file *get_next_file_rand(struct thread_data *td,
 
 		r = __rand(&td->next_file_state);
 		fno = (unsigned int) ((double) td->o.nr_files
-				* (r / (FRAND_MAX + 1.0)));
+				* (r / (frand_max + 1.0)));
 
 		f = td->files[fno];
 		if (fio_file_done(f))
@@ -1892,6 +1901,7 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
  */
 static struct frand_state *get_buf_state(struct thread_data *td)
 {
+	uint64_t frand_max;
 	unsigned int v;
 	unsigned long r;
 
@@ -1902,8 +1912,9 @@ static struct frand_state *get_buf_state(struct thread_data *td)
 		return &td->buf_state;
 	}
 
+	frand_max = rand_max(&td->dedupe_state);
 	r = __rand(&td->dedupe_state);
-	v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
+	v = 1 + (int) (100.0 * (r / (frand_max + 1.0)));
 
 	if (v <= td->o.dedupe_percentage)
 		return &td->buf_state_prev;
diff --git a/lib/gauss.c b/lib/gauss.c
index 1bb6c41..afd0490 100644
--- a/lib/gauss.c
+++ b/lib/gauss.c
@@ -15,7 +15,7 @@ static int gauss_dev(struct gauss_state *gs)
 		return 0;
 
 	r = __rand(&gs->r);
-	vr = gs->stddev * (r / (FRAND_MAX + 1.0));
+	vr = gs->stddev * (r / (FRAND32_MAX + 1.0));
 
 	return vr - gs->stddev / 2;
 }
@@ -45,7 +45,7 @@ void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
 		unsigned int seed)
 {
 	memset(gs, 0, sizeof(*gs));
-	init_rand_seed(&gs->r, seed);
+	init_rand_seed(&gs->r, seed, 0);
 	gs->nranges = nranges;
 
 	if (dev != 0.0) {
diff --git a/lib/rand.c b/lib/rand.c
index 185b679..2e4c66e 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -38,12 +38,14 @@
 #include "rand.h"
 #include "../hash.h"
 
-static inline int __seed(unsigned int x, unsigned int m)
+int arch_random;
+
+static inline uint64_t __seed(uint64_t x, uint64_t m)
 {
 	return (x < m) ? x + m : x;
 }
 
-static void __init_rand(struct frand_state *state, unsigned int seed)
+static void __init_rand32(struct taus88_state *state, unsigned int seed)
 {
 	int cranks = 6;
 
@@ -54,17 +56,43 @@ static void __init_rand(struct frand_state *state, unsigned int seed)
 	state->s3 = __seed(LCG(state->s2, seed), 15);
 
 	while (cranks--)
-		__rand(state);
+		__rand32(state);
 }
 
-void init_rand(struct frand_state *state)
+static void __init_rand64(struct taus258_state *state, uint64_t seed)
 {
-	__init_rand(state, 1);
+	int cranks = 6;
+
+#define LCG64(x, seed)  ((x) * 6906969069ULL ^ (seed))
+
+	state->s1 = __seed(LCG64((2^31) + (2^17) + (2^7), seed), 1);
+	state->s2 = __seed(LCG64(state->s1, seed), 7);
+	state->s3 = __seed(LCG64(state->s2, seed), 15);
+	state->s4 = __seed(LCG64(state->s3, seed), 33);
+	state->s5 = __seed(LCG64(state->s4, seed), 49);
+
+	while (cranks--)
+		__rand64(state);
 }
 
-void init_rand_seed(struct frand_state *state, unsigned int seed)
+void init_rand(struct frand_state *state, int use64)
 {
-	__init_rand(state, seed);
+	state->use64 = use64;
+
+	if (!use64)
+		__init_rand32(&state->state32, 1);
+	else
+		__init_rand64(&state->state64, 1);
+}
+
+void init_rand_seed(struct frand_state *state, unsigned int seed, int use64)
+{
+	state->use64 = use64;
+
+	if (!use64)
+		__init_rand32(&state->state32, seed);
+	else
+		__init_rand64(&state->state64, seed);
 }
 
 void __fill_random_buf(void *buf, unsigned int len, unsigned long seed)
diff --git a/lib/rand.h b/lib/rand.h
index 089837d..cab9158 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -1,21 +1,69 @@
 #ifndef FIO_RAND_H
 #define FIO_RAND_H
 
-#define FRAND_MAX	(-1U)
+#include <inttypes.h>
+#include "../arch/arch.h"
 
-struct frand_state {
+#define FRAND32_MAX	(-1U)
+#define FRAND64_MAX	(-1ULL)
+
+struct taus88_state {
 	unsigned int s1, s2, s3;
 };
 
-static inline void frand_copy(struct frand_state *dst,
-			      struct frand_state *src)
+struct taus258_state {
+	uint64_t s1, s2, s3, s4, s5;
+};
+
+struct frand_state {
+	unsigned int use64;
+	union {
+		struct taus88_state state32;
+		struct taus258_state state64;
+	};
+};
+
+struct frand64_state {
+	uint64_t s1, s2, s3, s4, s5;
+};
+
+static inline uint64_t rand_max(struct frand_state *state)
+{
+	if (state->use64)
+		return FRAND64_MAX;
+	else
+		return FRAND32_MAX;
+}
+
+static inline void __frand32_copy(struct taus88_state *dst,
+				  struct taus88_state *src)
+{
+	dst->s1 = src->s1;
+	dst->s2 = src->s2;
+	dst->s3 = src->s3;
+}
+
+static inline void __frand64_copy(struct taus258_state *dst,
+				  struct taus258_state *src)
 {
 	dst->s1 = src->s1;
 	dst->s2 = src->s2;
 	dst->s3 = src->s3;
+	dst->s4 = src->s4;
+	dst->s5 = src->s5;
+}
+
+static inline void frand_copy(struct frand_state *dst, struct frand_state *src)
+{
+	if (src->use64)
+		__frand64_copy(&dst->state64, &src->state64);
+	else
+		__frand32_copy(&dst->state32, &src->state32);
+
+	dst->use64 = src->use64;
 }
 
-static inline unsigned int __rand(struct frand_state *state)
+static inline unsigned int __rand32(struct taus88_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
 
@@ -26,8 +74,38 @@ static inline unsigned int __rand(struct frand_state *state)
 	return (state->s1 ^ state->s2 ^ state->s3);
 }
 
-extern void init_rand(struct frand_state *);
-extern void init_rand_seed(struct frand_state *, unsigned int seed);
+static inline uint64_t __rand64(struct taus258_state *state)
+{
+	uint64_t xval;
+
+	xval = ((state->s1 <<  1) ^ state->s1) >> 53;
+	state->s1 = ((state->s1 & 18446744073709551614ULL) << 10) ^ xval;
+
+	xval = ((state->s2 << 24) ^ state->s2) >> 50;
+	state->s2 = ((state->s2 & 18446744073709551104ULL) <<  5) ^ xval;
+
+	xval = ((state->s3 <<  3) ^ state->s3) >> 23;
+	state->s3 = ((state->s3 & 18446744073709547520ULL) << 29) ^ xval;
+
+	xval = ((state->s4 <<  5) ^ state->s4) >> 24;
+	state->s4 = ((state->s4 & 18446744073709420544ULL) << 23) ^ xval;
+
+	xval = ((state->s5 <<  3) ^ state->s5) >> 33;
+	state->s5 = ((state->s5 & 18446744073701163008ULL) <<  8) ^ xval;
+
+	return (state->s1 ^ state->s2 ^ state->s3 ^ state->s4 ^ state->s5);
+}
+
+static inline uint64_t __rand(struct frand_state *state)
+{
+	if (state->use64)
+		return __rand64(&state->state64);
+	else
+		return __rand32(&state->state32);
+}
+
+extern void init_rand(struct frand_state *, int);
+extern void init_rand_seed(struct frand_state *, unsigned int seed, int);
 extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
 extern unsigned long fill_random_buf(struct frand_state *, void *buf, unsigned int len);
 extern void __fill_random_buf_percentage(unsigned long, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
diff --git a/lib/zipf.c b/lib/zipf.c
index c691bc5..d8e72b1 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -35,7 +35,7 @@ static void shared_rand_init(struct zipf_state *zs, unsigned long nranges,
 	memset(zs, 0, sizeof(*zs));
 	zs->nranges = nranges;
 
-	init_rand_seed(&zs->rand, seed);
+	init_rand_seed(&zs->rand, seed, 0);
 	zs->rand_off = __rand(&zs->rand);
 }
 
@@ -59,7 +59,7 @@ unsigned long long zipf_next(struct zipf_state *zs)
 	alpha = 1.0 / (1.0 - zs->theta);
 	eta = (1.0 - pow(2.0 / n, 1.0 - zs->theta)) / (1.0 - zs->zeta2 / zs->zetan);
 
-	rand_uni = (double) __rand(&zs->rand) / (double) FRAND_MAX;
+	rand_uni = (double) __rand(&zs->rand) / (double) FRAND32_MAX;
 	rand_z = rand_uni * zs->zetan;
 
 	if (rand_z < 1.0)
@@ -81,7 +81,7 @@ void pareto_init(struct zipf_state *zs, unsigned long nranges, double h,
 
 unsigned long long pareto_next(struct zipf_state *zs)
 {
-	double rand = (double) __rand(&zs->rand) / (double) FRAND_MAX;
+	double rand = (double) __rand(&zs->rand) / (double) FRAND32_MAX;
 	unsigned long long n = zs->nranges - 1;
 
 	return (__hash_u64(n * pow(rand, zs->pareto_pow)) + zs->rand_off) % zs->nranges;
diff --git a/options.c b/options.c
index 7f9075b..96b8b68 100644
--- a/options.c
+++ b/options.c
@@ -1897,6 +1897,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_RAND_GEN_LFSR,
 			    .help = "Variable length LFSR",
 			  },
+			  {
+			    .ival = "tausworthe64",
+			    .oval = FIO_RAND_GEN_TAUSWORTHE64,
+			    .help = "64-bit Tausworthe variant",
+			  },
 		},
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
diff --git a/server.c b/server.c
index 519a7ee..b4137d1 100644
--- a/server.c
+++ b/server.c
@@ -1410,7 +1410,7 @@ void fio_server_send_start(struct thread_data *td)
 }
 
 int fio_server_get_verify_state(const char *name, int threadnumber,
-				void **datap)
+				void **datap, int *version)
 {
 	struct thread_io_list *s;
 	struct cmd_sendfile out;
@@ -1458,7 +1458,7 @@ fail:
 	 * the header, and the thread_io_list checksum
 	 */
 	s = rep->data + sizeof(struct verify_state_hdr);
-	if (verify_state_hdr(rep->data, s))
+	if (verify_state_hdr(rep->data, s, version))
 		goto fail;
 
 	/*
diff --git a/server.h b/server.h
index 9944719..e4da882 100644
--- a/server.h
+++ b/server.h
@@ -197,7 +197,7 @@ extern void fio_server_send_ts(struct thread_stat *, struct group_run_stats *);
 extern void fio_server_send_gs(struct group_run_stats *);
 extern void fio_server_send_du(void);
 extern void fio_server_idle_loop(void);
-extern int fio_server_get_verify_state(const char *, int, void **);
+extern int fio_server_get_verify_state(const char *, int, void **, int *);
 
 extern int fio_recv_data(int sk, void *p, unsigned int len);
 extern int fio_send_data(int sk, const void *p, unsigned int len);
diff --git a/trim.c b/trim.c
index 95c433b..4345541 100644
--- a/trim.c
+++ b/trim.c
@@ -70,13 +70,15 @@ int get_next_trim(struct thread_data *td, struct io_u *io_u)
 int io_u_should_trim(struct thread_data *td, struct io_u *io_u)
 {
 	unsigned long long val;
+	uint64_t frand_max;
 	unsigned long r;
 
 	if (!td->o.trim_percentage)
 		return 0;
 
+	frand_max = rand_max(&td->trim_state);
 	r = __rand(&td->trim_state);
-	val = (FRAND_MAX / 100ULL);
+	val = (frand_max / 100ULL);
 
 	val *= (unsigned long long) td->o.trim_percentage;
 	return r <= val;
diff --git a/verify.c b/verify.c
index aa178e9..fcdf748 100644
--- a/verify.c
+++ b/verify.c
@@ -1343,10 +1343,21 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		s->depth = cpu_to_le64((uint64_t) td->o.iodepth);
 		s->numberio = cpu_to_le64((uint64_t) td->io_issues[DDIR_WRITE]);
 		s->index = cpu_to_le64((uint64_t) i);
-		s->rand.s[0] = cpu_to_le32(td->random_state.s1);
-		s->rand.s[1] = cpu_to_le32(td->random_state.s2);
-		s->rand.s[2] = cpu_to_le32(td->random_state.s3);
-		s->rand.s[3] = 0;
+		if (td->random_state.use64) {
+			s->rand.state64.s[0] = cpu_to_le64(td->random_state.state64.s1);
+			s->rand.state64.s[1] = cpu_to_le64(td->random_state.state64.s2);
+			s->rand.state64.s[2] = cpu_to_le64(td->random_state.state64.s3);
+			s->rand.state64.s[3] = cpu_to_le64(td->random_state.state64.s4);
+			s->rand.state64.s[4] = cpu_to_le64(td->random_state.state64.s5);
+			s->rand.state64.s[5] = 0;
+			s->rand.use64 = cpu_to_le64((uint64_t)1);
+		} else {
+			s->rand.state32.s[0] = cpu_to_le32(td->random_state.state32.s1);
+			s->rand.state32.s[1] = cpu_to_le32(td->random_state.state32.s2);
+			s->rand.state32.s[2] = cpu_to_le32(td->random_state.state32.s3);
+			s->rand.state32.s[3] = 0;
+			s->rand.use64 = 0;
+		}
 		s->name[sizeof(s->name) - 1] = '\0';
 		strncpy((char *) s->name, td->o.name, sizeof(s->name) - 1);
 		next = io_list_next(s);
@@ -1442,23 +1453,72 @@ void verify_free_state(struct thread_data *td)
 		free(td->vstate);
 }
 
-void verify_convert_assign_state(struct thread_data *td,
-				 struct thread_io_list *s)
+static struct thread_io_list *convert_v1_list(struct thread_io_list_v1 *s)
 {
+	struct thread_io_list *til;
 	int i;
 
-	s->no_comps = le64_to_cpu(s->no_comps);
-	s->depth = le64_to_cpu(s->depth);
-	s->numberio = le64_to_cpu(s->numberio);
+	til = malloc(__thread_io_list_sz(s->no_comps));
+	til->no_comps = s->no_comps;
+	til->depth = s->depth;
+	til->numberio = s->numberio;
+	til->index = s->index;
+	memcpy(til->name, s->name, sizeof(til->name));
+
+	til->rand.use64 = 0;
 	for (i = 0; i < 4; i++)
-		s->rand.s[i] = le32_to_cpu(s->rand.s[i]);
+		til->rand.state32.s[i] = s->rand.s[i];
+
 	for (i = 0; i < s->no_comps; i++)
-		s->offsets[i] = le64_to_cpu(s->offsets[i]);
+		til->offsets[i] = s->offsets[i];
+
+	return til;
+}
+
+void verify_convert_assign_state(struct thread_data *td, void *p, int version)
+{
+	struct thread_io_list *til;
+	int i;
+
+	if (version == 1) {
+		struct thread_io_list_v1 *s = p;
+
+		s->no_comps = le64_to_cpu(s->no_comps);
+		s->depth = le64_to_cpu(s->depth);
+		s->numberio = le64_to_cpu(s->numberio);
+		for (i = 0; i < 4; i++)
+			s->rand.s[i] = le32_to_cpu(s->rand.s[i]);
+		for (i = 0; i < s->no_comps; i++)
+			s->offsets[i] = le64_to_cpu(s->offsets[i]);
+
+		til = convert_v1_list(s);
+		free(s);
+	} else {
+		struct thread_io_list *s = p;
+
+		s->no_comps = le64_to_cpu(s->no_comps);
+		s->depth = le64_to_cpu(s->depth);
+		s->numberio = le64_to_cpu(s->numberio);
+		s->rand.use64 = le64_to_cpu(s->rand.use64);
+
+		if (s->rand.use64) {
+			for (i = 0; i < 6; i++)
+				s->rand.state64.s[i] = le64_to_cpu(s->rand.state64.s[i]);
+		} else {
+			for (i = 0; i < 4; i++)
+				s->rand.state32.s[i] = le32_to_cpu(s->rand.state32.s[i]);
+		}
+		for (i = 0; i < s->no_comps; i++)
+			s->offsets[i] = le64_to_cpu(s->offsets[i]);
+
+		til = p;
+	}
 
-	td->vstate = s;
+	td->vstate = til;
 }
 
-int verify_state_hdr(struct verify_state_hdr *hdr, struct thread_io_list *s)
+int verify_state_hdr(struct verify_state_hdr *hdr, struct thread_io_list *s,
+		     int *version)
 {
 	uint64_t crc;
 
@@ -1466,20 +1526,22 @@ int verify_state_hdr(struct verify_state_hdr *hdr, struct thread_io_list *s)
 	hdr->size = le64_to_cpu(hdr->size);
 	hdr->crc = le64_to_cpu(hdr->crc);
 
-	if (hdr->version != VSTATE_HDR_VERSION)
+	if (hdr->version != VSTATE_HDR_VERSION ||
+	    hdr->version != VSTATE_HDR_VERSION_V1)
 		return 1;
 
 	crc = fio_crc32c((void *)s, hdr->size);
 	if (crc != hdr->crc)
 		return 1;
 
+	*version = hdr->version;
 	return 0;
 }
 
 int verify_load_state(struct thread_data *td, const char *prefix)
 {
-	struct thread_io_list *s = NULL;
 	struct verify_state_hdr hdr;
+	void *s = NULL;
 	uint64_t crc;
 	ssize_t ret;
 	int fd;
@@ -1503,7 +1565,8 @@ int verify_load_state(struct thread_data *td, const char *prefix)
 	hdr.size = le64_to_cpu(hdr.size);
 	hdr.crc = le64_to_cpu(hdr.crc);
 
-	if (hdr.version != VSTATE_HDR_VERSION) {
+	if (hdr.version != VSTATE_HDR_VERSION &&
+	    hdr.version != VSTATE_HDR_VERSION_V1) {
 		log_err("fio: bad version in verify state header\n");
 		goto err;
 	}
@@ -1517,7 +1580,7 @@ int verify_load_state(struct thread_data *td, const char *prefix)
 		goto err;
 	}
 
-	crc = fio_crc32c((void *)s, hdr.size);
+	crc = fio_crc32c(s, hdr.size);
 	if (crc != hdr.crc) {
 		log_err("fio: verify state is corrupt\n");
 		goto err;
@@ -1525,7 +1588,7 @@ int verify_load_state(struct thread_data *td, const char *prefix)
 
 	close(fd);
 
-	verify_convert_assign_state(td, s);
+	verify_convert_assign_state(td, s, hdr.version);
 	return 0;
 err:
 	if (s)
diff --git a/verify.h b/verify.h
index 43de887..d4d6012 100644
--- a/verify.h
+++ b/verify.h
@@ -88,10 +88,22 @@ extern void fio_verify_init(struct thread_data *td);
 extern int verify_async_init(struct thread_data *);
 extern void verify_async_exit(struct thread_data *);
 
-struct thread_rand_state {
+struct thread_rand32_state {
 	uint32_t s[4];
 };
 
+struct thread_rand64_state {
+	uint64_t s[6];
+};
+
+struct thread_rand_state {
+	uint64_t use64;
+	union {
+		struct thread_rand32_state state32;
+		struct thread_rand64_state state64;
+	};
+};
+
 /*
  * For dumping current write state
  */
@@ -105,12 +117,23 @@ struct thread_io_list {
 	uint64_t offsets[0];
 };
 
+struct thread_io_list_v1 {
+	uint64_t no_comps;
+	uint64_t depth;
+	uint64_t numberio;
+	uint64_t index;
+	struct thread_rand32_state rand;
+	uint8_t name[64];
+	uint64_t offsets[0];
+};
+
 struct all_io_list {
 	uint64_t threads;
 	struct thread_io_list state[0];
 };
 
-#define VSTATE_HDR_VERSION	0x01
+#define VSTATE_HDR_VERSION_V1	0x01
+#define VSTATE_HDR_VERSION	0x02
 
 struct verify_state_hdr {
 	uint64_t version;
@@ -125,12 +148,18 @@ extern void verify_save_state(void);
 extern int verify_load_state(struct thread_data *, const char *);
 extern void verify_free_state(struct thread_data *);
 extern int verify_state_should_stop(struct thread_data *, struct io_u *);
-extern void verify_convert_assign_state(struct thread_data *, struct thread_io_list *);
-extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *);
+extern void verify_convert_assign_state(struct thread_data *, void *, int);
+extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *,
+				int *);
+
+static inline size_t __thread_io_list_sz(uint64_t depth)
+{
+	return sizeof(struct thread_io_list) + depth * sizeof(uint64_t);
+}
 
 static inline size_t thread_io_list_sz(struct thread_io_list *s)
 {
-	return sizeof(*s) + le64_to_cpu(s->depth) * sizeof(uint64_t);
+	return __thread_io_list_sz(le64_to_cpu(s->depth));
 }
 
 static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
