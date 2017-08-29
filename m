Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/6] HOWTO: add OpenBSD to direct I/O unsupported platform
Date: Wed, 30 Aug 2017 00:12:12 +0300
Message-Id: <20170829211216.42347-3-tkusumi@tuxera.com>
In-Reply-To: <20170829211216.42347-1-tkusumi@tuxera.com>
References: <20170829211216.42347-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

OpenBSD has neither open(O_DIRECT) nor its kernel specific way.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 2 +-
 fio.1 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index f36d4a7..3a720c3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -947,7 +947,7 @@ I/O type
 .. option:: direct=bool
 
 	If value is true, use non-buffered I/O. This is usually O_DIRECT. Note that
-	ZFS on Solaris doesn't support direct I/O.  On Windows the synchronous
+	OpenBSD and ZFS on Solaris don't support direct I/O.  On Windows the synchronous
 	ioengines don't support direct I/O.  Default: false.
 
 .. option:: atomic=bool
diff --git a/fio.1 b/fio.1
index b8b3da2..5b63dfd 100644
--- a/fio.1
+++ b/fio.1
@@ -717,7 +717,7 @@ read. The two zone options can be used to only do I/O on zones of a file.
 .TP
 .BI direct \fR=\fPbool
 If value is true, use non\-buffered I/O. This is usually O_DIRECT. Note that
-ZFS on Solaris doesn't support direct I/O. On Windows the synchronous
+OpenBSD and ZFS on Solaris don't support direct I/O. On Windows the synchronous
 ioengines don't support direct I/O. Default: false.
 .TP
 .BI atomic \fR=\fPbool
-- 
2.9.5


