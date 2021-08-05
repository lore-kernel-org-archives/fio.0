Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhHEMAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 Aug 2021 08:00:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9E4C061765
        for <fio@vger.kernel.org>; Thu,  5 Aug 2021 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBc2d-0061QV-To
        for fio@vger.kernel.org; Thu, 05 Aug 2021 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210805120001.73F8B1BC011F@kernel.dk>
Date: Thu,  5 Aug 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 382975557e632efb506836bc1709789e615c9094:

  fio: remove raw device support (2021-08-03 12:20:22 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2459bd33b3dbb7a34f28c612d595311a6bc7593d:

  ioengines: fix crash with --enghelp option (2021-08-04 12:49:57 -0600)

----------------------------------------------------------------
Ankit Kumar (2):
      HOWTO: Add missing documentation for job_max_open_zones
      zbd: Improve random zone index generation logic

Vincent Fu (2):
      backend: clarify io scheduler setting error message
      ioengines: fix crash with --enghelp option

 HOWTO       |  5 +++++
 backend.c   |  2 +-
 ioengines.c | 10 +++++-----
 zbd.c       |  5 +++--
 4 files changed, 14 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 59c7f1ff..d4e620de 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1055,6 +1055,11 @@ Target file/device
 	number of open zones is defined as the number of zones to which write
 	commands are issued.
 
+.. option:: job_max_open_zones=int
+
+	Limit on the number of simultaneously opened zones per single
+	thread/process.
+
 .. option:: zone_reset_threshold=float
 
 	A number between zero and one that indicates the ratio of logical
diff --git a/backend.c b/backend.c
index 6290e0d6..808e4362 100644
--- a/backend.c
+++ b/backend.c
@@ -1407,7 +1407,7 @@ static int set_ioscheduler(struct thread_data *td, struct fio_file *file)
 
 	sprintf(tmp2, "[%s]", td->o.ioscheduler);
 	if (!strstr(tmp, tmp2)) {
-		log_err("fio: io scheduler %s not found\n", td->o.ioscheduler);
+		log_err("fio: unable to set io scheduler to %s\n", td->o.ioscheduler);
 		td_verror(td, EINVAL, "iosched_switch");
 		fclose(f);
 		return 1;
diff --git a/ioengines.c b/ioengines.c
index dd61af07..d08a511a 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -692,17 +692,17 @@ int fio_show_ioengine_help(const char *engine)
 	}
 
 	td.o.ioengine = (char *)engine;
-	io_ops = load_ioengine(&td);
+	td.io_ops = load_ioengine(&td);
 
-	if (!io_ops) {
+	if (!td.io_ops) {
 		log_info("IO engine %s not found\n", engine);
 		return 1;
 	}
 
-	if (io_ops->options)
-		ret = show_cmd_help(io_ops->options, sep);
+	if (td.io_ops->options)
+		ret = show_cmd_help(td.io_ops->options, sep);
 	else
-		log_info("IO engine %s has no options\n", io_ops->name);
+		log_info("IO engine %s has no options\n", td.io_ops->name);
 
 	free_ioengine(&td);
 	return ret;
diff --git a/zbd.c b/zbd.c
index 04c68dea..43f12b45 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1184,11 +1184,12 @@ out:
 	return res;
 }
 
-/* Anything goes as long as it is not a constant. */
+/* Return random zone index for one of the open zones. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
 {
-	return io_u->offset * f->zbd_info->num_open_zones / f->real_file_size;
+	return (io_u->offset - f->file_offset) * f->zbd_info->num_open_zones /
+		f->io_size;
 }
 
 /*

