Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbgH2Ue7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 29 Aug 2020 16:34:59 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE67C061236
        for <fio@vger.kernel.org>; Sat, 29 Aug 2020 13:34:59 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l17so709007edq.12
        for <fio@vger.kernel.org>; Sat, 29 Aug 2020 13:34:59 -0700 (PDT)
Received: from localhost (ip-89-176-251-15.net.upcbroadband.cz. [89.176.251.15])
        by smtp.gmail.com with ESMTPSA id w5sm3097334ejk.14.2020.08.29.13.34.56
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 13:34:56 -0700 (PDT)
Date: Sat, 29 Aug 2020 22:34:56 +0200
From: Martin Bukatovic <martin.bukatovic@gmail.com>
Subject: [PATCH] Make fill_device to stop writing on EDQUOT
Message-ID: <20200829203456.GA18156@dione.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Option fill_device stops writing when we run out of quota as well.

Signed-off-by: Martin Bukatovic <martin.bukatovic@gmail.com>
---
 HOWTO       | 3 ++-
 backend.c   | 7 ++++---
 filesetup.c | 4 ++++
 fio.1       | 3 ++-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/HOWTO b/HOWTO
index e0403b08..d83f8eb6 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1804,7 +1804,8 @@ I/O size
 .. option:: fill_device=bool, fill_fs=bool
 
 	Sets size to something really large and waits for ENOSPC (no space left on
-	device) as the terminating condition. Only makes sense with sequential
+	device) or EDQUOT (disk quota exceeded)
+	as the terminating condition. Only makes sense with sequential
 	write. For a read workload, the mount point will be filled first then I/O
 	started on the result. This option doesn't make sense if operating on a raw
 	device node, since the size of that is already known by the file system.
diff --git a/backend.c b/backend.c
index a4367672..1692dd8f 100644
--- a/backend.c
+++ b/backend.c
@@ -392,7 +392,7 @@ static bool break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 			td_clear_error(td);
 			*retptr = 0;
 			return false;
-		} else if (td->o.fill_device && err == ENOSPC) {
+		} else if (td->o.fill_device && (err == ENOSPC || err == EDQUOT)) {
 			/*
 			 * We expect to hit this error if
 			 * fill_device option is set.
@@ -1099,7 +1099,7 @@ reap:
 	if (td->trim_entries)
 		log_err("fio: %lu trim entries leaked?\n", td->trim_entries);
 
-	if (td->o.fill_device && td->error == ENOSPC) {
+	if (td->o.fill_device && (td->error == ENOSPC || td->error == EDQUOT)) {
 		td->error = 0;
 		fio_mark_td_terminate(td);
 	}
@@ -1114,7 +1114,8 @@ reap:
 
 		if (i) {
 			ret = io_u_queued_complete(td, i);
-			if (td->o.fill_device && td->error == ENOSPC)
+			if (td->o.fill_device &&
+			    (td->error == ENOSPC || td->error == EDQUOT))
 				td->error = 0;
 		}
 
diff --git a/filesetup.c b/filesetup.c
index d382fa24..39a17521 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -233,6 +233,10 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 						 "file, stopping\n");
 					break;
 				}
+				if (__e == EDQUOT) {
+					if (td->o.fill_device)
+						break;
+				}
 				td_verror(td, errno, "write");
 			} else
 				td_verror(td, EIO, "write");
diff --git a/fio.1 b/fio.1
index 1c90e4a5..579b115a 100644
--- a/fio.1
+++ b/fio.1
@@ -1578,7 +1578,8 @@ of a file. This option is ignored on non-regular files.
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
2.26.2


-- 
Martin Bukatovič

