Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/6] Drop triple X for cpu affinity for OpenBSD
Date: Sun, 30 Apr 2017 20:41:00 +0300
Message-Id: <20170430174100.44698-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

(Sorry, resending this as gmail refused an email title including triple X)

This isn't really a fio's TODO item since no such thing seems to
exist (or have existed) in OpenBSD as of 2017, according to below
reference.

NetBSD is in more or less similar situation, except that NetBSD
has pthread_[gs]etaffinity_np() for threads, though it has another
problem that they don't take pid/tid.

CPU affinity comes to OpenBSD (2009)
http://undeadly.org/cgi?action=article&sid=20090324210236

tedu old comment about cpu affinity. (2012)
http://openbsd-archive.7691.n7.nabble.com/tedu-old-comment-about-cpu-affinity-tt172330.html

how to use cpu affinity from user space (2013)
http://openbsd-archive.7691.n7.nabble.com/how-to-use-cpu-affinity-from-user-space-td222323.html

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-netbsd.h  | 2 +-
 os/os-openbsd.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index e6ba508..7be02a7 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -25,7 +25,7 @@
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
-#undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
+#undef	FIO_HAVE_CPU_AFFINITY	/* doesn't exist */
 
 #define OS_MAP_ANON		MAP_ANON
 
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 670892b..d874ee2 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -25,7 +25,7 @@
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_SHM_ATTACH_REMOVED
 
-#undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
+#undef	FIO_HAVE_CPU_AFFINITY	/* doesn't exist */
 
 #define OS_MAP_ANON		MAP_ANON
 
-- 
2.9.3


