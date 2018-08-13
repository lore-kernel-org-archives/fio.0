Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:32824 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729289AbeHMOmQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Aug 2018 10:42:16 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fpBWC-0003q2-4Z
        for fio@vger.kernel.org; Mon, 13 Aug 2018 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180813120001.A7CA12C0311@kernel.dk>
Date: Mon, 13 Aug 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 73027fb9ad6728f5b066e25a9ec923459ceab8a2:

  eta: clean up ETA string printing (2018-08-10 09:33:44 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fee14ab846ef542d9bb9ebf68f11f0ecb8636f5e:

  Merge branch 'minor_fixes' of https://github.com/sitsofe/fio (2018-08-12 15:51:34 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'armv6' of https://github.com/sitsofe/fio
      travis: include new xcode 9.4
      Merge branch 'minor_fixes' of https://github.com/sitsofe/fio

Sitsofe Wheeler (5):
      arch: fix build breakage on armv6
      minor fio.service cleanups
      doc: update Log File Formats and write_iops_log sections
      doc: rewording and add reference to --aux-path
      man: fix missing/too many backslashes

 .travis.yml       |  4 ++++
 HOWTO             | 35 ++++++++++++++++++++---------------
 arch/arch-arm.h   |  3 ++-
 fio.1             | 45 +++++++++++++++++++++++++--------------------
 tools/fio.service |  8 ++++----
 5 files changed, 55 insertions(+), 40 deletions(-)

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index 94f69fb..4a87fe6 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -25,6 +25,10 @@ matrix:
       compiler: clang
       osx_image: xcode8.3
       env: BUILD_ARCH="x86_64"
+    - os: osx
+      compiler: clang
+      osx_image: xcode9.4
+      env: BUILD_ARCH="x86_64"
   exclude:
     - os: osx
       compiler: gcc
diff --git a/HOWTO b/HOWTO
index 16c5ae3..4c117c2 100644
--- a/HOWTO
+++ b/HOWTO
@@ -283,7 +283,8 @@ Command line options
 
 .. option:: --aux-path=path
 
-	Use this `path` for fio state generated files.
+	Use the directory specified by `path` for generated state files instead
+	of the current working directory.
 
 Any parameters following the options will be assumed to be job files, unless
 they match a job file parameter. Multiple job files can be listed and each job
@@ -748,12 +749,15 @@ Target file/device
 	assigned equally distributed to job clones created by :option:`numjobs` as
 	long as they are using generated filenames. If specific `filename(s)` are
 	set fio will use the first listed directory, and thereby matching the
-	`filename` semantic which generates a file each clone if not specified, but
-	let all clones use the same if set.
+	`filename` semantic (which generates a file for each clone if not
+	specified, but lets all clones use the same file if set).
 
 	See the :option:`filename` option for information on how to escape "``:``" and
 	"``\``" characters within the directory path itself.
 
+	Note: To control the directory fio will use for internal state files
+	use :option:`--aux-path`.
+
 .. option:: filename=str
 
 	Fio normally makes up a `filename` based on the job name, thread number, and
@@ -2915,9 +2919,11 @@ Measurements and reporting
 .. option:: write_iops_log=str
 
 	Same as :option:`write_bw_log`, but writes an IOPS file (e.g.
-	:file:`name_iops.x.log`) instead. See :option:`write_bw_log` for
-	details about the filename format and `Log File Formats`_ for how data
-	is structured within the file.
+	:file:`name_iops.x.log`) instead. Because fio defaults to individual
+	I/O logging, the value entry in the IOPS log will be 1 unless windowed
+	logging (see :option:`log_avg_msec`) has been enabled. See
+	:option:`write_bw_log` for details about the filename format and `Log
+	File Formats`_ for how data is structured within the file.
 
 .. option:: log_avg_msec=int
 
@@ -3802,17 +3808,16 @@ on the type of log, it will be one of the following:
 	**2**
 		I/O is a TRIM
 
-The entry's *block size* is always in bytes. The *offset* is the offset, in bytes,
-from the start of the file, for that particular I/O. The logging of the offset can be
+The entry's *block size* is always in bytes. The *offset* is the position in bytes
+from the start of the file for that particular I/O. The logging of the offset can be
 toggled with :option:`log_offset`.
 
-Fio defaults to logging every individual I/O.  When IOPS are logged for individual
-I/Os the *value* entry will always be 1. If windowed logging is enabled through
-:option:`log_avg_msec`, fio logs the average values over the specified period of time.
-If windowed logging is enabled and :option:`log_max_value` is set, then fio logs
-maximum values in that window instead of averages. Since *data direction*, *block
-size* and *offset* are per-I/O values, if windowed logging is enabled they
-aren't applicable and will be 0.
+Fio defaults to logging every individual I/O but when windowed logging is set
+through :option:`log_avg_msec`, either the average (by default) or the maximum
+(:option:`log_max_value` is set) *value* seen over the specified period of time
+is recorded. Each *data direction* seen within the window period will aggregate
+its values in a separate row. Further, when using windowed logging the *block
+size* and *offset* entries will always contain 0.
 
 Client/Server
 -------------
diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index dd286d0..fc1c484 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -6,7 +6,8 @@
 #if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) \
 	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5E__)\
 	|| defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
-	|| defined(__ARM_ARCH_6__)  || defined(__ARM_ARCH_6J__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6ZK__)
+	|| defined(__ARM_ARCH_6__)  || defined(__ARM_ARCH_6J__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6ZK__) \
+	|| defined(__ARM_ARCH_6KZ__)
 #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
 #define write_barrier()	__asm__ __volatile__ ("" : : : "memory")
