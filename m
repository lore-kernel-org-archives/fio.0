Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/8] io_u: don't use void* for pointer arithmetic (gcc)
Date: Sat, 24 Jun 2017 01:07:57 +0300
Message-Id: <20170623220801.38178-5-tkusumi@tuxera.com>
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think gcc extension should be avoided when it can be done by
just changing a pointer type.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index 375413f..8d42d65 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1602,7 +1602,7 @@ static void small_content_scramble(struct io_u *io_u)
 	unsigned int i, nr_blocks = io_u->buflen / 512;
 	uint64_t boffset;
 	unsigned int offset;
-	void *p, *end;
+	char *p, *end;
 
 	if (!nr_blocks)
 		return;
-- 
2.9.4


