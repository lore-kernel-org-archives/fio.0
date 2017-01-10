Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/4] Add missing trailing \n in dprint()
Date: Wed, 11 Jan 2017 02:39:45 +0900
Message-Id: <1484069987-13105-2-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
References: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 iolog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iolog.c b/iolog.c
index 25d8dd0..2e8da13 100644
--- a/iolog.c
+++ b/iolog.c
@@ -277,7 +277,7 @@ restart:
 			overlap = 1;
 
 		if (overlap) {
-			dprint(FD_IO, "iolog: overlap %llu/%lu, %llu/%lu",
+			dprint(FD_IO, "iolog: overlap %llu/%lu, %llu/%lu\n",
 				__ipo->offset, __ipo->len,
 				ipo->offset, ipo->len);
 			td->io_hist_len--;
-- 
2.5.5


