Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbbEaMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 31 May 2015 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Yz1uN-0003uK-NA
	for fio@vger.kernel.org; Sun, 31 May 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150531120002.32D2F2C00FF@kernel.dk>
Date: Sun, 31 May 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 37fbd7e9dd4f041b858507b3db06753614083770:

  filesetup: print warning if chosen random generator can't cover range (2015-05-29 19:40:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ec4dde5948a52c5bf8dcfe3b1c43912ddef2538e:

  rdma: adapt to new init_rand_seed() (2015-05-30 13:04:33 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      rdma: adapt to new init_rand_seed()

 engines/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/rdma.c b/engines/rdma.c
index 5081202..c59d5dd 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -1202,7 +1202,7 @@ static int fio_rdmaio_setup(struct thread_data *td)
 		rd = malloc(sizeof(*rd));
 
 		memset(rd, 0, sizeof(*rd));
-		init_rand_seed(&rd->rand_state, (unsigned int) GOLDEN_RATIO_PRIME);
+		init_rand_seed(&rd->rand_state, (unsigned int) GOLDEN_RATIO_PRIME, 0);
 		td->io_ops->data = rd;
 	}
 
