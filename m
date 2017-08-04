Return-Path: <sbates@raithlin.com>
From: sbates@raithlin.com
Subject: [PATCH v2] Add ability to keep memory-mapped files
Date: Fri,  4 Aug 2017 16:24:30 -0600
Message-Id: <1501885470-2445-1-git-send-email-sbates@raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain
Return-Path: sbates@raithlin.com
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: logang@deltatee.com, Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

From: Stephen Bates <sbates@raithlin.com>

By default file backed memory mappings are unlink()'ed after use. This
patch keeps the files if they already existed. We don't check for
errors on access() since we will catch them on the open().

Discovered this when doing p2pmem testing and fio kept deleting the
/dev/p2pmem0 files...

Changes since v1
  Altered based on feedback from Jens to avoid using an option and
  test for file existance instead.

Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 memory.c         | 8 ++++++--
 thread_options.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/memory.c b/memory.c
index 22a7f5dd..70fbb4ef 100644
--- a/memory.c
+++ b/memory.c
@@ -138,6 +138,9 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 	}
 
 	if (td->o.mmapfile) {
+		if (access(td->o.mmapfile, F_OK) == 0)
+			td->o.mmapkeep = 1;
+
 		td->mmapfd = open(td->o.mmapfile, O_RDWR|O_CREAT, 0644);
 
 		if (td->mmapfd < 0) {
@@ -169,7 +172,7 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 		td->orig_buffer = NULL;
 		if (td->mmapfd != 1 && td->mmapfd != -1) {
 			close(td->mmapfd);
-			if (td->o.mmapfile)
+			if (td->o.mmapfile && !td->o.mmapkeep)
 				unlink(td->o.mmapfile);
 		}
 
@@ -187,7 +190,8 @@ static void free_mem_mmap(struct thread_data *td, size_t total_mem)
 	if (td->o.mmapfile) {
 		if (td->mmapfd != -1)
 			close(td->mmapfd);
-		unlink(td->o.mmapfile);
+		if (!td->o.mmapkeep)
+			unlink(td->o.mmapfile);
 		free(td->o.mmapfile);
 	}
 }
diff --git a/thread_options.h b/thread_options.h
index 72d86cfe..e49c4be6 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -54,6 +54,7 @@ struct thread_options {
 	char *opendir;
 	char *ioengine;
 	char *mmapfile;
+	unsigned mmapkeep;
 	enum td_ddir td_ddir;
 	unsigned int rw_seq;
 	unsigned int kb_base;
-- 
2.11.0


