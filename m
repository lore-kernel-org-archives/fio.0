Return-Path: <prvs=36522ed81=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/3] t/zbd: Fix a bug in reset_zone() for all zones reset
Date: Mon, 13 Apr 2020 17:32:59 +0900
Message-Id: <20200413083300.256784-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
References: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The bash function reset_zone() is expected to reset all zones when -1 is
provided as its second argument. However, it fails to reset all zones
using blkzone command because of wrong and unnecessary options provided
to blkzone. Remove the option to fix it.

This failure was found with running test-zbd-support with -r option.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 5bffad6e..1bd22ec4 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -97,8 +97,7 @@ reset_zone() {
 
     if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
 	if [ "$offset" -lt 0 ]; then
-	    sectors=$(<"/sys/class/block/${dev#/dev/}/size")
-	    ${blkzone} reset -o "${offset}" -l "$sectors" "$dev"
+	    ${blkzone} reset "$dev"
 	else
 	    ${blkzone} reset -o "${offset}" -c 1 "$dev"
 	fi
-- 
2.25.1


