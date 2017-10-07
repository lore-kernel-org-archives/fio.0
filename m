Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47841 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbdJGMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Oct 2017 08:00:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e0nmD-0002Vy-CK
        for fio@vger.kernel.org; Sat, 07 Oct 2017 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171007120001.CF4E42C0111@kernel.dk>
Date: Sat,  7 Oct 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e6fe02651641fc64d2fa4fcfe9b1013b2947d11b:

  Merge branch 'master' of https://github.com/dyniusz/fio (2017-10-03 11:19:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f7c9bfd57232c6e11623d741be340d32f796c726:

  backend: don't complain about no IO done for create_only=1 (2017-10-06 11:41:47 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      backend: don't complain about no IO done for create_only=1

 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index b1995ef..ba6f585 100644
--- a/backend.c
+++ b/backend.c
@@ -1833,7 +1833,7 @@ static void *thread_main(void *data)
 	 * (Are we not missing other flags that can be ignored ?)
 	 */
 	if ((td->o.size || td->o.io_size) && !ddir_rw_sum(bytes_done) &&
-	    !did_some_io &&
+	    !did_some_io && !td->o.create_only &&
 	    !(td_ioengine_flagged(td, FIO_NOIO) ||
 	      td_ioengine_flagged(td, FIO_DISKLESSIO)))
 		log_err("%s: No I/O performed by %s, "
