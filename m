Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46336 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaKXNAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 24 Nov 2014 08:00:08 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XstFP-0002mk-1C
	for fio@vger.kernel.org; Mon, 24 Nov 2014 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141124130003.2440440408@lyth.info>
Date: Mon, 24 Nov 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit df8fb6097058098f1c2f7c2cf4019640561768df:

  iolog: account for wasted time in ipo stall (2014-11-21 14:33:33 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6f49f8bc80fbeff3d24cf84278d2611db0ec6f6c:

  lfsr: don't pass in last value to lfsr_next() (2014-11-23 18:41:11 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      lfsr: don't pass in last value to lfsr_next()

 io_u.c     |   14 ++++++++------
 lib/lfsr.c |    2 +-
 lib/lfsr.h |    2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index c51982d..33c82f2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -83,13 +83,15 @@ struct rand_off {
 static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 				  enum fio_ddir ddir, uint64_t *b)
 {
-	uint64_t r, lastb;
-
-	lastb = last_block(td, f, ddir);
-	if (!lastb)
-		return 1;
+	uint64_t r;
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE) {
+		uint64_t lastb;
+
+		lastb = last_block(td, f, ddir);
+		if (!lastb)
+			return 1;
+
 		r = __rand(&td->random_state);
 
 		dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
@@ -98,7 +100,7 @@ static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 	} else {
 		uint64_t off = 0;
 
-		if (lfsr_next(&f->lfsr, &off, lastb))
+		if (lfsr_next(&f->lfsr, &off))
 			return 1;
 
 		*b = off;
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 9fff50d..0c0072c 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -124,7 +124,7 @@ static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
  * c. Check if the calculated value exceeds the desirable range. In this case,
  *    go back to b, else return.
  */
-int lfsr_next(struct fio_lfsr *fl, uint64_t *off, uint64_t last)
+int lfsr_next(struct fio_lfsr *fl, uint64_t *off)
 {
 	if (fl->num_vals++ > fl->max_val)
 		return 1;
diff --git a/lib/lfsr.h b/lib/lfsr.h
index 187abf2..c2d5569 100644
--- a/lib/lfsr.h
+++ b/lib/lfsr.h
@@ -22,7 +22,7 @@ struct fio_lfsr {
 	unsigned int spin;
 };
 
-int lfsr_next(struct fio_lfsr *fl, uint64_t *off, uint64_t);
+int lfsr_next(struct fio_lfsr *fl, uint64_t *off);
 int lfsr_init(struct fio_lfsr *fl, uint64_t size,
 		unsigned long seed, unsigned int spin);
 int lfsr_reset(struct fio_lfsr *fl, unsigned long seed);
