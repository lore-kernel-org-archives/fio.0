Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaKJNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 10 Nov 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XnoZh-0005WT-EN
	for fio@vger.kernel.org; Mon, 10 Nov 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141110130003.A986B401D9@lyth.info>
Date: Mon, 10 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 988d97bac90c9ff3ee40a8ccd588fdf78f19320d:

  client/server: percentile_precision wasn't net converted (2014-11-07 18:47:41 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e5437a073e658e8154b9e87bab5c7b3b06ed4255:

  Fix for a race when fio prints I/O statistics periodically (2014-11-09 20:24:14 -0700)

----------------------------------------------------------------
Vasily Tarasov (1):
      Fix for a race when fio prints I/O statistics periodically

 backend.c |   17 ++++++++++-------
 stat.c    |    2 +-
 stat.h    |    2 ++
 3 files changed, 13 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index c0b446a..59a14d1 100644
--- a/backend.c
+++ b/backend.c
@@ -1484,18 +1484,21 @@ static void *thread_main(void *data)
 
 		clear_state = 1;
 
+		fio_mutex_down(stat_mutex);
 		if (td_read(td) && td->io_bytes[DDIR_READ]) {
-			elapsed = utime_since_now(&td->start);
+			elapsed = mtime_since_now(&td->start);
 			td->ts.runtime[DDIR_READ] += elapsed;
 		}
 		if (td_write(td) && td->io_bytes[DDIR_WRITE]) {
-			elapsed = utime_since_now(&td->start);
+			elapsed = mtime_since_now(&td->start);
 			td->ts.runtime[DDIR_WRITE] += elapsed;
 		}
 		if (td_trim(td) && td->io_bytes[DDIR_TRIM]) {
-			elapsed = utime_since_now(&td->start);
+			elapsed = mtime_since_now(&td->start);
 			td->ts.runtime[DDIR_TRIM] += elapsed;
 		}
+		fio_gettime(&td->start, NULL);
+		fio_mutex_up(stat_mutex);
 
 		if (td->error || td->terminate)
 			break;
@@ -1511,16 +1514,16 @@ static void *thread_main(void *data)
 
 		do_verify(td, verify_bytes);
 
-		td->ts.runtime[DDIR_READ] += utime_since_now(&td->start);
+		fio_mutex_down(stat_mutex);
+		td->ts.runtime[DDIR_READ] += mtime_since_now(&td->start);
+		fio_gettime(&td->start, NULL);
+		fio_mutex_up(stat_mutex);
 
 		if (td->error || td->terminate)
 			break;
 	}
 
 	update_rusage_stat(td);
-	td->ts.runtime[DDIR_READ] = (td->ts.runtime[DDIR_READ] + 999) / 1000;
-	td->ts.runtime[DDIR_WRITE] = (td->ts.runtime[DDIR_WRITE] + 999) / 1000;
-	td->ts.runtime[DDIR_TRIM] = (td->ts.runtime[DDIR_TRIM] + 999) / 1000;
 	td->ts.total_run_time = mtime_since_now(&td->epoch);
 	td->ts.io_bytes[DDIR_READ] = td->io_bytes[DDIR_READ];
 	td->ts.io_bytes[DDIR_WRITE] = td->io_bytes[DDIR_WRITE];
diff --git a/stat.c b/stat.c
index 84d9eef..1bfbbeb 100644
--- a/stat.c
+++ b/stat.c
@@ -14,7 +14,7 @@
 #include "lib/getrusage.h"
 #include "idletime.h"
 
-static struct fio_mutex *stat_mutex;
+struct fio_mutex *stat_mutex;
 
 void update_rusage_stat(struct thread_data *td)
 {
diff --git a/stat.h b/stat.h
index 8aefe03..8b4416c 100644
--- a/stat.h
+++ b/stat.h
@@ -214,6 +214,8 @@ struct jobs_eta {
 	uint8_t run_str[];
 } __attribute__((packed));
 
+extern struct fio_mutex *stat_mutex;
+
 extern struct jobs_eta *get_jobs_eta(int force, size_t *size);
 
 extern void stat_init(void);
