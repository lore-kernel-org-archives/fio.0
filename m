Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2B9C4332F
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiKHIto (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiKHIto (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:44 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844122C67F
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897383; x=1699433383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I6UAzvilVVoBBtzWSSmri4OR5oAhhrOEZg2sx+LueRM=;
  b=h9c+gm+GMTMeC/KDGAe3GfyUAI9LhEvl9ePS6phxUZWRukvMZmFGjKMg
   98lhVvRPxELvFACm4Zbl4MV+QoGTngZGeTzffRsXl8yCml/l/2G9X+ki/
   2Nfv1OrQwmNsNaKoJUkeKzNB2e4Z4S+UEWQ3ep6qS8O/2Ld50FgvsH+US
   OPqaUtqYh+GnVH0jwL2avAB4mxFyEQ5iUzJnpXleB3fn901IZV5cUCr4E
   6QjZlD7XA9uYQYEaigVd7/Pu7I5rztmShR0kVrhKutKDEN01y817ntVFf
   mkSfeP6eL7im+4uTnC7z7MKBfNOMlrK/r458/HNiUdzauDV/ypU1Sm+Aq
   g==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="320079423"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:43 +0800
IronPort-SDR: 4WgAo1YmipeY7C5SJL3wI3kUvU7WPRojrX6rhYCASPJEFSvwcf0WVkte9/uUkdm+jL0e8JpHBp
 FwLGmhfZXdsY908/d9zuVlkDHj0YTQOSGh4MNFDC7/RPivcSMCjERjQUtj+LSyCLqT65tnNrd3
 S2Yv+ymjmAOq6H7sQLEFSw6onnFKmT7nnrpFsiORHENOrpllH5m7F/bNEw3fGRY8B/BvOu2VT5
 09krmZv1+xWhGl20uqqVeINPtyrrkFV6BZ0ajy+Fifuprv10u4GK2wTWVdAP98NmoSxeufbMmT
 7bo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:04 -0800
IronPort-SDR: B1Pen6+AIwIs04BE35jCBD+RJ9xCUVt7MWxyPQX2V35V1xgDUamVn8OO6/Nq2FQZ8nEKqhF1OU
 t3jhddPbfnWMQyRW2rnRY1teh3vKo+Scc4sGzqHdAoV9UrlqOztBCqYclAue/AYcfOZVLEhWNm
 2bJpOZkxsPQjppp9s6zyQP6H/aQq3oo+0x/GfnDYynpeCgHe5AuiDGg0ti2GP7HyKWmnyVfSpb
 eRs0REPG7UeWW9KJSpNAsDbhlj5Of7TttvbO8tCiJPuiGhTF4s0EMiNqbSf2kF0simz22YKwo9
 4R0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:43 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 01/13] oslib: blkzoned: add blkzoned_finish_zone() helper function
Date:   Tue,  8 Nov 2022 17:49:28 +0900
Message-Id: <20221108084940.1574939-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add the helper function blkzoned_finish_zone() to support zone finish
operation to zoned block devices through ioctl. This feature will be
used to change status of zones which is not yet full but does not have
enough size to write next block, so that such zones do not exceed max
active zones limit. This function does zone finish only when kernel
supports the ioctl BLKFINISHZONE. Otherwise, it does nothing. This
should be fine since the kernel without BLKFINISHZONE does not report
max active zone limit through sysfs to user space.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 oslib/blkzoned.h       |  8 ++++++++
 oslib/linux-blkzoned.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 719b041d..29fb034f 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -18,6 +18,8 @@ extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
 extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				       unsigned int *max_open_zones);
+extern int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
+				uint64_t offset, uint64_t length);
 #else
 /*
  * Define stubs for systems that do not have zoned block device support.
@@ -51,6 +53,12 @@ static inline int blkzoned_get_max_open_zones(struct thread_data *td, struct fio
 {
 	return -EIO;
 }
+static inline int blkzoned_finish_zone(struct thread_data *td,
+				       struct fio_file *f,
+				       uint64_t offset, uint64_t length)
+{
+	return -EIO;
+}
 #endif
 
 #endif /* FIO_BLKZONED_H */
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 185bd501..c3130d0e 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -308,3 +308,40 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 
 	return ret;
 }
+
+int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
+			 uint64_t offset, uint64_t length)
+{
+#ifdef BLKFINISHZONE
+	struct blk_zone_range zr = {
+		.sector         = offset >> 9,
+		.nr_sectors     = length >> 9,
+	};
+	int fd, ret = 0;
+
+	/* If the file is not yet opened, open it for this function. */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
+		if (fd < 0)
+			return -errno;
+	}
+
+	if (ioctl(fd, BLKFINISHZONE, &zr) < 0)
+		ret = -errno;
+
+	if (f->fd < 0)
+		close(fd);
+
+	return ret;
+#else
+	/*
+	 * Kernel versions older than 5.5 does not support BLKFINISHZONE. These
+	 * old kernels assumed zones are closed automatically at max_open_zones
+	 * limit. Also they did not support max_active_zones limit. Then there
+	 * was no need to finish zones to avoid errors caused by max_open_zones
+	 * or max_active_zones. For those old versions, just do nothing.
+	 */
+	return 0;
+#endif
+}
-- 
2.37.1

