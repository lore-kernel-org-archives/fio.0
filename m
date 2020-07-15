Return-Path: <prvs=4589743b3=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/8] zbd: Fix initial zone write pointer of regular block devices
Date: Wed, 15 Jul 2020 13:13:15 +0900
Message-Id: <20200715041322.114929-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
References: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

With zonemode=zbd and regular block devices, fio initializes zone status
as empty. However, write pointers are set not at zone start but at zone
end. This inconsistency between write pointer position and zone status
caused different behavior from zoned block devices. Fix the inconsistency
by setting initial write pointer at zone start.

Of note is that every fio run with zonemode=zbd and regular block devices
starts with empty zones. Then read workloads just ends without any data
to read. To run read workload, specify read_beyond_wp option. Or specify
two jobs to a single fio command: write job to prepare data for read and
read job which waits for the write job completion.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 8cf8f812..cf2cded9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -381,7 +381,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		mutex_init_pshared_with_type(&p->mutex,
 					     PTHREAD_MUTEX_RECURSIVE);
 		p->start = i * zone_size;
-		p->wp = p->start + zone_size;
+		p->wp = p->start;
 		p->type = ZBD_ZONE_TYPE_SWR;
 		p->cond = ZBD_ZONE_COND_EMPTY;
 	}
-- 
2.26.2


