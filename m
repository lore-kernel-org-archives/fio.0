Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729273AbgHTMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Aug 2020 08:00:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E93C061385
        for <fio@vger.kernel.org>; Thu, 20 Aug 2020 05:00:12 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8jEm-0004LR-59
        for fio@vger.kernel.org; Thu, 20 Aug 2020 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200820120001.875DC1BC0181@kernel.dk>
Date: Thu, 20 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3c1f3ca75b447a2bd0a93deb0a2a1210529d2ccb:

  Merge branch 'filelock_assert_fix' of https://github.com/bardavid/fio into master (2020-08-18 08:33:49 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e711df54082b5d2d739e9ee3e46a2bc23b1b3c7c:

  file: provider fio_file_free() helper (2020-08-19 13:02:42 -0600)

----------------------------------------------------------------
Dmitry Fomichev (1):
      configure: fix syntax error with NetBSD

Jens Axboe (5):
      engines/windowsaio: fix silly thinky on IO thread creation
      Merge branch 'force-windows-artifact' of https://github.com/sitsofe/fio into master
      file: track allocation origin
      init: add_job() needs to use right file freeing functions
      file: provider fio_file_free() helper

Sitsofe Wheeler (1):
      ci: always upload Windows MSI if smoke test passes

 .appveyor.yml        | 10 ++++------
 configure            | 14 +++++++-------
 engines/windowsaio.c |  8 +++-----
 file.h               |  3 +++
 filesetup.c          | 31 ++++++++++++++++---------------
 init.c               |  7 ++-----
 6 files changed, 35 insertions(+), 38 deletions(-)

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index 5c0266a1..352caeee 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -25,15 +25,13 @@ build_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --disable-native --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
 
 after_build:
-  - cd os\windows && dobuild.cmd %PLATFORM%
+  - file.exe fio.exe
+  - make.exe test
+  - 'cd os\windows && dobuild.cmd %PLATFORM% && cd ..'
+  - ps: Get-ChildItem .\os\windows\*.msi | % { Push-AppveyorArtifact $_.FullName -FileName $_.Name -DeploymentName fio.msi }
 
 test_script:
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -f fio.exe ] && python.exe t/run-fio-tests.py --artifact-root test-artifacts --debug'
 
-artifacts:
-  - path: os\windows\*.msi
-    name: msi
-
 on_finish:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -d test-artifacts ] && 7z a -t7z test-artifacts.7z test-artifacts -xr!foo.0.0 -xr!latency.?.0 -xr!fio_jsonplus_clat2csv.test && appveyor PushArtifact test-artifacts.7z'
diff --git a/configure b/configure
index dd7fe3d2..d3997b5f 100755
--- a/configure
+++ b/configure
@@ -134,18 +134,18 @@ output_sym() {
 }
 
 check_min_lib_version() {
-  local feature=$3
+  _feature=$3
 
-  if ${cross_prefix}pkg-config --atleast-version=$2 $1 > /dev/null 2>&1; then
+  if "${cross_prefix}"pkg-config --atleast-version="$2" "$1" > /dev/null 2>&1; then
     return 0
   fi
-  : ${feature:=${1}}
-  if ${cross_prefix}pkg-config --version > /dev/null 2>&1; then
-    if test ${!feature} = "yes" ; then
-      feature_not_found "$feature" "$1 >= $2"
+  : "${_feature:=${1}}"
+  if "${cross_prefix}"pkg-config --version > /dev/null 2>&1; then
+    if eval "echo \$$_feature" = "yes" ; then
+      feature_not_found "$_feature" "$1 >= $2"
     fi
   else
-    print_config "$1" "missing pkg-config, can't check $feature version"
+    print_config "$1" "missing pkg-config, can't check $_feature version"
   fi
   return 1
 }
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index ff8b6e1b..5c7e7964 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -106,12 +106,10 @@ static int fio_windowsaio_init(struct thread_data *td)
 			ctx->iocp = hFile;
 			ctx->wd = wd;
 			wd->iothread = CreateThread(NULL, 0, IoCompletionRoutine, ctx, 0, &threadid);
