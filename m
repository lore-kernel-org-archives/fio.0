Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B18C67871
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiJ0GBq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiJ0GBp (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:01:45 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD5274CEB
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850504; x=1698386504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I6UAzvilVVoBBtzWSSmri4OR5oAhhrOEZg2sx+LueRM=;
  b=BxteEnfFDufXi8RDEOCTa6nAb6TGvdTMR1ofP0rUPaKjf9adodEF3aoV
   LP13av2guX0j7UdE00b3TqNDLRSQJNHf5medCBz9KgSf7MkNrKPSaATeY
   vkBTJDejV0q9N2CGRqCSK4e7ejPtfdTB1yolrWDzE4j7/DkaHywcS5ehF
   mwFxb/6WGUpOBRWUKRHNg8/sCxT3dq3hE+xaRqvGmeAWBqHHujavtuW4a
   PSqQBXA3g6wnWQGBZslm62BgAgw0FpWdI7yy30DumS8BKQVJjduWp9G51
   sTpCu7ug9hzBDJnhYPku227SYxWp1iHgG5FqBZIqhU/GxL3TTBocvlDeN
   g==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="214845829"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:43 +0800
IronPort-SDR: 15pFVIiHbbXaJMmey7r81nh97fIgIZrG5g7V9518WGNBJyV9PjjHB1X88kF/2PdNYBasAi5a8z
 bxVjGa90S+IZ3vSnMkp6XqH/Ju36SBCFul1gRvwJwwDrZ+05HaX/x2RIe0dsoAsawpyfrIoPPb
 K+ixG7pCQypJ6EIpSqaYrYOS5YV3Izzah44NFDunjYuSsU1tUTHesI9k+yAf/P3wurzTotJwgf
 YK0ayVT2DAQ/ppLMOvU8xpBYuOmc6rpHXUTkQy3MTK2ufPmCgTALzUcANOpyod6EEvIiGInoAT
 VQGJsX+jzZeBXKDM9T51qJ2q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:21 -0700
IronPort-SDR: 5X8LNvEnu3HMaoF4Cu7NxlKcybnq5Ib5V76FkFphH2DCbhULWpEyGEEj9L7jxzqGPgIylSoIrE
 CG6wEX+gpJROG9fvCM9WWgm71/l5h3sxSRQ2dO+rwlOX1OJlnrSguV/X4nvNiUHsf9xd7EEWue
 d5jwlOLhX/Eb+sWcEGR9qWMZ7buRz4YX/elVXrzafzAodx4d8mw2S47FsMc6fw9ORCOUZ/mXi0
 CqwWCloAnGw5Q6Y20UeE7AxzmVY+I05Nsc4rZgW0KWqFZsf2b4fGabuIixBbitLLsZmo2TmFA1
 Qeg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:42 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 01/13] oslib: blkzoned: add blkzoned_finish_zone() helper function
Date:   Thu, 27 Oct 2022 15:01:27 +0900
Message-Id: <20221027060139.952508-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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

