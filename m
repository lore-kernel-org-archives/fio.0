Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABBEC54EED
	for <fio@archiver.kernel.org>; Mon, 30 Jan 2023 02:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjA3C2z (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 29 Jan 2023 21:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjA3C2y (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Jan 2023 21:28:54 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0131CF4E
        for <fio@vger.kernel.org>; Sun, 29 Jan 2023 18:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675045733; x=1706581733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ibVgClyQ36np1k0srJkuY3srr/5LFiL9SlqKxIgyrs=;
  b=NcLrpafHgV7S3xau6+WA5sfWqbwDDzDwSH4hq0fdYYp93ZDSY4FK5DCK
   5NO60crB7ViJCIhdUSNbSrUGnm04moSUVeulGpbqP8wF5lAfBxTLkpBrW
   RoTcsnX4BWk7QNjYvSq1YmVPxBIDrDPLQJYb1C+nR8tgOEZRy0etpYn+f
   jZl/fbp1UyO1dyYYcLqqh5+yMRwUQ1n0fUJYgJ8Jsz6Vi2UqF3MfwsAGb
   3Y5Xt0VFSTojBzNmW+iJeOz2NbpQKJC7Jh7XyJti+9TsvzGtVVYGJkJjU
   7D3oKs8hErrpn0j1gNHhisV6ZVH4UHbUxvVhI273tuq/z1WiOHf2Xo/da
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,256,1669046400"; 
   d="scan'208";a="227010380"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 10:28:53 +0800
IronPort-SDR: Wmq9t0vGK4J5FoX4tPPrxP+qm6Y8yFb5lq/BWye1k/2CApVvdTwmQnZdNFSAR9vp94D9j0FITX
 mu5lozJ/i9U60ls976KMsj8wSQV8K5wI9GORaS6xPacBD5Vnf8QJ17QQ6hZZWKo567d+oIT4GF
 rDzQKVeX9dwzmmsMhGGIKGlasCl4jD8CQuEJo2+sRYiQzZHvDSsWcRdZy32cfATsqMg/u+DcOx
 xKEWUr8ojeBzkUmsxnBSEVtwl4XKtykhslEgLooKIIxHGZA6AyYsv3G3gdCWISXGoQRx2FmJwD
 QR4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Jan 2023 17:40:35 -0800
IronPort-SDR: K1CmZyGpFz47nzFs5pj4Rcpg4Yre2zQ7AQUiQMFUJ6C6eE1UruOvOx0Xb4kra7ULR8ieraZTyP
 KF8t9AL4PrKEUH3Uos3NUXLGZsm52ZWPnN3A0oMFnEh5B5aRDsnbLRwu4ME2wCnuLNSSkF+q+W
 K3ZFEYbZP7HC3kG0gg1x1I3Y8J32+Dj/jnxZQFk90w/tgMdusq6DqHGLSDxveTdgMvXrg5sWdZ
 WE2zYcA0Q+6K4kBUE/7gqiTyU0lzVPRpAIbf2JyZVXYDRjoLUKp0+As1KzdWhaiKIzI83n/8OT
 F4g=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Jan 2023 18:28:51 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/5] zbd: refer file->last_start[] instead of sectors with data accounting
Date:   Mon, 30 Jan 2023 11:28:46 +0900
Message-Id: <20230130022850.1375523-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
References: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

To decide the first IO direction of randrw workload, the function
zbd_adjust_ddir() refers to the file zbd_info->sectors_with_data value
which indicates the number of sectors written to the zoned block device
being accessed. However, the sector with data accounting has two issues.
The first issue is vague definition between accounting per job and per
device. The second issue is job start up failure due to zone lock
contention.

Avoid using zbd_info->sectors_with_data and simply refer to file->
last_start[DDIR_WRITE] instead. It is initialized with -1ULL for each
job. After any write operation is done by the job, it keeps valid
offset. If it has valid offset, written data is expected and the first
IO direction can be read.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index d1e469f6..8d8d5747 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1801,8 +1801,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
-	if (io_u->file->zbd_info->sectors_with_data ||
-	    td->o.read_beyond_wp)
+	if (io_u->file->last_start[DDIR_WRITE] != -1ULL || td->o.read_beyond_wp)
 		return DDIR_READ;
 
 	return DDIR_WRITE;
-- 
2.38.1

