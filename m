Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BA8C43217
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJUGeY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJUGeX (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:23 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807F921AF
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334061; x=1697870061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fi+1BDKxLNSYwWYwPqS+Pngcu+HmIyHeyz3NPTPuGwo=;
  b=YDyq3WiBaAEp9lp74/gvRNyDEl+Ilyo+hi4bQxKBO7X1SgmAgBpKKPjk
   sm9s4NOpSwWWEkN7y5myY3tBnnCxcJENhhwB7t7dDNeNTw76GXOlqNTI3
   Xh87TCyV33fTdhvuxlAaPfu1F9yBcJRET8icFMTyC5/7MjqMuAxZhCL+1
   hgUb0xiEVNtHJ6NgnKvPkJcBywEN9Ct6DQCGtyGpd7LFUIYOeLBUelCyn
   dxpjOyXK/0wYrr1prEd9y2LskIbzHQpQGVfiZ2JhEpyhpiTWgh4sZNXX7
   QpBlGvNOJfyb7awL+yeBj3SD3T15a8Y3W76q7dfOBRZ5llu0LcZX3hSx/
   A==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733102"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:20 +0800
IronPort-SDR: HiTlLPpsa5AGi0yGJOuxvWnPUgottQM32JBeD+s/epCDXAZQvkReHcMLA6I9/EyPwnZwOsdM7b
 TIp5TvBPg5F3nxIcpbeUSruCqt8IOSiFb6kRi3eN+xlgCDBEwCC99chm0/8AManZ03Om4mvLxD
 Dr5ofBAGY7EUxI/ZudfSqVGmPyJDLeGk6pM9Hd/kjO6ZGUFoBCdkQXD2ktZC9LOM0eBvfIRmXz
 o+A5Cb0LEWjmrelcf08EeFBbECPSrb0RFG0uwCuStt6f2aBiv/Uk+Oc0bJPrgieB5R7L6ngrdo
 2+Vi8UpPgXxgjcXYS7/H+hS/
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:08 -0700
IronPort-SDR: NVK3ESDLSygzKPaGsYq5KUF2Q9FkJI54tgbc6kbQ6bd9Jbl8j5Za+vZJlWQY7YAd2/6Se0DzXL
 nQZbEoLmaB41hXB1lnChqQRscxsIomWtLjB/TTAutU1Z99EnNipFXIcYkuSIKAV/OWj6GN8y32
 SQxMA0PPNYD4R84tF4SbEdVZX1GyQRT87HQWQbu3ZaE+megfE+ziuftpuv/WeqWeNEws9uhfjN
 LdhT3r1QCSiG9c7J91bPCsCIb3zoBdongr4mFSF+hKyCr/Ojlj6ER+bBhzEWsnhFnakt2AhFvW
 4D4=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:20 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 02/11] engines/libzbc: add libzbc_finish_zone() helper function
Date:   Fri, 21 Oct 2022 15:34:07 +0900
Message-Id: <20221021063416.860438-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
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

