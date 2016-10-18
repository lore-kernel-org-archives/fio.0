Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56824 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbcJRMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bwT3r-0005Jf-RU
        for fio@vger.kernel.org; Tue, 18 Oct 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161018120002.035F22C0400@kernel.dk>
Date: Tue, 18 Oct 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a4f581f981a2a0e19d22339d9fdf17b3aaeb12b8:

  Update REPORTING-BUGS (2016-10-14 14:07:43 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dac34079f7d8cfb0a64e4d3f086728edd7eded6d:

  iolog: enable replay_redirect on iolog replay (2016-10-17 14:51:54 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      iolog: enable replay_redirect on iolog replay

Tomohiro Kusumi (4):
      Add FIO_HAVE_FS_STAT/get_fs_free_size() support for NetBSD
      Add FIO_HAVE_FS_STAT/get_fs_free_size() support for OpenBSD
      Fix e7e136da (Add device_is_mounted() support for BSDs)
      Add device_is_mounted() support for NetBSD

 configure        | 29 +++++++++++++++++++++++++++--
 iolog.c          | 12 ++++++++----
 lib/mountcheck.c | 23 ++++++++++++++++++++++-
 os/os-netbsd.h   | 15 +++++++++++++++
 os/os-openbsd.h  | 15 +++++++++++++++
 5 files changed, 87 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index a24e3ef..e91ec25 100755
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
@@ -1628,15 +1633,32 @@ cat > $TMPC << EOF
 #include <sys/mount.h>
 int main(int argc, char **argv)
 {
-  struct statfs st;
+  struct statfs *st;
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
diff --git a/iolog.c b/iolog.c
index ab9c878..686c713 100644
--- a/iolog.c
+++ b/iolog.c
@@ -346,7 +346,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 	unsigned long long offset;
 	unsigned int bytes;
 	int reads, writes, waits, fileno = 0, file_action = 0; /* stupid gcc */
-	char *fname, *act;
+	char *rfname, *fname, *act;
 	char *str, *p;
 	enum fio_ddir rw;
 
@@ -357,7 +357,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 	 * for doing verifications.
 	 */
 	str = malloc(4096);
-	fname = malloc(256+16);
+	rfname = fname = malloc(256+16);
 	act = malloc(256+16);
 
 	reads = writes = waits = 0;
@@ -365,8 +365,12 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 		struct io_piece *ipo;
 		int r;
 
-		r = sscanf(p, "%256s %256s %llu %u", fname, act, &offset,
+		r = sscanf(p, "%256s %256s %llu %u", rfname, act, &offset,
 									&bytes);
+
+		if (td->o.replay_redirect)
+			fname = td->o.replay_redirect;
+
 		if (r == 4) {
 			/*
 			 * Check action first
@@ -451,7 +455,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 
 	free(str);
 	free(act);
-	free(fname);
+	free(rfname);
 
 	if (writes && read_only) {
 		log_err("fio: <%s> skips replay of %d writes due to"
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
 
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 4b0269e..4c629dd 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -6,6 +6,7 @@
 #include <errno.h>
 #include <lwp.h>
 #include <sys/param.h>
+#include <sys/statvfs.h>
 /* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
 #define	rb_node	_rb_node
 #include <sys/sysctl.h>
@@ -19,6 +20,7 @@
 #define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
@@ -55,6 +57,19 @@ static inline int gettid(void)
 	return (int) _lwp_self();
 }
 
+static inline unsigned long long get_fs_free_size(const char *path)
+{
+	unsigned long long ret;
+	struct statvfs s;
+
+	if (statvfs(path, &s) < 0)
+		return -1ULL;
+
+	ret = s.f_frsize;
+	ret *= (unsigned long long) s.f_bfree;
+	return ret;
+}
+
 #ifdef MADV_FREE
 #define FIO_MADV_FREE	MADV_FREE
 #endif
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index b1d8e83..2998510 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -5,6 +5,7 @@
 
 #include <errno.h>
 #include <sys/param.h>
+#include <sys/statvfs.h>
 /* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #include <sys/sysctl.h>
 #undef RB_BLACK
@@ -17,6 +18,7 @@
 #define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
@@ -53,6 +55,19 @@ static inline int gettid(void)
 	return (int) pthread_self();
 }
 
+static inline unsigned long long get_fs_free_size(const char *path)
+{
+	unsigned long long ret;
+	struct statvfs s;
+
+	if (statvfs(path, &s) < 0)
+		return -1ULL;
+
+	ret = s.f_frsize;
+	ret *= (unsigned long long) s.f_bfree;
+	return ret;
+}
+
 #ifdef MADV_FREE
 #define FIO_MADV_FREE	MADV_FREE
 #endif
