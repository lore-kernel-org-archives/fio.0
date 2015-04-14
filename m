Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH 1/7] Allow trim on any file type
Date: Tue, 14 Apr 2015 15:58:14 -0700
Message-Id: <1429052300-9822-2-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429052300-9822-1-git-send-email-dehrenberg@chromium.org>
References: <1429052300-9822-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

The mtd fio engine will support trim (interpreted as erase). There is
no particular reason to tie trims to block devices, as it is only a
particular ioengine which calls the trim ioctl, not generic code.
This patch simply removes the test which checks that trim is only
run on block devices.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 filesetup.c | 5 -----
 1 file changed, 5 deletions(-)

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
-- 
2.2.0.rc0.207.ga3a616c


