Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbeLAAJp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Nov 2018 19:09:45 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gSiPH-00014b-CT
        for fio@vger.kernel.org; Fri, 30 Nov 2018 13:00:31 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181130130002.89BC42C0114@kernel.dk>
Date: Fri, 30 Nov 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c36210b443a37c53978bbea88f1dabb0b61799d7:

  engines/libaio: use maximum buffer size for fixed user bufs (2018-11-27 19:43:30 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a0318e176ace1e53b0049965f63b0c60b55ff8cd:

  gettime: use nsec in get_cycles_per_msec division (2018-11-29 11:21:18 -0700)

----------------------------------------------------------------
Bari Antebi (1):
      rand: fix compressible data ratio per segment

Vincent Fu (1):
      gettime: use nsec in get_cycles_per_msec division

 gettime.c  | 12 ++++++------
 lib/rand.c |  1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index 7702193..272a3e6 100644
--- a/gettime.c
+++ b/gettime.c
@@ -239,13 +239,13 @@ static unsigned long get_cycles_per_msec(void)
 		__fio_gettime(&e);
 		c_e = get_cpu_clock();
 
-		elapsed = utime_since(&s, &e);
-		if (elapsed >= 1280)
+		elapsed = ntime_since(&s, &e);
+		if (elapsed >= 1280000)
 			break;
 	} while (1);
 
 	fio_clock_source = old_cs;
-	return (c_e - c_s) * 1000 / elapsed;
+	return (c_e - c_s) * 1000000 / elapsed;
 }
 
 #define NR_TIME_ITERS	50
@@ -298,10 +298,10 @@ static int calibrate_cpu_clock(void)
 
 	avg /= samples;
 	cycles_per_msec = avg;
-	dprint(FD_TIME, "avg: %llu\n", (unsigned long long) avg);
-	dprint(FD_TIME, "min=%llu, max=%llu, mean=%f, S=%f\n",
+	dprint(FD_TIME, "min=%llu, max=%llu, mean=%f, S=%f, N=%d\n",
 			(unsigned long long) minc,
-			(unsigned long long) maxc, mean, S);
+			(unsigned long long) maxc, mean, S, NR_TIME_ITERS);
+	dprint(FD_TIME, "trimmed mean=%llu, N=%d\n", (unsigned long long) avg, samples);
 
 	max_ticks = MAX_CLOCK_SEC * cycles_per_msec * 1000ULL;
 	max_mult = ULLONG_MAX / max_ticks;
diff --git a/lib/rand.c b/lib/rand.c
index 99846a8..f18bd8d 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -166,6 +166,7 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
 		if (!len)
 			break;
 		buf += this_len;
+		this_len = segment - this_len;
 
 		if (this_len > len)
 			this_len = len;

