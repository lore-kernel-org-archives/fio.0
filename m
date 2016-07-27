Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbcG0MAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 27 Jul 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bSNVL-0002p9-85
	for fio@vger.kernel.org; Wed, 27 Jul 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160727120001.B9B5C2C00D9@kernel.dk>
Date: Wed, 27 Jul 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 79baf7f48a6e680e1e746e150b60c165542fdf6c:

  Fio 2.13 (2016-07-22 13:43:56 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fa3cdbb7a46e42186e8fa62d33b82b92c7c0e310:

  Add sample job file showing how to read backwards (2016-07-26 14:50:02 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Revert "Revert "fio: Simplify forking of processes""
      Add sample job file showing how to read backwards

 backend.c                   | 46 +++++++--------------------------------------
 examples/backwards-read.fio |  7 +++++++
 2 files changed, 14 insertions(+), 39 deletions(-)
 create mode 100644 examples/backwards-read.fio

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 58c77cb..ad2d7da 100644
--- a/backend.c
+++ b/backend.c
@@ -1808,39 +1808,6 @@ err:
 	return (void *) (uintptr_t) td->error;
 }
 
-
-/*
- * We cannot pass the td data into a forked process, so attach the td and
- * pass it to the thread worker.
- */
-static int fork_main(struct sk_out *sk_out, int shmid, int offset)
-{
-	struct fork_data *fd;
-	void *data, *ret;
-
-#if !defined(__hpux) && !defined(CONFIG_NO_SHM)
-	data = shmat(shmid, NULL, 0);
-	if (data == (void *) -1) {
-		int __err = errno;
-
-		perror("shmat");
-		return __err;
-	}
-#else
-	/*
-	 * HP-UX inherits shm mappings?
-	 */
-	data = threads;
-#endif
-
-	fd = calloc(1, sizeof(*fd));
-	fd->td = data + offset * sizeof(struct thread_data);
-	fd->sk_out = sk_out;
-	ret = thread_main(fd);
-	shmdt(data);
-	return (int) (uintptr_t) ret;
-}
-
 static void dump_td_info(struct thread_data *td)
 {
 	log_err("fio: job '%s' (state=%d) hasn't exited in %lu seconds, it "
@@ -2178,6 +2145,7 @@ reap:
 		struct thread_data *map[REAL_MAX_JOBS];
 		struct timeval this_start;
 		int this_jobs = 0, left;
+		struct fork_data *fd;
 
 		/*
 		 * create threads (TD_NOT_CREATED -> TD_CREATED)
@@ -2227,14 +2195,13 @@ reap:
 			map[this_jobs++] = td;
 			nr_started++;
 
+			fd = calloc(1, sizeof(*fd));
+			fd->td = td;
+			fd->sk_out = sk_out;
+
 			if (td->o.use_thread) {
-				struct fork_data *fd;
 				int ret;
 
-				fd = calloc(1, sizeof(*fd));
-				fd->td = td;
-				fd->sk_out = sk_out;
-
 				dprint(FD_PROCESS, "will pthread_create\n");
 				ret = pthread_create(&td->thread, NULL,
 							thread_main, fd);
@@ -2254,8 +2221,9 @@ reap:
 				dprint(FD_PROCESS, "will fork\n");
 				pid = fork();
 				if (!pid) {
-					int ret = fork_main(sk_out, shm_id, i);
+					int ret;
 
+					ret = (int)(uintptr_t)thread_main(fd);
 					_exit(ret);
 				} else if (i == fio_debug_jobno)
 					*fio_debug_jobp = pid;
diff --git a/examples/backwards-read.fio b/examples/backwards-read.fio
new file mode 100644
index 0000000..ddd47e4
--- /dev/null
+++ b/examples/backwards-read.fio
@@ -0,0 +1,7 @@
+# Demonstrates how to read backwards in a file.
+
+[backwards-read]
+bs=4k
+# seek -8k back for every IO
+rw=read:-8k
+filename=128m
