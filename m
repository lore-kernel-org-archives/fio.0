Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171E154652
	for <fio@vger.kernel.org>; Fri, 16 Jan 2026 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768568422; cv=none; b=WSfUiArKqtDwvBvpgzs2Dq37Ev4Kp7RWdHWHOJdprc4sr46yOuCfofY+Y6f6jB5+62qjQjasqtCivGG/JbldgK5hhxrsSXVGqLnjWb7JKgkUNl1JdOj6cEjYLiDwINQ3yU24UKxVwOSjpmvN68KbniK7PbcJs77zpRGaZRcd+6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768568422; c=relaxed/simple;
	bh=RqeJ8LbQEiMU6xAd19Tx71FIRYahYnaKW/o1Abvsgiw=;
	h=Subject:From:To:Date:Message-Id; b=fxiZ0fMANqTkWTvj2Eo8WJ1VPjNP8eB1JPM/upOL4vJGwDcdS5OtD2D2Oa3/qOeRUk4uRpv4Yunznq7JI4CO9awZkvyKjU76PlGWd0QjtnILwPW5SCm+VqHfBW/P3cSljriX+DgyLzxPnl1iZ8qJqAVArHDRgK4cScQl3iE5Qys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SIXjRuGS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SIXjRuGS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=achR+YqnSak3P3abPKPbBM6jWAC4o6MQPESCP2yvGQA=; b=SIXjRuGSWS+cvfV9aWedqpr5/Z
	ryRIyTrptnf/DGSN8qHzJf9ZAUh1HY1ro9uNHhyswT0wwMtQpnb1J7u7A7BaKxb2jsvVJXJ42YmbQ
	KffDEEnicBMM555hCxIFJewa87mLB5O7oCCRyy3sjsQ1PfcLKtLSHVbyA9IwntA1TX3m98JJXrrWX
	7JsxhRimIxshx3ze/Ty56G4sYgzMLcJdV/oqRN9kQSdUh10klZ60Ei/E9AWeh80C69coIjuUXVCQa
	Bb8EtDd4MRppw+jy2ixQxFVoIp9YR5VvFA17FXff9A5jVPKxwUYGCKFq7cKuB2+1Ila0ovCwNyB3g
	n0o03rAA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgjQu-00000009N2t-3Bpx
	for fio@vger.kernel.org;
	Fri, 16 Jan 2026 13:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C58051BC0147; Fri, 16 Jan 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 16 Jan 2026 06:00:01 -0700
Message-Id: <20260116130001.C58051BC0147@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit adeceb86edb28070cbae79dd38b5ec7354271063:

  Merge branch 'sync-fileop' of https://github.com/struschev/fio (2026-01-11 13:05:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1d282baecd689f4409449d5e5238b30990cec377:

  fio: make sure that child process output is comitted (2026-01-15 17:35:13 +0000)

----------------------------------------------------------------
Vincent Fu (6):
      init: make fdp_state rand generator always 32 bits
      init: make trim_state always a 32-bit random generator
      fio: rename random_state to offset_state
      fio: improve comment for offset_state
      filesetup: switch to tausworthe64 for real if limits exceeded
      fio: make sure that child process output is comitted

 backend.c   |  6 ++++++
 filesetup.c |  1 +
 fio.h       |  5 +++--
 init.c      | 23 ++++++++++++++++++++---
 io_u.c      |  4 ++--
 verify.c    | 18 +++++++++---------
 6 files changed, 41 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 1e4c4a38..7eb5ca2b 100644
--- a/backend.c
+++ b/backend.c
@@ -2515,6 +2515,9 @@ reap:
 		}
 	} end_for_each();
 
+	/* make sure child processes have empty stream buffers before fork */
+	log_info_flush();
+
 	/* start idle threads before io threads start to run */
 	fio_idle_prof_start();
 
@@ -2607,6 +2610,9 @@ reap:
 					int ret;
 
 					ret = (int)(uintptr_t)thread_main(fd);
+					/* _exit() does not flush buffers, so
+					 * do it ourselves */
+					log_info_flush();
 					_exit(ret);
 				} else if (__td_index == fio_debug_jobno)
 					*fio_debug_jobp = pid;
diff --git a/filesetup.c b/filesetup.c
index 1e5f2fa7..a766c39a 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1515,6 +1515,7 @@ static int check_rand_gen_limits(struct thread_data *td, struct fio_file *f,
 			 "random_generator= option to get rid of this "
 			 "warning.\n");
 		td->o.random_generator = FIO_RAND_GEN_TAUSWORTHE64;
+		init_rand_offset_seed(td);
 		return 0;
 	}
 
diff --git a/fio.h b/fio.h
index fdd36fa4..e0b7c13c 100644
--- a/fio.h
+++ b/fio.h
@@ -403,9 +403,9 @@ struct thread_data {
 	int64_t last_thinktime_blocks;
 
 	/*
-	 * State for random io, a bitmap of blocks done vs not done
+	 * State for random offsets
 	 */
-	struct frand_state random_state;
+	struct frand_state offset_state;
 
 	struct timespec start;	/* start of this loop */
 	struct timespec epoch;	/* time job was started */
@@ -677,6 +677,7 @@ extern void fio_options_dup_and_init(struct option *);
 extern char *fio_option_dup_subs(const char *);
 extern void fio_options_mem_dupe(struct thread_data *);
 extern void td_fill_rand_seeds(struct thread_data *);
+extern void init_rand_offset_seed(struct thread_data *);
 extern void add_job_opts(const char **, int);
 extern int ioengine_load(struct thread_data *);
 extern bool parse_dryrun(void);
diff --git a/init.c b/init.c
index 76e1a86d..8a0d8c20 100644
--- a/init.c
+++ b/init.c
@@ -1134,6 +1134,23 @@ static void init_rand_file_service(struct thread_data *td)
 	}
 }
 
