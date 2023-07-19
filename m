Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0489C001DC
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjGSK6G (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjGSK6F (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:05 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF42A18D
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764283; x=1721300283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i6yAdmW734JUvgnYTL31v8uBG3TRyUy4mAEs+7lDNsY=;
  b=NH0n9oFOAl6zscDRlSVYc61oq9k561cWQu/Mr8QU2oUa+UQXUcKabNRL
   WBO61g3vW28reCldnbHeI3RF9KttBcuBmSbMNdy6JdcV6sRVjloMB9G53
   AYMysaZ9qUTZu2eFrnarcwDLs/im7iUzKhS1nufZo4Ew62FSchw0rCg9w
   n+SQBSo0dlaMwwU2Z8K2lNauTcXhBZ5gkYLt4J0GVwlgLoUbLOTyKrH5T
   tmSWl+u0Nd0Mh+jNoRnJIYdtX4fbo17HyL+BoL5TXdNwrinNDQYNqBCZW
   wZ3NhaF1JFBu+KuO+/uYrtoGVRFthW7veUUR77CGw1WT8AbksOAvA9w7I
   A==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860316"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:00 +0800
IronPort-SDR: tmqC5PT22PTxpf16e+pqZv1UshRHfs1ruaq3uQw/2ZxroFMA3Bl0wGcUrWX4K50nWfvNh0sJyM
 eLSeLLlpEmrqjUT+afWj8GumxVXnck4hHSRBL2fLpSPNQ1BTn1W813FBRZjq5u56Ru6x2UWqy/
 fMKJhXT4GQCgy9nX/0M8HI2fMlh103i0gPC5XUrIY5preuyQEOHrn6XIScnAis+Vm/lKFOHXWK
 F0wihNQhdYokAgZlc1FA9tSfB0KBR1pWWbdtZXIy1DNUZA0a1FIUWxU843NH22AYXzgkweRLxo
 l7A=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:12 -0700
IronPort-SDR: cBBo8utEvLPKh8dfYavUOKTkac6ocJ8YwsEWySTRUU1iFr60ryLZ3No8/7r2BTvCoP9TV+JNFj
 AFlW6YSC+GrJDwLQb89JTMQTZHWIOsrGTrMEup3u5yBQiG2LshzG1h28zfQn3Mh6ZwRxTE+vPF
 cinU0Er4arPsPukVopWvL2OV6XycIn2CWkkAuM57c1+1twbKvpmMbTHsIreGFRm9wYfsxzb8UZ
 PvuLTmSVZ4vOpDdWmAVLEmsgrZIJH+HrlCyH4u1b/u6qRCrnobPs0KXaHhk5cWOLFAVuVvC5Sx
 uHc=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:57:59 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 01/13] zbd: get max_active_zones limit value from zoned devices
Date:   Wed, 19 Jul 2023 19:57:44 +0900
Message-Id: <20230719105756.553146-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

As a preparation to improve open zones accounting for devices with the
max_active_zones limit, get the limit from the devices. In same manner
as max_open_zones, call get_max_active_zones callback if the I/O engine
supports it. Add the new call back to the I/O engine API and bump up
FIO_IOOPS_VERSION. It is expected that io_uring and xnvme engines to
support the callback later. When the callback is not available, refer
max_active_zones sysfs attribute for block devices. When the limit value
is not available, use zero value which means no limit. Keep the obtained
limit value in the struct zoned_block_device_info.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 ioengines.h            |  4 +++-
 oslib/blkzoned.h       |  9 +++++++++
 oslib/linux-blkzoned.c | 23 +++++++++++++++++++++++
 zbd.c                  | 29 +++++++++++++++++++++++++++++
 zbd.h                  |  4 ++++
 5 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/ioengines.h b/ioengines.h
index 9484265e..4391b31e 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "fdp.h"
 
-#define FIO_IOOPS_VERSION	32
+#define FIO_IOOPS_VERSION	33
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -62,6 +62,8 @@ struct ioengine_ops {
 			uint64_t, uint64_t);
 	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
 				  unsigned int *);
