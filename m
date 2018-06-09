Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52434 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753172AbeFIMAk (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 9 Jun 2018 08:00:40 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fRcXv-0004F4-UO
        for fio@vger.kernel.org; Sat, 09 Jun 2018 12:00:39 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180609120002.53E9B2C0311@kernel.dk>
Date: Sat,  9 Jun 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7ceefc0914b9ff721047b4dc8be54625d43f577c:

  idle-prof: Fix segment fault issue when run with '--idle-prof' and multiple output format normal,json (2018-06-07 20:27:25 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ab5643cb04dac549b2202231d5c6e33339b7fe7d:

  stat: fix --bandwidth-log segfault (2018-06-08 08:31:20 -0600)

----------------------------------------------------------------
Igor Konopko (1):
      stat: fix --bandwidth-log segfault

 stat.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 58edf04..d5240d9 100644
--- a/stat.c
+++ b/stat.c
@@ -2207,12 +2207,14 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 	 * submissions, flag 'td' as needing a log regrow and we'll take
 	 * care of it on the submission side.
 	 */
-	if (iolog->td->o.io_submit_mode == IO_MODE_OFFLOAD ||
+	if ((iolog->td && iolog->td->o.io_submit_mode == IO_MODE_OFFLOAD) ||
 	    !per_unit_log(iolog))
 		return regrow_log(iolog);
 
-	iolog->td->flags |= TD_F_REGROW_LOGS;
-	assert(iolog->pending->nr_samples < iolog->pending->max_samples);
+	if (iolog->td)
+		iolog->td->flags |= TD_F_REGROW_LOGS;
+	if (iolog->pending)
+		assert(iolog->pending->nr_samples < iolog->pending->max_samples);
 	return iolog->pending;
 }
 
