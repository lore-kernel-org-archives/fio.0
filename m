Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34290 "EHLO
        mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934302AbcJEWPi (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Oct 2016 18:15:38 -0400
Received: by mail-pa0-f43.google.com with SMTP id rz1so667559pab.1
        for <fio@vger.kernel.org>; Wed, 05 Oct 2016 15:15:37 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 2/4] iolog: fix --bandwidth-log segfaults
Date: Wed,  5 Oct 2016 15:15:27 -0700
Message-Id: <0fbb21a1d03796c77a79e588e8c9f51cd90e1030.1475705698.git.osandov@fb.com>
In-Reply-To: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
References: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
In-Reply-To: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
References: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

The global bandwidth log doesn't have thread data.

Fixes: 1e613c9c2393 ("This commit / feature adds completion latency histogram output to fio")
Fixes: 3aea75b14510 ("Option for changing log files to use Unix epoch")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 iolog.c | 2 +-
 stat.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iolog.c b/iolog.c
index 6576ca5..ab9c878 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1065,7 +1065,7 @@ void flush_log(struct io_log *log, bool do_append)
 		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
 		flist_del_init(&cur_log->list);
 		
-		if (log == log->td->clat_hist_log)
+		if (log->td && log == log->td->clat_hist_log)
 			flush_hist_samples(f, log->hist_coarseness, cur_log->log,
 			                   log_sample_sz(log, cur_log));
 		else
diff --git a/stat.c b/stat.c
index 3c72a6c..1e889f5 100644
--- a/stat.c
+++ b/stat.c
@@ -2023,7 +2023,7 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 		s = get_sample(iolog, cur_log, cur_log->nr_samples);
 
 		s->val = val;
-		s->time = t + iolog->td->unix_epoch;
+		s->time = t + (iolog->td ? iolog->td->unix_epoch : 0);
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
 
-- 
2.10.0

