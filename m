Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbhAQNAs (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 17 Jan 2021 08:00:48 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AC2C061573
        for <fio@vger.kernel.org>; Sun, 17 Jan 2021 05:00:07 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l17f2-00070t-RI
        for fio@vger.kernel.org; Sun, 17 Jan 2021 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210117130001.789571BC0149@kernel.dk>
Date: Sun, 17 Jan 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e4d9a7bf68d0ffb9fd7ab328a4f0edddc89297be:

  Merge branch 'fix_keyword_sub' of https://github.com/sitsofe/fio (2021-01-15 20:52:57 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 548b363c08875165a018788195e8fd2304c2ce24:

  Merge branch 'fix_filename_overrun' of https://github.com/sitsofe/fio (2021-01-16 13:36:27 -0700)

----------------------------------------------------------------
HongweiQin (1):
      Fix a rate limit issue.

Jens Axboe (1):
      Merge branch 'fix_filename_overrun' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      options: fix buffer overrun

 backend.c |  4 ++--
 fio.h     | 10 +---------
 options.c |  1 +
 parse.c   |  5 +++++
 4 files changed, 9 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 2e6a377c..e20a2e07 100644
--- a/backend.c
+++ b/backend.c
@@ -439,7 +439,7 @@ static int wait_for_completions(struct thread_data *td, struct timespec *time)
 	if ((full && !min_evts) || !td->o.iodepth_batch_complete_min)
 		min_evts = 1;
 
-	if (time && __should_check_rate(td))
+	if (time && should_check_rate(td))
 		fio_gettime(time, NULL);
 
 	do {
@@ -494,7 +494,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 			requeue_io_u(td, &io_u);
 		} else {
 sync_done:
-			if (comp_time && __should_check_rate(td))
+			if (comp_time && should_check_rate(td))
 				fio_gettime(comp_time, NULL);
 
 			*ret = io_u_sync_complete(td, io_u);
diff --git a/fio.h b/fio.h
index 4d439d98..ee582a72 100644
--- a/fio.h
+++ b/fio.h
@@ -757,17 +757,9 @@ static inline bool option_check_rate(struct thread_data *td, enum fio_ddir ddir)
 	return false;
 }
 
-static inline bool __should_check_rate(struct thread_data *td)
-{
-	return (td->flags & TD_F_CHECK_RATE) != 0;
-}
-
 static inline bool should_check_rate(struct thread_data *td)
 {
-	if (!__should_check_rate(td))
-		return false;
-
-	return ddir_rw_sum(td->bytes_done) != 0;
+	return (td->flags & TD_F_CHECK_RATE) != 0;
 }
 
 static inline unsigned long long td_max_bs(struct thread_data *td)
diff --git a/options.c b/options.c
index 0b4c48d6..955bf959 100644
--- a/options.c
+++ b/options.c
@@ -1672,6 +1672,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Filename(s)",
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= offsetof(struct thread_options, filename),
+		.maxlen	= PATH_MAX,
 		.cb	= str_filename_cb,
 		.prio	= -1, /* must come after "directory" */
 		.help	= "File(s) to use for the workload",
diff --git a/parse.c b/parse.c
index c28d82ef..44bf9507 100644
--- a/parse.c
+++ b/parse.c
@@ -786,6 +786,11 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 		if (o->off1) {
 			cp = td_var(data, o, o->off1);
 			*cp = strdup(ptr);
+			if (strlen(ptr) > o->maxlen - 1) {
+				log_err("value exceeds max length of %d\n",
+					o->maxlen);
+				return 1;
+			}
 		}
 
 		if (fn)

