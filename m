Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58856 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 Oct 2019 08:00:16 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHRgU-0002mQ-VQ
        for fio@vger.kernel.org; Mon, 07 Oct 2019 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191007120001.5C0E62C086D@kernel.dk>
Date: Mon,  7 Oct 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 13e9c0b09c0c8d892b790aeaf736263dd76f2d2e:

  Windows: Update URLs to https, and remove mention of WiX version (2019-10-02 08:23:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 58d68a0dad21fb8aed34bb987e00b9b7dee65296:

  Merge branch 'error-on-implicit-decl' of https://github.com/sitsofe/fio (2019-10-06 09:15:51 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'error-on-implicit-decl' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      configure: stop enabling fdatasync on OSX

 HOWTO       | 2 +-
 configure   | 4 ++--
 fio.1       | 2 +-
 os/os-mac.h | 6 ------
 4 files changed, 4 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4fef1504..96a047de 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1279,7 +1279,7 @@ I/O type
 .. option:: fdatasync=int
 
 	Like :option:`fsync` but uses :manpage:`fdatasync(2)` to only sync data and
-	not metadata blocks.  In Windows, FreeBSD, and DragonFlyBSD there is no
+	not metadata blocks. In Windows, FreeBSD, DragonFlyBSD or OSX there is no
 	:manpage:`fdatasync(2)` so this falls back to using :manpage:`fsync(2)`.
 	Defaults to 0, which means fio does not periodically issue and wait for a
 	data-only sync to complete.
diff --git a/configure b/configure
index 59da2f7e..e32d5dcf 100755
--- a/configure
+++ b/configure
@@ -88,14 +88,14 @@ do_cc() {
 }
 
 compile_object() {
-  do_cc $CFLAGS -c -o $TMPO $TMPC
+  do_cc $CFLAGS -Werror-implicit-function-declaration -c -o $TMPO $TMPC
 }
 
 compile_prog() {
   local_cflags="$1"
   local_ldflags="$2 $LIBS"
   echo "Compiling test case $3" >> config.log
-  do_cc $CFLAGS $local_cflags -o $TMPE $TMPC $LDFLAGS $local_ldflags
+  do_cc $CFLAGS -Werror-implicit-function-declaration $local_cflags -o $TMPE $TMPC $LDFLAGS $local_ldflags
 }
 
 feature_not_found() {
diff --git a/fio.1 b/fio.1
index 77a2d799..6685e507 100644
--- a/fio.1
+++ b/fio.1
@@ -1050,7 +1050,7 @@ see \fBend_fsync\fR and \fBfsync_on_close\fR.
 .TP
 .BI fdatasync \fR=\fPint
 Like \fBfsync\fR but uses \fBfdatasync\fR\|(2) to only sync data and
-not metadata blocks. In Windows, FreeBSD, and DragonFlyBSD there is no
+not metadata blocks. In Windows, FreeBSD, DragonFlyBSD or OSX there is no
 \fBfdatasync\fR\|(2) so this falls back to using \fBfsync\fR\|(2).
 Defaults to 0, which means fio does not periodically issue and wait for a
 data\-only sync to complete.
diff --git a/os/os-mac.h b/os/os-mac.h
index a073300c..0d97f6b9 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -97,12 +97,6 @@ static inline int gettid(void)
 }
 #endif
 
-/*
- * For some reason, there's no header definition for fdatasync(), even
- * if it exists.
- */
-extern int fdatasync(int fd);
-
 static inline bool fio_fallocate(struct fio_file *f, uint64_t offset, uint64_t len)
 {
 	fstore_t store = {F_ALLOCATEALL, F_PEOFPOSMODE, offset, len};

