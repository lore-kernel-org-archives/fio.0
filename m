Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46862 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgCQMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Mar 2020 08:00:14 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEAtJ-0006J8-Rz
        for fio@vger.kernel.org; Tue, 17 Mar 2020 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200317120002.5AB711BC0F17@kernel.dk>
Date: Tue, 17 Mar 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dcdfc515ab7a245f9086c901a675a246e3b4db4e:

  Merge branch 'patch-1' of https://github.com/neheb/fio (2020-03-15 18:59:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5e8865c0e08861558c1253c521dc9098d0c773ee:

  t/io_uring: don't use *rand48_r() variants (2020-03-16 08:30:36 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: don't use *rand48_r() variants

 t/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index e84a2b6b..d48db1e9 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -63,7 +63,6 @@ struct file {
 struct submitter {
 	pthread_t thread;
 	int ring_fd;
-	struct drand48_data rand;
 	struct io_sq_ring sq_ring;
 	struct io_uring_sqe *sqes;
 	struct io_cq_ring cq_ring;
@@ -170,7 +169,7 @@ static void init_io(struct submitter *s, unsigned index)
 	}
 	f->pending_ios++;
 
-	lrand48_r(&s->rand, &r);
+	r = lrand48();
 	offset = (r % (f->max_blocks - 1)) * BS;
 
 	if (register_files) {
@@ -286,7 +285,7 @@ static void *submitter_fn(void *data)
 
 	printf("submitter=%d\n", gettid());
 
-	srand48_r(pthread_self(), &s->rand);
+	srand48(pthread_self());
 
 	prepped = 0;
 	do {

