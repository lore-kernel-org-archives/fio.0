Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936481AbcJ0NvL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2016 09:51:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bzjLm-0001oJ-VW
        for fio@vger.kernel.org; Thu, 27 Oct 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161027120001.CECC32C1A72@kernel.dk>
Date: Thu, 27 Oct 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a0290964d9e15aa9faa5a139effc14cfa5bcd3f1:

  Fio 2.15 (2016-10-25 12:38:13 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a955f5297d6951517c663ac9effd94adfae6a563:

  Add blockdev_size() support for OpenBSD (2016-10-26 08:00:10 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (2):
      Add blockdev_size() support for NetBSD
      Add blockdev_size() support for OpenBSD

 os/os-netbsd.h  | 17 ++++++++++++++++-
 os/os-openbsd.h | 17 ++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 1ef5866..2133d7a 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -7,6 +7,9 @@
 #include <lwp.h>
 #include <sys/param.h>
 #include <sys/statvfs.h>
+#include <sys/ioctl.h>
+#include <sys/dkio.h>
+#include <sys/disklabel.h>
 /* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
 #define	rb_node	_rb_node
 #include <sys/sysctl.h>
@@ -17,7 +20,6 @@
 #include "../file.h"
 
 #define FIO_HAVE_ODIRECT
-#define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
@@ -37,6 +39,19 @@
 
 typedef off_t off64_t;
 
+static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
+{
+	struct disklabel dl;
+
+	if (!ioctl(f->fd, DIOCGDINFO, &dl)) {
+		*bytes = ((unsigned long long)dl.d_secperunit) * dl.d_secsize;
+		return 0;
+	}
+
+	*bytes = 0;
+	return errno;
+}
+
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
 	return EINVAL;
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 2998510..3343cbd 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -6,6 +6,9 @@
 #include <errno.h>
 #include <sys/param.h>
 #include <sys/statvfs.h>
+#include <sys/ioctl.h>
+#include <sys/dkio.h>
+#include <sys/disklabel.h>
 /* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #include <sys/sysctl.h>
 #undef RB_BLACK
@@ -15,7 +18,6 @@
 #include "../file.h"
 
 #undef  FIO_HAVE_ODIRECT
-#define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
@@ -35,6 +37,19 @@
 
 typedef off_t off64_t;
 
+static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
+{
+	struct disklabel dl;
+
+	if (!ioctl(f->fd, DIOCGDINFO, &dl)) {
+		*bytes = ((unsigned long long)dl.d_secperunit) * dl.d_secsize;
+		return 0;
+	}
+
+	*bytes = 0;
+	return errno;
+}
+
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
 	return EINVAL;
