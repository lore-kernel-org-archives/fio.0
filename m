Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50380 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdHIMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2017 08:00:10 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dfPej-0004JC-TC
        for fio@vger.kernel.org; Wed, 09 Aug 2017 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170809120001.B89B92C289E@kernel.dk>
Date: Wed,  9 Aug 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d4a507c17533f05bcf6d6eeb8d00f3dad1a020a1:

  Merge branch 'fio-jsonplus-patches' of https://github.com/vincentkfu/fio (2017-08-07 13:44:01 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f9cfc7d44a80638f81810416385136c35ad34658:

  Add ability to keep memory-mapped files (2017-08-08 14:26:56 -0600)

----------------------------------------------------------------
Stephen Bates (1):
      Add ability to keep memory-mapped files

 fio.h    | 1 +
 memory.c | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index 39d775c..da950ef 100644
--- a/fio.h
+++ b/fio.h
@@ -87,6 +87,7 @@ enum {
 	TD_F_CHILD		= 1U << 12,
 	TD_F_NO_PROGRESS        = 1U << 13,
 	TD_F_REGROW_LOGS	= 1U << 14,
+	TD_F_MMAP_KEEP		= 1U << 15,
 };
 
 enum {
diff --git a/memory.c b/memory.c
index 22a7f5d..04dc3be 100644
--- a/memory.c
+++ b/memory.c
@@ -138,6 +138,9 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 	}
 
 	if (td->o.mmapfile) {
+		if (access(td->o.mmapfile, F_OK) == 0)
+			td->flags |= TD_F_MMAP_KEEP;
+
 		td->mmapfd = open(td->o.mmapfile, O_RDWR|O_CREAT, 0644);
 
 		if (td->mmapfd < 0) {
@@ -169,7 +172,7 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 		td->orig_buffer = NULL;
 		if (td->mmapfd != 1 && td->mmapfd != -1) {
 			close(td->mmapfd);
-			if (td->o.mmapfile)
+			if (td->o.mmapfile && !(td->flags & TD_F_MMAP_KEEP))
 				unlink(td->o.mmapfile);
 		}
 
@@ -187,7 +190,8 @@ static void free_mem_mmap(struct thread_data *td, size_t total_mem)
 	if (td->o.mmapfile) {
 		if (td->mmapfd != -1)
 			close(td->mmapfd);
-		unlink(td->o.mmapfile);
+		if (!(td->flags & TD_F_MMAP_KEEP))
+			unlink(td->o.mmapfile);
 		free(td->o.mmapfile);
 	}
 }
