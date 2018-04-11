Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45992 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbeDKMAX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Apr 2018 08:00:23 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f6EQJ-0003gd-7B
        for fio@vger.kernel.org; Wed, 11 Apr 2018 12:00:23 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180411120002.09F222C0079@kernel.dk>
Date: Wed, 11 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cb73748b9af3d678eb6ad0af7b9cea5a2ea1999e:

  stat: remove dead 'nr_uninit' assignment (2018-04-09 08:10:40 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4fe721ac83e84df7c6be07394d1963fd1ec5d9a6:

  os/os-dragonfly: sync with header file changes in upstream (2018-04-10 09:17:22 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (1):
      os/os-dragonfly: sync with header file changes in upstream

 os/os-dragonfly.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

---

Diff of recent changes:

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
