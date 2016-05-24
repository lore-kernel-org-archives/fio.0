Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbcEXPD2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 May 2016 11:03:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 63D61AB5F
	for <fio@vger.kernel.org>; Tue, 24 May 2016 15:03:26 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] fio: Simplify forking of processes
Date: Tue, 24 May 2016 17:03:21 +0200
Message-Id: <1464102202-16724-1-git-send-email-jack@suse.cz>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>

There is no reason to re-attach to shared memory segments after fork(2).
shmat(2) manpage specifically says:

After a fork(2), the child inherits the attached shared memory segments.

So get rid of some unnecessary code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 backend.c | 46 +++++++---------------------------------------
 1 file changed, 7 insertions(+), 39 deletions(-)

diff --git a/backend.c b/backend.c
index 6d503606b10e..95385bc0b8b3 100644
--- a/backend.c
+++ b/backend.c
@@ -1791,39 +1791,6 @@ err:
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
@@ -2161,6 +2128,7 @@ reap:
 		struct thread_data *map[REAL_MAX_JOBS];
 		struct timeval this_start;
 		int this_jobs = 0, left;
+		struct fork_data *fd;
 
 		/*
 		 * create threads (TD_NOT_CREATED -> TD_CREATED)
@@ -2210,14 +2178,13 @@ reap:
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
@@ -2237,8 +2204,9 @@ reap:
 				dprint(FD_PROCESS, "will fork\n");
 				pid = fork();
 				if (!pid) {
-					int ret = fork_main(sk_out, shm_id, i);
+					int ret;
 
+					ret = (int)(uintptr_t)thread_main(fd);
 					_exit(ret);
 				} else if (i == fio_debug_jobno)
 					*fio_debug_jobp = pid;
-- 
2.6.6

