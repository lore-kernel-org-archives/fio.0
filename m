Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbcGGMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 7 Jul 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bL7yM-0007i7-HP
	for fio@vger.kernel.org; Thu, 07 Jul 2016 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160707120001.C52CE2C23FF@kernel.dk>
Date: Thu,  7 Jul 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f1c4b3727386bd8da3617a6730ad55cf2ba04ec8:

  gfio: call g_thread_init() for <= 2.31.0 (2016-07-05 14:23:56 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0b2eef4940d9818f91f455d0cdb4f37db4fbb158:

  samples being added to the pending log were silently dropped because we failed to set nr_samples in the new log they get copied into (2016-07-06 15:54:10 -0400)

----------------------------------------------------------------
Karl Cronburg (1):
      samples being added to the pending log were silently dropped because we failed to set nr_samples in the new log they get copied into

 stat.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index e0e97cd..96cd764 100644
--- a/stat.c
+++ b/stat.c
@@ -1949,6 +1949,7 @@ static struct io_logs *regrow_log(struct io_log *iolog)
 		dst = get_sample(iolog, cur_log, i);
 		memcpy(dst, src, log_entry_sz(iolog));
 	}
+	cur_log->nr_samples = iolog->pending->nr_samples;
 
 	iolog->pending->nr_samples = 0;
 	return cur_log;