-
-			if (wd->iothread != NULL &&
-			    fio_option_is_set(&td->o, cpumask))
-				fio_setaffinity(threadid, td->o.cpumask);
-			else
+			if (!wd->iothread)
 				log_err("windowsaio: failed to create io completion thread\n");
+			else if (fio_option_is_set(&td->o, cpumask))
+				fio_setaffinity(threadid, td->o.cpumask);
 		}
 
 		if (rc || wd->iothread == NULL)
diff --git a/file.h b/file.h
index 375bbfd3..493ec04a 100644
--- a/file.h
+++ b/file.h
@@ -33,6 +33,7 @@ enum fio_file_flags {
 	FIO_FILE_partial_mmap	= 1 << 6,	/* can't do full mmap */
 	FIO_FILE_axmap		= 1 << 7,	/* uses axmap */
 	FIO_FILE_lfsr		= 1 << 8,	/* lfsr is used */
+	FIO_FILE_smalloc	= 1 << 9,	/* smalloc file/file_name */
 };
 
 enum file_lock_mode {
@@ -188,6 +189,7 @@ FILE_FLAG_FNS(hashed);
 FILE_FLAG_FNS(partial_mmap);
 FILE_FLAG_FNS(axmap);
 FILE_FLAG_FNS(lfsr);
+FILE_FLAG_FNS(smalloc);
 #undef FILE_FLAG_FNS
 
 /*
@@ -229,5 +231,6 @@ extern void fio_file_reset(struct thread_data *, struct fio_file *);
 extern bool fio_files_done(struct thread_data *);
 extern bool exists_and_not_regfile(const char *);
 extern int fio_set_directio(struct thread_data *, struct fio_file *);
+extern void fio_file_free(struct fio_file *);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index 49c54b81..d382fa24 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1445,11 +1445,23 @@ void close_files(struct thread_data *td)
 	}
 }
 
+void fio_file_free(struct fio_file *f)
+{
+	if (fio_file_axmap(f))
+		axmap_free(f->io_axmap);
+	if (!fio_file_smalloc(f)) {
+		free(f->file_name);
+		free(f);
+	} else {
+		sfree(f->file_name);
+		sfree(f);
+	}
+}
+
 void close_and_free_files(struct thread_data *td)
 {
 	struct fio_file *f;
 	unsigned int i;
-	bool use_free = td_ioengine_flagged(td, FIO_NOFILEHASH);
 
 	dprint(FD_FILE, "close files\n");
 
@@ -1470,20 +1482,7 @@ void close_and_free_files(struct thread_data *td)
 		}
 
 		zbd_close_file(f);
-
-		if (use_free)
-			free(f->file_name);
-		else
-			sfree(f->file_name);
-		f->file_name = NULL;
-		if (fio_file_axmap(f)) {
-			axmap_free(f->io_axmap);
-			f->io_axmap = NULL;
-		}
-		if (use_free)
-			free(f);
-		else
-			sfree(f);
+		fio_file_free(f);
 	}
 
 	td->o.filename = NULL;
@@ -1609,6 +1608,8 @@ static struct fio_file *alloc_new_file(struct thread_data *td)
 	f->fd = -1;
 	f->shadow_fd = -1;
 	fio_file_reset(td, f);
+	if (!td_ioengine_flagged(td, FIO_NOFILEHASH))
+		fio_file_set_smalloc(f);
 	return f;
 }
 
diff --git a/init.c b/init.c
index 6ff7c68d..491b46e6 100644
--- a/init.c
+++ b/init.c
@@ -1735,11 +1735,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		if (file_alloced) {
 			if (td_new->files) {
 				struct fio_file *f;
-				for_each_file(td_new, f, i) {
-					if (f->file_name)
-						sfree(f->file_name);
-					sfree(f);
-				}
+				for_each_file(td_new, f, i)
+					fio_file_free(f);
 				free(td_new->files);
 				td_new->files = NULL;
 			}

