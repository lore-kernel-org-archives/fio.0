Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbbKQNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 17 Nov 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Zyfrg-0006iM-Tk
	for fio@vger.kernel.org; Tue, 17 Nov 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151117130001.DA8032C00CE@kernel.dk>
Date: Tue, 17 Nov 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 236d24dff4826a469d2e980c2b71c2adba3b907e:

  json output fixups (2015-11-11 11:26:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d883efbdb2034b4ab23abec9cee1762d6d476247:

  Fix group_id != groupid mixup (2015-11-16 14:00:41 -0700)

----------------------------------------------------------------
Casey Bodley (1):
      iolog: fix error when compiled as c++

Jens Axboe (1):
      Fix group_id != groupid mixup

 fio.h    | 4 ++--
 init.c   | 4 ++++
 iolog.h  | 3 ++-
 libfio.c | 4 ++--
 4 files changed, 10 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index a2b3d9f..2e13b54 100644
--- a/fio.h
+++ b/fio.h
@@ -539,8 +539,8 @@ extern void td_restore_runstate(struct thread_data *, int);
  */
 #define FIO_REAP_TIMEOUT	60
 
-#define TERMINATE_ALL		(-1)
-extern void fio_terminate_threads(int);
+#define TERMINATE_ALL		(-1U)
+extern void fio_terminate_threads(unsigned int);
 extern void fio_mark_td_terminate(struct thread_data *);
 
 /*
diff --git a/init.c b/init.c
index 04b4a1e..af35ee6 100644
--- a/init.c
+++ b/init.c
@@ -1233,6 +1233,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if ((o->stonewall || o->new_group) && prev_group_jobs) {
 		prev_group_jobs = 0;
 		groupid++;
+		if (groupid == INT_MAX) {
+			log_err("fio: too many groups defined\n");
+			goto err;
+		}
 	}
 
 	td->groupid = groupid;
diff --git a/iolog.h b/iolog.h
index b1c13bf..aa4562d 100644
--- a/iolog.h
+++ b/iolog.h
@@ -122,7 +122,8 @@ static inline size_t log_entry_sz(struct io_log *log)
 static inline struct io_sample *__get_sample(void *samples, int log_offset,
 					     uint64_t sample)
 {
-	return samples + sample * __log_entry_sz(log_offset);
+	uint64_t sample_offset = sample * __log_entry_sz(log_offset);
+	return (struct io_sample *) ((char *) samples + sample_offset);
 }
 
 static inline struct io_sample *get_sample(struct io_log *iolog,
diff --git a/libfio.c b/libfio.c
index 09591a1..3aa52e0 100644
--- a/libfio.c
+++ b/libfio.c
@@ -229,7 +229,7 @@ void fio_mark_td_terminate(struct thread_data *td)
 	td->terminate = 1;
 }
 
-void fio_terminate_threads(int group_id)
+void fio_terminate_threads(unsigned int group_id)
 {
 	struct thread_data *td;
 	pid_t pid = getpid();
@@ -238,7 +238,7 @@ void fio_terminate_threads(int group_id)
 	dprint(FD_PROCESS, "terminate group_id=%d\n", group_id);
 
 	for_each_td(td, i) {
-		if (group_id == TERMINATE_ALL || groupid == td->groupid) {
+		if (group_id == TERMINATE_ALL || group_id == td->groupid) {
 			dprint(FD_PROCESS, "setting terminate on %s/%d\n",
 						td->o.name, (int) td->pid);
 
