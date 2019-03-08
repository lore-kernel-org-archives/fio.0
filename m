Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45482 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfCHNH6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Mar 2019 08:07:58 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h2FEC-0005Mj-Sj
        for fio@vger.kernel.org; Fri, 08 Mar 2019 13:07:56 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190308130002.55F062C0049@kernel.dk>
Date: Fri,  8 Mar 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit be26a9823261c15c6e737e2e6c8762423cf325b8:

  t/io_uring: stop when max number of files is reached (2019-03-06 08:24:38 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 44364a9937d01825557f4a7d78c6f153886e1115:

  engines/skeleton_external: update gcc incantation (2019-03-07 16:54:54 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      engines/skeleton_external: update gcc incantation

 engines/skeleton_external.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 21a36018..1b6625b2 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -3,7 +3,7 @@
  *
  * Should be compiled with:
  *
- * gcc -Wall -O2 -g -shared -rdynamic -fPIC -o skeleton_external.o skeleton_external.c
+ * gcc -Wall -O2 -g -D_GNU_SOURCE -include ../config-host.h -shared -rdynamic -fPIC -o skeleton_external.o skeleton_external.c
  * (also requires -D_GNU_SOURCE -DCONFIG_STRSEP on Linux)
  *
  */

