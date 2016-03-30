Return-Path: <fio-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50073 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbcC3WXf (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Mar 2016 18:23:35 -0400
From: Jon Derrick <jonathan.derrick@intel.com>
Subject: [PATCH] fio: register pvsync2 engine correctly
Date: Wed, 30 Mar 2016 16:17:55 -0600
Message-Id: <1459376275-13194-1-git-send-email-jonathan.derrick@intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jon Derrick <jonathan.derrick@intel.com>

I'm experimenting with the new syscalls and noticed fio's support was
incomplete. This patch fixes some of those issues.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
---
Additionally, until libc catches up, I've hacked in:
#include <unistd.h>
#include <sys/syscall.h>
#define preadv2(...) syscall(SYS_preadv2, __VA_ARGS__)
#define pwritev2(...) syscall(SYS_pwritev2, __VA_ARGS__)

 engines/sync.c | 6 ++++++
 options.c      | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/engines/sync.c b/engines/sync.c
index 0b0d1a7..260ef66 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -453,6 +453,9 @@ static void fio_init fio_syncio_register(void)
 #ifdef CONFIG_PWRITEV
 	register_ioengine(&ioengine_pvrw);
 #endif
+#ifdef CONFIG_PWRITEV2
+	register_ioengine(&ioengine_pvrw2);
+#endif
 }
 
 static void fio_exit fio_syncio_unregister(void)
@@ -463,4 +466,7 @@ static void fio_exit fio_syncio_unregister(void)
 #ifdef CONFIG_PWRITEV
 	unregister_ioengine(&ioengine_pvrw);
 #endif
+#ifdef CONFIG_PWRITEV2
+	unregister_ioengine(&ioengine_pvrw2);
+#endif
 }
diff --git a/options.c b/options.c
index 062abb4..b6c980e 100644
--- a/options.c
+++ b/options.c
@@ -1471,7 +1471,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Use preadv/pwritev",
 			  },
 #endif
-#ifdef CONFIG_PWRITEV
+#ifdef CONFIG_PWRITEV2
 			  { .ival = "pvsync2",
 			    .help = "Use preadv2/pwritev2",
 			  },
-- 
2.5.0

