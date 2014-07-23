Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54583 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbaGWMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Jul 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X9vDI-0000p7-JV
	for fio@vger.kernel.org; Wed, 23 Jul 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140723120003.9302940208@lyth.info>
Date: Wed, 23 Jul 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 908119302fbb900a449988d03dacc95426c09e08:

  stat: move stat mutex grab to thread (2014-07-21 11:32:13 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7ffa8930764e6ccc5bf036fe4d73f1d7276453e5:

  verify: ensure that verify interval is smaller or equal to blocksize (2014-07-23 09:47:26 +0200)

----------------------------------------------------------------
Jens Axboe (1):
      verify: ensure that verify interval is smaller or equal to blocksize

 init.c |    9 +++++++++
 1 file changed, 9 insertions(+)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index cf1d7f9..b4a0cbb 100644
--- a/init.c
+++ b/init.c
@@ -635,6 +635,15 @@ static int fixup_options(struct thread_data *td)
 		if (o->max_bs[DDIR_WRITE] != o->min_bs[DDIR_WRITE] &&
 		    !o->verify_interval)
 			o->verify_interval = o->min_bs[DDIR_WRITE];
+
+		/*
+		 * Verify interval must be smaller or equal to the
+		 * write size.
+		 */
+		if (o->verify_interval > o->min_bs[DDIR_WRITE])
+			o->verify_interval = o->min_bs[DDIR_WRITE];
+		else if (td_read(td) && o->verify_interval > o->min_bs[DDIR_READ])
+			o->verify_interval = o->min_bs[DDIR_READ];
 	}
 
 	if (o->pre_read) {
