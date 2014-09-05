Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaIEMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Sep 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XPsBQ-0002U1-NT
	for fio@vger.kernel.org; Fri, 05 Sep 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140905120003.26C20401E5@lyth.info>
Date: Fri,  5 Sep 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9a4424c81b146b9a08b105af9e53d8435e888cd1:

  Fix crash in client with NULL hostname (2014-08-22 17:16:44 -0500)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5fb4b36674b194ae6c6756314dc0c665fcaea06d:

  Fix hangs due to iodepth_low (2014-09-04 13:51:05 -0600)

----------------------------------------------------------------
Robert Elliott (1):
      Fix hangs due to iodepth_low

 io_u.c |    2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index ba192a3..be2f242 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1792,6 +1792,8 @@ int io_u_queued_complete(struct thread_data *td, int min_evts,
 
 	if (!min_evts)
 		tvp = &ts;
+	else if (min_evts > td->cur_depth)
+		min_evts = td->cur_depth;
 
 	ret = td_io_getevents(td, min_evts, td->o.iodepth_batch_complete, tvp);
 	if (ret < 0) {
