Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C4AC4332F
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiKNCNW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiKNCNW (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:22 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB68FE009
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392000; x=1699928000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I6UAzvilVVoBBtzWSSmri4OR5oAhhrOEZg2sx+LueRM=;
  b=bUmszEzMI4NnYnCxmxoklLOAmnW5L6DVrPAL1bU72kG2Jb4lw06MW3ky
   dAttqBdndbsPwC8w6qGQc1oKkVtmsUv3dPmBjuOJsfbxayxhtsjfjvwWv
   0ZCt1jNjq/VPmLxLMsFwRzFc9rR1mocJLtxNpBdFMzNLTn1A7nntQ1Xkc
   k+seqJYqY+fR1a+jZh+FURO/iN/bXsdZ3pfakujhw1THz3nCzdLa20iZS
   QKH22ZIK3H8as4RP2aLhCojX155TUwwx75foCNUFLblGAoLNMZWrFjUiS
   3KFVmGbrXqO70VT0KfXje6vaHHJ8ea6IThBnID88w8OxiRFhK/kjQ2sFC
   w==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279207"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:12 +0800
IronPort-SDR: FDoZXTrQMdapCMY75Vfdty5SIhMrs6+0Yqtla2KoYNP8Z8KvzebHk2B2xdXk3edZha3KPKSXUa
 l//Hk573iSE9S1em0P+Ae7hnVuJ7JeJJKCypOgCk92nQJGUE/E82RdGe7XXlSYSLNKLy20snZB
 3JN2dMk+4R7zeZt5iokGGNw4mqCF5UMZJrcnGeJeKim/1kB++86oXUSfffZo59LhroHVEz6ZM8
 VQ1UNoocmztcut21Trocx28VhVZagGyalmAKUiK+BwjZFfgzE4b2WgX02cJpcLLTrzjKiNzUU8
 wGc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:12 -0800
IronPort-SDR: L92WQUGRaDffc8PShk7Zv+Dv6iZlPksI8tJ4JHQeemUg/MF6kJFPsd66DvXjcLsqvswXH4sssx
 I2wVn6QsInDKZbdCV0Lch1n1dfQdc3a5jY2oNOwKtJHHXRV8N69fUWDpkjqkw2POeXKTNPvdta
 2NBOkuj9+YxoDTWKrBb3q+6RUo71+4EJOjGf+uLY+JEMDy+nc5Eq4IvXL/IppK08aKpPJwOJGT
 4LO9Os5srL/MDvU6UkLthgdYzXt1zk6Zu5cR9kITK8F8+Lt6QEXdHz5DQbL3/5mKIm+EbKjnG/
 cpE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:12 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 01/13] oslib: blkzoned: add blkzoned_finish_zone() helper function
Date:   Mon, 14 Nov 2022 11:12:56 +0900
Message-Id: <20221114021308.1684141-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
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

