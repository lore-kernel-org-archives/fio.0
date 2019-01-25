Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45290 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfAYNIY (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 25 Jan 2019 08:08:24 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gn1Dc-0003Vk-Fv
        for fio@vger.kernel.org; Fri, 25 Jan 2019 13:08:24 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190125130002.466462C0199@kernel.dk>
Date: Fri, 25 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 63ed82548f4489b4c6d5df688f7405b9eb20ddc9:

  io_uring: system calls have been renumbered (2019-01-23 08:04:28 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4c085cf20f5c0d083aca18680c4323a1fb2b7a1f:

  rate-submit: call ioengine post_init when starting workers (2019-01-24 13:58:00 -0700)

----------------------------------------------------------------
Vincent Fu (1):
      rate-submit: call ioengine post_init when starting workers

 rate-submit.c | 3 +++
 1 file changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/rate-submit.c b/rate-submit.c
index b07a2072..cf00d9bc 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -165,6 +165,9 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	if (td_io_init(td))
 		goto err_io_init;
 
+	if (td->io_ops->post_init && td->io_ops->post_init(td))
+		goto err_io_init;
+
 	set_epoch_time(td, td->o.log_unix_epoch);
 	fio_getrusage(&td->ru_start);
 	clear_io_state(td, 1);

