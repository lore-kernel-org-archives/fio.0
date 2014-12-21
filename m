Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58443 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaLUNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 21 Dec 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y2g7A-0003SS-Vq
	for fio@vger.kernel.org; Sun, 21 Dec 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141221130003.9607D40183@lyth.info>
Date: Sun, 21 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8a2b393b00dc4b6a8ba129a0e7850a78114ac75e:

  gettime: hide fio_gtod_cpumask if not used (2014-12-19 15:04:10 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b04f590551050b23768a3969d47371d363aa8745:

  Fix default scrambling of buffers (2014-12-20 14:44:45 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fix default scrambling of buffers

 init.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 427768c..d3dec0a 100644
--- a/init.c
+++ b/init.c
@@ -933,12 +933,16 @@ static void init_flags(struct thread_data *td)
 	if (o->refill_buffers)
 		td->flags |= TD_F_REFILL_BUFFERS;
 	/*
-	 * Scramble by default, but not if zero_buffer is true and has been
-	 * set. But if scramble_buffers has been set, always scramble.
+	 * Always scramble buffers if asked to
 	 */
-	if (o->scramble_buffers && ((!o->zero_buffers &&
-	    fio_option_is_set(o, zero_buffers)) ||
-	    fio_option_is_set(o, scramble_buffers)))
+	if (o->scramble_buffers && fio_option_is_set(o, scramble_buffers))
+		td->flags |= TD_F_SCRAMBLE_BUFFERS;
+	/*
+	 * But also scramble buffers, unless we were explicitly asked
+	 * to zero them.
+	 */
+	if (o->scramble_buffers && !(o->zero_buffers &&
+	    fio_option_is_set(o, zero_buffers)))
 		td->flags |= TD_F_SCRAMBLE_BUFFERS;
 	if (o->verify != VERIFY_NONE)
 		td->flags |= TD_F_VER_NONE;
