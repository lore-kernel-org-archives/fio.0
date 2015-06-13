Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbFMMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 13 Jun 2015 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z3k6X-0007fR-4Z
	for fio@vger.kernel.org; Sat, 13 Jun 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150613120002.412B82C0069@kernel.dk>
Date: Sat, 13 Jun 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c08ad04c17e63c275ff477b21460ed6fa3b493f9:

  Rename get_fs_size() to get_fs_free_size() (2015-06-11 20:15:54 +0900)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1116dc04bec6df8f0857fceaf1cbf9032644e643:

  Enable FIO_HAVE_CHARDEV_SIZE on DragonFlyBSD (2015-06-12 23:16:26 +0900)

----------------------------------------------------------------
Tomohiro Kusumi (1):
      Enable FIO_HAVE_CHARDEV_SIZE on DragonFlyBSD

 os/os-dragonfly.h | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 2a2b198..b67c660 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -8,14 +8,15 @@
 #include <sys/param.h>
 #include <sys/sysctl.h>
 #include <sys/statvfs.h>
+#include <sys/diskslice.h>
 
 #include "../file.h"
 
 #define FIO_HAVE_ODIRECT
-#define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
+#define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_GETTID
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
@@ -32,6 +33,24 @@
 
 typedef off_t off64_t;
 
+static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
+{
+	struct partinfo pi;
+
+	if (!ioctl(f->fd, DIOCGPART, &pi)) {
+		*bytes = (unsigned long long) pi.media_size;
+		return 0;
+	}
+
+	*bytes = 0;
+	return errno;
+}
+
+static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
+{
+	return blockdev_size(f, bytes);
+}
+
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
 	return EINVAL;
