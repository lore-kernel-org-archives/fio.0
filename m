Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH] os/os-dragonfly: sync with header file changes in upstream
Date: Wed, 11 Apr 2018 00:35:32 +0900
Message-Id: <1523374532-8629-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

IOCTLTRIM was moved and renamed to a different header file,
so conditionally include previous or current header depending on
__DragonFly_version.

Some details in below commit messages.
In short, they have had IOCTLTRIM in a wrong header, and they
decided to fix/change it since fio was the only application using
IOCTLTRIM within their userspace package collections.

<sys/ioctl_compat.h>: Add a reminder comment about IOCTLTRIM.
http://gitweb.dragonflybsd.org/dragonfly.git/commitdiff/7226e3530be4df743a5cfe61f602b0c4bd436ee9

Move the IOCTLTRIM ioctl to a better header and rename it to DAIOCTRIM.
http://gitweb.dragonflybsd.org/dragonfly.git/commitdiff/32506cfa691f80faa47486d6f94a98ae12387eeb

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 os/os-dragonfly.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 713046f..e80ad8c 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -10,10 +10,17 @@
 #include <sys/sysctl.h>
 #include <sys/statvfs.h>
 #include <sys/diskslice.h>
-#include <sys/ioctl_compat.h>
 #include <sys/usched.h>
 #include <sys/resource.h>
 
+/* API changed during "5.3 development" */
+#if __DragonFly_version < 500302
+#include <sys/ioctl_compat.h>
+#define DAIOCTRIM	IOCTLTRIM
+#else
+#include <bus/cam/scsi/scsi_daio.h>
+#endif
+
 #include "../file.h"
 #include "../lib/types.h"
 
@@ -222,7 +229,7 @@ static inline int os_trim(struct fio_file *f, unsigned long long start,
 	range[0] = start;
 	range[1] = len;
 
-	if (!ioctl(f->fd, IOCTLTRIM, range))
+	if (!ioctl(f->fd, DAIOCTRIM, range))
 		return 0;
 
 	return errno;
-- 
1.7.1


