Return-Path: <ankit.kumar@samsung.com>
From: Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/2] zbd: Improve random zone index generation logic
Date: Wed,  4 Aug 2021 14:54:50 +0530
Message-Id: <20210804092450.28782-3-ankit.kumar@samsung.com>
In-Reply-To: <20210804092450.28782-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
References: <20210804092450.28782-1-ankit.kumar@samsung.com>
	<CGME20210804092859epcas5p1085bcaafa631e16cc3ad4325b883172e@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, krish.reddy@samsung.com, prakash.v@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

Existing random zone index generation logic is dependent on the file size.
For smaller I/O sizes the random zone index always return a particular
section of open zones. As this index is used to return one of the open zones,
it was observed that after one of the max_open_zones / job_max_open_zones limit
is reached all further I/O's are redirected to only a few open zones till they
are full.

This patch modifies the random zone index genration logic so that it is uniform
across all the open zones.

It reverts part of the commit 6463db6c1
('fio: fix interaction between offset/size limited threads and
"max_open_zones"')
---
 zbd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 04c68dea..43f12b45 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1184,11 +1184,12 @@ out:
 	return res;
 }
 
-/* Anything goes as long as it is not a constant. */
+/* Return random zone index for one of the open zones. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
 {
-	return io_u->offset * f->zbd_info->num_open_zones / f->real_file_size;
+	return (io_u->offset - f->file_offset) * f->zbd_info->num_open_zones /
+		f->io_size;
 }
 
 /*
-- 
2.30.0-rc0


