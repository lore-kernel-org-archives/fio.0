Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbeLENAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Dec 2018 08:00:15 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUWmk-0001LB-Ey
        for fio@vger.kernel.org; Wed, 05 Dec 2018 13:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181205130002.8C2162C00B0@kernel.dk>
Date: Wed,  5 Dec 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6f3a2c116481731abdf2fbed2d0f63cf4d3ddca2:

  engines/libaio: set IOCB_HIPRI if we are polling (2018-12-01 10:17:26 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 46961748140e291f0f1e966bac9aad1a3b9ad1c7:

  engines/libaio: increase RLIMIT_MEMLOCK for user buffers (2018-12-04 11:27:02 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      engines/libaio: update for newer io_setup2() system call
      engines/libaio: increase RLIMIT_MEMLOCK for user buffers

 engines/libaio.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libaio.c b/engines/libaio.c
index a780b2b..0333509 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -8,6 +8,8 @@
 #include <unistd.h>
 #include <errno.h>
 #include <libaio.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 
 #include "../fio.h"
 #include "../lib/pow2.h"
@@ -450,11 +452,18 @@ static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
 		flags |= IOCTX_FLAG_IOPOLL;
 	if (useriocb)
 		flags |= IOCTX_FLAG_USERIOCB;
-	if (fixedbufs)
+	if (fixedbufs) {
+		struct rlimit rlim = {
+			.rlim_cur = RLIM_INFINITY,
+			.rlim_max = RLIM_INFINITY,
+		};
+
+		setrlimit(RLIMIT_MEMLOCK, &rlim);
 		flags |= IOCTX_FLAG_FIXEDBUFS;
+	}
 
 	ret = syscall(__NR_sys_io_setup2, depth, flags, ld->user_iocbs,
-			&ld->aio_ctx);
+			NULL, NULL, &ld->aio_ctx);
 	if (!ret)
 		return 0;
 	/* fall through to old syscall */

