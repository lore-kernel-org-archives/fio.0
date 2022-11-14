Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9683AC43219
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiKNCNY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiKNCNW (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:22 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6639DFFC
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392001; x=1699928001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fOqXgXeHnGLdRqz5sg76Gjr60bWCjMMUsQEqihUygmw=;
  b=AfFXNGAewYmq7A0Uz6wn40HjgiTxNoNmZsbBabdDMXUUprBmlutjHXh3
   VcfWMEqXJn+HmJYCMU1Xb382cSP1Y1TxM9xEpYUbnGuQBaavAT3D/Nu2h
   ZlhzeLtuRowPIVJJBWYVbmYmu8fJ6XlzG7iBgFHqBSwftqMZ68waacFnE
   sVKvMeOdwDcfYoEBFy77s+b30QAoTZnwToiU8igZHbtsiLZrCy+LdcX0z
   /FBmgkgJIrcJ0hRLO0wUFDNhFYP64r2D3Oe6nujt5lCfXBIsp0z792sMt
   ygOKd1kDPHUB2IyfV3UzAMqLaOqQzSOafK/Pte6F2fLfHxOH7Wv3UcQNa
   A==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279214"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:14 +0800
IronPort-SDR: WfH8Cdl6EKZmCVMBDhpuKJ+rRNXNSJ2EjJCGwBG/5NgfofKqk4hQJV9VjrQUIIdKF9HwpltRjG
 zSVrV7QxPAWgLfRbRSN0pSvyISBEYnS9bmoKqgAgmpJk1McSHbqrYLzdDTm90aiR6mIgl6DbSW
 aRDdwXil/QaareeG/Tv9ju3W8fO7tKxTP0jVJLyaH7qLcaNYanoaLLjFGXoaAPR/sJNXmwCHQW
 xv7KYn9JtafJNl0uQGmUjF/cG9LjSJA2Rti8xNv4ioDdtKeRBAEFfCFmTmx7Pmrs2uOb3TFISA
 vhg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:14 -0800
IronPort-SDR: iarFE2zz0KR78vm1Q7BFmo3edvUGczFbHwxOzEqeW2ANvgDkbK+zxeBgY9t4l66uy7IlsjEmIk
 INP/sRO+RuZe9QAZtMiTPydraXGyPBw52x/baDgXjJ1Na08G/eRhPsdjpr/BtXulfitJBjclJr
 VPnMe5J8U6qRpV6n1PtUi+vTzli+2ybT+lqzl6D+1UAWhWpMNsGnPVgfgK1wLLt4HTgfiAwvbT
 MRolCJ3ij/BoTFj++NUReVJSsNMWL8xYnyWEUKMsdyjsBd9F/7Xe2+T7F1UTXUgOImE4UFj7uy
 Bjo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:14 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 02/13] engines/libzbc: add libzbc_finish_zone() helper function
Date:   Mon, 14 Nov 2022 11:12:57 +0900
Message-Id: <20221114021308.1684141-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

To support zone finish operation to ZBC drives through libzbc, add
finish_zone() callback to struct ioengine_ops, and implement in libzbc
IO engine. This feature is used to keep the same zone handling by
zonemode=zbd for libzbc engine as other engines.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 engines/libzbc.c | 34 ++++++++++++++++++++++++++++++++++
 ioengines.h      |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 2bc2c7e0..2b63ef1a 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -332,6 +332,39 @@ err:
 	return -ret;
 }
 
+static int libzbc_finish_zone(struct thread_data *td, struct fio_file *f,
+			      uint64_t offset, uint64_t length)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	uint64_t sector = offset >> 9;
+	unsigned int nr_zones;
+	struct zbc_errno err;
+	int i, ret;
+
+	assert(ld);
+	assert(ld->zdev);
+
+	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
+	assert(nr_zones > 0);
+
+	for (i = 0; i < nr_zones; i++, sector += td->o.zone_size >> 9) {
+		ret = zbc_finish_zone(ld->zdev, sector, 0);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	zbc_errno(ld->zdev, &err);
+	td_verror(td, errno, "zbc_finish_zone failed");
+	if (err.sk)
+		log_err("%s: finish zone failed %s:%s\n",
+			f->file_name,
+			zbc_sk_str(err.sk), zbc_asc_ascq_str(err.asc_ascq));
+	return -ret;
+}
+
 static int libzbc_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				     unsigned int *max_open_zones)
 {
@@ -434,6 +467,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.report_zones		= libzbc_report_zones,
 	.reset_wp		= libzbc_reset_wp,
 	.get_max_open_zones	= libzbc_get_max_open_zones,
+	.finish_zone		= libzbc_finish_zone,
 	.queue			= libzbc_queue,
 	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
 };
diff --git a/ioengines.h b/ioengines.h
index fafa1e48..11d2115c 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -61,6 +61,8 @@ struct ioengine_ops {
 			uint64_t, uint64_t);
 	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
 				  unsigned int *);
+	int (*finish_zone)(struct thread_data *, struct fio_file *,
+			   uint64_t, uint64_t);
 	int option_struct_size;
 	struct fio_option *options;
 };
-- 
2.37.1

