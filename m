Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09103C433FE
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiKHItr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiKHItq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:46 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187C72DA80
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897385; x=1699433385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fOqXgXeHnGLdRqz5sg76Gjr60bWCjMMUsQEqihUygmw=;
  b=FCGIc3hseO5hXEO1gsVmPZ/rg4J9ox2frUNqYG/37PZdnTX411sM0lRE
   8XVOSu3SljMEtu+CkZhErkrZ5JsZtUrk+nbV0TzmNBiF0jtQyaaTdWReV
   sLVdN85UvmgM65VxZOC7zoFwuszy6p5j4QdLMlKA7iNE7cR/QNQ/Yv/tx
   l/jJipMrBxNR/fIoJ92zbB01D64qJ+mcrVf/3dpSjQ9Z3nAfMWI6Ma47C
   5hdQcESab17ISBl49+yv1CaJzdvn+ywfEb2/J7pVCdykK4lVTrAdSH1i4
   0hKoeoKp9h4eMLjH9Tjt5n+7mE63peHNMCAIzZ/kWHq68RfKUCoo16RTp
   w==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="320079424"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:44 +0800
IronPort-SDR: iEqTAH1ICKtYIFvyQosxeQVKJlEtaY53vntPXSkNiZb4K5hF0q+PCIYuU6h0mjcRwx+Onvgtw8
 8/fnJgsX+7/TkUHuTgwAXrM/laSLzrsrRmHhckGKPPpZbIwEVPXR7qggfCxfAqEJ9xI6qQCQi6
 UBFphYpCmyuAItN4cLqHQWZ0CadyG+s0cp46zang0/Lb50MZBq5dwvZD/IKCcZeh7ctlfX28gx
 lLWUIHEY/BDAtLXr7Lqwxyp9REie1yzGO8zyVd0P9dCaBFLKjKa+FC1m22+r62mgGGpsgXfWKl
 Uuk=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:05 -0800
IronPort-SDR: n4BRfyqIFTDmtvUa23dJRQ07e13V71W48vrgmNspqQKNq/+R0ApFMnHSadfQl08qKjuW7KcuYK
 sYjLXtS36TAkslRCOu7OkadJ7IjgqudgSKHth/q0niKh1EAmReiUZ36Yo4jnb87AnlmLwveFQd
 aPICuONFvqQ0eFUGUSKCYigURYlBf8YEvQIu/Vkz0SQKmLLn/dKrtPlXkFWjPaGIhHcIL08vSi
 J5ipqiLCSJMfveCQccsWTEcA//CEXVAzuNBIAGBRfCQgZOAXlIfacmduHlfmhvNYOA9bNL525X
 tdY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:44 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 02/13] engines/libzbc: add libzbc_finish_zone() helper function
Date:   Tue,  8 Nov 2022 17:49:29 +0900
Message-Id: <20221108084940.1574939-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
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

