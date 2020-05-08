Return-Path: <prvs=390c41bd8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 3/7] zbd: Fix read with verify
Date: Fri,  8 May 2020 16:56:41 +0900
Message-Id: <20200508075645.543890-4-damien.lemoal@wdc.com>
In-Reply-To: <20200508075645.543890-1-damien.lemoal@wdc.com>
References: <20200508075645.543890-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

For a read only workload with verify option enabled, executing
zbd_replay_write_order() will ignore target zones that are full and try
to open another zone. This either triggers an assert if max_open_zones
is unused, or result in verify failing. Fix this by executing
zbd_replay_write_order() only for writing workloads. This fix is also
consistent with the fact that zoned devices do not implicitly open
zones for read operations.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 5aaf1e2c..c30454b9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1409,7 +1409,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	switch (io_u->ddir) {
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING) {
-			zb = zbd_replay_write_order(td, io_u, zb);
+			if (td_write(td))
+				zb = zbd_replay_write_order(td, io_u, zb);
 			goto accept;
 		}
 		/*
-- 
2.25.4


