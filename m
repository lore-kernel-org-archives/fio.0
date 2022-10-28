Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4ABC38A02
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiJ1LyA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJ1Lx7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:53:59 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C131D2B77
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958038; x=1698494038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fOqXgXeHnGLdRqz5sg76Gjr60bWCjMMUsQEqihUygmw=;
  b=Ry04BmNHfzvO7lk4mwIMV6tQa8N0wksAWLABSKOSa8plem+8hr22b4Ll
   P3Tm/s4MXLceM1hmVC+8ndcY9tZnaI0qO12CAogI43t2QkW0Y/ViE1Jr0
   Vw/E4DD+Z9V/Q53vtDpZIE0XzSV+66WAMeYfQHPvI/H6ZB8Wfu9qrRNpA
   yPm1FQi/CfYf7b/0gRd997YFqfO/A3C88D1W22jjfNysXt7x1pEHJjg+i
   UVMXiU/jrGd9EN9UyPgEVtQ+5MILf3TNEcXshnqUJbd/xU5y1NThwDo7v
   OxyXmTpKjBhAWKRx/NdLaTOXHUPKb600ofGcETdJEngmlLk3edHq7tYJP
   g==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074522"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:53:58 +0800
IronPort-SDR: oFy++Mkpwu0qzbKePBmVFvWmxrXr6Sue/xV5d6StiMWXqzdBct8Rbv49gZo+aaaF8Yf89s3xew
 WWW09jIfA70J/m31AMHynUs1dT5Xrq/Db6vqWJpFPnpEXdC+2JCDIKDPvnSxrIqJws5g1iLQiI
 z8EswBy7b4IGmgYKAqDpCFmVOi/QJ0Q7pVuYAsbrkgumdivbyi8o+MlenIQlCDMaxat9AqhFwh
 qvvn/EHxEI9swcSXIijSR/yybyE+GRDEphO2o1/ThEwEqDkAWlOtYdjAkhBlEM5LyJBol23ShI
 s5B4Q+qVN2Vwaik+vEUKJIiG
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:35 -0700
IronPort-SDR: RQ7sDoGyLW69EiNy6/0KZvTXGMxDcyOn/LkL/LejJnW3SgBaveNlo7X0hthHrbwU6ImXuclfXJ
 8bIu7sVjZU8JFjds/dUFftT5fDg9d61ShZJbFp6Lt2j2A2Tj5i4GfN9A4PwEKsEku88G3qb8vP
 iGFJe6LUIo170JIQgWMp47u7z1coj51mnVSxVjmFdvVz/fe6kziqwVegRU6qsGjt1w4MdNek5G
 8pNyU+ruxzd4QyjycZCnv01i+Ma4bSna3G2IUMsBW2mE+vA6kznSLPQ0tgQy/EoIpYAUXTzeZP
 qow=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:53:58 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 02/13] engines/libzbc: add libzbc_finish_zone() helper function
Date:   Fri, 28 Oct 2022 20:53:43 +0900
Message-Id: <20221028115354.971715-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
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

