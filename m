Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33661 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdH2VMe (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 29 Aug 2017 17:12:34 -0400
Received: by mail-lf0-f66.google.com with SMTP id y15so2850914lfd.0
        for <fio@vger.kernel.org>; Tue, 29 Aug 2017 14:12:33 -0700 (PDT)
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/6] filesetup: add non O_DIRECT direct I/O support for initial layout setup
Date: Wed, 30 Aug 2017 00:12:14 +0300
Message-Id: <20170829211216.42347-5-tkusumi@tuxera.com>
In-Reply-To: <20170829211216.42347-1-tkusumi@tuxera.com>
References: <20170829211216.42347-1-tkusumi@tuxera.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

8c43ba62('filesetup: align layout buffer') and
6e344dc3('filesetup: keep OS_O_DIRECT flag when pre-allocating file')
only consider OS with open(O_DIRECT).

This commit adds fio_set_directio() since now OS specific direct I/O
initialization is needed by both real ->fd and temporary ->fd while in
extend_file() to equally support the feature.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 file.h      |  1 +
 filesetup.c | 31 +++++++++++++++++++++++++++++++
 ioengines.c | 25 ++-----------------------
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/file.h b/file.h
index 84daa5f..ad8802d 100644
--- a/file.h
+++ b/file.h
@@ -211,5 +211,6 @@ extern void filesetup_mem_free(void);
 extern void fio_file_reset(struct thread_data *, struct fio_file *);
 extern bool fio_files_done(struct thread_data *);
 extern bool exists_and_not_regfile(const char *);
+extern int fio_set_directio(struct thread_data *, struct fio_file *);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index a6a94ee..4ceaef6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -196,6 +196,9 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
+	if (td->o.odirect && !OS_O_DIRECT && fio_set_directio(td, f))
+		goto err;
+
 	left = f->real_file_size;
 	bs = td->o.max_bs[DDIR_WRITE];
 	if (bs > left)
@@ -1852,3 +1855,31 @@ void filesetup_mem_free(void)
 {
 	free_already_allocated();
 }
+
+/*
+ * This function is for platforms which support direct I/O but not O_DIRECT.
+ */
+int fio_set_directio(struct thread_data *td, struct fio_file *f)
+{
+#ifdef FIO_OS_DIRECTIO
+	int ret = fio_set_odirect(f->fd);
+
+	if (ret) {
+		td_verror(td, ret, "fio_set_directio");
+#if defined(__sun__)
+		if (ret == ENOTTY) { /* ENOTTY suggests RAW device or ZFS */
+			log_err("fio: doing directIO to RAW devices or ZFS not supported\n");
+		} else {
+			log_err("fio: the file system does not seem to support direct IO\n");
+		}
+#else
+		log_err("fio: the file system does not seem to support direct IO\n");
+#endif
+		return -1;
+	}
+
+	return 0;
+#else
+	return -1;
+#endif
+}
diff --git a/ioengines.c b/ioengines.c
index 6e135af..919781c 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -495,29 +495,8 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 	}
 #endif
 
-#ifdef FIO_OS_DIRECTIO
-	/*
-	 * Some OS's have a distinct call to mark the file non-buffered,
-	 * instead of using O_DIRECT (Solaris)
-	 */
-	if (td->o.odirect) {
-		int ret = fio_set_odirect(f->fd);
-
-		if (ret) {
-			td_verror(td, ret, "fio_set_odirect");
-#if defined(__sun__)
-			if (ret == ENOTTY) { /* ENOTTY suggests RAW device or ZFS */
-				log_err("fio: doing directIO to RAW devices or ZFS not supported\n");
-			} else {
-				log_err("fio: the file system does not seem to support direct IO\n");
-			}
-#else
-			log_err("fio: the file system does not seem to support direct IO\n");
-#endif
-			goto err;
-		}
-	}
-#endif
+	if (td->o.odirect && !OS_O_DIRECT && fio_set_directio(td, f))
+		goto err;
 
 done:
 	log_file(td, f, FIO_LOG_OPEN_FILE);
-- 
2.9.5

