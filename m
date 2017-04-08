Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35614 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751841AbdDHMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 8 Apr 2017 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cwp2B-0002cc-RP
        for fio@vger.kernel.org; Sat, 08 Apr 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170408120002.448AA2C351B@kernel.dk>
Date: Sat,  8 Apr 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e07a8a2281c7a5a0ec4eb8e8e66601ca1f9f71bb:

  Fio 2.19 (2017-04-04 08:30:59 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6c8611c79713fe73fddf7458ab3ab36feaeae67b:

  Split poisson rate control into read/write/trim (2017-04-07 16:04:31 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Split poisson rate control into read/write/trim

 backend.c | 6 +++---
 fio.h     | 6 ++++--
 init.c    | 6 ++++--
 3 files changed, 11 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 38ef348..86e689f 100644
--- a/backend.c
+++ b/backend.c
@@ -811,13 +811,13 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 		uint64_t val;
 		iops = bps / td->o.bs[ddir];
 		val = (int64_t) (1000000 / iops) *
-				-logf(__rand_0_1(&td->poisson_state));
+				-logf(__rand_0_1(&td->poisson_state[ddir]));
 		if (val) {
 			dprint(FD_RATE, "poisson rate iops=%llu\n",
 					(unsigned long long) 1000000 / val);
 		}
-		td->last_usec += val;
-		return td->last_usec;
+		td->last_usec[ddir] += val;
+		return td->last_usec[ddir];
 	} else if (bps) {
 		secs = bytes / bps;
 		remainder = bytes % bps;
diff --git a/fio.h b/fio.h
index 3955a81..8171b9a 100644
--- a/fio.h
+++ b/fio.h
@@ -100,6 +100,8 @@ enum {
 	FIO_DEDUPE_OFF,
 	FIO_RAND_POISSON_OFF,
 	FIO_RAND_ZONE_OFF,
+	FIO_RAND_POISSON2_OFF,
+	FIO_RAND_POISSON3_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -281,8 +283,8 @@ struct thread_data {
 	unsigned long rate_blocks[DDIR_RWDIR_CNT];
 	unsigned long long rate_io_issue_bytes[DDIR_RWDIR_CNT];
 	struct timeval lastrate[DDIR_RWDIR_CNT];
-	int64_t last_usec;
-	struct frand_state poisson_state;
+	int64_t last_usec[DDIR_RWDIR_CNT];
+	struct frand_state poisson_state[DDIR_RWDIR_CNT];
 
 	/*
 	 * Enforced rate submission/completion workqueue
diff --git a/init.c b/init.c
index 2f9433b..9aa452d 100644
--- a/init.c
+++ b/init.c
@@ -523,7 +523,7 @@ static int __setup_rate(struct thread_data *td, enum fio_ddir ddir)
 
 	td->rate_next_io_time[ddir] = 0;
 	td->rate_io_issue_bytes[ddir] = 0;
-	td->last_usec = 0;
+	td->last_usec[ddir] = 0;
 	return 0;
 }
 
@@ -933,7 +933,9 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	init_rand_seed(&td->file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], use64);
 	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], use64);
 	init_rand_seed(&td->delay_state, td->rand_seeds[FIO_RAND_START_DELAY], use64);
-	init_rand_seed(&td->poisson_state, td->rand_seeds[FIO_RAND_POISSON_OFF], 0);
+	init_rand_seed(&td->poisson_state[0], td->rand_seeds[FIO_RAND_POISSON_OFF], 0);
+	init_rand_seed(&td->poisson_state[1], td->rand_seeds[FIO_RAND_POISSON2_OFF], 0);
+	init_rand_seed(&td->poisson_state[2], td->rand_seeds[FIO_RAND_POISSON3_OFF], 0);
 	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], false);
 	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], false);
 
