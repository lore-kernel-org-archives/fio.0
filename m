Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 4/4] Add device_is_mounted() support for NetBSD
Date: Mon, 17 Oct 2016 23:17:41 +0900
Message-Id: <1476713861-8325-4-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

This commit is NetBSD version of e7e136da in 2015. It's basically
the same as the one for FreeBSD/DragonFlyBSD, but NetBSD takes
statvfs instead of statfs, so I had to add CONFIG_GETMNTINFO_STATVFS
to differentiate from CONFIG_GETMNTINFO. It could be renamed if
there is any better name, as it sounds strange.

compile_prog() takes -Werror for local CFLAGS. Without -Werror,
the existing getmntinfo(3) test code for FreeBSD/DragonFlyBSD only
gives a warning on NetBSD and results in trying to compile wrong
device_is_mounted().

(The reason this hasn't been reported as a problem is because of
the ./configure bug fixed by the previous commit. It fails to
compile the test code unless st is a pointer.)

The remaining one, OpenBSD seems to have the same interface as
FreeBSD/DragonFlyBSD, so the existing test code will probably work,
but fio doesn't compile on OpenBSD 5.9 due to other compile time
errors (lex error) that have nothing to do with this.

--
 # uname
 NetBSD
 # cat ./test1.c
 #include <stdio.h>
 #include "./lib/mountcheck.h"
 int main(int argc, char *argv[]) {
         printf("%s %d\n", argv[1], device_is_mounted(argv[1]));
         return 0;
 }
 # gcc -Wall -g ./test1.c ./lib/mountcheck.o -o ./test1
 # ./test1 /dev/wd0a	/* UFS */
 /dev/wd0a 1
 # ./test1 procfs	/* procfs */
 procfs 1
 # ./test1 tmpfs	/* tmpfs */
 tmpfs 1
 # ./test1 invalid	/* irrelevant string */
 invalid 0

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 configure        |   27 ++++++++++++++++++++++++++-
 lib/mountcheck.c |   23 ++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index e8e6953..e91ec25 100755
--- a/configure
+++ b/configure
@@ -1621,6 +1621,11 @@ echo "getmntent                     $getmntent"
 
 ##########################################
 # Check whether we have getmntinfo
+# These are originally added for BSDs, but may also work
+# on other operating systems with getmntinfo(3).
+
+# getmntinfo(3) for FreeBSD/DragonFlyBSD/OpenBSD.
+# Note that NetBSD needs -Werror to catch warning as error.
 getmntinfo="no"
 cat > $TMPC << EOF
 #include <stdio.h>
@@ -1632,11 +1637,28 @@ int main(int argc, char **argv)
   return getmntinfo(&st, MNT_NOWAIT);
 }
 EOF
-if compile_prog "" "" "getmntinfo"; then
+if compile_prog "-Werror" "" "getmntinfo"; then
   getmntinfo="yes"
 fi
 echo "getmntinfo                    $getmntinfo"
 
+# getmntinfo(3) for NetBSD.
+getmntinfo_statvfs="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <sys/statvfs.h>
+int main(int argc, char **argv)
+{
+  struct statvfs *st;
+  return getmntinfo(&st, MNT_NOWAIT);
+}
+EOF
+# Skip the test if the one with statfs arg is detected.
+if test "$getmntinfo" != "yes" && compile_prog "-Werror" "" "getmntinfo_statvfs"; then
+  getmntinfo_statvfs="yes"
+  echo "getmntinfo_statvfs            $getmntinfo_statvfs"
+fi
+
 ##########################################
 # Check whether we have _Static_assert
 static_assert="no"
@@ -1883,6 +1905,9 @@ fi
 if test "$getmntinfo" = "yes" ; then
   output_sym "CONFIG_GETMNTINFO"
 fi
+if test "$getmntinfo_statvfs" = "yes" ; then
+  output_sym "CONFIG_GETMNTINFO_STATVFS"
+fi
 if test "$static_assert" = "yes" ; then
   output_sym "CONFIG_STATIC_ASSERT"
 fi
diff --git a/lib/mountcheck.c b/lib/mountcheck.c
index e8780eb..0aec744 100644
--- a/lib/mountcheck.c
+++ b/lib/mountcheck.c
@@ -32,7 +32,7 @@ int device_is_mounted(const char *dev)
 }
 
 #elif defined(CONFIG_GETMNTINFO)
-/* for BSDs */
+/* for most BSDs */
 #include <sys/param.h>
 #include <sys/mount.h>
 
@@ -53,6 +53,27 @@ int device_is_mounted(const char *dev)
 	return 0;
 }
 
+#elif defined(CONFIG_GETMNTINFO_STATVFS)
+/* for NetBSD */
+#include <sys/statvfs.h>
+
+int device_is_mounted(const char *dev)
+{
+	struct statvfs *st;
+	int i, ret;
+
+	ret = getmntinfo(&st, MNT_NOWAIT);
+	if (ret <= 0)
+		return 0;
+
+	for (i = 0; i < ret; i++) {
+		if (!strcmp(st[i].f_mntfromname, dev))
+			return 1;
+	}
+
+	return 0;
+}
+
 #else
 /* others */
 
-- 
1.7.1


