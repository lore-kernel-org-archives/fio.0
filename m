Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38487 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3E3EAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 30 May 2013 00:00:05 -0400
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Uhu20-0005X6-Sn
	for fio@vger.kernel.org; Thu, 30 May 2013 04:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20130530040002.1434A20A76@kernel.dk>
Date: Thu, 30 May 2013 04:00:02 +0000 (UTC)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d179fe19f0f6b56a3335848bfac04df4c758e69f:

  Bump IO engine version number (2013-05-28 14:17:50 +0200)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Bruce Cran (3):
      Update windowsaio for changes to the thread structure
      posix_fadvise is now provided in helpers.c: remove it from the Windows posix.c
      Windows: include winsock2.h instead of windows.h to avoid a warning.

Jens Axboe (2):
      Fix bad merge of write_iops_log= option for fio 2.1
      Makefile: don't run configure for make clean

 Makefile                          |    2 ++
 engines/windowsaio.c              |    8 +++++---
 options.c                         |    2 +-
 os/windows/posix.c                |    5 -----
 os/windows/posix/include/dirent.h |    2 +-
 5 files changed, 9 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 57f3f82..3de9735 100644
--- a/Makefile
+++ b/Makefile
@@ -6,8 +6,10 @@ config-host-mak: configure
 	@sed -n "/.*Configured with/s/[^:]*: //p" $@ | sh
 else
 config-host.mak:
+ifneq ($(MAKECMDGOALS),clean)
 	@echo "Running configure for you..."
 	@./configure
+endif
 all:
 include config-host.mak
 endif
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index ee89fa1..16df740 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -259,9 +259,9 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 					unsigned int max, struct timespec *t)
 {
 	struct windowsaio_data *wd = td->io_ops->data;
-	struct flist_head *entry;
 	unsigned int dequeued = 0;
 	struct io_u *io_u;
+	int i;
 	struct fio_overlapped *fov;
 	DWORD start_count = 0;
 	DWORD end_count = 0;
@@ -275,8 +275,10 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 	}
 
 	do {
-		flist_for_each(entry, &td->io_u_busylist) {
-			io_u = flist_entry(entry, struct io_u, list);
+		io_u_qiter(&td->io_u_all, io_u, i) {
+			if (!(io_u->flags & IO_U_F_FLIGHT))
+				continue;
+
 			fov = (struct fio_overlapped*)io_u->engine_data;
 
 			if (fov->io_complete) {
diff --git a/options.c b/options.c
index d0c53b6..1ca4801 100644
--- a/options.c
+++ b/options.c
@@ -2778,7 +2778,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_iops_log",
 		.lname	= "Write IOPS log",
-		.type	= FIO_OPT_STR,
+		.type	= FIO_OPT_STR_STORE,
 		.off1	= td_var_offset(iops_log_file),
 		.help	= "Write log of IOPS during run",
 		.category = FIO_OPT_C_LOG,
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 794a707..49bce43 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -662,11 +662,6 @@ int getrusage(int who, struct rusage *r_usage)
 	return 0;
 }
 
-int posix_fadvise(int fd, off_t offset, off_t len, int advice)
-{
-	return 0;
-}
-
 int posix_madvise(void *addr, size_t len, int advice)
 {
 	log_err("%s is not implemented\n", __func__);
diff --git a/os/windows/posix/include/dirent.h b/os/windows/posix/include/dirent.h
index 379fdf0..6b4e671 100644
--- a/os/windows/posix/include/dirent.h
+++ b/os/windows/posix/include/dirent.h
@@ -1,7 +1,7 @@
 #ifndef DIRENT_H
 #define DIRENT_H
 
-#include <windows.h>
+#include <winsock2.h>
 
 struct dirent
 {
