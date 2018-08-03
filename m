Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55448 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbeHCN4U (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Aug 2018 09:56:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1flYkm-0001Se-1c
        for fio@vger.kernel.org; Fri, 03 Aug 2018 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180803120002.890572C030F@kernel.dk>
Date: Fri,  3 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 284226f333be2fb7d859287fd3ab3c51b3636a92:

  Merge branch 'fio-histo-fix' of https://github.com/parallel-fs-utils/fio (2018-07-30 08:24:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 17924179519397e49a7a82fd99d860f9ef077645:

  Merge branch 'szaydel/solaris-Wincompatible-pointer-types' of https://github.com/szaydel/fio (2018-08-02 16:20:24 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'szaydel/solaris-Wincompatible-pointer-types' of https://github.com/szaydel/fio

Sam Zaydel (1):
      Fix incompatible pointer types warning on Solaris with gcc 6.4

 engines/solarisaio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/solarisaio.c b/engines/solarisaio.c
index 151f31d..21e9593 100644
--- a/engines/solarisaio.c
+++ b/engines/solarisaio.c
@@ -105,7 +105,7 @@ static struct io_u *fio_solarisaio_event(struct thread_data *td, int event)
 	return sd->aio_events[event];
 }
 
-static int fio_solarisaio_queue(struct thread_data fio_unused *td,
+static enum fio_q_status fio_solarisaio_queue(struct thread_data fio_unused *td,
 			      struct io_u *io_u)
 {
 	struct solarisaio_data *sd = td->io_ops_data;
