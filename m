Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:36544 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgDHBy2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Apr 2020 21:54:28 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Fix build errors on Windows and MacOS
Date: Wed,  8 Apr 2020 10:54:26 +0900
Message-Id: <20200408015426.1609539-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>

Including dirent.h is not needed, so remove it to avoid a compilation
error on Windows and MacOS. Also make sure that EREMOTEIO is defined as
some OSes do not have this error code.

Fixes: b76949618d55 ("fio: Generalize zonemode=zbd")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 2a324d34..f4067802 100644
--- a/zbd.c
+++ b/zbd.c
@@ -7,7 +7,6 @@
 #include <errno.h>
 #include <string.h>
 #include <stdlib.h>
-#include <dirent.h>
 #include <fcntl.h>
 #include <sys/stat.h>
 #include <unistd.h>
@@ -1235,6 +1234,13 @@ static void zbd_put_io(const struct io_u *io_u)
 	zbd_check_swd(f);
 }
 
+/*
+ * Windows and MacOS do not define this.
+ */
+#ifndef EREMOTEIO
+#define EREMOTEIO	121	/* POSIX value */
+#endif
+
 bool zbd_unaligned_write(int error_code)
 {
 	switch (error_code) {
-- 
2.25.1


