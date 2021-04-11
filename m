Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhDKMAX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 11 Apr 2021 08:00:23 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A273C061574
        for <fio@vger.kernel.org>; Sun, 11 Apr 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVYl2-004Pkv-Vv
        for fio@vger.kernel.org; Sun, 11 Apr 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210411120001.C35421BC0147@kernel.dk>
Date: Sun, 11 Apr 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6202c70d8d5cbdd3fb4bc23b96f691cbd25a327e:

  gettime: cleanup ifdef mess (2021-03-30 20:13:16 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1588c8f571f67a004571e51cdbb5de97c3e4f457:

  Merge branch 'wip-rados-dont-zerowrite' of https://github.com/aclamk/fio (2021-04-10 11:46:30 -0600)

----------------------------------------------------------------
Adam Kupczyk (1):
      engine/rados: Add option to skip object creation

Jens Axboe (1):
      Merge branch 'wip-rados-dont-zerowrite' of https://github.com/aclamk/fio

 HOWTO           |  6 ++++++
 engines/rados.c | 19 ++++++++++++++++---
 fio.1           |  5 +++++
 3 files changed, 27 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index c48f46d8..2788670d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2328,6 +2328,12 @@ with the caveat that when used on the command line, they must come after the
         Poll store instead of waiting for completion. Usually this provides better
         throughput at cost of higher(up to 100%) CPU utilization.
 
+.. option:: touch_objects=bool : [rados]
+
+        During initialization, touch (create if do not exist) all objects (files).
+        Touching all objects affects ceph caches and likely impacts test results.
+        Enabled by default.
+
 .. option:: skip_bad=bool : [mtd]
 
 	Skip operations against known bad blocks.
diff --git a/engines/rados.c b/engines/rados.c
index 42ee48ff..23e62c4c 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -38,6 +38,7 @@ struct rados_options {
 	char *pool_name;
 	char *client_name;
 	int busy_poll;
+	int touch_objects;
 };
 
 static struct fio_option options[] = {
@@ -78,6 +79,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group    = FIO_OPT_G_RBD,
 	},
+	{
+		.name     = "touch_objects",
+		.lname    = "touch objects on start",
+		.type     = FIO_OPT_BOOL,
+		.help     = "Touch (create) objects on start",
+		.off1     = offsetof(struct rados_options, touch_objects),
+		.def	  = "1",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_RBD,
+	},
 	{
 		.name     = NULL,
 	},
@@ -194,9 +205,11 @@ static int _fio_rados_connect(struct thread_data *td)
 	for (i = 0; i < td->o.nr_files; i++) {
 		f = td->files[i];
 		f->real_file_size = file_size;
-		r = rados_write(rados->io_ctx, f->file_name, "", 0, 0);
-		if (r < 0) {
-			goto failed_obj_create;
+		if (o->touch_objects) {
+			r = rados_write(rados->io_ctx, f->file_name, "", 0, 0);
+			if (r < 0) {
+				goto failed_obj_create;
+			}
 		}
 	}
 	return 0;
diff --git a/fio.1 b/fio.1
index ad4a662b..f959e00d 100644
--- a/fio.1
+++ b/fio.1
@@ -2087,6 +2087,11 @@ by default.
 Poll store instead of waiting for completion. Usually this provides better
 throughput at cost of higher(up to 100%) CPU utilization.
 .TP
+.BI (rados)touch_objects \fR=\fPbool
+During initialization, touch (create if do not exist) all objects (files).
+Touching all objects affects ceph caches and likely impacts test results.
+Enabled by default.
+.TP
 .BI (http)http_host \fR=\fPstr
 Hostname to connect to. For S3, this could be the bucket name. Default
 is \fBlocalhost\fR

