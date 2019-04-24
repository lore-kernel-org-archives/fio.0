Return-Path: <phillip.a.chen@seagate.com>
From: phillip.a.chen@seagate.com
Subject: [PATCH] zbd random read conventional zones
Date: Wed, 24 Apr 2019 15:47:41 -0600
Message-Id: <20190424214741.21554-1-phillip.a.chen@seagate.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: damien.lemoal@wdc.com, Phillip Chen <phillip.a.chen@seagate.com>
List-ID: <fio@vger.kernel.org>

From: Phillip Chen <phillip.a.chen@seagate.com>

Signed-off-by: Phillip Chen <phillip.a.chen@seagate.com>
Initialize conventional zone write pointers to full so
zbd_find_zone will accept conventional zones when searching
around a randomly chosen empty zone.

---
 zbd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 2da742b7..616c3e0e 100644
--- a/zbd.c
+++ b/zbd.c
@@ -418,8 +418,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			p->start = z->start << 9;
 			switch (z->cond) {
 			case BLK_ZONE_COND_NOT_WP:
-				p->wp = p->start;
-				break;
 			case BLK_ZONE_COND_FULL:
 				p->wp = p->start + zone_size;
 				break;
-- 
2.21.0


