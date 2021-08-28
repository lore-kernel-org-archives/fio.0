Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbhH1MBX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Aug 2021 08:01:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57223C061756
        for <fio@vger.kernel.org>; Sat, 28 Aug 2021 05:00:33 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJx0G-00FX7o-Bh
        for fio@vger.kernel.org; Sat, 28 Aug 2021 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210828120001.E471D1BC0128@kernel.dk>
Date: Sat, 28 Aug 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fd70e3619c00bc9f7b2f80cadf3fdb348cbacf51:

  io_uring: don't clear recently set sqe->rw_flags (2021-08-26 10:50:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 26976a134e44f583f91e05df95ef8ec5a9cc968d:

  t/io_uring: pretty up multi-file depths (2021-08-27 12:44:02 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: pretty up multi-file depths

 t/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 538cc7d4..607c7946 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -515,6 +515,7 @@ static int setup_ring(struct submitter *s)
 
 static void file_depths(char *buf)
 {
+	bool prev = false;
 	char *p;
 	int i, j;
 
@@ -526,10 +527,11 @@ static void file_depths(char *buf)
 		for (i = 0; i < s->nr_files; i++) {
 			struct file *f = &s->files[i];
 
-			if (i + 1 == s->nr_files)
-				p += sprintf(p, "%d", f->pending_ios);
+			if (prev)
+				p += sprintf(p, " %d", f->pending_ios);
 			else
-				p += sprintf(p, "%d, ", f->pending_ios);
+				p += sprintf(p, "%d ", f->pending_ios);
+			prev = true;
 		}
 	}
 }

