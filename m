Return-Path: <prvs=108f0b385=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] bssplit: Fix handling of 0 percentage
Date: Wed, 31 Jul 2019 13:32:07 +0900
Message-Id: <20190731043207.16247-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

If a block size percentage is ispecified as 0 in bssplit, the block size
defined is not ignored by the loop in get_next_buflen(). In particular,
if the first (smallest) block size specified has a 0 percentage, the
loop is existed and that block size used as the next IO size, resulting
in a behavior equivalent to specifying 100%. E.g. using
--bssplit=64k/0,1024k/100 results in 100% of issued IOs to be 64KB
instead of 1MB.

Fix this by ignoring bssplit entries that have a 0 percentage. This is
safe as the initialization of the bssplit array ensure that the sum of
all percentages is always 100, guaranteeing that a block size will be
chosen for the next IO size.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 io_u.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_u.c b/io_u.c
index 910b7deb..80df2854 100644
--- a/io_u.c
+++ b/io_u.c
@@ -557,10 +557,10 @@ static unsigned long long get_next_buflen(struct thread_data *td, struct io_u *i
 			for (i = 0; i < td->o.bssplit_nr[ddir]; i++) {
 				struct bssplit *bsp = &td->o.bssplit[ddir][i];
 
+				if (!bsp->perc)
+					continue;
 				buflen = bsp->bs;
 				perc += bsp->perc;
-				if (!perc)
-					break;
 				if ((r / perc <= frand_max / 100ULL) &&
 				    io_u_fits(td, io_u, buflen))
 					break;
-- 
2.21.0


