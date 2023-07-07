Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBD3EB64D9
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjGGDPO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjGGDPM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:12 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B53C1BC9
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699710; x=1720235710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U6ZiDVRbXJfrmdjKwu/2vtFd2tLZSEY4V82tan0h48o=;
  b=YuSdATXYK423I5to8Vc4eWDboA5TOOHY4JOcpak0LbkIQp2c2N3YkTco
   gNtaXvS9xH/YvLiWvV2QuGO0wVuTqB4DPlvCxVzN9tkEVhkaWIyfSotWc
   c4stGFx8+Rz4aYNyYLSc/SOqrykGzVDPAcjV07+6lDmvBHReSdI/o4VgD
   alLmXmkmFjkAToH5Kmg8uQaQfK4O9UTedTU4eWT9vUTvKDLPFGoMqzGwI
   Dgul1A/lb2ezkQgG6slrqhoetMbIJ4mOgE8jOsH5NfliF2ehoqGTlQPec
   0VfQnruuav/lJ2HbQn5k6sfdOhKqRzLRj7iHVIrMv4bB7tfI1cnV5OeHD
   g==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468797"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:10 +0800
IronPort-SDR: kI0DJD0TpAombSKNXLNLDG8lt4p9DGGqpU0DHq3gbFBEonVC/CK+KUyEUDXBUNotdkKo1/EY5G
 A0xJs1dly/Q39rrqYuD6zYwg00i3WdxBtdON4GDAzhy5EoOqy39qYzeAOqMphIEALmoyxMnaX8
 VcAQT+/z05OOrtTN+PLm4U0lrlAcf6Y/1kN2lHMVukBFWHcyovKuM4OG2r1G6hAO4oY/aRTVW7
 S79KGn0q+bLMb0ZzY4PxF5+JuZUVtH4SoMLoXuWcHmEk92DWmU94FrxSzXuYlZ1in71ygwGHwS
 X2Y=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:17 -0700
IronPort-SDR: TjdoTtIFGXBNNjFju1r3uTx6P66b6Kkua5UUPPjqNPM5B4UFmVWxX/sUUIEUD0/prdGYUIB0lv
 EsqibuRe2aND3bFWjH2pF7/MOclIe9u4k6TDXwvgpiZkCUWtLAwDcSDPGUEl+aDLaDhrG590kV
 hOtQ4DREH7vEnv4/LxSO9z+2EP+mFwbMBogendck4Hf6JL4L1OAjnw9Byj7zYDwQQBMWlGJ1uZ
 66UUVbM2gnduRcIpXUvHOhbjXTAfhvSOn5Bz3PSXmOP82cqHsv9waZe/k1phAS1uvugm5JF4Pd
 sjc=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:10 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 03/13] zbd: print max_active_zones limit error message
Date:   Fri,  7 Jul 2023 12:14:55 +0900
Message-Id: <20230707031505.3468915-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When zoned block devices have max_active_zones limit and when write
operations exceed that limit, Linux block sub-system reports EOVERFLOW.
However, the strerror() string for EOVERFLOW does not mention about
max_active_zones then it confuses users.

To avoid the confusion, print additional error message to indicate the
max_active_zones limit. For this purpose, add a hook function
zbd_log_err() and call it from __io_u_log_error().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 io_u.c |  2 ++
 zbd.c  | 12 ++++++++++++
 zbd.h  |  1 +
 3 files changed, 15 insertions(+)

diff --git a/io_u.c b/io_u.c
index 27b6c92a..07e5bac5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1879,6 +1879,8 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 		io_ddir_name(io_u->ddir),
 		io_u->offset, io_u->xfer_buflen);
 
+	zbd_log_err(td, io_u);
+
 	if (td->io_ops->errdetails) {
 		char *err = td->io_ops->errdetails(io_u);
 
diff --git a/zbd.c b/zbd.c
index 3069ad1d..047489db 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2222,3 +2222,15 @@ int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u)
 
 	return io_u_completed;
 }
+
+void zbd_log_err(const struct thread_data *td, const struct io_u *io_u)
+{
+	const struct fio_file *f = io_u->file;
+
+	if (td->o.zone_mode != ZONE_MODE_ZBD)
+		return;
+
+	if (io_u->error == EOVERFLOW && f->zbd_info->max_active_zones)
+		log_err("%s: Exceeded max_active_zones limit. Check conditions of zones out of I/O ranges.\n",
+			f->file_name);
+}
diff --git a/zbd.h b/zbd.h
index a5cf59d1..5750a0b8 100644
--- a/zbd.h
+++ b/zbd.h
@@ -105,6 +105,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
+void zbd_log_err(const struct thread_data *td, const struct io_u *io_u);
 
 static inline void zbd_close_file(struct fio_file *f)
 {
-- 
2.40.1

