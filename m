Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41908 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbKUNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 21 Nov 2015 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a07lr-0007FT-3e
	for fio@vger.kernel.org; Sat, 21 Nov 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151121130002.59E6B2C00ED@kernel.dk>
Date: Sat, 21 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3379b94e3b7da4b74afcfa9781752179ede6ec4d:

  Fix ETA calculations (2015-11-19 13:36:18 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 13aa415afc8d0a2ad0de2d6c17d6bca2d16f00c7:

  gettime: get rid of the (unecessary) 10x scaling factor (2015-11-20 17:26:37 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      gettime: print first clock offset for CPU clock
      gettime: make cpuclock calibration more tolerant
      gettime: get rid of the (unecessary) 10x scaling factor

 gettime.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index 8d99900..b896b5b 100644
--- a/gettime.c
+++ b/gettime.c
@@ -232,6 +232,7 @@ static unsigned long get_cycles_per_usec(void)
 	struct timeval s, e;
 	uint64_t c_s, c_e;
 	enum fio_cs old_cs = fio_clock_source;
+	uint64_t elapsed;
 
 #ifdef CONFIG_CLOCK_GETTIME
 	fio_clock_source = CS_CGETTIME;
@@ -242,8 +243,6 @@ static unsigned long get_cycles_per_usec(void)
 
 	c_s = get_cpu_clock();
 	do {
-		uint64_t elapsed;
-
 		__fio_gettime(&e);
 
 		elapsed = utime_since(&s, &e);
@@ -254,7 +253,7 @@ static unsigned long get_cycles_per_usec(void)
 	} while (1);
 
 	fio_clock_source = old_cs;
-	return (c_e - c_s + 127) >> 7;
+	return (c_e - c_s) / elapsed;
 }
 
 #define NR_TIME_ITERS	50
@@ -300,16 +299,11 @@ static int calibrate_cpu_clock(void)
 	}
 
 	S /= (double) NR_TIME_ITERS;
-	mean /= 10.0;
 
 	for (i = 0; i < NR_TIME_ITERS; i++)
-		dprint(FD_TIME, "cycles[%d]=%llu\n", i,
-					(unsigned long long) cycles[i] / 10);
+		dprint(FD_TIME, "cycles[%d]=%llu\n", i, (unsigned long long) cycles[i]);
 
 	avg /= samples;
-	avg = (avg + 5) / 10;
-	minc /= 10;
-	maxc /= 10;
 	dprint(FD_TIME, "avg: %llu\n", (unsigned long long) avg);
 	dprint(FD_TIME, "min=%llu, max=%llu, mean=%f, S=%f\n",
 			(unsigned long long) minc,
@@ -485,6 +479,7 @@ static void *clock_thread_fn(void *data)
 	struct clock_entry *c;
 	os_cpu_mask_t cpu_mask;
 	uint32_t last_seq;
+	unsigned long long first;
 	int i;
 
 	if (fio_cpuset_init(&cpu_mask)) {
@@ -506,6 +501,7 @@ static void *clock_thread_fn(void *data)
 	pthread_mutex_lock(&t->lock);
 	pthread_mutex_unlock(&t->started);
 
+	first = get_cpu_clock();
 	last_seq = 0;
 	c = &t->entries[0];
 	for (i = 0; i < t->nr_entries; i++, c++) {
@@ -528,7 +524,8 @@ static void *clock_thread_fn(void *data)
 		unsigned long long clocks;
 
 		clocks = t->entries[i - 1].tsc - t->entries[0].tsc;
-		log_info("cs: cpu%3d: %llu clocks seen\n", t->cpu, clocks);
+		log_info("cs: cpu%3d: %llu clocks seen, first %llu\n", t->cpu,
+							clocks, first);
 	}
 
 	/*
