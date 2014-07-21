Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaGUMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 21 Jul 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X9CGC-0000mj-HF
	for fio@vger.kernel.org; Mon, 21 Jul 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140721120002.D993C401E4@lyth.info>
Date: Mon, 21 Jul 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9142eb54f7ab1428ecc6b2af99154b877892cca6:

  Fio 2.1.11 (2014-07-16 10:22:43 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 908119302fbb900a449988d03dacc95426c09e08:

  stat: move stat mutex grab to thread (2014-07-21 11:32:13 +0200)

----------------------------------------------------------------
Jens Axboe (2):
      verify: disable numberio check for multiple block sizes
      stat: move stat mutex grab to thread

 stat.c   |   17 +++++++++++------
 verify.c |   12 ++++++------
 2 files changed, 17 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 979c810..d836581 100644
--- a/stat.c
+++ b/stat.c
@@ -1411,13 +1411,15 @@ void show_run_stats(void)
 	fio_mutex_up(stat_mutex);
 }
 
-static void *__show_running_run_stats(void fio_unused *arg)
+static void *__show_running_run_stats(void *arg)
 {
 	struct thread_data *td;
 	unsigned long long *rt;
 	struct timeval tv;
 	int i;
 
+	fio_mutex_down(stat_mutex);
+
 	rt = malloc(thread_number * sizeof(unsigned long long));
 	fio_gettime(&tv, NULL);
 
@@ -1458,6 +1460,7 @@ static void *__show_running_run_stats(void fio_unused *arg)
 
 	free(rt);
 	fio_mutex_up(stat_mutex);
+	free(arg);
 	return NULL;
 }
 
@@ -1468,21 +1471,23 @@ static void *__show_running_run_stats(void fio_unused *arg)
  */
 void show_running_run_stats(void)
 {
-	pthread_t thread;
+	pthread_t *thread;
 
-	fio_mutex_down(stat_mutex);
+	thread = calloc(1, sizeof(*thread));
+	if (!thread)
+		return;
 
-	if (!pthread_create(&thread, NULL, __show_running_run_stats, NULL)) {
+	if (!pthread_create(thread, NULL, __show_running_run_stats, thread)) {
 		int err;
 
-		err = pthread_detach(thread);
+		err = pthread_detach(*thread);
 		if (err)
 			log_err("fio: DU thread detach failed: %s\n", strerror(err));
 
 		return;
 	}
 
-	fio_mutex_up(stat_mutex);
+	free(thread);
 }
 
 static int status_interval_init;
diff --git a/verify.c b/verify.c
index e59a4b2..7c99e15 100644
--- a/verify.c
+++ b/verify.c
@@ -405,13 +405,13 @@ static int verify_io_u_meta(struct verify_header *hdr, struct vcont *vc)
 
 	/*
 	 * For read-only workloads, the program cannot be certain of the
-	 * last numberio written to a block. Checking of numberio will be done
-	 * only for workloads that write data.
-	 * For verify_only, numberio will be checked in the last iteration when
-	 * the correct state of numberio, that would have been written to each
-	 * block in a previous run of fio, has been reached.
+	 * last numberio written to a block. Checking of numberio will be
+	 * done only for workloads that write data.  For verify_only,
+	 * numberio will be checked in the last iteration when the correct
+	 * state of numberio, that would have been written to each block
+	 * in a previous run of fio, has been reached.
 	 */
-	if (td_write(td) || td_rw(td))
+	if ((td_write(td) || td_rw(td)) && (td_min_bs(td) == td_max_bs(td)))
 		if (!td->o.verify_only || td->o.loops == 0)
 			if (vh->numberio != io_u->numberio)
 				ret = EILSEQ;
