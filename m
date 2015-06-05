Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52704 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbbFEMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Jun 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z0qI8-0006CV-KQ
	for fio@vger.kernel.org; Fri, 05 Jun 2015 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150605120001.CC5132C0102@kernel.dk>
Date: Fri,  5 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a53d4f7847273faeef9795ad7a3f5865b0c22840:

  Merge branch 'req6' of git://github.com/kusumi/fio (2015-06-01 08:32:45 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2236df3d9d6bc053039a5c2185cff43ea5015111:

  init: automate displaying debug categories (2015-06-04 13:45:32 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      init: automate displaying debug categories

Tomohiro Kusumi (1):
      Add device_is_mounted() support for BSDs

 configure        | 21 +++++++++++++++++++++
 init.c           | 34 +++++++++++++++++++++++++++++++---
 lib/mountcheck.c | 17 ++++++++++++++++-
 3 files changed, 68 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 5c6129d..835a3b9 100755
--- a/configure
+++ b/configure
@@ -1472,6 +1472,24 @@ if compile_prog "" "" "getmntent"; then
 fi
 echo "getmntent                     $getmntent"
 
+##########################################
+# Check whether we have getmntinfo
+getmntinfo="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <sys/param.h>
+#include <sys/mount.h>
+int main(int argc, char **argv)
+{
+  struct statfs st;
+  return getmntinfo(&st, MNT_NOWAIT);
+}
+EOF
+if compile_prog "" "" "getmntinfo"; then
+  getmntinfo="yes"
+fi
+echo "getmntinfo                    $getmntinfo"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1648,6 +1666,9 @@ fi
 if test "$getmntent" = "yes" ; then
   output_sym "CONFIG_GETMNTENT"
 fi
+if test "$getmntinfo" = "yes" ; then
+  output_sym "CONFIG_GETMNTINFO"
+fi
 
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
diff --git a/init.c b/init.c
index 9f1041c..515f314 100644
--- a/init.c
+++ b/init.c
@@ -1710,13 +1710,41 @@ static int fill_def_thread(void)
 	return 0;
 }
 
+static void show_debug_categories(void)
+{
+	struct debug_level *dl = &debug_levels[0];
+	int curlen, first = 1;
+
+	curlen = 0;
+	while (dl->name) {
+		int has_next = (dl + 1)->name != NULL;
+
+		if (first || curlen + strlen(dl->name) >= 80) {
+			if (!first) {
+				printf("\n");
+				curlen = 0;
+			}
+			curlen += printf("\t\t\t%s", dl->name);
+			curlen += 3 * (8 - 1);
+			if (has_next)
+				curlen += printf(",");
+		} else {
+			curlen += printf("%s", dl->name);
+			if (has_next)
+				curlen += printf(",");
+		}
+		dl++;
+		first = 0;
+	}
+	printf("\n");
+}
+
 static void usage(const char *name)
 {
 	printf("%s\n", fio_version_string);
 	printf("%s [options] [job options] <job file(s)>\n", name);
-	printf("  --debug=options\tEnable debug logging. May be one/more of:\n"
-		"\t\t\tprocess,file,io,mem,blktrace,verify,random,parse,\n"
-		"\t\t\tdiskutil,job,mutex,profile,time,net,rate,compress\n");
+	printf("  --debug=options\tEnable debug logging. May be one/more of:\n");
+	show_debug_categories();
 	printf("  --parse-only\t\tParse options only, don't start any IO\n");
 	printf("  --output\t\tWrite output to file\n");
 	printf("  --runtime\t\tRuntime in seconds\n");
diff --git a/lib/mountcheck.c b/lib/mountcheck.c
index bb01f69..2eedcc7 100644
--- a/lib/mountcheck.c
+++ b/lib/mountcheck.c
@@ -29,10 +29,25 @@ int device_is_mounted(const char *dev)
 	return ret;
 }
 
-#else
+#elif defined(CONFIG_GETMNTINFO)
+/* for BSDs */
+#include <sys/param.h>
+#include <sys/mount.h>
 
 int device_is_mounted(const char *dev)
 {
+	struct statfs *st;
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
 	return 0;
 }
 