+	int (*get_max_active_zones)(struct thread_data *, struct fio_file *,
+				    unsigned int *);
 	int (*finish_zone)(struct thread_data *, struct fio_file *,
 			   uint64_t, uint64_t);
 	int (*fdp_fetch_ruhs)(struct thread_data *, struct fio_file *,
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 29fb034f..e598bd4f 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -18,6 +18,9 @@ extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
 extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				       unsigned int *max_open_zones);
+extern int blkzoned_get_max_active_zones(struct thread_data *td,
+					 struct fio_file *f,
+					 unsigned int *max_active_zones);
 extern int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
 #else
@@ -53,6 +56,12 @@ static inline int blkzoned_get_max_open_zones(struct thread_data *td, struct fio
 {
 	return -EIO;
 }
+static inline int blkzoned_get_max_active_zones(struct thread_data *td,
+						struct fio_file *f,
+						unsigned int *max_open_zones)
+{
+	return -EIO;
+}
 static inline int blkzoned_finish_zone(struct thread_data *td,
 				       struct fio_file *f,
 				       uint64_t offset, uint64_t length)
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 722e0992..2c3ecf33 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -186,6 +186,29 @@ int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 	return 0;
 }
 
+int blkzoned_get_max_active_zones(struct thread_data *td, struct fio_file *f,
+				  unsigned int *max_active_zones)
+{
+	char *max_active_str;
+
+	if (f->filetype != FIO_TYPE_BLOCK)
+		return -EIO;
+
+	max_active_str = blkzoned_get_sysfs_attr(f->file_name, "queue/max_active_zones");
+	if (!max_active_str) {
+		*max_active_zones = 0;
+		return 0;
+	}
+
+	dprint(FD_ZBD, "%s: max active zones supported by device: %s\n",
+	       f->file_name, max_active_str);
+	*max_active_zones = atoll(max_active_str);
+
+	free(max_active_str);
+
+	return 0;
+}
+
 static uint64_t zone_capacity(struct blk_zone_report *hdr,
 			      struct blk_zone *blkz)
 {
diff --git a/zbd.c b/zbd.c
index d4565215..a5cb34d2 100644
--- a/zbd.c
+++ b/zbd.c
@@ -471,6 +471,34 @@ static int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 	return ret;
 }
 
+/**
+ * zbd_get_max_active_zones - Get the maximum number of active zones
+ * @td: FIO thread data
+ * @f: FIO file for which to get max active zones
+ *
+ * Returns max_active_zones limit value of the target file if it is available.
+ * Otherwise return zero, which means no limit.
+ */
+static unsigned int zbd_get_max_active_zones(struct thread_data *td,
+					     struct fio_file *f)
+{
+	unsigned int max_active_zones;
+	int ret;
+
+	if (td->io_ops && td->io_ops->get_max_active_zones)
+		ret = td->io_ops->get_max_active_zones(td, f,
+						       &max_active_zones);
+	else
+		ret = blkzoned_get_max_active_zones(td, f, &max_active_zones);
+	if (ret < 0) {
+		dprint(FD_ZBD, "%s: max_active_zones is not available\n",
+		       f->file_name);
+		return 0;
+	}
+
+	return max_active_zones;
+}
+
 /**
  * __zbd_write_zone_get - Add a zone to the array of write zones.
  * @td: fio thread data.
@@ -927,6 +955,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
 		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
+	f->zbd_info->max_active_zones = zbd_get_max_active_zones(td, f);
 
 	if (same_zone_cap)
 		dprint(FD_ZBD, "Zone capacity = %"PRIu64" KB\n",
diff --git a/zbd.h b/zbd.h
index f0ac9876..a5cf59d1 100644
--- a/zbd.h
+++ b/zbd.h
@@ -52,6 +52,9 @@ struct fio_zone_info {
  *      are simultaneously written. A zero value means unlimited zones of
  *      simultaneous writes and that write target zones will not be tracked in
  *      the write_zones array.
+ * @max_active_zones: device side limit on the number of sequential write zones
+ *	in open or closed conditions. A zero value means unlimited number of
+ *	zones in the conditions.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
@@ -75,6 +78,7 @@ struct fio_zone_info {
 struct zoned_block_device_info {
 	enum zbd_zoned_model	model;
 	uint32_t		max_write_zones;
+	uint32_t		max_active_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		wp_valid_data_bytes;
-- 
2.40.1

