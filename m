Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbgDRMA1 (ORCPT
        <rfc822;fio@vger.kernel.org>); Sat, 18 Apr 2020 08:00:27 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4CFC061A0C
        for <fio@vger.kernel.org>; Sat, 18 Apr 2020 05:00:27 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPm8o-0003qF-H0
        for fio@vger.kernel.org; Sat, 18 Apr 2020 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200418120001.AD7141BC0CC0@kernel.dk>
Date: Sat, 18 Apr 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8dbd327fbaa267eef862843a270fac61d06df00b:

  Merge branch 'patch-1' of https://github.com/aakarshg/fio (2020-04-16 14:04:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c65057f93d1de62a48f98578e24716128ce77a75:

  zbd: Fix I/O direction adjustment step for random read/write (2020-04-17 08:32:15 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      zbd: Fix I/O direction adjustment step for random read/write

 io_u.c |  2 ++
 zbd.c  | 40 ++++++++++++++++++++++++++++++----------
 zbd.h  |  2 ++
 3 files changed, 34 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 5d62a76c..18e94617 100644
--- a/io_u.c
+++ b/io_u.c
@@ -746,6 +746,8 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 {
 	enum fio_ddir ddir = get_rw_ddir(td);
 
+	ddir = zbd_adjust_ddir(td, io_u, ddir);
+
 	if (td_trimwrite(td)) {
 		struct fio_file *f = io_u->file;
 		if (f->last_pos[DDIR_WRITE] == f->last_pos[DDIR_TRIM])
diff --git a/zbd.c b/zbd.c
index de0c5bf4..8dc3c397 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1331,6 +1331,36 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	}
 }
 
+/**
+ * zbd_adjust_ddir - Adjust an I/O direction for zonedmode=zbd.
+ *
+ * @td: FIO thread data.
+ * @io_u: FIO I/O unit.
+ * @ddir: I/O direction before adjustment.
+ *
+ * Return adjusted I/O direction.
+ */
+enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
+			      enum fio_ddir ddir)
+{
+	/*
+	 * In case read direction is chosen for the first random I/O, fio with
+	 * zonemode=zbd stops because no data can be read from zoned block
+	 * devices with all empty zones. Overwrite the first I/O direction as
+	 * write to make sure data to read exists.
+	 */
+	if (td->o.zone_mode != ZONE_MODE_ZBD ||
+	    ddir != DDIR_READ ||
+	    !td_rw(td))
+		return ddir;
+
+	if (io_u->file->zbd_info->sectors_with_data ||
+	    td->o.read_beyond_wp)
+		return DDIR_READ;
+
+	return DDIR_WRITE;
+}
+
 /**
  * zbd_adjust_block - adjust the offset and length as necessary for ZBD drives
  * @td: FIO thread data.
@@ -1364,16 +1394,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	if (!zbd_zone_swr(zb))
 		return io_u_accept;
 
-	/*
-	 * In case read direction is chosen for the first random I/O, fio with
-	 * zonemode=zbd stops because no data can be read from zoned block
-	 * devices with all empty zones. Overwrite the first I/O direction as
-	 * write to make sure data to read exists.
-	 */
-	if (td_rw(td) && !f->zbd_info->sectors_with_data
-	    && !td->o.read_beyond_wp)
-		io_u->ddir = DDIR_WRITE;
-
 	/*
 	 * Accept the I/O offset for reads if reading beyond the write pointer
 	 * is enabled.
diff --git a/zbd.h b/zbd.h
index 4eaf902e..5a660399 100644
--- a/zbd.h
+++ b/zbd.h
@@ -82,6 +82,8 @@ int zbd_init(struct thread_data *td);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
 void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);
+enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
+			      enum fio_ddir ddir);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 

