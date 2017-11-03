Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/3] solaris: add os_phys_mem() implementation
Date: Fri,  3 Nov 2017 18:46:02 +0200
Message-Id: <20171103164603.31819-3-tkusumi@tuxera.com>
In-Reply-To: <20171103164603.31819-1-tkusumi@tuxera.com>
References: <20171103164603.31819-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Copied from os/os-linux.h. The standard sysconf(3C) names work on
Solaris (actually compiled/tested on illumos) as well.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-solaris.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/os/os-solaris.h b/os/os-solaris.h
index a6cd376..644807c 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -66,7 +66,14 @@ static inline int blockdev_invalidate_cache(struct fio_file *f)
 
 static inline unsigned long long os_phys_mem(void)
 {
-	return 0;
+	long pagesize, pages;
+
+	pagesize = sysconf(_SC_PAGESIZE);
+	pages = sysconf(_SC_PHYS_PAGES);
+	if (pages == -1 || pagesize == -1)
+		return 0;
+
+	return (unsigned long long) pages * (unsigned long long) pagesize;
 }
 
 static inline void os_random_seed(unsigned long seed, os_random_state_t *rs)
-- 
2.9.5


