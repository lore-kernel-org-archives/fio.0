Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/6] Implement shm_attach_to_open_removed() for OpenBSD
Date: Sun, 30 Apr 2017 20:35:10 +0300
Message-Id: <20170430173511.44593-6-tkusumi@tuxera.com>
In-Reply-To: <20170430173511.44593-1-tkusumi@tuxera.com>
References: <20170430173511.44593-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Add implementation which had been left by
0cfe2089 (Add runtime handlers for 97900ebf for FreeBSD/DragonFlyBSD).

This implementation is based on what
97900ebf (shm: have os remove shared memory if fio dies unexpectedly)
says. There seems to be no easy way to statically test versions like
KERNEL_VERSION() in Linux kernel.

The code assumes major/minor are both < 10. The minor has never been
10 or above. The major won't be 10 anytime soon based on the past
release cycle (current version is 6.1 after more than 2 decades).
https://en.wikipedia.org/wiki/OpenBSD_version_history

--
 # uname
 OpenBSD
 # uname -r
 6.1
 # cat ./test1.c
 #include <stdio.h>
 #include "./os/os.h"
 #include "./os/os-openbsd.h"
 int main(void) {
         printf("%d\n", shm_attach_to_open_removed());
         return 0;
 }
 # gcc -Wall -g ./test1.c
 # ./a.out
 1

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-openbsd.h | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 9c7092c..670892b 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -9,6 +9,7 @@
 #include <sys/ioctl.h>
 #include <sys/dkio.h>
 #include <sys/disklabel.h>
+#include <sys/utsname.h>
 /* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #include <sys/sysctl.h>
 #undef RB_BLACK
@@ -90,9 +91,31 @@ static inline unsigned long long get_fs_free_size(const char *path)
 
 static inline int shm_attach_to_open_removed(void)
 {
+	struct utsname uts;
+	int major, minor;
+
+	if (uname(&uts) == -1)
+		return 0;
+
 	/*
-	 * XXX: Return 1 if >= OpenBSD 5.1 according to 97900ebf.
+	 * Return 1 if >= OpenBSD 5.1 according to 97900ebf,
+	 * assuming both major/minor versions are < 10.
 	 */
+	if (uts.release[0] > '9' || uts.release[0] < '0')
+		return 0;
+	if (uts.release[1] != '.')
+		return 0;
+	if (uts.release[2] > '9' || uts.release[2] < '0')
+		return 0;
+
+	major = uts.release[0] - '0';
+	minor = uts.release[2] - '0';
+
+	if (major > 5)
+		return 1;
+	if (major == 5 && minor >= 1)
+		return 1;
+
 	return 0;
 }
 
-- 
2.9.3


