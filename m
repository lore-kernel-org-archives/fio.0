Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/2] Remove getopt_long_only macro from NetBSD header
Date: Thu, 20 Oct 2016 23:03:17 +0900
Message-Id: <1476972198-5530-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

If CONFIG_GETOPT_LONG_ONLY isn't defined, fio is compiled with
its own getopt_long_only(), so this macro is no longer needed.
(os/os-netbsd.h was added before getopt_long_only() support)

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 os/os-netbsd.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 4c629dd..1ef5866 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -74,7 +74,4 @@ static inline unsigned long long get_fs_free_size(const char *path)
 #define FIO_MADV_FREE	MADV_FREE
 #endif
 
-/* XXX NetBSD doesn't have getopt_long_only */
-#define	getopt_long_only	getopt_long
-
 #endif
-- 
1.7.1


