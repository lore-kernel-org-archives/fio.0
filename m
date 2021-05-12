Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhELMBP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 May 2021 08:01:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8F8C061574
        for <fio@vger.kernel.org>; Wed, 12 May 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgnX3-002fbH-5g
        for fio@vger.kernel.org; Wed, 12 May 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210512120002.6BF8E1BC0119@kernel.dk>
Date: Wed, 12 May 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit afa2cfb29b6c28b55d19f71f59287e43ecba80dd:

  Merge branch 'z_unit_docs' of https://github.com/ahribeng/fio (2021-05-10 21:16:58 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 30bec59eab3908b681cbc2866179f7166a849c83:

  os: define EDQUOT to EIO if the OS doesn't provide it (2021-05-11 07:58:03 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      os: define EDQUOT to EIO if the OS doesn't provide it

Martin Bukatovic (1):
      Make fill_device to stop writing on EDQUOT

 HOWTO       |  3 ++-
 backend.c   |  7 ++++---
 filesetup.c | 11 ++++++++---
 fio.1       |  3 ++-
 os/os.h     |  5 +++++
 5 files changed, 21 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 177310f6..f5681c0d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1858,7 +1858,8 @@ I/O size
 .. option:: fill_device=bool, fill_fs=bool
 
 	Sets size to something really large and waits for ENOSPC (no space left on
-	device) as the terminating condition. Only makes sense with sequential
+	device) or EDQUOT (disk quota exceeded)
+	as the terminating condition. Only makes sense with sequential
 	write. For a read workload, the mount point will be filled first then I/O
 	started on the result. This option doesn't make sense if operating on a raw
 	device node, since the size of that is already known by the file system.
diff --git a/backend.c b/backend.c
index 399c299e..6290e0d6 100644
--- a/backend.c
+++ b/backend.c
@@ -393,7 +393,7 @@ static bool break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 			td_clear_error(td);
 			*retptr = 0;
 			return false;
-		} else if (td->o.fill_device && err == ENOSPC) {
+		} else if (td->o.fill_device && (err == ENOSPC || err == EDQUOT)) {
 			/*
 			 * We expect to hit this error if
 			 * fill_device option is set.
@@ -1105,7 +1105,7 @@ reap:
 	if (td->trim_entries)
 		log_err("fio: %lu trim entries leaked?\n", td->trim_entries);
 
-	if (td->o.fill_device && td->error == ENOSPC) {
+	if (td->o.fill_device && (td->error == ENOSPC || td->error == EDQUOT)) {
 		td->error = 0;
 		fio_mark_td_terminate(td);
 	}
@@ -1120,7 +1120,8 @@ reap:
 
 		if (i) {
 			ret = io_u_queued_complete(td, i);
-			if (td->o.fill_device && td->error == ENOSPC)
+			if (td->o.fill_device &&
+			    (td->error == ENOSPC || td->error == EDQUOT))
 				td->error = 0;
 		}
 
diff --git a/filesetup.c b/filesetup.c
index e664f8b4..296de5a1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -226,11 +226,16 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			if (r < 0) {
 				int __e = errno;
 
-				if (__e == ENOSPC) {
+				if (__e == ENOSPC || __e == EDQUOT) {
+					const char *__e_name;
 					if (td->o.fill_device)
 						break;
-					log_info("fio: ENOSPC on laying out "
-						 "file, stopping\n");
+					if (__e == ENOSPC)
+						__e_name = "ENOSPC";
+					else
+						__e_name = "EDQUOT";
+					log_info("fio: %s on laying out "
+						 "file, stopping\n", __e_name);
 				}
 				td_verror(td, errno, "write");
 			} else
diff --git a/fio.1 b/fio.1
index e7da5c68..533bcf6a 100644
--- a/fio.1
+++ b/fio.1
@@ -1650,7 +1650,8 @@ of a file. This option is ignored on non-regular files.
 .TP
 .BI fill_device \fR=\fPbool "\fR,\fB fill_fs" \fR=\fPbool
 Sets size to something really large and waits for ENOSPC (no space left on
-device) as the terminating condition. Only makes sense with sequential
+device) or EDQUOT (disk quota exceeded)
+as the terminating condition. Only makes sense with sequential
 write. For a read workload, the mount point will be filled first then I/O
 started on the result. This option doesn't make sense if operating on a raw
 device node, since the size of that is already known by the file system.
diff --git a/os/os.h b/os/os.h
index b46f4164..e47d3d97 100644
--- a/os/os.h
+++ b/os/os.h
@@ -7,6 +7,7 @@
 #include <pthread.h>
 #include <unistd.h>
 #include <stdlib.h>
+#include <errno.h>
 
 #include "../arch/arch.h" /* IWYU pragma: export */
 #include "../lib/types.h"
@@ -58,6 +59,10 @@ typedef enum {
 #error "unsupported os"
 #endif
 
+#ifndef EDQUOT
+#define EDQUOT	EIO
+#endif
+
 #ifdef CONFIG_POSIXAIO
 #include <aio.h>
 #ifndef FIO_OS_HAVE_AIOCB_TYPEDEF

