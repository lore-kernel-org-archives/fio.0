Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/6] Fix "C99 inline functions are not supported" warning on OpenBSD
Date: Sun, 30 Apr 2017 20:35:07 +0300
Message-Id: <20170430173511.44593-3-tkusumi@tuxera.com>
In-Reply-To: <20170430173511.44593-1-tkusumi@tuxera.com>
References: <20170430173511.44593-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

OpenBSD has below compiler warning due to hist_sum() being inlined.
It should be fine with no inline (or move it to iolog.h with static
if we somehow want to keep it inlined).

iolog.c:702: warning: C99 inline functions are not supported; using GNU89
iolog.c:702: warning: to disable this warning use -fgnu89-inline or the gnu_inline function attribute

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 iolog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iolog.c b/iolog.c
index 2e8da13..31d674c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -696,7 +696,7 @@ void free_log(struct io_log *log)
 	sfree(log);
 }
 
-inline unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat,
+unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat,
 		unsigned int *io_u_plat_last)
 {
 	unsigned long sum;
-- 
2.9.3


