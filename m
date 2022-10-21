Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73905C4332F
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJUGeY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiJUGeX (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:23 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FE4C18
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334060; x=1697870060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xdnI4KBWc2yqSuv4rRzdjwuUbD1Hzen4O0EmBQmyIjc=;
  b=ILoyWdy4l6BZIFJrV/+GcZ/zJN9SVYvHuw6jPSKmKlVSypo55aK/o2UE
   bUvarZMjPamrtr7QiVoGuzmGfXIdHUHqENfjlvDX4hkZQRDkw7UVQkqZ4
   +brD8FTFBlq7R/rWhUuVqESYyfVPhn6vpOsLIDq3vnElCoc9PrXZQSKCU
   lZrY8f/USDSASdGup5YJHSR84bsf1dsqSUvy/HjXT8Sk7MwRrljrp+oxv
   ixangx/v43FBFPhcyEn72A4PgM+ophWtwQyihL8/1gMdmg4JaRRWpwMkV
   3kaAfpo9cw85hLMJD9hYLpscAgFjaJRFKApuDbl2AsbVgFfNZPLQX62Oa
   g==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733099"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:19 +0800
IronPort-SDR: aYDoZUieNXCLjKnqXBq2fbLAKuUjkq122i2K5Z1gf33mo2Zt1hi9VcvtE2V7yNXQSki1D2g7lM
 rM7VxYapZ2PKvvo4LaTQvZ/OktdRpIppg7TR1dbJtEWQfBb19LfxI4x8rxkomFWjPspMT1nXZI
 W58zbJ0AKOyn8Z9CC4WrTa+W7pVlzJTWi6+1tzEcwz0RBEgtK6eftwchvWW0f2Gjvl9YdFmCec
 qns8HCIHj30Qa55dY1ml8MOmVJLM6ZpA4D8QmM9HEITtzEa3LwsljO5lbHoKwAJAedplhyhXVx
 6OWT+L572fbeO/KHmuvJKfME
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:07 -0700
IronPort-SDR: SbwvalveEuuKmCsxaiFAbAt3oKa4bGNSXmqZ/A9L36IoQhu1RSFTDRFpYi7cVD2yCtAUMrz9kA
 GAzGzA+llj2F/aKgpkuYgoxOrUen1We1arLt2fDLD54BrSBAu9AvCryeS3KkjjkRnrppDxtCNH
 CyaVQyMbCHH/NECjM/7HiyGqdzhN57IxaafdMmUJeRG3MKP6CtYhlhtEdwf0G3SUbH70qK/Ifh
 rqSEDk1XNHldw9gaF8e8C8TZHqF6FGBHk9Oy1h7vviH3x365eA/YVQlS9onjuFgtRrloS4zHu6
 sd4=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:19 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 01/11] oslib: blkzoned: add blkzoned_finish_zone() helper function
Date:   Fri, 21 Oct 2022 15:34:06 +0900
Message-Id: <20221021063416.860438-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
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

