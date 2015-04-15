Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34223 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbbDORlv (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Apr 2015 13:41:51 -0400
Received: by oiko83 with SMTP id o83so32387571oik.1
        for <fio@vger.kernel.org>; Wed, 15 Apr 2015 10:41:50 -0700 (PDT)
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH v2 1/7] Allow trim on any file type
Date: Wed, 15 Apr 2015 10:41:29 -0700
Message-Id: <1429119695-22425-2-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
References: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>

The mtd fio engine will support trim (interpreted as erase). There is
no particular reason to tie trims to block devices, as it is only a
particular ioengine which calls the trim ioctl, not generic code.
This patch simply removes the test which checks that trim is only
run on block devices.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>

---
 filesetup.c | 5 -----
 fio.1       | 4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 0fb5589..4b63632 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -512,11 +512,6 @@ int generic_open_file(struct thread_data *td, struct fio_file *f)
 
 	dprint(FD_FILE, "fd open %s\n", f->file_name);
 
-	if (td_trim(td) && f->filetype != FIO_TYPE_BD) {
-		log_err("fio: trim only applies to block device\n");
-		return 1;
-	}
-
 	if (!strcmp(f->file_name, "-")) {
 		if (td_rw(td)) {
 			log_err("fio: can't read/write to stdin/out\n");
diff --git a/fio.1 b/fio.1
index 0164f42..b94fb43 100644
--- a/fio.1
+++ b/fio.1
@@ -270,7 +270,7 @@ Sequential reads.
 Sequential writes.
 .TP
 .B trim
-Sequential trim (Linux block devices only).
+Sequential trim.
 .TP
 .B randread
 Random reads.
@@ -279,7 +279,7 @@ Random reads.
 Random writes.
 .TP
 .B randtrim
-Random trim (Linux block devices only).
+Random trim.
 .TP
 .B rw, readwrite
 Mixed sequential reads and writes.
-- 
2.2.0.rc0.207.ga3a616c

