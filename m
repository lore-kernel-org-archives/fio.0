Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbbAHNAK (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Jan 2015 08:00:10 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y9Ch7-0002x4-Ad
	for fio@vger.kernel.org; Thu, 08 Jan 2015 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150108130003.637FB40157@lyth.info>
Date: Thu,  8 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 35326842297205554a9005723309bed565594c8a:

  Adjust ctime_r buf down to 32 (2015-01-06 12:03:09 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 36bb0880c7f7f48abb86e3a16d3168343dda9b75:

  Fix disk utils being updated too often (2015-01-07 15:04:39 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fix disk utils being updated too often

 backend.c |    7 -------
 1 file changed, 7 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 3df0133..efabfa7 100644
--- a/backend.c
+++ b/backend.c
@@ -2104,18 +2104,11 @@ static void *helper_thread_main(void *data)
 		uint64_t sec = DISK_UTIL_MSEC / 1000;
 		uint64_t nsec = (DISK_UTIL_MSEC % 1000) * 1000000;
 		struct timespec ts;
-
-#if defined(CONFIG_CLOCK_MONOTONIC)
-		clock_gettime(CLOCK_MONOTONIC, &ts);
-		ts.tv_sec += sec;
-		ts.tv_nsec += nsec;
-#else
 		struct timeval tv;
 
 		gettimeofday(&tv, NULL);
 		ts.tv_sec = tv.tv_sec + sec;
 		ts.tv_nsec = (tv.tv_usec * 1000) + nsec;
-#endif
 
 		if (ts.tv_nsec >= 1000000000ULL) {
 			ts.tv_nsec -= 1000000000ULL;
