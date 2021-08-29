Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbhH2MA7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Aug 2021 08:00:59 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD77BC061575
        for <fio@vger.kernel.org>; Sun, 29 Aug 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKJTp-00E7kI-G3
        for fio@vger.kernel.org; Sun, 29 Aug 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210829120001.7B2BC1BC013A@kernel.dk>
Date: Sun, 29 Aug 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 26976a134e44f583f91e05df95ef8ec5a9cc968d:

  t/io_uring: pretty up multi-file depths (2021-08-27 12:44:02 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4f2152278e0b3c35ded02fb3e6fb550eab7bedcd:

  t/io_uring: further simplify inflight tracking (2021-08-28 15:37:25 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: further simplify inflight tracking

 t/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 607c7946..3130e469 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -530,7 +530,7 @@ static void file_depths(char *buf)
 			if (prev)
 				p += sprintf(p, " %d", f->pending_ios);
 			else
-				p += sprintf(p, "%d ", f->pending_ios);
+				p += sprintf(p, "%d", f->pending_ios);
 			prev = true;
 		}
 	}
@@ -708,9 +708,8 @@ int main(int argc, char *argv[])
 		} else
 			rpc = ipc = -1;
 		file_depths(fdepths);
-		printf("IOPS=%lu, IOS/call=%ld/%ld, inflight=%u (%s)\n",
-				this_done - done, rpc, ipc, s->inflight,
-				fdepths);
+		printf("IOPS=%lu, IOS/call=%ld/%ld, inflight=(%s)\n",
+				this_done - done, rpc, ipc, fdepths);
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;

