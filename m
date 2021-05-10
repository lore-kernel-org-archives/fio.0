Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhEJWjz (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 May 2021 18:39:55 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FF8C061574
        for <fio@vger.kernel.org>; Mon, 10 May 2021 15:38:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gx5so26836049ejb.11
        for <fio@vger.kernel.org>; Mon, 10 May 2021 15:38:49 -0700 (PDT)
Received: from localhost (ip-89-176-114-3.net.upcbroadband.cz. [89.176.114.3])
        by smtp.gmail.com with ESMTPSA id p18sm10053777ejb.19.2021.05.10.15.38.47
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 15:38:47 -0700 (PDT)
Date: Tue, 11 May 2021 00:38:46 +0200
From: Martin Bukatovic <martin.bukatovic@gmail.com>
Subject: [PATCH v2] Make fill_device to stop writing on EDQUOT
Message-ID: <YJm19oa9P0bscNjI@dione.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Option fill_device stops writing when we run out of quota as well.

Signed-off-by: Martin Bukatovic <martin.bukatovic@gmail.com>
---
Changes in v2:
  - moved ENOSPC check into ENOSPC check, modified the log statement

 HOWTO       |  3 ++-
 backend.c   |  7 ++++---
 filesetup.c | 12 +++++++++---
 fio.1       |  3 ++-
 4 files changed, 17 insertions(+), 8 deletions(-)

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
index e664f8b4..57173637 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -226,11 +226,17 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			if (r < 0) {
 				int __e = errno;
 
-				if (__e == ENOSPC) {
+				if (__e == ENOSPC || __e == EDQUOT) {
+					const char* __e_name;
 					if (td->o.fill_device)
 						break;
-					log_info("fio: ENOSPC on laying out "
-						 "file, stopping\n");
+					if (__e == ENOSPC) {
+						__e_name = "ENOSPC";
+					} else {
+						__e_name = "EDQUOT";
+					}
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

