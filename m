Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52654 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbfDSTbC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Apr 2019 15:31:02 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hHSBe-0005W5-3h
        for fio@vger.kernel.org; Fri, 19 Apr 2019 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190419120001.D97912C0104@kernel.dk>
Date: Fri, 19 Apr 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 96416da576d47c01dd3c9481b03e969908b3ff74:

  Merge branch 'master' of https://github.com/mingnus/fio (2019-04-17 06:50:25 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ff547caad147b437f654881717fedc750c0c9b17:

  fio: Add advise THP option to mmap engine (2019-04-18 10:46:19 -0600)

----------------------------------------------------------------
Keith Busch (1):
      fio: Add advise THP option to mmap engine

 configure      | 27 +++++++++++++++++++++++++++
 engines/mmap.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 optgroup.h     |  2 ++
 3 files changed, 81 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 6e549cdc..3c882f0f 100755
--- a/configure
+++ b/configure
@@ -2326,6 +2326,30 @@ if compile_prog "-Wimplicit-fallthrough" "" "-Wimplicit-fallthrough"; then
 fi
 print_config "-Wimplicit-fallthrough" "$fallthrough"
 
+##########################################
+# check for MADV_HUGEPAGE support
+if test "$thp" != "yes" ; then
+  thp="no"
+fi
+if test "$esx" != "yes" ; then
+  cat > $TMPC <<EOF
+#include <sys/mman.h>
+int main(void)
+{
+  return madvise(0, 0x1000, MADV_HUGEPAGE);
+}
+EOF
+  if compile_prog "" "" "thp" ; then
+    thp=yes
+  else
+    if test "$thp" = "yes" ; then
+      feature_not_found "Transparent Huge Page" ""
+    fi
+    thp=no
+  fi
+fi
+print_config "MADV_HUGEPAGE" "$thp"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2600,6 +2624,9 @@ fi
 if test "$fallthrough" = "yes"; then
   CFLAGS="$CFLAGS -Wimplicit-fallthrough"
 fi
+if test "$thp" = "yes" ; then
+  output_sym "CONFIG_HAVE_THP"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/engines/mmap.c b/engines/mmap.c
index 308b4665..55ba1ab3 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -11,6 +11,7 @@
 #include <sys/mman.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 #include "../verify.h"
 
 /*
@@ -26,11 +27,40 @@ struct fio_mmap_data {
 	off_t mmap_off;
 };
 
+#ifdef CONFIG_HAVE_THP
+struct mmap_options {
+	void *pad;
+	unsigned int thp;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "thp",
+		.lname	= "Transparent Huge Pages",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct mmap_options, thp),
+		.help	= "Memory Advise Huge Page",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_MMAP,
+	},
+	{
+		.name = NULL,
+	},
+};
+#endif
+
 static bool fio_madvise_file(struct thread_data *td, struct fio_file *f,
 			     size_t length)
 
 {
 	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
+#ifdef CONFIG_HAVE_THP
+	struct mmap_options *o = td->eo;
+
+	/* Ignore errors on this optional advisory */
+	if (o->thp)
+		madvise(fmd->mmap_ptr, length, MADV_HUGEPAGE);
+#endif
 
 	if (!td->o.fadvise_hint)
 		return true;
@@ -50,11 +80,27 @@ static bool fio_madvise_file(struct thread_data *td, struct fio_file *f,
 	return true;
 }
 
+#ifdef CONFIG_HAVE_THP
+static int fio_mmap_get_shared(struct thread_data *td)
+{
+	struct mmap_options *o = td->eo;
+
+	if (o->thp)
+		return MAP_PRIVATE;
+	return MAP_SHARED;
+}
+#else
+static int fio_mmap_get_shared(struct thread_data *td)
+{
+	return MAP_SHARED;
+}
+#endif
+
 static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 			 size_t length, off_t off)
 {
 	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
-	int flags = 0;
+	int flags = 0, shared = fio_mmap_get_shared(td);
 
 	if (td_rw(td) && !td->o.verify_only)
 		flags = PROT_READ | PROT_WRITE;
@@ -66,7 +112,7 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 	} else
 		flags = PROT_READ;
 
-	fmd->mmap_ptr = mmap(NULL, length, flags, MAP_SHARED, f->fd, off);
+	fmd->mmap_ptr = mmap(NULL, length, flags, shared, f->fd, off);
 	if (fmd->mmap_ptr == MAP_FAILED) {
 		fmd->mmap_ptr = NULL;
 		td_verror(td, errno, "mmap");
@@ -275,6 +321,10 @@ static struct ioengine_ops ioengine = {
 	.close_file	= fio_mmapio_close_file,
 	.get_file_size	= generic_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_NOEXTEND,
+#ifdef CONFIG_HAVE_THP
+	.options	= options,
+	.option_struct_size = sizeof(struct mmap_options),
+#endif
 };
 
 static void fio_init fio_mmapio_register(void)
diff --git a/optgroup.h b/optgroup.h
index adf4d09b..bf1bb036 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -61,6 +61,7 @@ enum opt_category_group {
 	__FIO_OPT_G_MTD,
 	__FIO_OPT_G_HDFS,
 	__FIO_OPT_G_SG,
+	__FIO_OPT_G_MMAP,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
@@ -97,6 +98,7 @@ enum opt_category_group {
 	FIO_OPT_G_MTD		= (1ULL << __FIO_OPT_G_MTD),
 	FIO_OPT_G_HDFS		= (1ULL << __FIO_OPT_G_HDFS),
 	FIO_OPT_G_SG		= (1ULL << __FIO_OPT_G_SG),
+	FIO_OPT_G_MMAP		= (1ULL << __FIO_OPT_G_MMAP),
 	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
 };
 

