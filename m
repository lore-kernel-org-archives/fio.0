Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.stepping-stone.ch ([194.176.109.206]:40411 "EHLO
	mail.stepping-stone.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaGCQWz (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Jul 2014 12:22:55 -0400
From: =?UTF-8?q?Tiziano=20M=C3=BCller?= 
	<tiziano.mueller@stepping-stone.ch>
Subject: [PATCH] Bail out if glfs_creat failed
Date: Thu,  3 Jul 2014 18:22:29 +0200
Message-Id: <1404404549-864-1-git-send-email-tiziano.mueller@stepping-stone.ch>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: =?UTF-8?q?Tiziano=20M=C3=BCller?= <tiziano.mueller@stepping-stone.ch>

Otherwise we will get segfaults from gfapi when it tries to access the
invalid fd.
---
 engines/glusterfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index 94daab5..a64c687 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -160,8 +160,9 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 	       flags & O_RDONLY ? "ro" : "rw", td_read(td) ? "read" : "write");
 	g->fd = glfs_creat(g->fs, f->file_name, flags, 0644);
 	if (!g->fd) {
-		log_err("glfs_creat failed.\n");
 		ret = errno;
+		log_err("glfs_creat failed.\n");
+		return ret;
 	}
 	/* file for read doesn't exist or shorter than required, create/extend it */
 	if (td_read(td)) {
-- 
2.0.0

