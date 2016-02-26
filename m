Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbcBZNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Feb 2016 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aZI04-0007pr-Ca
	for fio@vger.kernel.org; Fri, 26 Feb 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160226130002.10BEF2C1369@kernel.dk>
Date: Fri, 26 Feb 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a6cb85e25b31553aab043fe763ce4c999197dcff:

  Allow IO engine driven allocations of IO structures (2016-02-24 16:29:08 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e6727cbdd34a6ec30b437311724a6aa60e6b06fd:

  ioengines: account any queued IO on the engine side (2016-02-25 12:24:47 -0800)

----------------------------------------------------------------
Jens Axboe (2):
      backend: ensure that fio_io_sync() commits IN on queued status
      ioengines: account any queued IO on the engine side

 backend.c   | 2 ++
 ioengines.c | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index fd81849..6083a51 100644
--- a/backend.c
+++ b/backend.c
@@ -309,6 +309,8 @@ requeue:
 		put_io_u(td, io_u);
 		return true;
 	} else if (ret == FIO_Q_QUEUED) {
+		if (td_io_commit(td))
+			return true;
 		if (io_u_queued_complete(td, 1) < 0)
 			return true;
 	} else if (ret == FIO_Q_COMPLETED) {
diff --git a/ioengines.c b/ioengines.c
index decc9cb..b89a121 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -342,10 +342,10 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	} else if (ret == FIO_Q_QUEUED) {
 		int r;
 
-		if (ddir_rw(io_u->ddir)) {
-			td->io_u_queued++;
+		td->io_u_queued++;
+
+		if (ddir_rw(io_u->ddir))
 			td->ts.total_io_u[io_u->ddir]++;
-		}
 
 		if (td->io_u_queued >= td->o.iodepth_batch) {
 			r = td_io_commit(td);
