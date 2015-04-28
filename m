Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345AbbD1L7z (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Apr 2015 07:59:55 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Yn4B9-00075T-1X
	for fio@vger.kernel.org; Tue, 28 Apr 2015 11:59:55 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150428120001.A15FB2C01AF@kernel.dk>
Date: Tue, 28 Apr 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7c306bb1d27de928cba1b58d7888981d44416fd1:

  io_u: fix bug in rounding of generated buffer length (2015-04-24 10:41:58 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9451b93e81fb950a80da09e295e56b1ad4538509:

  dedupe: improve 100% dedupe case (2015-04-27 09:37:11 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      dedupe: fix dedupe_percentage=100
      dedupe: improve 100% dedupe case

 io_u.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 5064485..d00e6e3 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1896,8 +1896,10 @@ static struct frand_state *get_buf_state(struct thread_data *td)
 
 	if (!td->o.dedupe_percentage)
 		return &td->buf_state;
-	else if (td->o.dedupe_percentage == 100)
-		return &td->buf_state_prev;
+	else if (td->o.dedupe_percentage == 100) {
+		frand_copy(&td->buf_state_prev, &td->buf_state);
+		return &td->buf_state;
+	}
 
 	r = __rand(&td->dedupe_state);
 	v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
@@ -1910,7 +1912,9 @@ static struct frand_state *get_buf_state(struct thread_data *td)
 
 static void save_buf_state(struct thread_data *td, struct frand_state *rs)
 {
-	if (rs == &td->buf_state)
+	if (td->o.dedupe_percentage == 100)
+		frand_copy(rs, &td->buf_state_prev);
+	else if (rs == &td->buf_state)
 		frand_copy(&td->buf_state_prev, rs);
 }
 
