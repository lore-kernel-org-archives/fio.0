Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdDCMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Apr 2017 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cv0eU-0005NU-8P
        for fio@vger.kernel.org; Mon, 03 Apr 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170403120001.A42D82C319A@kernel.dk>
Date: Mon,  3 Apr 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 618ee94c319c46c670d29c7cf71538ca2ace13b7:

  Separate io_u from ioengine [3/3] - rename ioengine.h to ioengines.h (2017-03-28 15:14:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 249ad5bfaded90c0431041b4a3816e7371c2d403:

  time: use correct size type for usecs (2017-04-02 16:01:18 -0600)

----------------------------------------------------------------
Chris Taylor (1):
      time: fix overflow in timeval_add_msec()

Jens Axboe (1):
      time: use correct size type for usecs

 time.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/time.c b/time.c
index f5dc049..279ee48 100644
--- a/time.c
+++ b/time.c
@@ -8,8 +8,16 @@ static unsigned long ns_granularity;
 
 void timeval_add_msec(struct timeval *tv, unsigned int msec)
 {
-	tv->tv_usec += 1000 * msec;
-	if (tv->tv_usec >= 1000000) {
+	unsigned long adj_usec = 1000 * msec;
+
+	tv->tv_usec += adj_usec;
+	if (adj_usec >= 1000000) {
+		unsigned long adj_sec = adj_usec / 1000000;
+
+		tv->tv_usec -=  adj_sec * 1000000;
+		tv->tv_sec += adj_sec;
+	}
+	if (tv->tv_usec >= 1000000){
 		tv->tv_usec -= 1000000;
 		tv->tv_sec++;
 	}
