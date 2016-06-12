Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33739 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbcFLMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 12 Jun 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bC43g-0001YR-UL
	for fio@vger.kernel.org; Sun, 12 Jun 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160612120001.CC7792C00A6@kernel.dk>
Date: Sun, 12 Jun 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 54d0a3150d44adca3ee4047fabd85651c6ea2db1:

  options: fix typos (2016-06-09 13:30:52 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2b7625e25e32783272b8e6ffbc1546fa50b9386c:

  iolog: fix 'cur_log' leaks (2016-06-11 21:41:13 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Revert "fio: Simplify forking of processes"
      iolog: allocate 'cur_log's out of shared pool
      iolog: fix 'cur_log' leaks

 backend.c | 46 +++++++++++++++++++++++++++++++++++++++-------
 iolog.c   |  6 +++---
 stat.c    |  5 +++--
 3 files changed, 45 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index d8f4f4c..bb0200b 100644
--- a/backend.c
+++ b/backend.c
@@ -1799,6 +1799,39 @@ err:
 	return (void *) (uintptr_t) td->error;
 }
 
+
+/*
+ * We cannot pass the td data into a forked process, so attach the td and
+ * pass it to the thread worker.
+ */
+static int fork_main(struct sk_out *sk_out, int shmid, int offset)
+{
+	struct fork_data *fd;
+	void *data, *ret;
+
+#if !defined(__hpux) && !defined(CONFIG_NO_SHM)
+	data = shmat(shmid, NULL, 0);
+	if (data == (void *) -1) {
+		int __err = errno;
+
+		perror("shmat");
+		return __err;
+	}
+#else
+	/*
+	 * HP-UX inherits shm mappings?
+	 */
+	data = threads;
+#endif
+
+	fd = calloc(1, sizeof(*fd));
+	fd->td = data + offset * sizeof(struct thread_data);
+	fd->sk_out = sk_out;
+	ret = thread_main(fd);
+	shmdt(data);
+	return (int) (uintptr_t) ret;
+}
+
 static void dump_td_info(struct thread_data *td)
 {
 	log_err("fio: job '%s' (state=%d) hasn't exited in %lu seconds, it "
@@ -2136,7 +2169,6 @@ reap:
 		struct thread_data *map[REAL_MAX_JOBS];
 		struct timeval this_start;
 		int this_jobs = 0, left;
-		struct fork_data *fd;
 
 		/*
 		 * create threads (TD_NOT_CREATED -> TD_CREATED)
@@ -2186,13 +2218,14 @@ reap:
 			map[this_jobs++] = td;
 			nr_started++;
 
-			fd = calloc(1, sizeof(*fd));
-			fd->td = td;
-			fd->sk_out = sk_out;
-
 			if (td->o.use_thread) {
+				struct fork_data *fd;
 				int ret;
 
+				fd = calloc(1, sizeof(*fd));
+				fd->td = td;
+				fd->sk_out = sk_out;
+
 				dprint(FD_PROCESS, "will pthread_create\n");
 				ret = pthread_create(&td->thread, NULL,
 							thread_main, fd);
@@ -2212,9 +2245,8 @@ reap:
 				dprint(FD_PROCESS, "will fork\n");
 				pid = fork();
 				if (!pid) {
-					int ret;
+					int ret = fork_main(sk_out, shm_id, i);
 
-					ret = (int)(uintptr_t)thread_main(fd);
 					_exit(ret);
 				} else if (i == fio_debug_jobno)
 					*fio_debug_jobp = pid;
diff --git a/iolog.c b/iolog.c
index 9391507..ff521df 100644
--- a/iolog.c
+++ b/iolog.c
@@ -645,6 +645,7 @@ void free_log(struct io_log *log)
 		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
 		flist_del_init(&cur_log->list);
 		free(cur_log->log);
+		sfree(cur_log);
 	}
 
 	if (log->pending) {
@@ -988,6 +989,7 @@ void flush_log(struct io_log *log, int do_append)
 		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
 		flist_del_init(&cur_log->list);
 		flush_samples(f, cur_log->log, cur_log->nr_samples * log_entry_sz(log));
+		sfree(cur_log);
 	}
 
 	fclose(f);
@@ -1226,9 +1228,7 @@ static int iolog_flush(struct io_log *log)
 		data->samples = cur_log->log;
 		data->nr_samples = cur_log->nr_samples;
 
-		cur_log->nr_samples = 0;
-		cur_log->max_samples = 0;
-		cur_log->log = NULL;
+		sfree(cur_log);
 
 		gz_work(data);
 	}
diff --git a/stat.c b/stat.c
index a8ccd9a..26d8d53 100644
--- a/stat.c
+++ b/stat.c
@@ -16,6 +16,7 @@
 #include "lib/pow2.h"
 #include "lib/output_buffer.h"
 #include "helper_thread.h"
+#include "smalloc.h"
 
 struct fio_mutex *stat_mutex;
 
@@ -1877,7 +1878,7 @@ static struct io_logs *get_new_log(struct io_log *iolog)
 
 	new_size = new_samples * log_entry_sz(iolog);
 
-	cur_log = malloc(sizeof(*cur_log));
+	cur_log = smalloc(sizeof(*cur_log));
 	if (cur_log) {
 		INIT_FLIST_HEAD(&cur_log->list);
 		cur_log->log = malloc(new_size);
@@ -1888,7 +1889,7 @@ static struct io_logs *get_new_log(struct io_log *iolog)
 			iolog->cur_log_max = new_samples;
 			return cur_log;
 		}
-		free(cur_log);
+		sfree(cur_log);
 	}
 
 	return NULL;
