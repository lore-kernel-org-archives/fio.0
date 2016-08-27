Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbcH0MAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 Aug 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bdcHL-0004ew-Eq
        for fio@vger.kernel.org; Sat, 27 Aug 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160827120002.84C5A2C0286@kernel.dk>
Date: Sat, 27 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 04d6530f6ecd50520e99732b0b6bb90f71ff131a:

  file: fix numjobs > 1 and implied jobname as filename (2016-08-25 21:00:55 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 39d13e67ef1f4b327c68431f8daf033a03920117:

  backend: check if we need to update rusage stats, if stat_mutex is busy (2016-08-26 14:39:30 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      file: fio_files_done() can return bool
      backend: check if we need to update rusage stats, if stat_mutex is busy

 backend.c   | 8 ++++++--
 file.h      | 2 +-
 filesetup.c | 7 +++----
 3 files changed, 10 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index d986586..fb2a855 100644
--- a/backend.c
+++ b/backend.c
@@ -1731,9 +1731,13 @@ static void *thread_main(void *data)
 		 * the rusage_sem, which would never get upped because
 		 * this thread is waiting for the stat mutex.
 		 */
-		check_update_rusage(td);
+		do {
+			check_update_rusage(td);
+			if (!fio_mutex_down_trylock(stat_mutex))
+				break;
+			usleep(1000);
+		} while (1);
 
-		fio_mutex_down(stat_mutex);
 		if (td_read(td) && td->io_bytes[DDIR_READ])
 			update_runtime(td, elapsed_us, DDIR_READ);
 		if (td_write(td) && td->io_bytes[DDIR_WRITE])
diff --git a/file.h b/file.h
index aff3ce9..6f34dd5 100644
--- a/file.h
+++ b/file.h
@@ -210,7 +210,7 @@ extern int get_fileno(struct thread_data *, const char *);
 extern void free_release_files(struct thread_data *);
 extern void filesetup_mem_free(void);
 extern void fio_file_reset(struct thread_data *, struct fio_file *);
-extern int fio_files_done(struct thread_data *);
+extern bool fio_files_done(struct thread_data *);
 extern bool exists_and_not_regfile(const char *);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index fc9f306..c6ef3bf 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1292,7 +1292,6 @@ static void set_already_allocated(const char *fname)
 	}
 }
 
-
 static void free_already_allocated(void)
 {
 	struct flist_head *entry, *tmp;
@@ -1666,16 +1665,16 @@ void fio_file_reset(struct thread_data *td, struct fio_file *f)
 		lfsr_reset(&f->lfsr, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
 }
 
-int fio_files_done(struct thread_data *td)
+bool fio_files_done(struct thread_data *td)
 {
 	struct fio_file *f;
 	unsigned int i;
 
 	for_each_file(td, f, i)
 		if (!fio_file_done(f))
-			return 0;
+			return false;
 
-	return 1;
+	return true;
 }
 
 /* free memory used in initialization phase only */
