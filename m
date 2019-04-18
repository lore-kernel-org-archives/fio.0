Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388344AbfDRMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Apr 2019 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hH5i4-0000qL-PJ
        for fio@vger.kernel.org; Thu, 18 Apr 2019 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190418120001.ED16E2C0178@kernel.dk>
Date: Thu, 18 Apr 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ef32da643574162c2b1aae67af38ecffb43db036:

  Merge branch 'patch-1' of https://github.com/neheb/fio (2019-04-01 06:57:22 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 96416da576d47c01dd3c9481b03e969908b3ff74:

  Merge branch 'master' of https://github.com/mingnus/fio (2019-04-17 06:50:25 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/mingnus/fio

Ming-Hung Tsai (1):
      rand: fix truncated rand_seed on Windows

 filesetup.c     |  2 +-
 fio.h           |  2 +-
 init.c          |  2 +-
 lib/lfsr.c      |  6 +++---
 lib/lfsr.h      |  4 ++--
 lib/rand.c      | 20 ++++++++++----------
 lib/rand.h      |  8 ++++----
 os/os-windows.h |  2 +-
 os/os.h         |  2 +-
 verify.c        | 10 +++++-----
 verify.h        |  2 +-
 11 files changed, 30 insertions(+), 30 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index aa1a3945..47c889a0 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1287,7 +1287,7 @@ bool init_random_map(struct thread_data *td)
 			return false;
 
 		if (td->o.random_generator == FIO_RAND_GEN_LFSR) {
-			unsigned long seed;
+			uint64_t seed;
 
 			seed = td->rand_seeds[FIO_RAND_BLOCK_OFF];
 
diff --git a/fio.h b/fio.h
index b3ba5db2..2103151d 100644
--- a/fio.h
+++ b/fio.h
@@ -245,7 +245,7 @@ struct thread_data {
 	void *iolog_buf;
 	FILE *iolog_f;
 
-	unsigned long rand_seeds[FIO_RAND_NR_OFFS];
+	uint64_t rand_seeds[FIO_RAND_NR_OFFS];
 
 	struct frand_state bsrange_state[DDIR_RWDIR_CNT];
 	struct frand_state verify_state;
diff --git a/init.c b/init.c
index e6378715..73834279 100644
--- a/init.c
+++ b/init.c
@@ -1217,7 +1217,7 @@ static void init_flags(struct thread_data *td)
 
 static int setup_random_seeds(struct thread_data *td)
 {
-	unsigned long seed;
+	uint64_t seed;
 	unsigned int i;
 
 	if (!td->o.rand_repeatable && !fio_option_is_set(&td->o, rand_seed)) {
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 32fbec56..1ef6ebbf 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -232,7 +232,7 @@ static int prepare_spin(struct fio_lfsr *fl, unsigned int spin)
 	return 0;
 }
 
-int lfsr_reset(struct fio_lfsr *fl, unsigned long seed)
+int lfsr_reset(struct fio_lfsr *fl, uint64_t seed)
 {
 	uint64_t bitmask = (fl->cached_bit << 1) - 1;
 
@@ -246,8 +246,8 @@ int lfsr_reset(struct fio_lfsr *fl, unsigned long seed)
 	return 0;
 }
 
-int lfsr_init(struct fio_lfsr *fl, uint64_t nums, unsigned long seed,
-		unsigned int spin)
+int lfsr_init(struct fio_lfsr *fl, uint64_t nums, uint64_t seed,
+	      unsigned int spin)
 {
 	uint8_t *taps;
 
diff --git a/lib/lfsr.h b/lib/lfsr.h
index c2d55693..95bc07fd 100644
--- a/lib/lfsr.h
+++ b/lib/lfsr.h
@@ -24,7 +24,7 @@ struct fio_lfsr {
 
 int lfsr_next(struct fio_lfsr *fl, uint64_t *off);
 int lfsr_init(struct fio_lfsr *fl, uint64_t size,
-		unsigned long seed, unsigned int spin);
-int lfsr_reset(struct fio_lfsr *fl, unsigned long seed);
+	      uint64_t seed, unsigned int spin);
+int lfsr_reset(struct fio_lfsr *fl, uint64_t seed);
 
 #endif
diff --git a/lib/rand.c b/lib/rand.c
index f18bd8d8..69acb06c 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -95,7 +95,7 @@ void init_rand_seed(struct frand_state *state, unsigned int seed, bool use64)
 		__init_rand64(&state->state64, seed);
 }
 
-void __fill_random_buf(void *buf, unsigned int len, unsigned long seed)
+void __fill_random_buf(void *buf, unsigned int len, uint64_t seed)
 {
 	void *ptr = buf;
 
@@ -122,10 +122,10 @@ void __fill_random_buf(void *buf, unsigned int len, unsigned long seed)
 	}
 }
 
-unsigned long fill_random_buf(struct frand_state *fs, void *buf,
-			      unsigned int len)
+uint64_t fill_random_buf(struct frand_state *fs, void *buf,
+			 unsigned int len)
 {
-	unsigned long r = __rand(fs);
+	uint64_t r = __rand(fs);
 
 	if (sizeof(int) != sizeof(long *))
 		r *= (unsigned long) __rand(fs);
@@ -134,7 +134,7 @@ unsigned long fill_random_buf(struct frand_state *fs, void *buf,
 	return r;
 }
 
-void __fill_random_buf_percentage(unsigned long seed, void *buf,
+void __fill_random_buf_percentage(uint64_t seed, void *buf,
 				  unsigned int percentage,
 				  unsigned int segment, unsigned int len,
 				  char *pattern, unsigned int pbytes)
@@ -183,12 +183,12 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
 	}
 }
 
-unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
-					 unsigned int percentage,
-					 unsigned int segment, unsigned int len,
-					 char *pattern, unsigned int pbytes)
+uint64_t fill_random_buf_percentage(struct frand_state *fs, void *buf,
+				    unsigned int percentage,
+				    unsigned int segment, unsigned int len,
+				    char *pattern, unsigned int pbytes)
 {
-	unsigned long r = __rand(fs);
+	uint64_t r = __rand(fs);
 
 	if (sizeof(int) != sizeof(long *))
 		r *= (unsigned long) __rand(fs);
diff --git a/lib/rand.h b/lib/rand.h
index 1676cf98..95d4f6d4 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -150,9 +150,9 @@ static inline uint64_t rand_between(struct frand_state *state, uint64_t start,
 
 extern void init_rand(struct frand_state *, bool);
 extern void init_rand_seed(struct frand_state *, unsigned int seed, bool);
-extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
-extern unsigned long fill_random_buf(struct frand_state *, void *buf, unsigned int len);
-extern void __fill_random_buf_percentage(unsigned long, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
-extern unsigned long fill_random_buf_percentage(struct frand_state *, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
+extern void __fill_random_buf(void *buf, unsigned int len, uint64_t seed);
+extern uint64_t fill_random_buf(struct frand_state *, void *buf, unsigned int len);
+extern void __fill_random_buf_percentage(uint64_t, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
+extern uint64_t fill_random_buf_percentage(struct frand_state *, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
 
 #endif
diff --git a/os/os-windows.h b/os/os-windows.h
index ef955dc3..dc958f5c 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -167,7 +167,7 @@ static inline int gettid(void)
 	return GetCurrentThreadId();
 }
 
-static inline int init_random_seeds(unsigned long *rand_seeds, int size)
+static inline int init_random_seeds(uint64_t *rand_seeds, int size)
 {
 	HCRYPTPROV hCryptProv;
 
diff --git a/os/os.h b/os/os.h
index 36b6bb2e..756ece4b 100644
--- a/os/os.h
+++ b/os/os.h
@@ -323,7 +323,7 @@ static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 #endif
 
 #ifdef FIO_USE_GENERIC_INIT_RANDOM_STATE
-static inline int init_random_seeds(unsigned long *rand_seeds, int size)
+static inline int init_random_seeds(uint64_t *rand_seeds, int size)
 {
 	int fd;
 
diff --git a/verify.c b/verify.c
index da429e79..f79ab43a 100644
--- a/verify.c
+++ b/verify.c
@@ -39,14 +39,14 @@ void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len)
 	(void)cpy_pattern(td->o.buffer_pattern, td->o.buffer_pattern_bytes, p, len);
 }
 
-static void __fill_buffer(struct thread_options *o, unsigned long seed, void *p,
+static void __fill_buffer(struct thread_options *o, uint64_t seed, void *p,
 			  unsigned int len)
 {
 	__fill_random_buf_percentage(seed, p, o->compress_percentage, len, len, o->buffer_pattern, o->buffer_pattern_bytes);
 }
 
-static unsigned long fill_buffer(struct thread_data *td, void *p,
-				 unsigned int len)
+static uint64_t fill_buffer(struct thread_data *td, void *p,
+			    unsigned int len)
 {
 	struct frand_state *fs = &td->verify_state;
 	struct thread_options *o = &td->o;
@@ -55,7 +55,7 @@ static unsigned long fill_buffer(struct thread_data *td, void *p,
 }
 
 void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
-			 struct io_u *io_u, unsigned long seed, int use_seed)
+			 struct io_u *io_u, uint64_t seed, int use_seed)
 {
 	struct thread_options *o = &td->o;
 
@@ -100,7 +100,7 @@ static unsigned int get_hdr_inc(struct thread_data *td, struct io_u *io_u)
 }
 
 static void fill_pattern_headers(struct thread_data *td, struct io_u *io_u,
-				 unsigned long seed, int use_seed)
+				 uint64_t seed, int use_seed)
 {
 	unsigned int hdr_inc, header_num;
 	struct verify_header *hdr;
diff --git a/verify.h b/verify.h
index 64121a51..539e6f6c 100644
--- a/verify.h
+++ b/verify.h
@@ -97,7 +97,7 @@ extern void populate_verify_io_u(struct thread_data *, struct io_u *);
 extern int __must_check get_next_verify(struct thread_data *td, struct io_u *);
 extern int __must_check verify_io_u(struct thread_data *, struct io_u **);
 extern int verify_io_u_async(struct thread_data *, struct io_u **);
-extern void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u *io_u, unsigned long seed, int use_seed);
+extern void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u *io_u, uint64_t seed, int use_seed);
 extern void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len);
 extern void fio_verify_init(struct thread_data *td);
 

