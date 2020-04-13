Return-Path: <prvs=36522ed81=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/3] t/zbd: Fix a bug in max_open_zones()
Date: Mon, 13 Apr 2020 17:32:58 +0900
Message-Id: <20200413083300.256784-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
References: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

When sg_inq command is executed to check if it can provide maximum open
zones, the command's standard output was not discarded and caused
unexpected script behavior. Fix it discarding the standard output.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 35087b15..5bffad6e 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -43,7 +43,8 @@ max_open_zones() {
     local dev=$1
 
     if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
-	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" 2> /dev/null; then
+	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" \
+		 > /dev/null 2>&1; then
 	    # Non scsi device such as null_blk can not return max open zones.
 	    # Use default value.
 	    echo 128
-- 
2.25.1


