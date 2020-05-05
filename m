Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 2/9] zbd: bump ZBD_MAX_OPEN_ZONES
Date: Tue,  5 May 2020 20:56:28 +0300
Message-Id: <20200505175634.2517-2-adobriyan@gmail.com>
In-Reply-To: <20200505175634.2517-1-adobriyan@gmail.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

128 opened zones is not enough for us!

4096 opened zones is OK for 64×iodepth=64 stress testing.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
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


