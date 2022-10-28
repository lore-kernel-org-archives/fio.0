Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F0CC38A02
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJ1Lx6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJ1Lx6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:53:58 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A619D1D2B77
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958037; x=1698494037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I6UAzvilVVoBBtzWSSmri4OR5oAhhrOEZg2sx+LueRM=;
  b=rZkmb9IMHMNQ5TRSDId2MN8gS4NyETJibN/gDDpdeBRP6eCXD2maMRVC
   trdBj9OIfHVrP2pYloBwwcdJN5+g8eZxH4OY+rdv4I7hCn5M+MWkTvEaF
   9+rtqMxIOBSnL3ByuScxxKzNtkeGCjn2vU8IHoBiEyNhgkJhijbMKtqFK
   D0B5PmXIIJdJBXG0uwMk7Z5854nEtRLbw2H7R0uT3/nezp1HneHzH5oeg
   yaewrxXFwPO6HLXywNPtqF9Oxc6iIGOX3cyeW4u3DF6VKfs9F3DOyGk9a
   k3p9K20/CnqSYXG3oJNnZFUlVPNfZzaCbHaxrdMVCe6TQ2UBtRmH3NafX
   w==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074520"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:53:57 +0800
IronPort-SDR: rsDLGP1KsGOkm7r7hMg43ltVoXgz9qYuhkEz0+IEdO9ui2iA7YEjSyjPoQv0uDjG85A+lDdEBy
 j9vKNpz7HlvxMMEfLYT10NzRH7E82kpmspd/klXttPcuDpUDmugk0C50/qwwYEjLScCXkBWHDM
 qwJJfDhWkkDIpQYXqQzKSdAVe1E5P2d2b33RBGPnbbsDSTZl0WUbynQV+YdDQXpn+684NEN8Ib
 TOHZw8WMwzLHn62lLnDW4McKxt2MJO2cSZbHi37NngKCQS35FMlbsv2drQ6w8ZuJNnS5Osgz+6
 YPPcagV6Mc0UraSuZDvmbr93
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:34 -0700
IronPort-SDR: g+kjnDjUkQoZiGieA0mqh6DdHzqO9b6Q6LIuSkEaley/FBT07zPNph32XIWS03fE92EuaKff68
 HKkz9yg9EGdR2CDKzSLowiCvnGNb8fdf2UZMCSAyvAZ+sA41hudS6oS22MRIQ+rnW/ezp6RARW
 /wCFGIjLktreq2TGeHfcaoZEIspbK0tLJMtHJqj+kzxls2Rrg1eKBTYwNlMyBwmTPtXdRCGhDg
 bvAW8z1VcN2nYFhYIiDr/Nvm5EWGY/ww9Hv2dlCRdo97730TJTdVv3wtC4jnaXDKW3u7z0gfnX
 ZHk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:53:57 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 01/13] oslib: blkzoned: add blkzoned_finish_zone() helper function
Date:   Fri, 28 Oct 2022 20:53:42 +0900
Message-Id: <20221028115354.971715-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
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

