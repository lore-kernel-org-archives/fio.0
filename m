Return-Path: <jmoyer@redhat.com>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] fio.1 - escape the escape character so it shows up
Date: Thu, 03 Jul 2014 14:20:28 -0400
Message-ID: <x49bnt6wbgz.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi, Jens,

In the filename= text, the escape character gets eaten.  This fixes it
for me.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fio.1 b/fio.1
index da44e57..72625fd 100644
--- a/fio.1
+++ b/fio.1
@@ -182,8 +182,8 @@ set. On Windows, disk devices are accessed as \\.\PhysicalDrive0 for the first
 device, \\.\PhysicalDrive1 for the second etc. Note: Windows and FreeBSD
 prevent write access to areas of the disk containing in-use data
 (e.g. filesystems). If the wanted filename does need to include a colon, then
-escape that with a '\' character. For instance, if the filename is
-"/dev/dsk/foo@3,0:c", then you would use filename="/dev/dsk/foo@3,0\:c".
+escape that with a '\\' character. For instance, if the filename is
+"/dev/dsk/foo@3,0:c", then you would use filename="/dev/dsk/foo@3,0\\:c".
 .TP
 .BI filename_format \fR=\fPstr
 If sharing multiple files between jobs, it is usually necessary to have

