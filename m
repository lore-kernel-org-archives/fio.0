Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57092 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbcGUMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Jul 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bQCe3-0006PD-Rl
	for fio@vger.kernel.org; Thu, 21 Jul 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160721120002.884852C0131@kernel.dk>
Date: Thu, 21 Jul 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit eec97b935abb714bf498c96a8f18ec1104c75fd4:

  Add missing header inclusion for Android from 1c764dbe (2016-07-19 16:20:02 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c16556af62cd1cd1ae31b6ee8706efc43c137f77:

  drifting in output of interval-averaged values was eventually causing IOP samples to be dropped. (2016-07-20 16:21:55 -0400)

----------------------------------------------------------------
Karl Cronburg (1):
      drifting in output of interval-averaged values was eventually causing IOP samples to be dropped.

 stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 96cd764..08a402a 100644
--- a/stat.c
+++ b/stat.c
@@ -2142,7 +2142,7 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 
 	_add_stat_to_log(iolog, elapsed, td->o.log_max != 0);
 
-	iolog->avg_last = elapsed;
+	iolog->avg_last = elapsed - (this_window - iolog->avg_msec);
 }
 
 void finalize_logs(struct thread_data *td, bool unit_logs)
