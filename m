Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/5] Include sg headers in os/os-linux.h
Date: Tue, 23 May 2017 21:44:48 +0300
Message-Id: <20170523184449.48134-5-tkusumi@tuxera.com>
In-Reply-To: <20170523184449.48134-1-tkusumi@tuxera.com>
References: <20170523184449.48134-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Since sg is Linux kernel's SCSI subsystem specific interface, it's
better to include required headers in os/os-linux.h which also defines
FIO_HAVE_SGIO, rather than conditionally including them in os/os.h.
Android has FIO_HAVE_SGIO disabled, so no need to do this for Android.

Even if another platform implements sg (compatible) ioctls within
their SCSI driver, there is no guarantee the required kernel header
will be "linux/fs.h", which then fails to compile.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-linux.h | 2 ++
 os/os.h       | 5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/os/os-linux.h b/os/os-linux.h
index ba53590..0e6246e 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -16,6 +16,8 @@
 #include <linux/unistd.h>
 #include <linux/raw.h>
 #include <linux/major.h>
+#include <linux/fs.h>
+#include <scsi/sg.h>
 
 #include "./os-linux-syscall.h"
 #include "binject.h"
diff --git a/os/os.h b/os/os.h
index 21b7a9d..3c96b4d 100644
--- a/os/os.h
+++ b/os/os.h
@@ -60,11 +60,6 @@ typedef struct aiocb os_aiocb_t;
 #endif
 #endif
 
-#ifdef FIO_HAVE_SGIO
-#include <linux/fs.h>
-#include <scsi/sg.h>
-#endif
-
 #ifndef CONFIG_STRSEP
 #include "../oslib/strsep.h"
 #endif
-- 
2.9.4


