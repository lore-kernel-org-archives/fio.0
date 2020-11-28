Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733109AbgK1TFV (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Nov 2020 14:05:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221E9C02A194
        for <fio@vger.kernel.org>; Sat, 28 Nov 2020 05:00:07 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kizpc-0006jU-Sj
        for fio@vger.kernel.org; Sat, 28 Nov 2020 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201128130002.1A1171BC012C@kernel.dk>
Date: Sat, 28 Nov 2020 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d04162b62c9d7d4f5e8ea70be9cb419abaced160:

  Merge branch 'update-fio-ioops-version' of https://github.com/diameter/fio (2020-11-25 11:01:00 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7914c6147adaf3ef32804519ced850168fff1711:

  Merge branch 'regrow_agg_logs' of https://github.com/pmoust/fio (2020-11-27 08:55:12 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'regrow_agg_logs' of https://github.com/pmoust/fio

Panagiotis Moustafellos (1):
      stat: allow bandwidth log stats to grow to MAX_LOG_ENTRIES

 eta.c   | 1 +
 iolog.h | 1 +
 stat.c  | 8 ++++++++
 3 files changed, 10 insertions(+)

---

Diff of recent changes:

diff --git a/eta.c b/eta.c
index d1c9449f..97843012 100644
--- a/eta.c
+++ b/eta.c
@@ -507,6 +507,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
 				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
+		regrow_agg_logs();
 		for_each_rw_ddir(ddir) {
 			add_agg_sample(sample_val(je->rate[ddir]), ddir, 0, 0);
 		}
diff --git a/iolog.h b/iolog.h
index 981081f9..9e382cc0 100644
--- a/iolog.h
+++ b/iolog.h
@@ -182,6 +182,7 @@ static inline struct io_sample *__get_sample(void *samples, int log_offset,
 struct io_logs *iolog_cur_log(struct io_log *);
 uint64_t iolog_nr_samples(struct io_log *);
 void regrow_logs(struct thread_data *);
+void regrow_agg_logs(void);
 
 static inline struct io_sample *get_sample(struct io_log *iolog,
 					   struct io_logs *cur_log,
diff --git a/stat.c b/stat.c
index eb40bd7f..d42586e7 100644
--- a/stat.c
+++ b/stat.c
@@ -2536,6 +2536,14 @@ void regrow_logs(struct thread_data *td)
 	td->flags &= ~TD_F_REGROW_LOGS;
 }
 
+void regrow_agg_logs(void)
+{
+	enum fio_ddir ddir;
+
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
+		regrow_log(agg_io_log[ddir]);
+}
+
 static struct io_logs *get_cur_log(struct io_log *iolog)
 {
 	struct io_logs *cur_log;

