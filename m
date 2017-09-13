Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53806 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdIMMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Sep 2017 08:00:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ds6L3-0005cS-JB
        for fio@vger.kernel.org; Wed, 13 Sep 2017 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170913120002.9185D2C0128@kernel.dk>
Date: Wed, 13 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c6fa271e32f08f35d7fc25272e77c0f7ee17bfec:

  Merge branch 'solaris-clock-setaffinity' of https://github.com/szaydel/fio (2017-09-11 14:26:01 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 956e60eade2bddb8aadfb54b58030e0b88fd03b2:

  io_u: fix trimming of mixed block size randommap (2017-09-12 14:02:34 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      io_u: fix trimming of mixed block size randommap

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index db043e4..e98cd31 100644
--- a/io_u.c
+++ b/io_u.c
@@ -37,7 +37,7 @@ static bool random_map_free(struct fio_file *f, const uint64_t block)
  */
 static void mark_random_map(struct thread_data *td, struct io_u *io_u)
 {
-	unsigned int min_bs = td->o.rw_min_bs;
+	unsigned int min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	unsigned int nr_blocks;
 	uint64_t block;
