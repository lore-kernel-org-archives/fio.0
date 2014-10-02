Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJBMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Oct 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XZf3F-00087r-DY
	for fio@vger.kernel.org; Thu, 02 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141002120003.7FF564016A@lyth.info>
Date: Thu,  2 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a120ca7f793b41532b04e3915fcd6646fa37bb4f:

  engines/libaio: don't reap on EAGAIN and no pending events (2014-09-30 20:28:45 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e3b4e568b362ec8d89243609e75763b37cf81b17:

  engines/libaio: reset 'wait_start' on non-EAGAIN (2014-10-01 08:48:54 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      engines/libaio: fix submit loop to use 'ld->queued' for exit
      Bump IO engine version number
      engines/libaio: reset 'wait_start' on non-EAGAIN

 engines/libaio.c |    4 +++-
 ioengine.h       |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libaio.c b/engines/libaio.c
index ca7bfde..31c850e 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -255,9 +255,11 @@ static int fio_libaio_commit(struct thread_data *td)
 			ld->queued -= ret;
 			ring_inc(ld, &ld->tail, ret);
 			ret = 0;
+			wait_start = 0;
 		} else if (ret == -EINTR || !ret) {
 			if (!ret)
 				io_u_mark_submit(td, ret);
+			wait_start = 0;
 			continue;
 		} else if (ret == -EAGAIN) {
 			/*
@@ -283,7 +285,7 @@ static int fio_libaio_commit(struct thread_data *td)
 			continue;
 		} else
 			break;
-	} while (ld->head != ld->tail);
+	} while (ld->queued);
 
 	return ret;
 }
diff --git a/ioengine.h b/ioengine.h
index dfe84ac..85923fc 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -15,7 +15,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	20
+#define FIO_IOOPS_VERSION	21
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
