Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DFFC7EE25
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 07:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbjFHHGV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 03:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbjFHHGT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 03:06:19 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87825E43
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 00:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686207977; x=1717743977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bCfFPzgHarblnvCP7asYv+92r/3vfjTNWZBFtgcHRFE=;
  b=ai7iyurqwGziD/ptTks4GpKSha9c489krYTfp5acsoxr7QX84bntsfs2
   AXEU3/QXCVY/Izi/OcledweEz6ZHCoR9sXYVc4PPjxAssJe6zZlA81AjR
   obk1u7rx6tw2PqnfV7BfIK/5x6AkqR9H/H58zc9vfpbL0xENt1W4kEyP7
   oRgNhZnxkdvbefC02J4kBetX7DQnR+38QaM4ugjM6zdAWg5kc2CSLgIe+
   7U3DdAoOQnqVOKLLA9TOZf6a6vTPSuyyV87siDJmSodyrxiytOGn54dyT
   lazWDHd8gHwjJELyeKuVN9NB7OZ3qQW3zkFUJBMzGdaYAucLC1dbYkkeq
   w==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="231238480"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 15:06:16 +0800
IronPort-SDR: p5GNGwm1bCCaH9BxjY/6pjhmY0u6rGPO/Te6uql6D60mreUblQHCdATvLpzGFayPhWpxbOenvw
 l2vQlbDMjn3HI+ZhY+DvnNpxXdOR0jN/SKtE6NkmuYwzR7qNxJnQ+MA7kwkRf/BqprVHIh5nDP
 pO1Rx7q8vP+ZHbYIOn4vCmR6L3yUp/hB+agEfhDkm7pqPc42v5TDjGVJhdt/beBklXWZjRAOvk
 FFfVUn7NSsDHgzBOkzPt3lTMiL83Gu8xxHP+DwE3be5dD7TpC4tBtFOMetOiOO/NJCT3F/YX5Q
 iGA=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 23:15:18 -0700
IronPort-SDR: m8P10/R025++a57kr2j3O5slEkJ/FUCzIMYHq74u2x1j/l/4OFU5lqu3mvj8YAajzXITMOCAMD
 ERIq6I0U8U8JTKjrxYr0/w2b1Thk4lz9rvq0evDJ/sSHMgzUyCNqyr0Ub/ideDrjkg+N5kjLdt
 dFVFpIYdYDl5hfsOUlrjPZ1LC5Cd4LcRgfXguiT1fDYDN4g7ExvOkVjdCfIGlmRxvOH7vU/Ism
 LjTSr0egNQF0vF/fBS5wATsct841wP2kAEgFWmed3SK3GBn+xi8dhCYLqlrOml7GQuUjFIgb8P
 0rk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jun 2023 00:06:15 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 4/7] zbd: fix write zone accounting of trim workload
Date:   Thu,  8 Jun 2023 16:06:05 +0900
Message-Id: <20230608070608.1256970-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The commit e3be810bf0fd ("zbd: Support zone reset by trim") supported
trim for zonemode=zbd by introducing the function zbd_do_io_u_trim(),
which calls zbd_reset_zone(). However, it did not call
zbd_write_zone_put() to the trim target zone, then trim operation
resulted in wrong accounting of write zones.

To fix the issue, call zbd_write_zone_put() from zbd_reset_zone(). To
cover the case to reset zones without a zbd_write_zone_put() call,
prepare another function __zbd_reset_zone(). While at it, simplify
zbd_reset_zones() by calling the modified zbd_reset_zone().

Of note is that the constifier of the argument td of do_io_u_trim() is
removed since zbd_write_zone_put() requires changes in that argument.

Fixes: e3be810bf0fd ("zbd: Support zone reset by trim")
Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 engines/io_uring.c |  2 +-
 io_u.c             |  2 +-
 io_u.h             |  2 +-
 zbd.c              | 39 +++++++++++++++++++++++++++++++--------
 zbd.h              |  2 +-
 5 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index ff64fc9f..73e4a27a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -561,7 +561,7 @@ static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
 		ld->sqes[io_u->index].ioprio = io_u->ioprio;
 }
 
