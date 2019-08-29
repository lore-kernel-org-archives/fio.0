Return-Path: <prvs=137559805=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/6] zbd: Fix initialization error message
Date: Thu, 29 Aug 2019 16:21:31 +0900
Message-Id: <20190829072135.2872-3-damien.lemoal@wdc.com>
In-Reply-To: <20190829072135.2872-1-damien.lemoal@wdc.com>
References: <20190829072135.2872-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Fix the error message on zbd_create_zone_info() failures to a more
generic message rather than indicating a BLKREPORTZONE ioctl error.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 09ddcca4..eeaeaa91 100644
--- a/zbd.c
+++ b/zbd.c
@@ -559,7 +559,7 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 
 	ret = zbd_create_zone_info(td, file);
 	if (ret < 0)
-		td_verror(td, -ret, "BLKREPORTZONE failed");
+		td_verror(td, -ret, "zbd_create_zone_info() failed");
 	return ret;
 }
 
-- 
2.21.0


