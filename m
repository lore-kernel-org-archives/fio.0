Return-Path: <fio-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:57737 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbcCSMAr (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 19 Mar 2016 08:00:47 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ahFY2-0003rb-R7
	for fio@vger.kernel.org; Sat, 19 Mar 2016 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160319120002.492A82C0114@kernel.dk>
Date: Sat, 19 Mar 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a7ef38c4f0bb5ff11f46968e7fa5fa9a54c16de0:

  Fio 2.8 (2016-03-15 09:10:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 87a0ea3b58ef3d126148cb0279e015177ef9c62f:

  init: seed repeatable jobs differently (2016-03-18 09:07:16 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      init: seed repeatable jobs differently

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 9052add..cc33bf0 100644
--- a/init.c
+++ b/init.c
@@ -1079,7 +1079,7 @@ static int setup_random_seeds(struct thread_data *td)
 		seed *= 0x9e370001UL;
 
 	for (i = 0; i < FIO_RAND_NR_OFFS; i++) {
-		td->rand_seeds[i] = seed;
+		td->rand_seeds[i] = seed * td->thread_number + i;
 		seed *= 0x9e370001UL;
 	}
 
