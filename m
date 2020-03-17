Return-Path: <feng.tang@intel.com>
From: Feng Tang <feng.tang@intel.com>
Subject: [PATCH RFC] gauss.c: correct the stddev initializtion
Date: Tue, 17 Mar 2020 20:53:31 +0800
Message-Id: <20200317125331.6799-1-feng.tang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 lib/gauss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/gauss.c b/lib/gauss.c
index 1d24e187..3f84dbc6 100644
--- a/lib/gauss.c
+++ b/lib/gauss.c
@@ -51,7 +51,7 @@ void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
 	gs->nranges = nranges;
 
 	if (dev != 0.0) {
-		gs->stddev = ceil((double) (nranges * 100.0) / dev);
+		gs->stddev = ceil((double)(nranges * dev) / 100.0);
 		if (gs->stddev > nranges / 2)
 			gs->stddev = nranges / 2;
 	}
-- 
2.20.1


