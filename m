Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43966 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753763AbeGEMAY (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 Jul 2018 08:00:24 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fb2vv-0006qx-4T
        for fio@vger.kernel.org; Thu, 05 Jul 2018 12:00:23 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180705120001.D18B02C006C@kernel.dk>
Date: Thu,  5 Jul 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 354d50e771451f510e5886275768abb63b602798:

  Fix compilation without cgroups (2018-06-29 08:00:29 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 19a8064ef4a2a826ee06ed061af970d1737cf840:

  blktrace: just ignore zero byte traces (2018-07-04 14:59:18 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      blktrace: just ignore zero byte traces

 blktrace.c | 11 ++++++++++-
 debug.h    |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index cda111a..36a7180 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -303,6 +303,11 @@ static void handle_trace_discard(struct thread_data *td,
 	queue_io_piece(td, ipo);
 }
 
+static void dump_trace(struct blk_io_trace *t)
+{
+	log_err("blktrace: ignoring zero byte trace: action=%x\n", t->action);
+}
+
 static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 			    unsigned long long ttime, unsigned long *ios,
 			    unsigned int *rw_bs)
@@ -323,7 +328,11 @@ static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 			return;
 	}
 
-	assert(t->bytes);
+	if (!t->bytes) {
+		if (!fio_did_warn(FIO_WARN_BTRACE_ZERO))
+			dump_trace(t);
+		return;
+	}
 
 	if (t->bytes > rw_bs[rw])
 		rw_bs[rw] = t->bytes;
diff --git a/debug.h b/debug.h
index 8a8cf87..e5e8040 100644
--- a/debug.h
+++ b/debug.h
@@ -42,6 +42,7 @@ enum {
 	FIO_WARN_ZONED_BUG	= 4,
 	FIO_WARN_IOLOG_DROP	= 8,
 	FIO_WARN_FADVISE	= 16,
+	FIO_WARN_BTRACE_ZERO	= 32,
 };
 
 #ifdef FIO_INC_DEBUG
