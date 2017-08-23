Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36926 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753828AbdHWMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 Aug 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dkUKP-0004IV-6Z
        for fio@vger.kernel.org; Wed, 23 Aug 2017 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170823120001.EAB962C0094@kernel.dk>
Date: Wed, 23 Aug 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 168bb5875da97004163c6b755de162ad481134c4:

  doc: latency log unit is nsec (2017-08-17 15:39:56 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to deeb3c11c212e99e8d1162e03e0ef734bd0d01a7:

  Merge branch 'timespec_add_msec_overflow' of https://github.com/sitsofe/fio (2017-08-22 10:32:18 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'timespec_add_msec_overflow' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      time: fix overflow in timespec_add_msec

 time.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/time.c b/time.c
index edfe779..0798419 100644
--- a/time.c
+++ b/time.c
@@ -8,17 +8,17 @@ static unsigned long ns_granularity;
 
 void timespec_add_msec(struct timespec *ts, unsigned int msec)
 {
-	unsigned long adj_nsec = 1000000 * msec;
+	uint64_t adj_nsec = 1000000ULL * msec;
 
 	ts->tv_nsec += adj_nsec;
 	if (adj_nsec >= 1000000000) {
-		unsigned long adj_sec = adj_nsec / 1000000000UL;
+		uint64_t adj_sec = adj_nsec / 1000000000;
 
-		ts->tv_nsec -=  adj_sec * 1000000000UL;
+		ts->tv_nsec -= adj_sec * 1000000000;
 		ts->tv_sec += adj_sec;
 	}
-	if (ts->tv_nsec >= 1000000000UL){
-		ts->tv_nsec -= 1000000000UL;
+	if (ts->tv_nsec >= 1000000000){
+		ts->tv_nsec -= 1000000000;
 		ts->tv_sec++;
 	}
 }
