Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9EDC38A2D
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbiJ0GBt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbiJ0GBr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:01:47 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C997AB17
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850506; x=1698386506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fOqXgXeHnGLdRqz5sg76Gjr60bWCjMMUsQEqihUygmw=;
  b=c3hevWjqR+XI7dYA4M7ljW7yX2Lw5qINzX7+hBu/4s/hOj1EpmjsqAH7
   VgZzkeGEBx3PegTiSmJLFeMD4CXqad1YzT9Vukv/UUvDDyMKTX23AzQb2
   KS6KzC2VyG5Eqhc4IPwm/KnfdMx3H00CTxwmeJ12jMdNNLW2xcw1N3Roe
   /1jpJ4WWEJlPMsq6U0YjXgdhKf2XWsivvaEgT4Mk5S2ihTjao6qKSuQ4k
   AW/CmgrlkCdUGjmijKvMM7/B7sFVEG71ZTlAXcoRwyHCpLe4DZYNlBy3E
   DcPEaAlY0OeG3LvtL/AhaeYJ0wIQbWidS+Mr/KkR5QTYYOlVRqeMHzawT
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="214845835"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:44 +0800
IronPort-SDR: awq94C0Cg7VYnYDtYWXJwq5pBNsCJ4lv7mLdwPeD4u/76uXs7LUE/QzLnNv98O/KfsqLoeAd+Y
 lNgT4+ulvZ+cGL4mJspTF6mICVSN2n4CEpXy3g9O14CUd03e3jU4moUz289S2dsM5fvfJoSjDT
 0crj7ZASXVy2rolAmx8cIDoKSJZdPSsjgg5hWz/LqSOnQFdjBRigEmzVVfWm1vGI5iNxXPESb8
 +sghEoBpue0xM/ELcp5exA4QDV4NT9v2CTjh/q0uPpDWiL4VcINAiWSOWnfnaQ/ZQZpb189waC
 B4AHpRia/cVitbVFxK9I0S+o
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:22 -0700
IronPort-SDR: K98nW88GQ7QEfDqQKtBTxwxS8EG1s3g/JJYnkk/BVz4lhCHPvTx/6E0TpO4dZuRi5MH+VE0pCO
 1RweKKMv71KHtBS3DbkAiF+oXAXSybmJVVD8c3pgxDfMooDS+9KsmL6JE+g35qi86UrFheQATy
 HAfcPGDsIRye2RxCmvlDKDewFzQOVgX5afIRiU9o3q51U/Q9HioWsi0Q3NQsMvtiBDkLdxRpQy
 1UYa/6qUZCaKnkQJLWp4fuoAmkYM8AO+uBPfbI+ZEsC2O7t2AXpOdyxNClc8HaySbeWFycQsPd
 afI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:43 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 02/13] engines/libzbc: add libzbc_finish_zone() helper function
Date:   Thu, 27 Oct 2022 15:01:28 +0900
Message-Id: <20221027060139.952508-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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

