Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/3] HOWTO: fix wrong description of trim_backlog=
Date: Tue,  1 Aug 2017 22:49:26 +0300
Message-Id: <20170801194928.50146-2-tkusumi@tuxera.com>
In-Reply-To: <20170801194928.50146-1-tkusumi@tuxera.com>
References: <20170801194928.50146-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

f80dba8d('Convert documentation to reStructured text.')
mixed this up with trim_verify_zero= located before this one.

The man page has this right as it's not synced (will be soon).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index caf6591..80d1c05 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2595,7 +2595,7 @@ Verification
 
 .. option:: trim_backlog=int
 
-	Verify that trim/discarded blocks are returned as zeros.
+	Trim after this number of blocks are written.
 
 .. option:: trim_backlog_batch=int
 
-- 
2.9.4


