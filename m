Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbIIMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Sep 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZZe2n-0007WG-6Z
	for fio@vger.kernel.org; Wed, 09 Sep 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150909120001.BFDB62C00B4@kernel.dk>
Date: Wed,  9 Sep 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b638d82f882bd8c15cc933ee0b8fa684308e7855:

  verify: move meta header to generic verify_header (2015-09-05 16:24:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 736a50cd7d04e510d0a104316a6b4a3a5bcc43f6:

  workqueue: Ensure submission offload worker inherits parent's options (2015-09-08 09:10:55 -0600)

----------------------------------------------------------------
Andrey Kuzmin (1):
      workqueue: Ensure submission offload worker inherits parent's options

 workqueue.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/workqueue.c b/workqueue.c
index e236516..60e6ab2 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -162,6 +162,7 @@ static int init_submit_worker(struct submit_worker *sw)
 	memcpy(&td->ts, &parent->ts, sizeof(td->ts));
 	td->o.uid = td->o.gid = -1U;
 	dup_files(td, parent);
+	td->eo = parent->eo;
 	fio_options_mem_dupe(td);
 
 	if (ioengine_load(td))
