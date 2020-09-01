Return-Path: <prvs=50667a661=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 7/7] t/zbd: Remove unnecessary option for zbc_reset_zone
Date: Tue,  1 Sep 2020 17:20:06 +0900
Message-Id: <20200901082006.1476720-8-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200901082006.1476720-1-shinichiro.kawasaki@wdc.com>
References: <20200901082006.1476720-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

When -all option is specified, zbc_reset_zone command does not take
offset option. Remove it.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/functions | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 81b6f3f7..1a64a215 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -185,7 +185,7 @@ reset_zone() {
 	fi
     else
 	if [ "$offset" -lt 0 ]; then
-	    ${zbc_reset_zone} -all "$dev" "${offset}" >/dev/null
+	    ${zbc_reset_zone} -all "$dev" >/dev/null
 	else
 	    ${zbc_reset_zone} -sector "$dev" "${offset}" >/dev/null
 	fi
-- 
2.26.2


