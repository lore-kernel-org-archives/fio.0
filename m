Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:28099 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfH2HVj (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Aug 2019 03:21:39 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 3/6] zbd: Fix error message
Date: Thu, 29 Aug 2019 16:21:32 +0900
Message-Id: <20190829072135.2872-4-damien.lemoal@wdc.com>
In-Reply-To: <20190829072135.2872-1-damien.lemoal@wdc.com>
References: <20190829072135.2872-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

Use log_err() instead of log_info() for notifying invalid zonesize
values specified by the user.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index eeaeaa91..876246ed 100644
--- a/zbd.c
+++ b/zbd.c
@@ -411,8 +411,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	if (td->o.zone_size == 0) {
 		td->o.zone_size = zone_size;
 	} else if (td->o.zone_size != zone_size) {
-		log_info("fio: %s job parameter zonesize %llu does not match disk zone size %llu.\n",
-			 f->file_name, (unsigned long long) td->o.zone_size,
+		log_err("fio: %s job parameter zonesize %llu does not match disk zone size %llu.\n",
+			f->file_name, (unsigned long long) td->o.zone_size,
 			(unsigned long long) zone_size);
 		ret = -EINVAL;
 		goto close;
-- 
2.21.0


