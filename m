Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbbGJMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Jul 2015 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZDWyO-0000Ve-Rj
	for fio@vger.kernel.org; Fri, 10 Jul 2015 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150710120002.0A8412C005F@kernel.dk>
Date: Fri, 10 Jul 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 59d8f4125b0871cc26ad60150bcf4cd29f7daac7:

  configure: don't be so eager to overwrite an existing Makefile (2015-07-08 13:50:35 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fd727d9de9f22a7ad3e026bcca80f58a65410ad6:

  verify: fix bad 'from_verify' setting in do_io() (2015-07-09 13:13:43 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      verify: fix bad 'from_verify' setting in do_io()

 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 6989407..3eafff6 100644
--- a/backend.c
+++ b/backend.c
@@ -894,7 +894,7 @@ static uint64_t do_io(struct thread_data *td)
 		} else {
 			ret = td_io_queue(td, io_u);
 
-			if (io_queue_event(td, io_u, &ret, ddir, &bytes_issued, 1, &comp_time))
+			if (io_queue_event(td, io_u, &ret, ddir, &bytes_issued, 0, &comp_time))
 				break;
 
 			/*
