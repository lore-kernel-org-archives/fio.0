Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/5] Move Linux/ppc64 specific cpu_online() to os/os-linux.h
Date: Tue, 23 May 2017 21:44:49 +0300
Message-Id: <20170523184449.48134-6-tkusumi@tuxera.com>
In-Reply-To: <20170523184449.48134-1-tkusumi@tuxera.com>
References: <20170523184449.48134-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

cpu_online() implementation for ppc64 added to os/os.h by c5dd5d97
(powerpc: fix cpus_online() to get correct max CPU number for powerpc64)
seems Linux specific, thus it should be moved to os/os-linux.h.

For example, non standard sysconf values _SC_NPROCESSORS_ONLN and
_SC_NPROCESSORS_CONF do the same thing with libc in FreeBSD, whereas
they aren't always the same with glibc. This implies c5dd5d97 is about
Linux, and wouldn't be a general solution that needs to be in os/os.h.

sysconf(3) in FreeBSD
https://github.com/freebsd/freebsd/blob/master/lib/libc/gen/sysconf.c#L588

Another possibility is AIX in addition to Linux, but below website
has an example of both _SC_NPROCESSORS_ONLN and _SC_NPROCESSORS_CONF
having the same value under SMT.

Topic: prtconf and sysconf produce different numbers of processors
https://www.ibm.com/developerworks/community/forums/html/topic?id=77777777-0000-0000-0000-000014250083
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-linux.h | 8 ++++++++
 os/os.h       | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/os/os-linux.h b/os/os-linux.h
index 0e6246e..008ce2d 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -260,6 +260,14 @@ static inline int arch_cache_line_size(void)
 		return atoi(size);
 }
 
+#ifdef __powerpc64__
+#define FIO_HAVE_CPU_ONLINE_SYSCONF
+static inline unsigned int cpus_online(void)
+{
+        return sysconf(_SC_NPROCESSORS_CONF);
+}
+#endif
+
 static inline unsigned long long get_fs_free_size(const char *path)
 {
 	unsigned long long ret;
diff --git a/os/os.h b/os/os.h
index 3c96b4d..1d400c8 100644
--- a/os/os.h
+++ b/os/os.h
@@ -324,14 +324,6 @@ static inline unsigned long long get_fs_free_size(const char *path)
 }
 #endif
 
-#ifdef __powerpc64__
-#define FIO_HAVE_CPU_ONLINE_SYSCONF
-static inline unsigned int cpus_online(void)
-{
-        return sysconf(_SC_NPROCESSORS_CONF);
-}
-#endif
-
 #ifndef FIO_HAVE_CPU_ONLINE_SYSCONF
 static inline unsigned int cpus_online(void)
 {
-- 
2.9.4


