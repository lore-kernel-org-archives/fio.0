Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/7] manpage: Add URL links to HOWTO/README
Date: Mon, 13 Mar 2017 20:15:02 +0200
Message-Id: <20170313181503.33322-6-tkusumi@tuxera.com>
In-Reply-To: <20170313181503.33322-1-tkusumi@tuxera.com>
References: <20170313181503.33322-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Add links to the official repository since whether HOWTO/README
get installed somewhere in fs is distributions/OS dependent.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index cc68dee..3348513 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "December 2016" "User Manual"
+.TH fio 1 "March 2017" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -2584,3 +2584,10 @@ See \fBREADME\fR.
 For further documentation see \fBHOWTO\fR and \fBREADME\fR.
 .br
 Sample jobfiles are available in the \fBexamples\fR directory.
+.br
+These are typically located under /usr/share/doc/fio.
+
+\fBHOWTO\fR:  http://git.kernel.dk/?p=fio.git;a=blob_plain;f=HOWTO
+.br
+\fBREADME\fR: http://git.kernel.dk/?p=fio.git;a=blob_plain;f=README
+.br
-- 
2.9.3


