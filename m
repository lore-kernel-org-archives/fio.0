Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41024 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbgCBNAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 2 Mar 2020 08:00:17 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j8kgB-0001Vu-CJ
        for fio@vger.kernel.org; Mon, 02 Mar 2020 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200302130001.CF0131BC0179@kernel.dk>
Date: Mon,  2 Mar 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 58d3994d9be0783990af82571cea819b499d526c:

  io_uring: we should not need two write barriers for SQ updates (2020-02-26 19:54:12 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 941e3356a7edde556ffd81c9767ded218de20a50:

  Merge branch 'genfio-bash' of https://github.com/sitsofe/fio (2020-03-01 15:43:14 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'clean1' of https://github.com/kusumi/fio
      Merge branch 'fix-win-raw' of https://github.com/sitsofe/fio
      Merge branch 'genfio-bash' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      genfio: use /bin/bash hashbang
      filesetup: fix win raw disk access and improve dir creation failure msg

Tomohiro Kusumi (1):
      Makefile: don't fail to remove conditionally compiled binaries on clean

 Makefile        |  1 +
 filesetup.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++++++---
 os/os-windows.h |  6 +++++-
 tools/genfio    |  2 +-
 4 files changed, 56 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 027b62bc..72ab39e9 100644
--- a/Makefile
+++ b/Makefile
@@ -511,6 +511,7 @@ endif
 
 clean: FORCE
 	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] profiles/*.[do] t/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
+	@rm -f t/fio-btrace2fio t/io_uring t/read-to-pipe-async
 	@rm -rf  doc/output
 
 distclean: clean FORCE
diff --git a/filesetup.c b/filesetup.c
index b45a5826..8a4091fc 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -913,15 +913,61 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 	return offset;
 }
 
+/*
+ * Find longest path component that exists and return its length
+ */
+int longest_existing_path(char *path) {
+	char buf[PATH_MAX];
+	bool done;
+	char *buf_pos;
+	int offset;
+#ifdef WIN32
+	DWORD dwAttr;
+#else
+	struct stat sb;
+#endif
+
+	sprintf(buf, "%s", path);
+	done = false;
+	while (!done) {
+		buf_pos = strrchr(buf, FIO_OS_PATH_SEPARATOR);
+		if (!buf_pos) {
+			done = true;
+			offset = 0;
+			break;
+		}
+
+		*(buf_pos + 1) = '\0';
+
+#ifdef WIN32
+		dwAttr = GetFileAttributesA(buf);
+		if (dwAttr != INVALID_FILE_ATTRIBUTES) {
+			done = true;
+		}
+#else
+		if (stat(buf, &sb) == 0)
+			done = true;
+#endif
+		if (done)
+			offset = buf_pos - buf;
+		else
+			*buf_pos = '\0';
+	}
+
+	return offset;
+}
+
 static bool create_work_dirs(struct thread_data *td, const char *fname)
 {
 	char path[PATH_MAX];
 	char *start, *end;
+	int offset;
 
 	snprintf(path, PATH_MAX, "%s", fname);
 	start = path;
 
-	end = start;
+	offset = longest_existing_path(path);
+	end = start + offset;
 	while ((end = strchr(end, FIO_OS_PATH_SEPARATOR)) != NULL) {
 		if (end == start) {
 			end++;
@@ -930,8 +976,8 @@ static bool create_work_dirs(struct thread_data *td, const char *fname)
 		*end = '\0';
 		errno = 0;
 		if (fio_mkdir(path, 0700) && errno != EEXIST) {
-			log_err("fio: failed to create dir (%s): %d\n",
-				start, errno);
+			log_err("fio: failed to create dir (%s): %s\n",
+				start, strerror(errno));
 			return false;
 		}
 		*end = FIO_OS_PATH_SEPARATOR;
diff --git a/os/os-windows.h b/os/os-windows.h
index 6d48ffe8..fa2955f9 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -203,7 +203,11 @@ static inline int fio_mkdir(const char *path, mode_t mode) {
 	}
 
 	if (CreateDirectoryA(path, NULL) == 0) {
-		log_err("CreateDirectoryA = %d\n", GetLastError());
+		/* Ignore errors if path is a device namespace */
+		if (strcmp(path, "\\\\.") == 0) {
+			errno = EEXIST;
+			return -1;
+		}
 		errno = win_to_posix_error(GetLastError());
 		return -1;
 	}
diff --git a/tools/genfio b/tools/genfio
index 286d814d..8518bbcc 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -1,4 +1,4 @@
-#!/usr/bin/bash
+#!/bin/bash
 #
 #  Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
 #  Author: Erwan Velu  <erwan@enovance.com>