diff --git a/fio.1 b/fio.1
index 4386f85..0c604a6 100644
--- a/fio.1
+++ b/fio.1
@@ -168,7 +168,8 @@ Set this \fIcommand\fR as local trigger.
 Set this \fIcommand\fR as remote trigger.
 .TP
 .BI \-\-aux\-path \fR=\fPpath
-Use this \fIpath\fR for fio state generated files.
+Use the directory specified by \fIpath\fP for generated state files instead
+of the current working directory.
 .SH "JOB FILE FORMAT"
 Any parameters following the options will be assumed to be job files, unless
 they match a job file parameter. Multiple job files can be listed and each job
@@ -523,12 +524,15 @@ separating the names with a ':' character. These directories will be
 assigned equally distributed to job clones created by \fBnumjobs\fR as
 long as they are using generated filenames. If specific \fBfilename\fR(s) are
 set fio will use the first listed directory, and thereby matching the
-\fBfilename\fR semantic which generates a file each clone if not specified, but
-let all clones use the same if set.
+\fBfilename\fR semantic (which generates a file for each clone if not
+specified, but lets all clones use the same file if set).
 .RS
 .P
-See the \fBfilename\fR option for information on how to escape ':' and '\'
+See the \fBfilename\fR option for information on how to escape ':' and '\\'
 characters within the directory path itself.
+.P
+Note: To control the directory fio will use for internal state files
+use \fB\-\-aux\-path\fR.
 .RE
 .TP
 .BI filename \fR=\fPstr
@@ -545,13 +549,13 @@ by this option will be \fBsize\fR divided by number of files unless an
 explicit size is specified by \fBfilesize\fR.
 .RS
 .P
-Each colon and backslash in the wanted path must be escaped with a '\'
+Each colon and backslash in the wanted path must be escaped with a '\\'
 character. For instance, if the path is `/dev/dsk/foo@3,0:c' then you
 would use `filename=/dev/dsk/foo@3,0\\:c' and if the path is
-`F:\\\\filename' then you would use `filename=F\\:\\\\filename'.
+`F:\\filename' then you would use `filename=F\\:\\\\filename'.
 .P
-On Windows, disk devices are accessed as `\\\\\\\\.\\\\PhysicalDrive0' for
-the first device, `\\\\\\\\.\\\\PhysicalDrive1' for the second etc.
+On Windows, disk devices are accessed as `\\\\.\\PhysicalDrive0' for
+the first device, `\\\\.\\PhysicalDrive1' for the second etc.
 Note: Windows and FreeBSD prevent write access to areas
 of the disk containing in\-use data (e.g. filesystems).
 .P
@@ -2608,9 +2612,11 @@ within the file.
 .TP
 .BI write_iops_log \fR=\fPstr
 Same as \fBwrite_bw_log\fR, but writes an IOPS file (e.g.
-`name_iops.x.log') instead. See \fBwrite_bw_log\fR for
-details about the filename format and the \fBLOG FILE FORMATS\fR section for how data
-is structured within the file.
+`name_iops.x.log`) instead. Because fio defaults to individual
+I/O logging, the value entry in the IOPS log will be 1 unless windowed
+logging (see \fBlog_avg_msec\fR) has been enabled. See
+\fBwrite_bw_log\fR for details about the filename format and \fBLOG
+FILE FORMATS\fR for how data is structured within the file.
 .TP
 .BI log_avg_msec \fR=\fPint
 By default, fio will log an entry in the iops, latency, or bw log for every
@@ -3527,17 +3533,16 @@ I/O is a WRITE
 I/O is a TRIM
 .RE
 .P
-The entry's `block size' is always in bytes. The `offset' is the offset, in bytes,
-from the start of the file, for that particular I/O. The logging of the offset can be
+The entry's `block size' is always in bytes. The `offset' is the position in bytes
+from the start of the file for that particular I/O. The logging of the offset can be
 toggled with \fBlog_offset\fR.
 .P
-Fio defaults to logging every individual I/O. When IOPS are logged for individual
-I/Os the `value' entry will always be 1. If windowed logging is enabled through
-\fBlog_avg_msec\fR, fio logs the average values over the specified period of time.
-If windowed logging is enabled and \fBlog_max_value\fR is set, then fio logs
-maximum values in that window instead of averages. Since `data direction', `block size'
-and `offset' are per\-I/O values, if windowed logging is enabled they
-aren't applicable and will be 0.
+Fio defaults to logging every individual I/O but when windowed logging is set
+through \fBlog_avg_msec\fR, either the average (by default) or the maximum
+(\fBlog_max_value\fR is set) `value' seen over the specified period of time
+is recorded. Each `data direction' seen within the window period will aggregate
+its values in a separate row. Further, when using windowed logging the `block
+size' and `offset' entries will always contain 0.
 .SH CLIENT / SERVER
 Normally fio is invoked as a stand\-alone application on the machine where the
 I/O workload should be generated. However, the backend and frontend of fio can
diff --git a/tools/fio.service b/tools/fio.service
index 21de0b7..678158b 100644
--- a/tools/fio.service
+++ b/tools/fio.service
@@ -1,10 +1,10 @@
 [Unit]
-
-Description=flexible I/O tester server
+Description=Flexible I/O tester server
 After=network.target
 
 [Service]
-
 Type=simple
-PIDFile=/run/fio.pid
 ExecStart=/usr/bin/fio --server
+
+[Install]
+WantedBy=multi-user.target

