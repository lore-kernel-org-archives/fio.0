Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/4] lib/memalign: don't malloc size twice
Date: Mon, 18 Sep 2017 20:53:49 +0300
Message-Id: <20170918175350.38471-4-tkusumi@tuxera.com>
In-Reply-To: <20170918175350.38471-1-tkusumi@tuxera.com>
References: <20170918175350.38471-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The footer offset (diff between malloc'd address and aligned address)
is (alignment-1) at most, and footer appears `size' bytes after the
aligned address, thus required size is (alignment-1 + size + sizeof(*f)).

The existing code seems to allocate extra unused `size' bytes.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/memalign.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/memalign.c b/lib/memalign.c
index 137cc8e..bfbd1e8 100644
--- a/lib/memalign.c
+++ b/lib/memalign.c
@@ -18,7 +18,7 @@ void *fio_memalign(size_t alignment, size_t size)
 
 	assert(!(alignment & (alignment - 1)));
 
-	ptr = malloc(size + alignment + size + sizeof(*f) - 1);
+	ptr = malloc(size + alignment + sizeof(*f) - 1);
 	if (ptr) {
 		ret = PTR_ALIGN(ptr, alignment - 1);
 		f = ret + size;
-- 
2.9.5