+/*
+ * Separate initialization of the random generator for offsets in case we need
+ * to re-initialize it if we discover later on that the combination of filesize
+ * and block size exceeds the limits of the default random generator.
+ */
+void init_rand_offset_seed(struct thread_data *td)
+{
+	bool use64;
+
+	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
+		use64 = true;
+	else
+		use64 = false;
+
+	init_rand_seed(&td->offset_state, td->rand_seeds[FIO_RAND_BLOCK_OFF], use64);
+}
+
 void td_fill_rand_seeds(struct thread_data *td)
 {
 	uint64_t read_seed = td->rand_seeds[FIO_RAND_BS_OFF];
@@ -1173,7 +1190,7 @@ void td_fill_rand_seeds(struct thread_data *td)
 		init_rand_file_service(td);
 
 	init_rand_seed(&td->file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], use64);
-	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], use64);
+	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], false);
 	init_rand_seed(&td->delay_state, td->rand_seeds[FIO_RAND_START_DELAY], use64);
 	init_rand_seed(&td->poisson_state[0], td->rand_seeds[FIO_RAND_POISSON_OFF], 0);
 	init_rand_seed(&td->poisson_state[1], td->rand_seeds[FIO_RAND_POISSON2_OFF], 0);
@@ -1183,7 +1200,7 @@ void td_fill_rand_seeds(struct thread_data *td)
 	init_rand_seed(&td->prio_state, td->rand_seeds[FIO_RAND_PRIO_CMDS], false);
 	init_rand_seed(&td->dedupe_working_set_index_state, td->rand_seeds[FIO_RAND_DEDUPE_WORKING_SET_IX], use64);
 
-	init_rand_seed(&td->random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF], use64);
+	init_rand_offset_seed(td);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		struct frand_state *s = &td->seq_rand_state[i];
@@ -1194,7 +1211,7 @@ void td_fill_rand_seeds(struct thread_data *td)
 	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF], use64);
 	frand_copy(&td->buf_state_prev, &td->buf_state);
 
-	init_rand_seed(&td->fdp_state, td->rand_seeds[FIO_RAND_FDP_OFF], use64);
+	init_rand_seed(&td->fdp_state, td->rand_seeds[FIO_RAND_FDP_OFF], false);
 	init_rand_seed(&td->sprandom_state, td->rand_seeds[FIO_RAND_SPRANDOM_OFF], false);
 }
 
diff --git a/io_u.c b/io_u.c
index be0a0555..ac9a1c7d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -110,11 +110,11 @@ static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE ||
 	    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64) {
 
-		r = __rand(&td->random_state);
+		r = __rand(&td->offset_state);
 
 		dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
 
-		*b = lastb * (r / (rand_max(&td->random_state) + 1.0));
+		*b = lastb * (r / (rand_max(&td->offset_state) + 1.0));
 	} else {
 		uint64_t off = 0;
 
diff --git a/verify.c b/verify.c
index 20c49a94..e2011a0f 100644
--- a/verify.c
+++ b/verify.c
@@ -1682,18 +1682,18 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		s->depth = cpu_to_le32((uint32_t) td->o.iodepth);
 		s->numberio = cpu_to_le64((uint64_t) atomic_load_acquire(&td->inflight_issued));
 		s->index = cpu_to_le64((uint64_t) __td_index);
-		if (td->random_state.use64) {
-			s->rand.state64.s[0] = cpu_to_le64(td->random_state.state64.s1);
-			s->rand.state64.s[1] = cpu_to_le64(td->random_state.state64.s2);
-			s->rand.state64.s[2] = cpu_to_le64(td->random_state.state64.s3);
-			s->rand.state64.s[3] = cpu_to_le64(td->random_state.state64.s4);
-			s->rand.state64.s[4] = cpu_to_le64(td->random_state.state64.s5);
+		if (td->offset_state.use64) {
+			s->rand.state64.s[0] = cpu_to_le64(td->offset_state.state64.s1);
+			s->rand.state64.s[1] = cpu_to_le64(td->offset_state.state64.s2);
+			s->rand.state64.s[2] = cpu_to_le64(td->offset_state.state64.s3);
+			s->rand.state64.s[3] = cpu_to_le64(td->offset_state.state64.s4);
+			s->rand.state64.s[4] = cpu_to_le64(td->offset_state.state64.s5);
 			s->rand.state64.s[5] = 0;
 			s->rand.use64 = cpu_to_le64((uint64_t)1);
 		} else {
-			s->rand.state32.s[0] = cpu_to_le32(td->random_state.state32.s1);
-			s->rand.state32.s[1] = cpu_to_le32(td->random_state.state32.s2);
-			s->rand.state32.s[2] = cpu_to_le32(td->random_state.state32.s3);
+			s->rand.state32.s[0] = cpu_to_le32(td->offset_state.state32.s1);
+			s->rand.state32.s[1] = cpu_to_le32(td->offset_state.state32.s2);
+			s->rand.state32.s[2] = cpu_to_le32(td->offset_state.state32.s3);
 			s->rand.state32.s[3] = 0;
 			s->rand.use64 = 0;
 		}
