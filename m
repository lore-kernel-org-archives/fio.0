Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53784 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759492AbcLBNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Dec 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cCnRc-0001Mw-8j
        for fio@vger.kernel.org; Fri, 02 Dec 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161202130002.47C9B2C11A9@kernel.dk>
Date: Fri,  2 Dec 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7a3b2fc3434985fa519db55e8f81734c24af274d:

  server: bump protocol version (2016-11-27 21:40:26 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6be06c46544c19e513ff80e7b841b1de688ffc66:

  log: fix for crash with rate IO and logging (2016-12-01 21:23:47 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      log: fix for crash with rate IO and logging

Vincent Fu (1):
      Fix conversion in fio_server_send_ts

 backend.c | 7 ++-----
 io_u.c    | 3 +++
 server.c  | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 8616fc2..ac71521 100644
--- a/backend.c
+++ b/backend.c
@@ -441,11 +441,8 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time)
 	int min_evts = 0;
 	int ret;
 
-	if (td->flags & TD_F_REGROW_LOGS) {
-		ret = io_u_quiesce(td);
-		regrow_logs(td);
-		return ret;
-	}
+	if (td->flags & TD_F_REGROW_LOGS)
+		return io_u_quiesce(td);
 
 	/*
 	 * if the queue is full, we MUST reap at least 1 event
diff --git a/io_u.c b/io_u.c
index 428d4b7..7420629 100644
--- a/io_u.c
+++ b/io_u.c
@@ -653,6 +653,9 @@ int io_u_quiesce(struct thread_data *td)
 			completed += ret;
 	}
 
+	if (td->flags & TD_F_REGROW_LOGS)
+		regrow_logs(td);
+
 	return completed;
 }
 
diff --git a/server.c b/server.c
index ab3e7cf..172ccc0 100644
--- a/server.c
+++ b/server.c
@@ -1541,9 +1541,9 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.latency_window	= cpu_to_le64(ts->latency_window);
 	p.ts.latency_percentile.u.i = cpu_to_le64(fio_double_to_uint64(ts->latency_percentile.u.f));
 
-	p.ts.nr_block_infos	= le64_to_cpu(ts->nr_block_infos);
+	p.ts.nr_block_infos	= cpu_to_le64(ts->nr_block_infos);
 	for (i = 0; i < p.ts.nr_block_infos; i++)
-		p.ts.block_infos[i] = le32_to_cpu(ts->block_infos[i]);
+		p.ts.block_infos[i] = cpu_to_le32(ts->block_infos[i]);
 
 	convert_gs(&p.rs, rs);
 
