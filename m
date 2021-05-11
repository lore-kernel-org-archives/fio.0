Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKHkF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 May 2021 03:40:05 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1374CC061574
        for <fio@vger.kernel.org>; Tue, 11 May 2021 00:38:59 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id di13so21689269edb.2
        for <fio@vger.kernel.org>; Tue, 11 May 2021 00:38:59 -0700 (PDT)
Received: from localhost (ip-89-176-114-3.net.upcbroadband.cz. [89.176.114.3])
        by smtp.gmail.com with ESMTPSA id g11sm10885821eje.7.2021.05.11.00.38.56
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 00:38:57 -0700 (PDT)
Date: Tue, 11 May 2021 09:38:55 +0200
From: Martin Bukatovic <martin.bukatovic@gmail.com>
Subject: [PATCH v3] Make fill_device to stop writing on EDQUOT
Message-ID: <YJo0j+luAzHGFWQ+@dione.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Option fill_device stops writing when we run out of quota as well.

Signed-off-by: Martin Bukatovic <martin.bukatovic@gmail.com>
---
Changes in v3:
  - fixing code style

Changes in v2:
  - moved ENOSPC check into ENOSPC check, modified the log statement
---
 HOWTO       |  3 ++-
 backend.c   |  7 ++++---
 filesetup.c | 11 ++++++++---
 fio.1       |  3 ++-
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/HOWTO b/HOWTO
index 889526d9..6bc52fb1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1852,7 +1852,8 @@ I/O size
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
index c3916168..75c06bf3 100644
--- a/fio.1
+++ b/fio.1
@@ -1638,7 +1638,8 @@ of a file. This option is ignored on non-regular files.
 .TP
 .BI fill_device \fR=\fPbool "\fR,\fB fill_fs" \fR=\fPbool
 Sets size to something really large and waits for ENOSPC (no space left on
-device) as the terminating condition. Only makes sense with sequential
+device) or EDQUOT (disk quota exceeded)
+as the terminating condition. Only makes sense with sequential
 write. For a read workload, the mount point will be filled first then I/O
 started on the result. This option doesn't make sense if operating on a raw
 device node, since the size of that is already known by the file system.
-- 
2.30.2


-- 
Martin Bukatovič

