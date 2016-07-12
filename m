Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41103 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbcGLMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Jul 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bMwM8-00036L-MY
	for fio@vger.kernel.org; Tue, 12 Jul 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160712120002.74AB32C23FF@kernel.dk>
Date: Tue, 12 Jul 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0b2eef4940d9818f91f455d0cdb4f37db4fbb158:

  samples being added to the pending log were silently dropped because we failed to set nr_samples in the new log they get copied into (2016-07-06 15:54:10 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 60a257279f249d65d9905e77d3a2fa54ac5aa881:

  iolog: flush_log() can be bool (2016-07-11 11:51:58 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      iolog: flush_log() can be bool

 backend.c | 2 +-
 iolog.c   | 2 +-
 iolog.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index bb0200b..dc6f530 100644
--- a/backend.c
+++ b/backend.c
@@ -2388,7 +2388,7 @@ int fio_backend(struct sk_out *sk_out)
 			for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 				struct io_log *log = agg_io_log[i];
 
-				flush_log(log, 0);
+				flush_log(log, false);
 				free_log(log);
 			}
 		}
diff --git a/iolog.c b/iolog.c
index ff521df..4c87f1c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -965,7 +965,7 @@ int iolog_file_inflate(const char *file)
 
 #endif
 
-void flush_log(struct io_log *log, int do_append)
+void flush_log(struct io_log *log, bool do_append)
 {
 	void *buf;
 	FILE *f;
diff --git a/iolog.h b/iolog.h
index 0da7067..a58e3f0 100644
--- a/iolog.h
+++ b/iolog.h
@@ -232,7 +232,7 @@ static inline bool per_unit_log(struct io_log *log)
 
 extern void finalize_logs(struct thread_data *td, bool);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
-extern void flush_log(struct io_log *, int);
+extern void flush_log(struct io_log *, bool);
 extern void flush_samples(FILE *, void *, uint64_t);
 extern void free_log(struct io_log *);
 extern void fio_writeout_logs(bool);
