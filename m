Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbCXMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 Mar 2015 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YaNV7-00027J-SC
	for fio@vger.kernel.org; Tue, 24 Mar 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150324120002.CB4D8401C1@lyth.info>
Date: Tue, 24 Mar 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dac499a01d1958781e526df982d78d733f19c527:

  Cpu clock does not wrap if there is no CPU clock (2015-03-20 10:29:29 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 40c666c87c2d7751abea8fc2f866404d1efbdee2:

  Always update rusage before grabbing stat_mutex (2015-03-23 10:19:44 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Always update rusage before grabbing stat_mutex

 backend.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index fdb7413..2be7149 100644
--- a/backend.c
+++ b/backend.c
@@ -1526,6 +1526,15 @@ static void *thread_main(void *data)
 
 		clear_state = 1;
 
+		/*
+		 * Make sure we've successfully updated the rusage stats
+		 * before waiting on the stat mutex. Otherwise we could have
+		 * the stat thread holding stat mutex and waiting for
+		 * the rusage_sem, which would never get upped because
+		 * this thread is waiting for the stat mutex.
+		 */
+		check_update_rusage(td);
+
 		fio_mutex_down(stat_mutex);
 		if (td_read(td) && td->io_bytes[DDIR_READ]) {
 			elapsed = mtime_since_now(&td->start);
@@ -1556,6 +1565,11 @@ static void *thread_main(void *data)
 
 		do_verify(td, verify_bytes);
 
+		/*
+		 * See comment further up for why this is done here.
+		 */
+		check_update_rusage(td);
+
 		fio_mutex_down(stat_mutex);
 		td->ts.runtime[DDIR_READ] += mtime_since_now(&td->start);
 		fio_gettime(&td->start, NULL);
