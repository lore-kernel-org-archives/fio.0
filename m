Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 06/15] Mention default values for readwrite=/ioengine=/mem= in documentation
Date: Wed, 27 Jul 2016 22:37:11 +0900
Message-Id: <1469626640-13335-6-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

HOWTO/fio(1) mention defaults for many of the available options.
This commit adds defaults for the following options.

 readwrite=
 ioengine=
 mem=

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 HOWTO | 6 +++++-
 fio.1 | 6 ++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index ca114a4..7f25bbc 100644
--- a/HOWTO
+++ b/HOWTO
@@ -405,6 +405,7 @@ rw=str		Type of io pattern. Accepted values are:
 			trimwrite	Mixed trims and writes. Blocks will be
 					trimmed first, then written to.
 
+		Fio defaults to read if the option is not specified.
 		For the mixed io types, the default is to split them 50/50.
 		For certain types of io the result may still be skewed a bit,
 		since the speed may be different. It is possible to specify
@@ -699,7 +700,8 @@ ioengine=str	Defines how the job issues io to the file. The following
 			sync	Basic read(2) or write(2) io. lseek(2) is
 				used to position the io location.
 
-			psync 	Basic pread(2) or pwrite(2) io.
+			psync 	Basic pread(2) or pwrite(2) io. Default on all
+				supported operating systems except for Windows.
 
 			vsync	Basic readv(2) or writev(2) IO.
 
@@ -717,6 +719,7 @@ ioengine=str	Defines how the job issues io to the file. The following
 			solarisaio Solaris native asynchronous io.
 
 			windowsaio Windows native asynchronous io.
+				Default on Windows.
 
 			mmap	File is memory mapped and data copied
 				to/from using memcpy(3).
@@ -1221,6 +1224,7 @@ mem=str		Fio can use various types of memory as the io unit buffer.
 		The allowed values are:
 
 			malloc	Use memory from malloc(3) as the buffers.
+				Default memory type.
 
 			shm	Use shared memory as the buffers. Allocated
 				through shmget(2).
diff --git a/fio.1 b/fio.1
index ac8e205..739d950 100644
--- a/fio.1
+++ b/fio.1
@@ -309,6 +309,7 @@ Trim and write mixed workload. Blocks will be trimmed first, then the same
 blocks will be written to.
 .RE
 .P
+Fio defaults to read if the option is not specified.
 For mixed I/O, the default split is 50/50. For certain types of io the result
 may still be skewed a bit, since the speed may be different. It is possible to
 specify a number of IO's to do before getting a new offset, this is done by
@@ -602,6 +603,7 @@ position the I/O location.
 .TP
 .B psync
 Basic \fBpread\fR\|(2) or \fBpwrite\fR\|(2) I/O.
+Default on all supported operating systems except for Windows.
 .TP
 .B vsync
 Basic \fBreadv\fR\|(2) or \fBwritev\fR\|(2) I/O. Will emulate queuing by
@@ -623,7 +625,7 @@ POSIX asynchronous I/O using \fBaio_read\fR\|(3) and \fBaio_write\fR\|(3).
 Solaris native asynchronous I/O.
 .TP
 .B windowsaio
-Windows native asynchronous I/O.
+Windows native asynchronous I/O. Default on Windows.
 .TP
 .B mmap
 File is memory mapped with \fBmmap\fR\|(2) and data copied using
@@ -1150,7 +1152,7 @@ Allocation method for I/O unit buffer.  Allowed values are:
 .RS
 .TP
 .B malloc
-Allocate memory with \fBmalloc\fR\|(3).
+Allocate memory with \fBmalloc\fR\|(3). Default memory type.
 .TP
 .B shm
 Use shared memory buffers allocated through \fBshmget\fR\|(2).
-- 
2.5.5


