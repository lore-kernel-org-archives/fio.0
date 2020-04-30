Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 1/7] zbd: bump ZBD_MAX_OPEN_ZONES
Date: Thu, 30 Apr 2020 15:40:44 +0300
Message-Id: <20200430124050.20146-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: adobriyan@gmail.com, damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

128 opened zones is not enough for everyone!

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---
 zbd_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbd_types.h b/zbd_types.h
index 2f2f1324..d63c0d0a 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -8,7 +8,7 @@
 
 #include <inttypes.h>
 
-#define ZBD_MAX_OPEN_ZONES	128
+#define ZBD_MAX_OPEN_ZONES	4096
 
 /*
  * Zoned block device models.
-- 
2.26.2


