Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38736 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaCMMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 13 Mar 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WO4Iu-0006Er-C6
	for fio@vger.kernel.org; Thu, 13 Mar 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140313120003.5C5FB400A2@strynoevaenget.dk>
Date: Thu, 13 Mar 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3939fe853fd146378811a05b78731d7f20d0152f:

  Add exceeds_number_ios() helper (2014-03-11 20:16:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dac45f23c3c7d146f7df82047ae7f25abf231ed3:

  stat: fixup fio-dump-status file location (2014-03-12 13:40:09 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Update documentation for filename/directory
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      stat: fixup fio-dump-status file location

 HOWTO           |    3 ++-
 fio.1           |   11 +++++++++--
 os/os-windows.h |    5 -----
 stat.c          |    2 +-
 4 files changed, 12 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 9a9f02a..725214f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -262,7 +262,8 @@ description=str	Text description of the job. Doesn't do anything except
 		not parsed.
 
 directory=str	Prefix filenames with this directory. Used to place files
-		in a different location than "./".
+		in a different location than "./". See the 'filename' option
+		for escaping certain characters.
 
 filename=str	Fio normally makes up a filename based on the job name,
 		thread number, and file number. If you want to share
diff --git a/fio.1 b/fio.1
index 764e323..2dee56b 100644
--- a/fio.1
+++ b/fio.1
@@ -166,7 +166,9 @@ character. These directories will be assigned equally distributed to job clones
 creates with \fInumjobs\fR as long as they are using generated filenames.
 If specific \fIfilename(s)\fR are set fio will use the first listed directory,
 and thereby matching the  \fIfilename\fR semantic which generates a file each
-clone if not specified, but let all clones use the same if set.
+clone if not specified, but let all clones use the same if set. See
+\fIfilename\fR for considerations regarding escaping certain characters on
+some platforms.
 .TP
 .BI filename \fR=\fPstr
 .B fio
@@ -176,7 +178,12 @@ specify a \fIfilename\fR for each of them to override the default.
 If the I/O engine is file-based, you can specify
 a number of files by separating the names with a `:' character. `\-' is a
 reserved name, meaning stdin or stdout, depending on the read/write direction
-set.
+set. On Windows, disk devices are accessed as \\.\PhysicalDrive0 for the first
+device, \\.\PhysicalDrive1 for the second etc. Note: Windows and FreeBSD
+prevent write access to areas of the disk containing in-use data
+(e.g. filesystems). If the wanted filename does need to include a colon, then
+escape that with a '\' character. For instance, if the filename is
+"/dev/dsk/foo@3,0:c", then you would use filename="/dev/dsk/foo@3,0\:c".
 .TP
 .BI filename_format \fR=\fPstr
 If sharing multiple files between jobs, it is usually necessary to have
diff --git a/os/os-windows.h b/os/os-windows.h
index 49f9606..6603635 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -162,11 +162,6 @@ static inline unsigned long long os_phys_mem(void)
 	return (unsigned long long) pages * (unsigned long long) pagesize;
 }
 
-static inline void os_get_tmpdir(char *path, int len)
-{
-	GetTempPath(len, path);
-}
-
 static inline int gettid(void)
 {
 	return GetCurrentThreadId();
diff --git a/stat.c b/stat.c
index e43db8f..f018f33 100644
--- a/stat.c
+++ b/stat.c
@@ -1480,7 +1480,7 @@ void show_running_run_stats(void)
 static int status_interval_init;
 static struct timeval status_time;
 
-#define FIO_STATUS_FILE		"/tmp/fio-dump-status"
+#define FIO_STATUS_FILE		"fio-dump-status"
 
 static int check_status_file(void)
 {
