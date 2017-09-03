Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46981 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdICMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 3 Sep 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doTZR-0007Ih-65
        for fio@vger.kernel.org; Sun, 03 Sep 2017 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170903120002.22A352C0167@kernel.dk>
Date: Sun,  3 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ba872a0beb498740f076e19299bb7388b82ad4d6:

  revert/rework 81647a9a('fix load_ioengine() not to support no "external:" prefix') (2017-09-01 13:58:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 07dff7d1d614b33e3a6d3e3ade38ce648b53a632:

  Merge branch 'shifted_logging' of https://github.com/sitsofe/fio (2017-09-02 17:00:24 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'shifted_logging' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      stat: fix shifted windowed logging when using multiple directions

 iolog.h |  2 +-
 stat.c  | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.h b/iolog.h
index d157fa2..bc3a0b5 100644
--- a/iolog.h
+++ b/iolog.h
@@ -117,7 +117,7 @@ struct io_log {
 	 */
 	struct io_stat avg_window[DDIR_RWDIR_CNT];
 	unsigned long avg_msec;
-	unsigned long avg_last;
+	unsigned long avg_last[DDIR_RWDIR_CNT];
 
 	/*
 	 * Windowed latency histograms, for keeping track of when we need to
diff --git a/stat.c b/stat.c
index 91c74ab..63353cc 100644
--- a/stat.c
+++ b/stat.c
@@ -2159,7 +2159,7 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 	if (iolog->disabled)
 		return;
 	if (flist_empty(&iolog->io_logs))
-		iolog->avg_last = t;
+		iolog->avg_last[ddir] = t;
 
 	cur_log = get_cur_log(iolog);
 	if (cur_log) {
@@ -2290,9 +2290,9 @@ static long add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 * If period hasn't passed, adding the above sample is all we
 	 * need to do.
 	 */
-	this_window = elapsed - iolog->avg_last;
-	if (elapsed < iolog->avg_last)
-		return iolog->avg_last - elapsed;
+	this_window = elapsed - iolog->avg_last[ddir];
+	if (elapsed < iolog->avg_last[ddir])
+		return iolog->avg_last[ddir] - elapsed;
 	else if (this_window < iolog->avg_msec) {
 		int diff = iolog->avg_msec - this_window;
 
@@ -2300,9 +2300,9 @@ static long add_log_sample(struct thread_data *td, struct io_log *iolog,
 			return diff;
 	}
 
-	_add_stat_to_log(iolog, elapsed, td->o.log_max != 0);
+	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0);
 
-	iolog->avg_last = elapsed - (this_window - iolog->avg_msec);
+	iolog->avg_last[ddir] = elapsed - (this_window - iolog->avg_msec);
 	return iolog->avg_msec;
 }
 
