Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51548 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbdGKMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jul 2017 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dUtpj-0003gR-V9
        for fio@vger.kernel.org; Tue, 11 Jul 2017 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170711120002.38D442C0098@kernel.dk>
Date: Tue, 11 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6210cf66316e25498ab2e445731b3bb6b886c363:

  Fio 2.99 (2017-07-07 12:45:04 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ef2f4a50c25b3315d8825eb5e6fdfd6d57a47b74:

  return correct error code for unhandled addr. (2017-07-11 00:28:45 +0800)

----------------------------------------------------------------
Pan Liu (1):
      return correct error code for unhandled addr.

 engines/rbd.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index 4bae425..5b51a39 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -517,6 +517,7 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 	} else {
 		dprint(FD_IO, "%s: Warning: unhandled ddir: %d\n", __func__,
 		       io_u->ddir);
+		r = -EINVAL;
 		goto failed_comp;
 	}
 
