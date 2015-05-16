Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbbEPMAL (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 16 May 2015 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YtalF-0001LL-Jk
	for fio@vger.kernel.org; Sat, 16 May 2015 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150516120001.A5DEC2C1079@kernel.dk>
Date: Sat, 16 May 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3e55d40fb5a68773b07cebb4a74870338eab81d4:

  Change (blank)cpu affinity macros to inline functions (2015-05-15 05:18:23 +0900)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fcb6b3ef8c606b60511c9c72a908e45f4cbd607b:

  Merge branch 'req4' of git://github.com/kusumi/fio (2015-05-15 20:13:58 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'req4' of git://github.com/kusumi/fio

Tomohiro Kusumi (2):
      Cleanup DragonFlyBSD support
      Add missing fio_mutex_up() on return

 flow.c            | 1 +
 os/os-dragonfly.h | 5 -----
 2 files changed, 1 insertion(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/flow.c b/flow.c
index f9d868d..e0ac135 100644
--- a/flow.c
+++ b/flow.c
@@ -59,6 +59,7 @@ static struct fio_flow *flow_get(unsigned int id)
 		flow = smalloc(sizeof(*flow));
 		if (!flow) {
 			log_err("fio: smalloc pool exhausted\n");
+			fio_mutex_up(flow_lock);
 			return NULL;
 		}
 		flow->refs = 0;
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index cc3de31..bc855ba 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -5,12 +5,7 @@
 
 #include <errno.h>
 #include <sys/param.h>
-/* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
-#define	rb_node	_rb_node
 #include <sys/sysctl.h>
-#undef rb_node
-#undef rb_left
-#undef rb_right
 
 #include "../file.h"
 
