Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgFMMAW (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 13 Jun 2020 08:00:22 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720B0C03E96F
        for <fio@vger.kernel.org>; Sat, 13 Jun 2020 05:00:20 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jk4pP-0003b8-2S
        for fio@vger.kernel.org; Sat, 13 Jun 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200613120001.7D2E51BC01B2@kernel.dk>
Date: Sat, 13 Jun 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 14060ebb90ce5a0a164d0e5e52c13e31b53b282d:

  Merge branch 'latency_window' of https://github.com/liu-song-6/fio (2020-06-09 19:43:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1a953d975847e248be1718105621796bf9481878:

  Priority bit log file format documentation update (2020-06-12 16:24:46 -0600)

----------------------------------------------------------------
Bart Van Assche (3):
      zbd: Fix spelling of the "zonemode" job option
      zbd: Fix zoned_block_device_info.zone_size documentation
      pshared: Improve mutex_init_pshared_with_type()

Jens Axboe (2):
      Merge branch 'master' of https://github.com/raphael-nutanix/fio
      Merge branch 'zbd' of https://github.com/bvanassche/fio

Phillip Chen (1):
      Priority bit log file format documentation update

Raphael Norwitz (1):
      Fix typo in libiscsi error message

 HOWTO              |  5 ++++-
 engines/libiscsi.c |  2 +-
 fio.1              |  6 +++++-
 pshared.c          | 18 ++++++++++--------
 zbd.c              |  2 +-
 zbd.h              |  2 +-
 6 files changed, 22 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 9e339bb8..8cf8d650 100644
--- a/HOWTO
+++ b/HOWTO
@@ -4165,7 +4165,7 @@ Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
 
     *time* (`msec`), *value*, *data direction*, *block size* (`bytes`),
-    *offset* (`bytes`)
+    *offset* (`bytes`), *command priority*
 
 *Time* for the log entry is always in milliseconds. The *value* logged depends
 on the type of log, it will be one of the following:
@@ -4190,6 +4190,9 @@ The entry's *block size* is always in bytes. The *offset* is the position in byt
 from the start of the file for that particular I/O. The logging of the offset can be
 toggled with :option:`log_offset`.
 
+*Command priority* is 0 for normal priority and 1 for high priority. This is controlled
+by the ioengine specific :option:`cmdprio_percentage`.
+
 Fio defaults to logging every individual I/O but when windowed logging is set
 through :option:`log_avg_msec`, either the average (by default) or the maximum
 (:option:`log_max_value` is set) *value* seen over the specified period of time
diff --git a/engines/libiscsi.c b/engines/libiscsi.c
index 58667fb2..35761a61 100644
--- a/engines/libiscsi.c
+++ b/engines/libiscsi.c
@@ -109,7 +109,7 @@ static int fio_iscsi_setup_lun(struct iscsi_info *iscsi_info,
 	if (iscsi_full_connect_sync(iscsi_lun->iscsi,
 				    iscsi_lun->url->portal,
 				    iscsi_lun->url->lun)) {
-		log_err("sicsi: failed to connect to LUN : %s\n",
+		log_err("iscsi: failed to connect to LUN : %s\n",
 			iscsi_get_error(iscsi_lun->iscsi));
 		ret = EINVAL;
 		goto out;
diff --git a/fio.1 b/fio.1
index f469c46e..f134e0bf 100644
--- a/fio.1
+++ b/fio.1
@@ -3863,7 +3863,8 @@ Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
 .RS
 .P
-time (msec), value, data direction, block size (bytes), offset (bytes)
+time (msec), value, data direction, block size (bytes), offset (bytes),
+command priority
 .RE
 .P
 `Time' for the log entry is always in milliseconds. The `value' logged depends
@@ -3897,6 +3898,9 @@ The entry's `block size' is always in bytes. The `offset' is the position in byt
 from the start of the file for that particular I/O. The logging of the offset can be
 toggled with \fBlog_offset\fR.
 .P
+`Command priority` is 0 for normal priority and 1 for high priority. This is controlled
+by the ioengine specific \fBcmdprio_percentage\fR.
+.P
 Fio defaults to logging every individual I/O but when windowed logging is set
 through \fBlog_avg_msec\fR, either the average (by default) or the maximum
 (\fBlog_max_value\fR is set) `value' seen over the specified period of time
diff --git a/pshared.c b/pshared.c
index e671c87f..182a3652 100644
--- a/pshared.c
+++ b/pshared.c
@@ -39,6 +39,10 @@ int cond_init_pshared(pthread_cond_t *cond)
 	return 0;
 }
 
+/*
+ * 'type' must be a mutex type, e.g. PTHREAD_MUTEX_NORMAL,
+ * PTHREAD_MUTEX_ERRORCHECK, PTHREAD_MUTEX_RECURSIVE or PTHREAD_MUTEX_DEFAULT.
+ */
 int mutex_init_pshared_with_type(pthread_mutex_t *mutex, int type)
 {
 	pthread_mutexattr_t mattr;
@@ -60,26 +64,24 @@ int mutex_init_pshared_with_type(pthread_mutex_t *mutex, int type)
 		return ret;
 	}
 #endif
-	if (type) {
-		ret = pthread_mutexattr_settype(&mattr, type);
-		if (ret) {
-			log_err("pthread_mutexattr_settype: %s\n",
-				strerror(ret));
-			return ret;
-		}
+	ret = pthread_mutexattr_settype(&mattr, type);
+	if (ret) {
+		log_err("pthread_mutexattr_settype: %s\n", strerror(ret));
+		return ret;
 	}
 	ret = pthread_mutex_init(mutex, &mattr);
 	if (ret) {
 		log_err("pthread_mutex_init: %s\n", strerror(ret));
 		return ret;
 	}
+	pthread_mutexattr_destroy(&mattr);
 
 	return 0;
 }
 
 int mutex_init_pshared(pthread_mutex_t *mutex)
 {
-	return mutex_init_pshared_with_type(mutex, 0);
+	return mutex_init_pshared_with_type(mutex, PTHREAD_MUTEX_DEFAULT);
 }
 
 int mutex_cond_init_pshared(pthread_mutex_t *mutex, pthread_cond_t *cond)
diff --git a/zbd.c b/zbd.c
index dc302606..8cf8f812 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1365,7 +1365,7 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 }
 
 /**
- * zbd_adjust_ddir - Adjust an I/O direction for zonedmode=zbd.
+ * zbd_adjust_ddir - Adjust an I/O direction for zonemode=zbd.
  *
  * @td: FIO thread data.
  * @io_u: FIO I/O unit.
diff --git a/zbd.h b/zbd.h
index 9c447af4..e942a7f6 100644
--- a/zbd.h
+++ b/zbd.h
@@ -49,7 +49,7 @@ struct fio_zone_info {
  *	sequential write zones.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
- * @zone_size: size of a single zone in units of 512 bytes
+ * @zone_size: size of a single zone in bytes.
  * @sectors_with_data: total size of data in all zones in units of 512 bytes
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.

