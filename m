Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40844 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbcEUMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 21 May 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1b45Zc-0007XJ-8J
	for fio@vger.kernel.org; Sat, 21 May 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160521120002.4B4732C00DF@kernel.dk>
Date: Sat, 21 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6fa3ad511a61666b492ed8126330db9f876359bc:

  iolog: fix duplicate handling of compression end (2016-05-19 15:49:57 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2ab71dc4d39e29764f0f80a3559a0119247e1eb1:

  iolog: fix potential oops in iolog disabling (2016-05-20 14:36:34 -0600)

----------------------------------------------------------------
David Zeng (1):
      The fixed CPU architecture in the Makefile will make failure on ppc64le.

Jens Axboe (5):
      iolog: regrow log out-of-line
      iolog: remove dead define
      Merge branch 'master' of https://github.com/davidzengxhsh/fio
      iolog: fix two bugs in deferred growing
      iolog: fix potential oops in iolog disabling

 Makefile  |  2 +-
 backend.c |  6 ++++++
 fio.h     |  1 +
 iolog.c   | 16 +++++++++++++++
 iolog.h   |  9 ++++++--
 stat.c    | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 6 files changed, 98 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 0133ac4..108e6ee 100644
--- a/Makefile
+++ b/Makefile
@@ -49,7 +49,7 @@ SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
-  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/amd64/server -L$(JAVA_HOME)/jre/lib/amd64/server -ljvm $(FIO_LIBHDFS_LIB)/libhdfs.a
+  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/`uname -m`/server -L$(JAVA_HOME)/jre/lib/`uname -m`/server -ljvm $(FIO_LIBHDFS_LIB)/libhdfs.a
   CFLAGS += $(HDFSFLAGS)
   SOURCE += engines/libhdfs.c
 endif
diff --git a/backend.c b/backend.c
index f830040..6d50360 100644
--- a/backend.c
+++ b/backend.c
@@ -441,6 +441,12 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time)
 	int min_evts = 0;
 	int ret;
 
+	if (td->flags & TD_F_REGROW_LOGS) {
+		ret = io_u_quiesce(td);
+		regrow_logs(td);
+		return ret;
+	}
+
 	/*
 	 * if the queue is full, we MUST reap at least 1 event
 	 */
diff --git a/fio.h b/fio.h
index 8b6a272..7e6311c 100644
--- a/fio.h
+++ b/fio.h
@@ -79,6 +79,7 @@ enum {
 	TD_F_NEED_LOCK		= 1U << 11,
 	TD_F_CHILD		= 1U << 12,
 	TD_F_NO_PROGRESS        = 1U << 13,
+	TD_F_REGROW_LOGS	= 1U << 14,
 };
 
 enum {
diff --git a/iolog.c b/iolog.c
index aec0881..d9a17a5 100644
--- a/iolog.c
+++ b/iolog.c
@@ -587,6 +587,15 @@ void setup_log(struct io_log **log, struct log_params *p,
 	l->filename = strdup(filename);
 	l->td = p->td;
 
+	if (l->td && l->td->o.io_submit_mode != IO_MODE_OFFLOAD) {
+		struct io_logs *p;
+
+		p = calloc(1, sizeof(*l->pending));
+		p->max_samples = DEF_LOG_ENTRIES;
+		p->log = calloc(p->max_samples, log_entry_sz(l));
+		l->pending = p;
+	}
+
 	if (l->log_offset)
 		l->log_ddir_mask = LOG_OFFSET_SAMPLE_BIT;
 
@@ -638,6 +647,13 @@ void free_log(struct io_log *log)
 		free(cur_log->log);
 	}
 
+	if (log->pending) {
+		free(log->pending->log);
+		free(log->pending);
+		log->pending = NULL;
+	}
+
+	free(log->pending);
 	free(log->filename);
 	sfree(log);
 }
