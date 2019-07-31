Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH] smalloc: fix compiler warning
Date: Wed, 31 Jul 2019 16:57:51 -0400
Message-Id: <20190731205751.17531-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

firstfree() triggers a warning from the Windows compiler used by
AppVeyor because it doesn't return a value if the for loop iterates to
completion. This patch resolves the compiler warning.

AppVeyor Windows build log: https://ci.appveyor.com/project/axboe/fio/builds/26381726
---
 smalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/smalloc.c b/smalloc.c
index c97bcbaa..0d7054a4 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -347,6 +347,9 @@ static unsigned int firstfree(struct pool *pool)
                         return i;
 
         assert(0);
+
+	/* we will never get here but this fixes a compiler warning */
+	return -1U;
 }
 
 static void *__smalloc_pool(struct pool *pool, size_t size)
-- 
2.17.1


