Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] man: fix wrong info on sync_file_range=
Date: Fri, 14 Jul 2017 10:24:03 +0300
Message-Id: <20170714072403.45658-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This part isn't in sync with HOWTO, but also simply wrong.
HOWTO as well as the actual option have SYNC_FILE_RANGE_WAIT_AFTER for this.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index 5da9ecf..8a41321 100644
--- a/fio.1
+++ b/fio.1
@@ -1071,7 +1071,7 @@ SYNC_FILE_RANGE_WAIT_BEFORE
 SYNC_FILE_RANGE_WRITE
 .TP
 .B wait_after
-SYNC_FILE_RANGE_WRITE
+SYNC_FILE_RANGE_WAIT_AFTER
 .TP
 .RE
 .P
-- 
2.9.4


