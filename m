Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbbLXNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 24 Dec 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aC5V5-00051a-1h
	for fio@vger.kernel.org; Thu, 24 Dec 2015 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151224130002.228AC2C00B1@kernel.dk>
Date: Thu, 24 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5c74fc767600f75cd6d53bdc5926962b75a614ae:

  backend: continue on failed wait_for() check, not break (2015-12-22 13:40:14 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f1480f98ae77ccb23888028563c5ae117d939e55:

  Fio 2.3 (2015-12-23 09:39:04 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      arch: add ffs64 and ffz64
      gfio: use ffz64 for 64-bit types
      Fio 2.3

shoichi.sawada@toshiba.co.jp (1):
      Fix runtime of terse output

 FIO-VERSION-GEN        |  2 +-
 arch/arch.h            |  4 ----
 goptions.c             |  4 ++--
 lib/ffz.h              | 19 +++++++++++++++----
 os/windows/install.wxs |  2 +-
 stat.c                 | 22 +++++++++++-----------
 6 files changed, 30 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 108ca4b..3253034 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.13
+DEF_VER=fio-2.3
 
 LF='
 '
diff --git a/arch/arch.h b/arch/arch.h
index 5671b9a..043e283 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -63,11 +63,7 @@ extern unsigned long arch_flags;
 #include "arch-generic.h"
 #endif
 
-#ifdef ARCH_HAVE_FFZ
-#define ffz(bitmask)	arch_ffz(bitmask)
-#else
 #include "../lib/ffz.h"
-#endif
 
 #ifndef ARCH_HAVE_INIT
 static inline int arch_init(char *envp[])
diff --git a/goptions.c b/goptions.c
index 20a17d1..9279b22 100644
--- a/goptions.c
+++ b/goptions.c
@@ -107,7 +107,7 @@ static GtkWidget *gopt_get_group_frame(struct gopt_job_view *gjv,
 	if (!og)
 		return NULL;
 
-	group = ffz(~groupmask);
+	group = ffz64(~groupmask);
 	gfw = &gjv->g_widgets[group];
 	if (!gfw->vbox[0]) {
 		frame = gtk_frame_new(og->name);
@@ -1139,7 +1139,7 @@ static void gopt_add_options(struct gopt_job_view *gjv,
 		struct opt_group *og;
 
 		while ((og = opt_group_from_mask(&mask)) != NULL) {
-			GtkWidget *vbox = gjv->vboxes[ffz(~og->mask)];
+			GtkWidget *vbox = gjv->vboxes[ffz64(~og->mask)];
 
 			hbox = gtk_hbox_new(FALSE, 3);
 			gtk_box_pack_start(GTK_BOX(vbox), hbox, FALSE, FALSE, 5);
diff --git a/lib/ffz.h b/lib/ffz.h
index eef612d..e2c1b8e 100644
--- a/lib/ffz.h
+++ b/lib/ffz.h
@@ -1,16 +1,16 @@
 #ifndef FIO_FFZ_H
 #define FIO_FFZ_H
 
-static inline int __ffs(unsigned long word)
+#include <inttypes.h>
+
+static inline int ffs64(uint64_t word)
 {
 	int r = 0;
 
-#if BITS_PER_LONG == 64
 	if ((word & 0xffffffff) == 0) {
 		r += 32;
 		word >>= 32;
 	}
-#endif
 	if (!(word & 0xffff)) {
 		word >>= 16;
 		r += 16;
@@ -35,9 +35,20 @@ static inline int __ffs(unsigned long word)
 	return r;
 }
 
+#ifndef ARCH_HAVE_FFZ
+
 static inline int ffz(unsigned long bitmask)
 {
-	return __ffs(~bitmask);
+	return ffs64(~bitmask);
+}
+
+#else
+#define ffz(bitmask)	arch_ffz(bitmask)
+#endif
+
+static inline int ffz64(uint64_t bitmask)
+{
+	return ffs64(~bitmask);
 }
 
 #endif
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 08de42f..299ca9b 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.13">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.3">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/stat.c b/stat.c
index a3bfe63..3070cef 100644
--- a/stat.c
+++ b/stat.c
@@ -1730,19 +1730,19 @@ void __show_running_run_stats(void)
 	fio_gettime(&tv, NULL);
 
 	for_each_td(td, i) {
-		rt[i] = mtime_since(&td->start, &tv);
-		if (td_read(td) && td->io_bytes[DDIR_READ])
-			td->ts.runtime[DDIR_READ] += rt[i];
-		if (td_write(td) && td->io_bytes[DDIR_WRITE])
-			td->ts.runtime[DDIR_WRITE] += rt[i];
-		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
-			td->ts.runtime[DDIR_TRIM] += rt[i];
-
 		td->update_rusage = 1;
 		td->ts.io_bytes[DDIR_READ] = td->io_bytes[DDIR_READ];
 		td->ts.io_bytes[DDIR_WRITE] = td->io_bytes[DDIR_WRITE];
 		td->ts.io_bytes[DDIR_TRIM] = td->io_bytes[DDIR_TRIM];
 		td->ts.total_run_time = mtime_since(&td->epoch, &tv);
+
+		rt[i] = mtime_since(&td->start, &tv);
+		if (td_read(td) && td->ts.io_bytes[DDIR_READ])
+			td->ts.runtime[DDIR_READ] += rt[i];
+		if (td_write(td) && td->ts.io_bytes[DDIR_WRITE])
+			td->ts.runtime[DDIR_WRITE] += rt[i];
+		if (td_trim(td) && td->ts.io_bytes[DDIR_TRIM])
+			td->ts.runtime[DDIR_TRIM] += rt[i];
 	}
 
 	for_each_td(td, i) {
@@ -1758,11 +1758,11 @@ void __show_running_run_stats(void)
 	__show_run_stats();
 
 	for_each_td(td, i) {
-		if (td_read(td) && td->io_bytes[DDIR_READ])
+		if (td_read(td) && td->ts.io_bytes[DDIR_READ])
 			td->ts.runtime[DDIR_READ] -= rt[i];
-		if (td_write(td) && td->io_bytes[DDIR_WRITE])
+		if (td_write(td) && td->ts.io_bytes[DDIR_WRITE])
 			td->ts.runtime[DDIR_WRITE] -= rt[i];
-		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
+		if (td_trim(td) && td->ts.io_bytes[DDIR_TRIM])
 			td->ts.runtime[DDIR_TRIM] -= rt[i];
 	}
 
