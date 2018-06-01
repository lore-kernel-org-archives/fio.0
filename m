Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeFAMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Jun 2018 08:00:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fOijC-00024z-Lt
        for fio@vger.kernel.org; Fri, 01 Jun 2018 12:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180601120001.909502C00E1@kernel.dk>
Date: Fri,  1 Jun 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cf04b906fda16c6c14c420b71130a31d6580e9d8:

  Fix typo in bssplit documentation (2018-05-25 08:14:50 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 80f021501fda6a6244672bb89dd8221a61cee54b:

  io_u: ensure to invalidate cache on time_based random reads (2018-05-31 09:05:59 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      io_u: ensure to invalidate cache on time_based random reads

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 5b4c0df..945aa19 100644
--- a/io_u.c
+++ b/io_u.c
@@ -325,9 +325,9 @@ static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 	if (td->o.time_based ||
 	    (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM)) {
 		fio_file_reset(td, f);
+		loop_cache_invalidate(td, f);
 		if (!get_next_rand_offset(td, f, ddir, b))
 			return 0;
-		loop_cache_invalidate(td, f);
 	}
 
 	dprint(FD_IO, "%s: rand offset failed, last=%llu, size=%llu\n",
