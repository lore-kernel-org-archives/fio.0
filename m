Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 01/36] zbd: return ENOMEM if zone buffer allocation fails
Date: Thu, 24 Dec 2020 11:11:44 +0900
Message-Id: <20201224021219.189727-2-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

parse_zone_info() function tries to allocate a buffer of
ZBD_REPORT_MAX_ZONES zone descriptors and exits if this allocation
fails. The problem is that it returns 0 error code in this case and
the caller may interpret this as the success.

Just return ENOMEM if we can't allocate that buffer.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 9327816a..ad1ad1a9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -443,7 +443,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *p;
 	uint64_t zone_size, offset;
 	struct zoned_block_device_info *zbd_info = NULL;
-	int i, j, ret = 0;
+	int i, j, ret = -ENOMEM;
 
 	zones = calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));
 	if (!zones)
@@ -475,7 +475,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
-	ret = -ENOMEM;
 	if (!zbd_info)
 		goto out;
 	mutex_init_pshared(&zbd_info->mutex);
-- 
2.28.0


