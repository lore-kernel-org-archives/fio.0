Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/6] cleanup NetBSD/OpenBSD header
Date: Wed, 30 Aug 2017 00:12:11 +0300
Message-Id: <20170829211216.42347-2-tkusumi@tuxera.com>
In-Reply-To: <20170829211216.42347-1-tkusumi@tuxera.com>
References: <20170829211216.42347-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

* NetBSD's <sys/rb.h> was renamed to <sys/rbtree.h> 7 years ago.
* Drop unneeded undefs.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-netbsd.h  | 6 ++----
 os/os-openbsd.h | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index eac76cf..682a11c 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -11,9 +11,9 @@
 #include <sys/dkio.h>
 #include <sys/disklabel.h>
 #include <sys/endian.h>
-/* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
-#define	rb_node	_rb_node
 #include <sys/sysctl.h>
+
+/* XXX hack to avoid confilcts between rbtree.h and <sys/rbtree.h> */
 #undef rb_node
 #undef rb_left
 #undef rb_right
@@ -26,8 +26,6 @@
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
-#undef	FIO_HAVE_CPU_AFFINITY	/* doesn't exist */
-
 #define OS_MAP_ANON		MAP_ANON
 
 #ifndef PTHREAD_STACK_MIN
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 675bf89..b4c02c9 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -11,23 +11,21 @@
 #include <sys/disklabel.h>
 #include <sys/endian.h>
 #include <sys/utsname.h>
-/* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #include <sys/sysctl.h>
+
+/* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #undef RB_BLACK
 #undef RB_RED
 #undef RB_ROOT
 
 #include "../file.h"
 
-#undef  FIO_HAVE_ODIRECT
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_SHM_ATTACH_REMOVED
 
-#undef	FIO_HAVE_CPU_AFFINITY	/* doesn't exist */
-
 #define OS_MAP_ANON		MAP_ANON
 
 #ifndef PTHREAD_STACK_MIN
-- 
2.9.5


