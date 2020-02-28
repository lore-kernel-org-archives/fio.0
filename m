Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34680 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgB1HOl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Feb 2020 02:14:41 -0500
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 1/6] zbd: avoid initializing swd when unnecessary
Date: Fri, 28 Feb 2020 16:12:43 +0900
Message-Id: <20200228071248.3981623-2-naohiro.aota@wdc.com>
In-Reply-To: <20200228071248.3981623-1-naohiro.aota@wdc.com>
References: <20200228071248.3981623-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>

When enable_check_swd == false, there is no use to initialize swd. Just
disable it in this case.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 zbd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/zbd.c b/zbd.c
index ee8bcb30416a..ddf1e6f3e008 100644
--- a/zbd.c
+++ b/zbd.c
@@ -847,6 +847,9 @@ static void zbd_init_swd(struct fio_file *f)
 {
 	uint64_t swd;
 
+	if (!enable_check_swd)
+		return;
+
 	swd = zbd_process_swd(f, SET_SWD);
 	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
 	       swd);
-- 
2.25.1


