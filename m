Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F54C636D4
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBIHJS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBIHJR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:09:17 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FE31C32B
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675926556; x=1707462556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XwVip18Q6n5KBCP1uPRXaE/z7LPA8h6odz7zyuvnbhg=;
  b=IJiWivsm8hYO9vOT1IpFVq2CBWk8qlWaCnp7ABZYK524VSR9GXvEuUzV
   JeznDDZhRfVfWITXi1drN9xcdfb4Lj7Jmhxv98koA9tw3U1pwTcwaGX2n
   /n8h7zNt/jZrtefm43So3SYJLipqgQ5hpddVP0RXavJlCO+pTGc+FgpIg
   5kG2p0/OSDfwYxpEM02TpUVnNui+i2B/+cr1oyfPkHKsIsRe1EnPzwlsE
   JnOPFt5mElRF3AMYdhJfWcuSb/LX13+bUZ9OfVE8eyNY7jc/K7CXotNZB
   F2kFTjgPoOV+3CE5k2KkRNqg95K2O12KYyFHmsaOy3jFJsmqAHSjEQeVq
   g==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="334848077"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:09:16 +0800
IronPort-SDR: /DXfzGfGWDCBsE1BSV6wQhMPkFXwufKs5+O3XUNlGL6EFNmRn/XmG9gowka8E+URSwzlo7EZyV
 8Gh7UmhymoFZpE0alGioTHzjO3I/SkrGfua5uX9mh8c97+JxQTLj4iW39l1FjwOCFdGzdvTzwo
 cxmkjSN0QYw9ibhowa8hTyy3C4AshnuzNGyZCY2kf/bUCDWkdKKb9LzVlgYl7DZr36N04LutWQ
 KL3Ov1p9odJZdlJ5tpoGuAqpnh1cOFCHI8LBBWrSyjrf0V27VSCk5xkga7zlNaziiFNp6Epo7E
 QII=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 22:20:46 -0800
IronPort-SDR: TZqzi09z41k7YLpV2ktpcdJyB+zyT+ULiS2QUqn7bkmL5o6deM5UCJ4hXqbwY8Fuj6jek7ggpO
 tjYzpgcZsVaCiNIGmO8b2zw+8z5zN2hv4yCpOCrkEo0O1ea7EJcNW6ggtHixBdAql8W4tzypO/
 H4zWlpZEji6iC42ei3cTKrzJeq2I5Eu0rgfDxLVvcLwMkrVBD6+w+VOqwOY91M3irYHyoDXBQt
 ld9LJgjbKfQWc/sriOKXjxMLT8eem8clhOzIgdildX4TjSdS5R9JA6B7udS8eOeAp27KYToMIO
 kcQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Feb 2023 23:09:15 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 5/8] zbd: account valid data bytes only for zone_reset_threshold option
Date:   Thu,  9 Feb 2023 16:09:04 +0900
Message-Id: <20230209070907.1733138-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The valid data bytes accounting is used only for zone_reset_threshold
option. Avoid the accounting when the option is not specified.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/zbd.c b/zbd.c
index 455dad53..6783acf9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -147,6 +147,11 @@ zbd_offset_to_zone(const struct fio_file *f,  uint64_t offset)
 	return zbd_get_zone(f, zbd_offset_to_zone_idx(f, offset));
 }
 
+static bool accounting_vdb(struct thread_data *td, const struct fio_file *f)
+{
+	return td->o.zrt.u.f && td_write(td);
+}
+
 /**
  * zbd_get_zoned_model - Get a device zoned model
  * @td: FIO thread data
@@ -285,9 +290,11 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 		break;
 	}
 
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->wp_valid_data_bytes -= data_in_zone;
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	if (accounting_vdb(td, f)) {
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		f->zbd_info->wp_valid_data_bytes -= data_in_zone;
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+	}
 
 	z->wp = z->start;
 
@@ -1195,6 +1202,9 @@ static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t wp_vdb = 0;
 
+	if (!accounting_vdb(td, f))
+		return 0;
+
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
@@ -1605,10 +1615,11 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		 * z->wp > zone_end means that one or more I/O errors
 		 * have occurred.
 		 */
-		pthread_mutex_lock(&zbd_info->mutex);
-		if (z->wp <= zone_end)
+		if (accounting_vdb(td, f) && z->wp <= zone_end) {
+			pthread_mutex_lock(&zbd_info->mutex);
 			zbd_info->wp_valid_data_bytes += zone_end - z->wp;
-		pthread_mutex_unlock(&zbd_info->mutex);
+			pthread_mutex_unlock(&zbd_info->mutex);
+		}
 		z->wp = zone_end;
 		break;
 	default:
-- 
2.38.1

