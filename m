Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/7] HOWTO: Mention fsync=/fsyncdata= are set to 0 by default
Date: Mon, 20 Mar 2017 23:28:44 +0200
Message-Id: <20170320212847.71404-4-tkusumi@tuxera.com>
In-Reply-To: <20170320212847.71404-1-tkusumi@tuxera.com>
References: <20170320212847.71404-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think people could think sync ioengine and variants would somehow
fsync(2) for writes from what their name sound like, while they do
not unless these options are explicitly set (default 0).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 1ce1b0c..cae95b7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1100,13 +1100,15 @@ I/O type
 	blocks given. For example, if you give 32 as a parameter, fio will sync the
 	file for every 32 writes issued. If fio is using non-buffered I/O, we may
 	not sync the file. The exception is the sg I/O engine, which synchronizes
-	the disk cache anyway.
+	the disk cache anyway. Defaults to 0, which means no sync every certain
+	number of writes.
 
 .. option:: fdatasync=int
 
 	Like :option:`fsync` but uses :manpage:`fdatasync(2)` to only sync data and
 	not metadata blocks.  In Windows, FreeBSD, and DragonFlyBSD there is no
 	:manpage:`fdatasync(2)`, this falls back to using :manpage:`fsync(2)`.
+	Defaults to 0, which means no sync data every certain number of writes.
 
 .. option:: write_barrier=int
 
@@ -1571,6 +1573,7 @@ I/O engine
 		**sync**
 			Basic :manpage:`read(2)` or :manpage:`write(2)`
 			I/O. :manpage:`lseek(2)` is used to position the I/O location.
+			See :option:`fsync` and :option:`fdatasync` for syncing write I/Os.
 
 		**psync**
 			Basic :manpage:`pread(2)` or :manpage:`pwrite(2)` I/O.  Default on
-- 
2.9.3


