Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39ECEC001B0
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjGSK6H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGSK6G (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:06 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D52919A
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764284; x=1721300284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mL3TCnx8k2I5VdSpxeBrTT3qSGNB3WqaTWPPcdCQZlk=;
  b=gXVoVp7q+H2fFTz3eELYyimA0d+eJm32rYuK+2Tfp7nrt4XmxOv6a/h0
   G0pe6CIfsudwbQg/bY3Z2QdoU10WLS94ExHpO7kqJHvIS7U0CAoHXy9Mn
   yB6Us465wF+4QdGJQk6164uZB0v4p6L8JoQu889JkqZ0WYvBgU6R++K5w
   lVH+9xCcvo4omZApSK4fdTR7faIp2aUBZ4NVc0OyVHPjdLiv+0qjeLfqx
   jsZoibHAF3HFp45QbTDft5rBpwcx3pZJ0JDxZZA3QmfaPF8oicjiP1+ON
   Jo88Y8eXnnINpRBskvA8gF1A3Jq5U+FkKduG92i5f1SK77UvDnNxZ8zlI
   A==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860321"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:02 +0800
IronPort-SDR: zbz0HBA564Uy7/qXOpVAwjRA8CG0GDd5SrOQN8Edy/rpZ9HlN/M6uvqORq6qJ/9OQIwLbev2Og
 QimsdpMCc+xidZopBIdmuGnMbpVv6OmLe9Jf/dgW5BpIejdrKSTCucThgEdKLFGkIDUGMAfTyd
 BraABOOslbsKGJuUjFim69tTuR4yk0JRCLKgRaH7sFKfmEykptLIp6NcGuQlzRhOenzVhZ0jtE
 fiaigKkspw2bretU9enVtiYsjl31De16rpK+kp05+FMiiiTYONHKuKfEaLv4tqYs1ieP74UY7f
 DY8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:13 -0700
IronPort-SDR: JD3mJTlX33bRfkDUYoPvZ0fPjVExHTqJwHEqVbMiwqtSVzwooXoiyNuyNIiuVmnoZ7wJckxvSe
 V3Dd0tpD2WZ8W0rw9owiFZrw4H/4eIduq66sjoWE1/FBnvWRth53C2D6P2Ya3OTu1RB48ZMlMQ
 9QDECg4WSzxM07HEtok6kFPY1zdD3/XUCgrMODCbmUR3tYEUgAe+69Rhfwy53SOSv7DHpI+vB+
 9uJMsWd3lvvTbZjkdwo26P4HlRhoSBaUfEnZ5Fm5zwKnBGdYsi0F9g6xgPJA9/F8nlCa8sO7QQ
 CAs=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:01 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 03/13] zbd: print max_active_zones limit error message
Date:   Wed, 19 Jul 2023 19:57:46 +0900
Message-Id: <20230719105756.553146-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
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
index b05d2360..caac68bb 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2243,3 +2243,15 @@ int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u)
 
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
+	if (io_u->error == EOVERFLOW)
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

