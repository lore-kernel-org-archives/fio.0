Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/3] manpage: update URL links to HOWTO/README
Date: Fri, 26 May 2017 22:25:11 +0300
Message-Id: <20170526192511.31502-3-tkusumi@tuxera.com>
In-Reply-To: <20170526192511.31502-1-tkusumi@tuxera.com>
References: <20170526192511.31502-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Web frontend of the official git repository seems to have been changed
after 9040e236 (manpage: Add URL links to HOWTO/README).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fio.1 b/fio.1
index 301a708..9956867 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "March 2017" "User Manual"
+.TH fio 1 "May 2017" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -2594,7 +2594,7 @@ Sample jobfiles are available in the \fBexamples\fR directory.
 .br
 These are typically located under /usr/share/doc/fio.
 
-\fBHOWTO\fR:  http://git.kernel.dk/?p=fio.git;a=blob_plain;f=HOWTO
+\fBHOWTO\fR:  http://git.kernel.dk/cgit/fio/plain/HOWTO
 .br
-\fBREADME\fR: http://git.kernel.dk/?p=fio.git;a=blob_plain;f=README
+\fBREADME\fR: http://git.kernel.dk/cgit/fio/plain/README
 .br
-- 
2.9.4


