Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 05/36] zbd: engines/libzbc: don't fail on assert for offline zones
Date: Thu, 24 Dec 2020 11:11:48 +0900
Message-Id: <20201224021219.189727-6-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

If fio is run against a zoned device that has any zones in OFFLINE
condition, the following assertion is raised -

fio: zbd.c:473: parse_zone_info: Assertion `z->wp <= z->start + zone_size' failed.

This happens because offline zones have no valid write pointer and
it is reported by libzbc and blkzoned as (uint64_t)(-1). To avoid
violating this assertion, set the write pointer in all offline zones
to point at the start of the zone.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 engines/libzbc.c       | 2 +-
 oslib/linux-blkzoned.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 4b900233..552aab65 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -283,7 +283,7 @@ static int libzbc_report_zones(struct thread_data *td, struct fio_file *f,
 		default:
 			/* Treat all these conditions as offline (don't use!) */
 			zbdz->cond = ZBD_ZONE_COND_OFFLINE;
-			break;
+			zbdz->wp = zbdz->start;
 		}
 	}
 
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 0a8a577a..f37c67fc 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -203,7 +203,7 @@ int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 		default:
 			/* Treat all these conditions as offline (don't use!) */
 			z->cond = ZBD_ZONE_COND_OFFLINE;
-			break;
+			z->wp = z->start;
 		}
 	}
 
-- 
2.28.0