diff --git a/iolog.h b/iolog.h
index 2b7813b..0da7067 100644
--- a/iolog.h
+++ b/iolog.h
@@ -44,8 +44,6 @@ enum {
 #define DEF_LOG_ENTRIES		1024
 #define MAX_LOG_ENTRIES		(1024 * DEF_LOG_ENTRIES)
 
-#define LOG_QUIESCE_SZ		(64 * 1024 * 1024)
-
 struct io_logs {
 	struct flist_head list;
 	uint64_t nr_samples;
@@ -63,6 +61,12 @@ struct io_log {
 	struct flist_head io_logs;
 	uint32_t cur_log_max;
 
+	/*
+	 * When the current log runs out of space, store events here until
+	 * we have a chance to regrow
+	 */
+	struct io_logs *pending;
+
 	unsigned int log_ddir_mask;
 
 	char *filename;
@@ -139,6 +143,7 @@ static inline struct io_sample *__get_sample(void *samples, int log_offset,
 
 struct io_logs *iolog_cur_log(struct io_log *);
 uint64_t iolog_nr_samples(struct io_log *);
+void regrow_logs(struct thread_data *);
 
 static inline struct io_sample *get_sample(struct io_log *iolog,
 					   struct io_logs *cur_log,
diff --git a/stat.c b/stat.c
index 5eb1aab..fc1efd4 100644
--- a/stat.c
+++ b/stat.c
@@ -1889,9 +1889,16 @@ static struct io_logs *get_new_log(struct io_log *iolog)
 	return NULL;
 }
 
-static struct io_logs *get_cur_log(struct io_log *iolog)
+/*
+ * Add and return a new log chunk, or return current log if big enough
+ */
+static struct io_logs *regrow_log(struct io_log *iolog)
 {
 	struct io_logs *cur_log;
+	int i;
+
+	if (!iolog || iolog->disabled)
+		goto disable;
 
 	cur_log = iolog_cur_log(iolog);
 	if (!cur_log) {
@@ -1918,13 +1925,70 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 	 * Get a new log array, and add to our list
 	 */
 	cur_log = get_new_log(iolog);
-	if (cur_log)
+	if (!cur_log) {
+		log_err("fio: failed extending iolog! Will stop logging.\n");
+		return NULL;
+	}
+
+	if (!iolog->pending || !iolog->pending->nr_samples)
 		return cur_log;
 
-	log_err("fio: failed extending iolog! Will stop logging.\n");
+	/*
+	 * Flush pending items to new log
+	 */
+	for (i = 0; i < iolog->pending->nr_samples; i++) {
+		struct io_sample *src, *dst;
+
+		src = get_sample(iolog, iolog->pending, i);
+		dst = get_sample(iolog, cur_log, i);
+		memcpy(dst, src, log_entry_sz(iolog));
+	}
+
+	iolog->pending->nr_samples = 0;
+	return cur_log;
+disable:
+	if (iolog)
+		iolog->disabled = true;
 	return NULL;
 }
 
+void regrow_logs(struct thread_data *td)
+{
+	regrow_log(td->slat_log);
+	regrow_log(td->clat_log);
+	regrow_log(td->lat_log);
+	regrow_log(td->bw_log);
+	regrow_log(td->iops_log);
+	td->flags &= ~TD_F_REGROW_LOGS;
+}
+
+static struct io_logs *get_cur_log(struct io_log *iolog)
+{
+	struct io_logs *cur_log;
+
+	cur_log = iolog_cur_log(iolog);
+	if (!cur_log) {
+		cur_log = get_new_log(iolog);
+		if (!cur_log)
+			return NULL;
+	}
+
+	if (cur_log->nr_samples < cur_log->max_samples)
+		return cur_log;
+
+	/*
+	 * Out of space. If we're in IO offload mode, add a new log chunk
+	 * inline. If we're doing inline submissions, flag 'td' as needing
+	 * a log regrow and we'll take care of it on the submission side.
+	 */
+	if (iolog->td->o.io_submit_mode == IO_MODE_OFFLOAD)
+		return regrow_log(iolog);
+
+	iolog->td->flags |= TD_F_REGROW_LOGS;
+	assert(iolog->pending->nr_samples < iolog->pending->max_samples);
+	return iolog->pending;
+}
+
 static void __add_log_sample(struct io_log *iolog, unsigned long val,
 			     enum fio_ddir ddir, unsigned int bs,
 			     unsigned long t, uint64_t offset)
