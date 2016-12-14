Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34639 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755636AbcLNNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Dec 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cH9AA-0008AB-Te
        for fio@vger.kernel.org; Wed, 14 Dec 2016 13:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161214130001.BB3C82C029F@kernel.dk>
Date: Wed, 14 Dec 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a79f17bf3bfa20b83424c2301de092bdcfbaaea4:

  iolog: add support for replay_scale option (2016-12-12 22:23:28 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 13e0f06b805eb0bb3a100ed710c7da18684c8950:

  Change misleading error message for invalid size= value (2016-12-13 09:32:59 -0700)

----------------------------------------------------------------
Jakub Sitnicki (1):
      Change misleading error message for invalid size= value

 init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 382fa1f..36feb51 100644
--- a/init.c
+++ b/init.c
@@ -822,7 +822,8 @@ static int fixup_options(struct thread_data *td)
 	 * If size is set but less than the min block size, complain
 	 */
 	if (o->size && o->size < td_min_bs(td)) {
-		log_err("fio: size too small, must be larger than the IO size: %llu\n", (unsigned long long) o->size);
+		log_err("fio: size too small, must not be less than minimum block size: %llu < %u\n",
+			(unsigned long long) o->size, td_min_bs(td));
 		ret = 1;
 	}
 
