Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422762AbbD2L7z (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 29 Apr 2015 07:59:55 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YnQeg-0007Oh-Sv
	for fio@vger.kernel.org; Wed, 29 Apr 2015 11:59:54 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150429120002.244EC2C01AF@kernel.dk>
Date: Wed, 29 Apr 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9451b93e81fb950a80da09e295e56b1ad4538509:

  dedupe: improve 100% dedupe case (2015-04-27 09:37:11 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 76a00ec6684317902e536365b89531431e7f8867:

  blktrace: only set O_DIRECT if the min bs is a multiple of 4k (2015-04-28 15:30:02 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Add recommendation to set direct=0 if first O_DIRECT fails
      blktrace: only set O_DIRECT if the min bs is a multiple of 4k

 blktrace.c  | 5 +++--
 ioengines.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index 8ffa9b0..bb0bcbe 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -503,9 +503,10 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 
 	/*
 	 * We need to do direct/raw ios to the device, to avoid getting
-	 * read-ahead in our way.
+	 * read-ahead in our way. But only do so if the minimum block size
+	 * is a multiple of 4k, otherwise we don't know if it's safe to do so.
 	 */
-	if (!fio_option_is_set(&td->o, odirect))
+	if (!fio_option_is_set(&td->o, odirect) && !(td_min_bs(td) & 4095))
 		td->o.odirect = 1;
 
 	/*
diff --git a/ioengines.c b/ioengines.c
index b724e0e..958731d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -327,7 +327,8 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	    td->o.odirect) {
 
 		log_info("fio: first direct IO errored. File system may not "
-			 "support direct IO, or iomem_align= is bad.\n");
+			 "support direct IO, or iomem_align= is bad. Try "
+			 "setting direct=0.\n");
 	}
 
 	if (!td->io_ops->commit || io_u->ddir == DDIR_TRIM) {
