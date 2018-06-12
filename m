Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932373AbeFLMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Jun 2018 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fShyA-000577-Pj
        for fio@vger.kernel.org; Tue, 12 Jun 2018 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180612120002.2CD292C263D@kernel.dk>
Date: Tue, 12 Jun 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ab5643cb04dac549b2202231d5c6e33339b7fe7d:

  stat: fix --bandwidth-log segfault (2018-06-08 08:31:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 49050b56681b17968256702a7a3ec0f545c7dad8:

  Fix start delay being the same across threads (2018-06-11 20:02:10 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fix start delay being the same across threads

 init.c           | 20 +++++++++++---------
 thread_options.h |  1 +
 2 files changed, 12 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 9257d47..e25e5e4 100644
--- a/init.c
+++ b/init.c
@@ -578,8 +578,7 @@ static int fixed_block_size(struct thread_options *o)
 static unsigned long long get_rand_start_delay(struct thread_data *td)
 {
 	unsigned long long delayrange;
-	uint64_t frand_max;
-	unsigned long r;
+	uint64_t r, frand_max;
 
 	delayrange = td->o.start_delay_high - td->o.start_delay;
 
@@ -587,7 +586,7 @@ static unsigned long long get_rand_start_delay(struct thread_data *td)
 	r = __rand(&td->delay_state);
 	delayrange = (unsigned long long) ((double) delayrange * (r / (frand_max + 1.0)));
 
-	delayrange += td->o.start_delay;
+	delayrange += td->o.start_delay_orig;
 	return delayrange;
 }
 
@@ -685,8 +684,11 @@ static int fixup_options(struct thread_data *td)
 	if (!o->file_size_high)
 		o->file_size_high = o->file_size_low;
 
-	if (o->start_delay_high)
+	if (o->start_delay_high) {
+		if (!o->start_delay_orig)
+			o->start_delay_orig = o->start_delay;
 		o->start_delay = get_rand_start_delay(td);
+	}
 
 	if (o->norandommap && o->verify != VERIFY_NONE
 	    && !fixed_block_size(o))  {
@@ -1456,6 +1458,11 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		}
 	}
 
+	if (setup_random_seeds(td)) {
+		td_verror(td, errno, "setup_random_seeds");
+		goto err;
+	}
+
 	if (fixup_options(td))
 		goto err;
 
@@ -1511,11 +1518,6 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	td->groupid = groupid;
 	prev_group_jobs++;
 
-	if (setup_random_seeds(td)) {
-		td_verror(td, errno, "setup_random_seeds");
-		goto err;
-	}
-
 	if (setup_rate(td))
 		goto err;
 
diff --git a/thread_options.h b/thread_options.h
index 52026e3..8d13b79 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -172,6 +172,7 @@ struct thread_options {
 	unsigned int fdatasync_blocks;
 	unsigned int barrier_blocks;
 	unsigned long long start_delay;
+	unsigned long long start_delay_orig;
 	unsigned long long start_delay_high;
 	unsigned long long timeout;
 	unsigned long long ramp_time;
