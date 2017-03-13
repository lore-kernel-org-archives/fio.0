Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] Conditionally enable FIO_HAVE_PSHARED_MUTEX on FreeBSD
Date: Mon, 13 Mar 2017 20:42:37 +0200
Message-Id: <20170313184237.33515-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

> This commit needs a better title, I had no idea what it does until I
> read the patch and the URL pointed at.

Sorry, I rewrote the commit message.

FreeBSD ports has had an outbox patch to conditionally enable
FIO_HAVE_PSHARED_MUTEX, which can be upstream'd.

This commit brings in below diff from FreeBSD ports.
https://github.com/freebsd/freebsd-ports/commit/271a84d2df7bc9b983fe2fabe1615d01202d429b

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-freebsd.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index c7863b5..3d7dbe6 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -24,6 +24,10 @@
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_SHM_ATTACH_REMOVED
 
+#if _POSIX_THREAD_PROCESS_SHARED > 0
+#define FIO_HAVE_PSHARED_MUTEX
+#endif
+
 #define OS_MAP_ANON		MAP_ANON
 
 #define fio_swap16(x)	bswap16(x)
-- 
2.9.3


