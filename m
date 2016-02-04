Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965015AbcBDNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Feb 2016 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aRJVy-0000vY-Nb
	for fio@vger.kernel.org; Thu, 04 Feb 2016 13:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160204130001.D52342C2157@kernel.dk>
Date: Thu,  4 Feb 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3bb85e8443d626ee71a4126dbe6ebcaf751527f1:

  Add a note of what is the default value for random_generator (2016-01-30 22:03:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d96d3bb34689d0290174134e5a4770056dd4f980:

  stat: cleanup average logging (2016-02-03 21:10:33 -0700)

----------------------------------------------------------------
Eric Whitney (1):
      fio: fix ignore_error regression

Jens Axboe (1):
      stat: cleanup average logging

Robin H. Johnson (2):
      Makefile: false positive on _FORTIFY_SOURCE
      libmtd: compile fix for linux header changes.

 Makefile       |  2 +-
 backend.c      |  8 ++++++++
 oslib/libmtd.h |  3 +++
 stat.c         | 31 +++++++++++++------------------
 4 files changed, 25 insertions(+), 19 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 9b15afe..684b565 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ all:
 include config-host.mak
 endif
 
-DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
+DEBUGFLAGS = -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
diff --git a/backend.c b/backend.c
index 2078409..fd81849 100644
--- a/backend.c
+++ b/backend.c
@@ -520,6 +520,14 @@ sync_done:
 			if (*ret < 0)
 				break;
 		}
+
+		/*
+		 * when doing I/O (not when verifying),
+		 * check for any errors that are to be ignored
+		 */
+		if (!from_verify)
+			break;
+
 		return 0;
 	case FIO_Q_QUEUED:
 		/*
diff --git a/oslib/libmtd.h b/oslib/libmtd.h
index 3625de5..b5fd3f3 100644
--- a/oslib/libmtd.h
+++ b/oslib/libmtd.h
@@ -29,6 +29,9 @@
 extern "C" {
 #endif
 
+// Needed for uint8_t, uint64_t
+#include <stdint.h>
+
 /* Maximum MTD device name length */
 #define MTD_NAME_MAX 127
 /* Maximum MTD device type string length */
diff --git a/stat.c b/stat.c
index 3070cef..73fd9f9 100644
--- a/stat.c
+++ b/stat.c
@@ -1942,35 +1942,30 @@ void reset_io_stats(struct thread_data *td)
 	}
 }
 
-static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed)
+static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
+			      unsigned long elapsed)
 {
 	/*
 	 * Note an entry in the log. Use the mean from the logged samples,
 	 * making sure to properly round up. Only write a log entry if we
 	 * had actual samples done.
 	 */
-	if (iolog->avg_window[DDIR_READ].samples) {
-		unsigned long mr;
+	if (iolog->avg_window[ddir].samples) {
+		unsigned long val;
 
-		mr = iolog->avg_window[DDIR_READ].mean.u.f + 0.50;
-		__add_log_sample(iolog, mr, DDIR_READ, 0, elapsed, 0);
+		val = iolog->avg_window[ddir].mean.u.f + 0.50;
+		__add_log_sample(iolog, val, ddir, 0, elapsed, 0);
 	}
-	if (iolog->avg_window[DDIR_WRITE].samples) {
-		unsigned long mw;
 
-		mw = iolog->avg_window[DDIR_WRITE].mean.u.f + 0.50;
-		__add_log_sample(iolog, mw, DDIR_WRITE, 0, elapsed, 0);
-	}
-	if (iolog->avg_window[DDIR_TRIM].samples) {
-		unsigned long mw;
+	reset_io_stat(&iolog->avg_window[ddir]);
+}
 
-		mw = iolog->avg_window[DDIR_TRIM].mean.u.f + 0.50;
-		__add_log_sample(iolog, mw, DDIR_TRIM, 0, elapsed, 0);
-	}
+static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed)
+{
+	int ddir;
 
-	reset_io_stat(&iolog->avg_window[DDIR_READ]);
-	reset_io_stat(&iolog->avg_window[DDIR_WRITE]);
-	reset_io_stat(&iolog->avg_window[DDIR_TRIM]);
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
+		__add_stat_to_log(iolog, ddir, elapsed);
 }
 
 static void add_log_sample(struct thread_data *td, struct io_log *iolog,
