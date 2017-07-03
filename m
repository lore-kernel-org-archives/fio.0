Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43330 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753367AbdGCMA2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Jul 2017 08:00:28 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dS01Z-0005Wv-7G
        for fio@vger.kernel.org; Mon, 03 Jul 2017 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170703120002.409A72C0087@kernel.dk>
Date: Mon,  3 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dd3503d365f87e68079fb3e443a410743688d53b:

  fio: make gauss a duplicate of normal for file_service_type (2017-06-28 22:58:08 +0100)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5283741f7be708fbbb3feb2cd5ca5187f3a964d1:

  gettime: reduce test CPU clock entries to 1000 (2017-07-02 16:21:47 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      filesetup: abstract out fallocate helper
      gettime: reduce test CPU clock entries to 1000

 filesetup.c | 81 ++++++++++++++++++++++++++++++++-----------------------------
 gettime.c   |  2 +-
 2 files changed, 44 insertions(+), 39 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 13079e4..f3e3865 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -38,12 +38,51 @@ static inline void clear_error(struct thread_data *td)
 	td->verror[0] = '\0';
 }
 
+static void fallocate_file(struct thread_data *td, struct fio_file *f)
+{
+	int r;
+
+	if (td->o.fill_device)
+		return;
+
+#ifdef CONFIG_POSIX_FALLOCATE
+	switch (td->o.fallocate_mode) {
+	case FIO_FALLOCATE_NONE:
+		break;
+	case FIO_FALLOCATE_POSIX:
+		dprint(FD_FILE, "posix_fallocate file %s size %llu\n",
+				 f->file_name,
+				 (unsigned long long) f->real_file_size);
+
+		r = posix_fallocate(f->fd, 0, f->real_file_size);
+		if (r > 0)
+			log_err("fio: posix_fallocate fails: %s\n", strerror(r));
+		break;
+#ifdef CONFIG_LINUX_FALLOCATE
+	case FIO_FALLOCATE_KEEP_SIZE:
+		dprint(FD_FILE, "fallocate(FALLOC_FL_KEEP_SIZE) "
+				"file %s size %llu\n", f->file_name,
+				(unsigned long long) f->real_file_size);
+
+		r = fallocate(f->fd, FALLOC_FL_KEEP_SIZE, 0, f->real_file_size);
+		if (r != 0)
+			td_verror(td, errno, "fallocate");
+
+		break;
+#endif /* CONFIG_LINUX_FALLOCATE */
+	default:
+		log_err("fio: unknown fallocate mode: %d\n", td->o.fallocate_mode);
+		assert(0);
+	}
+#endif /* CONFIG_POSIX_FALLOCATE */
+}
+
 /*
  * Leaves f->fd open on success, caller must close
  */
 static int extend_file(struct thread_data *td, struct fio_file *f)
 {
-	int r, new_layout = 0, unlink_file = 0, flags;
+	int new_layout = 0, unlink_file = 0, flags;
 	unsigned long long left;
 	unsigned int bs;
 	char *b = NULL;
@@ -100,43 +139,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		return 1;
 	}
 
-#ifdef CONFIG_POSIX_FALLOCATE
-	if (!td->o.fill_device) {
-		switch (td->o.fallocate_mode) {
-		case FIO_FALLOCATE_NONE:
-			break;
-		case FIO_FALLOCATE_POSIX:
-			dprint(FD_FILE, "posix_fallocate file %s size %llu\n",
-				 f->file_name,
-				 (unsigned long long) f->real_file_size);
-
-			r = posix_fallocate(f->fd, 0, f->real_file_size);
-			if (r > 0) {
-				log_err("fio: posix_fallocate fails: %s\n",
-						strerror(r));
-			}
-			break;
-#ifdef CONFIG_LINUX_FALLOCATE
-		case FIO_FALLOCATE_KEEP_SIZE:
-			dprint(FD_FILE,
-				"fallocate(FALLOC_FL_KEEP_SIZE) "
-				"file %s size %llu\n", f->file_name,
-				(unsigned long long) f->real_file_size);
-
-			r = fallocate(f->fd, FALLOC_FL_KEEP_SIZE, 0,
-					f->real_file_size);
-			if (r != 0)
-				td_verror(td, errno, "fallocate");
-
-			break;
-#endif /* CONFIG_LINUX_FALLOCATE */
-		default:
-			log_err("fio: unknown fallocate mode: %d\n",
-				td->o.fallocate_mode);
-			assert(0);
-		}
-	}
-#endif /* CONFIG_POSIX_FALLOCATE */
+	fallocate_file(td, f);
 
 	/*
 	 * If our jobs don't require regular files initially, we're done.
@@ -171,6 +174,8 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	}
 
 	while (left && !td->terminate) {
+		ssize_t r;
+
 		if (bs > left)
 			bs = left;
 
diff --git a/gettime.c b/gettime.c
index 5741932..9e5457e 100644
--- a/gettime.c
+++ b/gettime.c
@@ -542,7 +542,7 @@ uint64_t time_since_now(const struct timespec *s)
     defined(CONFIG_SFAA)
 
 #define CLOCK_ENTRIES_DEBUG	100000
-#define CLOCK_ENTRIES_TEST	10000
+#define CLOCK_ENTRIES_TEST	1000
 
 struct clock_entry {
 	uint32_t seq;