-static int fio_ioring_cmd_io_u_trim(const struct thread_data *td,
+static int fio_ioring_cmd_io_u_trim(struct thread_data *td,
 				    struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
diff --git a/io_u.c b/io_u.c
index 6f5fc94d..faf512e5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2379,7 +2379,7 @@ int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
 	return ret;
 }
 
-int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
+int do_io_u_trim(struct thread_data *td, struct io_u *io_u)
 {
 #ifndef FIO_HAVE_TRIM
 	io_u->error = EINVAL;
diff --git a/io_u.h b/io_u.h
index 55b4d083..b432a540 100644
--- a/io_u.h
+++ b/io_u.h
@@ -162,7 +162,7 @@ void io_u_mark_submit(struct thread_data *, unsigned int);
 bool queue_full(const struct thread_data *);
 
 int do_io_u_sync(const struct thread_data *, struct io_u *);
-int do_io_u_trim(const struct thread_data *, struct io_u *);
+int do_io_u_trim(struct thread_data *, struct io_u *);
 
 #ifdef FIO_INC_DEBUG
 static inline void dprint_io_u(struct io_u *io_u, const char *p)
diff --git a/zbd.c b/zbd.c
index 36b68d62..9455140a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -254,7 +254,7 @@ static int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
 }
 
 /**
- * zbd_reset_zone - reset the write pointer of a single zone
+ * __zbd_reset_zone - reset the write pointer of a single zone
  * @td: FIO thread data.
  * @f: FIO file associated with the disk for which to reset a write pointer.
  * @z: Zone to reset.
@@ -263,8 +263,8 @@ static int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
  *
  * The caller must hold z->mutex.
  */
-static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
-			  struct fio_zone_info *z)
+static int __zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			    struct fio_zone_info *z)
 {
 	uint64_t offset = z->start;
 	uint64_t length = (z+1)->start - offset;
@@ -339,6 +339,32 @@ static void zbd_write_zone_put(struct thread_data *td, const struct fio_file *f,
 	z->write = 0;
 }
 
+/**
+ * zbd_reset_zone - reset the write pointer of a single zone and remove the zone
+ *                  from the array of write zones.
+ * @td: FIO thread data.
+ * @f: FIO file associated with the disk for which to reset a write pointer.
+ * @z: Zone to reset.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ *
+ * The caller must hold z->mutex.
+ */
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			  struct fio_zone_info *z)
+{
+	int ret;
+
+	ret = __zbd_reset_zone(td, f, z);
+	if (ret)
+		return ret;
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	zbd_write_zone_put(td, f, z);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	return 0;
+}
+
 /**
  * zbd_finish_zone - finish the specified zone
  * @td: FIO thread data.
@@ -404,9 +430,6 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			continue;
 
 		zone_lock(td, f, z);
-		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_write_zone_put(td, f, z);
-		pthread_mutex_unlock(&f->zbd_info->mutex);
 
 		if (z->wp != z->start) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
@@ -2048,7 +2071,7 @@ retry:
 			 */
 			io_u_quiesce(td);
 			zb->reset_zone = 0;
-			if (zbd_reset_zone(td, f, zb) < 0)
+			if (__zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
 
 			if (zb->capacity < min_bs) {
@@ -2167,7 +2190,7 @@ char *zbd_write_status(const struct thread_stat *ts)
  * Return io_u_completed when reset zone succeeds. Return 0 when the target zone
  * does not have write pointer. On error, return negative errno.
  */
-int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
+int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z;
diff --git a/zbd.h b/zbd.h
index 25a3e0f1..f0ac9876 100644
--- a/zbd.h
+++ b/zbd.h
@@ -100,7 +100,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 			      enum fio_ddir ddir);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
-int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u);
+int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
 
 static inline void zbd_close_file(struct fio_file *f)
 {
-- 
2.40.1

