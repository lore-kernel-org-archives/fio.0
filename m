Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38710 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbCTMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Mar 2015 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YYvav-0005Xe-KY
	for fio@vger.kernel.org; Fri, 20 Mar 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150320120002.F3CFD401E2@lyth.info>
Date: Fri, 20 Mar 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d8f1f7d4ef536ea04a6a5fbd0399d46f69ff4e60:

  Pack io_u/fio_file (2015-03-18 16:17:41 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6fb1bda0d0b61e2433f9ef34b4b979b2642d8706:

  io_u_queue: add debug assert check on adding too many elements (2015-03-19 22:25:35 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      io_u_queue: add debug assert check on adding too many elements

 io_u_queue.c |    1 +
 io_u_queue.h |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u_queue.c b/io_u_queue.c
index 80a32ba..9994c78 100644
--- a/io_u_queue.c
+++ b/io_u_queue.c
@@ -8,6 +8,7 @@ int io_u_qinit(struct io_u_queue *q, unsigned int nr)
 		return 1;
 
 	q->nr = 0;
+	q->max = nr;
 	return 0;
 }
 
diff --git a/io_u_queue.h b/io_u_queue.h
index bda40d5..118e593 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -8,6 +8,7 @@ struct io_u;
 struct io_u_queue {
 	struct io_u **io_us;
 	unsigned int nr;
+	unsigned int max;
 };
 
 static inline struct io_u *io_u_qpop(struct io_u_queue *q)
@@ -25,7 +26,12 @@ static inline struct io_u *io_u_qpop(struct io_u_queue *q)
 
 static inline void io_u_qpush(struct io_u_queue *q, struct io_u *io_u)
 {
-	q->io_us[q->nr++] = io_u;
+	if (q->nr < q->max) {
+		q->io_us[q->nr++] = io_u;
+		return;
+	}
+
+	assert(0);
 }
 
 static inline int io_u_qempty(const struct io_u_queue *q)
