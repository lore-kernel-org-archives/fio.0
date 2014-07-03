Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.stepping-stone.ch ([194.176.109.206]:60135 "EHLO
	mail.stepping-stone.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaGCOtQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Jul 2014 10:49:16 -0400
From: =?UTF-8?q?Tiziano=20M=C3=BCller?= 
	<tiziano.mueller@stepping-stone.ch>
Subject: [PATCH] Pass O_DIRECT/O_SYNC to glfs_open if requested.
Date: Thu,  3 Jul 2014 16:48:39 +0200
Message-Id: <1404398919-24474-1-git-send-email-tiziano.mueller@stepping-stone.ch>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: =?UTF-8?q?Tiziano=20M=C3=BCller?= <tiziano.mueller@stepping-stone.ch>

GlusterFS supports O_DIRECT and O_SYNC.
---
 engines/glusterfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index b233b20..94daab5 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -150,8 +150,14 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 		else
 			flags = O_RDONLY;
 	}
+
+	if (td->o.odirect)
+		flags |= OS_O_DIRECT;
+	if (td->o.sync_io)
+		flags |= O_SYNC;
+
 	dprint(FD_FILE, "fio file %s open mode %s td rw %s\n", f->file_name,
-	       flags == O_RDONLY ? "ro" : "rw", td_read(td) ? "read" : "write");
+	       flags & O_RDONLY ? "ro" : "rw", td_read(td) ? "read" : "write");
 	g->fd = glfs_creat(g->fs, f->file_name, flags, 0644);
 	if (!g->fd) {
 		log_err("glfs_creat failed.\n");
-- 
2.0.0

