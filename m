Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:32844 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgETMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 20 May 2020 08:00:20 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbNOU-0007Qm-Eh
        for fio@vger.kernel.org; Wed, 20 May 2020 12:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200520120001.9BCF51BC01B0@kernel.dk>
Date: Wed, 20 May 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f09a7773f5821d5b89428419dcef1987ced39b67:

  Allow more flexibility in zone start and span (2020-05-18 16:56:00 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 26949a8bbc544094740c61f79b4ea778978e7d8e:

  Merge branch '32-bit-fixes' of https://github.com/sitsofe/fio (2020-05-19 16:14:19 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'stephen/rate-ull' of https://github.com/sbates130272/fio
      Merge branch '32-bit-fixes' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      Fix 32-bit/LLP64 platform truncation issues

Stephen Bates (1):
      rate: Convert the rate and rate_min options to FIO_OPTS_ULL

 backend.c  | 10 +++++-----
 fio.h      |  2 +-
 init.c     |  6 +++---
 lib/rand.c |  4 ++--
 lib/rand.h |  2 +-
 options.c  |  4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index feb34e51..f519728c 100644
--- a/backend.c
+++ b/backend.c
@@ -134,8 +134,8 @@ static bool __check_min_rate(struct thread_data *td, struct timespec *now,
 	unsigned long long bytes = 0;
 	unsigned long iops = 0;
 	unsigned long spent;
-	unsigned long rate;
-	unsigned int ratemin = 0;
+	unsigned long long rate;
+	unsigned long long ratemin = 0;
 	unsigned int rate_iops = 0;
 	unsigned int rate_iops_min = 0;
 
@@ -169,7 +169,7 @@ static bool __check_min_rate(struct thread_data *td, struct timespec *now,
 			 * check bandwidth specified rate
 			 */
 			if (bytes < td->rate_bytes[ddir]) {
-				log_err("%s: rate_min=%uB/s not met, only transferred %lluB\n",
+				log_err("%s: rate_min=%lluB/s not met, only transferred %lluB\n",
 					td->o.name, ratemin, bytes);
 				return true;
 			} else {
@@ -180,7 +180,7 @@ static bool __check_min_rate(struct thread_data *td, struct timespec *now,
 
 				if (rate < ratemin ||
 				    bytes < td->rate_bytes[ddir]) {
-					log_err("%s: rate_min=%uB/s not met, got %luB/s\n",
+					log_err("%s: rate_min=%lluB/s not met, got %lluB/s\n",
 						td->o.name, ratemin, rate);
 					return true;
 				}
@@ -201,7 +201,7 @@ static bool __check_min_rate(struct thread_data *td, struct timespec *now,
 
 				if (rate < rate_iops_min ||
 				    iops < td->rate_blocks[ddir]) {
-					log_err("%s: rate_iops_min=%u not met, got %lu IOPS\n",
+					log_err("%s: rate_iops_min=%u not met, got %llu IOPS\n",
 						td->o.name, rate_iops_min, rate);
 					return true;
 				}
diff --git a/fio.h b/fio.h
index bbf057c1..dbdfdf86 100644
--- a/fio.h
+++ b/fio.h
@@ -319,7 +319,7 @@ struct thread_data {
 	 */
 	uint64_t rate_bps[DDIR_RWDIR_CNT];
 	uint64_t rate_next_io_time[DDIR_RWDIR_CNT];
-	unsigned long rate_bytes[DDIR_RWDIR_CNT];
+	unsigned long long rate_bytes[DDIR_RWDIR_CNT];
 	unsigned long rate_blocks[DDIR_RWDIR_CNT];
 	unsigned long long rate_io_issue_bytes[DDIR_RWDIR_CNT];
 	struct timespec lastrate[DDIR_RWDIR_CNT];
diff --git a/init.c b/init.c
index b5315334..e220c323 100644
--- a/init.c
+++ b/init.c
@@ -993,9 +993,9 @@ void td_fill_verify_state_seed(struct thread_data *td)
 
 static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 {
-	unsigned int read_seed = td->rand_seeds[FIO_RAND_BS_OFF];
-	unsigned int write_seed = td->rand_seeds[FIO_RAND_BS1_OFF];
-	unsigned int trim_seed = td->rand_seeds[FIO_RAND_BS2_OFF];
+	uint64_t read_seed = td->rand_seeds[FIO_RAND_BS_OFF];
+	uint64_t write_seed = td->rand_seeds[FIO_RAND_BS1_OFF];
+	uint64_t trim_seed = td->rand_seeds[FIO_RAND_BS2_OFF];
 	int i;
 
 	/*
diff --git a/lib/rand.c b/lib/rand.c
index 69acb06c..5eb6e60a 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -85,12 +85,12 @@ void init_rand(struct frand_state *state, bool use64)
 		__init_rand64(&state->state64, 1);
 }
 
-void init_rand_seed(struct frand_state *state, unsigned int seed, bool use64)
+void init_rand_seed(struct frand_state *state, uint64_t seed, bool use64)
 {
 	state->use64 = use64;
 
 	if (!use64)
-		__init_rand32(&state->state32, seed);
+		__init_rand32(&state->state32, (unsigned int) seed);
 	else
 		__init_rand64(&state->state64, seed);
 }
diff --git a/lib/rand.h b/lib/rand.h
index 95d4f6d4..2ccc1b37 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -149,7 +149,7 @@ static inline uint64_t rand_between(struct frand_state *state, uint64_t start,
 }
 
 extern void init_rand(struct frand_state *, bool);
-extern void init_rand_seed(struct frand_state *, unsigned int seed, bool);
+extern void init_rand_seed(struct frand_state *, uint64_t seed, bool);
 extern void __fill_random_buf(void *buf, unsigned int len, uint64_t seed);
 extern uint64_t fill_random_buf(struct frand_state *, void *buf, unsigned int len);
 extern void __fill_random_buf_percentage(uint64_t, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
diff --git a/options.c b/options.c
index 2372c042..b18cea33 100644
--- a/options.c
+++ b/options.c
@@ -3537,7 +3537,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "rate",
 		.lname	= "I/O rate",
-		.type	= FIO_OPT_INT,
+		.type	= FIO_OPT_ULL,
 		.off1	= offsetof(struct thread_options, rate[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, rate[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, rate[DDIR_TRIM]),
@@ -3549,7 +3549,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "rate_min",
 		.alias	= "ratemin",
 		.lname	= "I/O min rate",
-		.type	= FIO_OPT_INT,
+		.type	= FIO_OPT_ULL,
 		.off1	= offsetof(struct thread_options, ratemin[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, ratemin[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, ratemin[DDIR_TRIM]),

