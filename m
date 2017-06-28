Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/2] HOWTO/manpage: update percentage explanation using '%'
Date: Wed, 28 Jun 2017 17:21:05 +0300
Message-Id: <20170628142106.31846-2-tkusumi@tuxera.com>
In-Reply-To: <20170628142106.31846-1-tkusumi@tuxera.com>
References: <20170628142106.31846-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

82dbb8cb (HOWTO: add offset unit info for offset= option) added
how to specify offset= option in percentage format based on below post,
which was technically correct, but str_to_decimal() invoked via
option parser can convert '%' format to low-level representation.

This commit replaces 82dbb8cb using '%' syntax since this is
considered better for documentation. Note that size= option which
also supports percentage uses '%' in documentation.

in what units is offset option?
http://www.spinics.net/lists/fio/msg05969.html

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 4 ++--
 fio.1 | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/HOWTO b/HOWTO
index 37caa3c..a07c5f2 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1095,8 +1095,8 @@ I/O type
 	offset will be used. Data before the given offset will not be touched. This
 	effectively caps the file size at `real_size - offset`. Can be combined with
 	:option:`size` to constrain the start and end range of the I/O workload.
-	A percentage can be specified by the percentage number plus 1 with preceding '-'.
-	For example, -1 is parsed as 0%, -10 is parsed as 9%, -101 is parsed as 100%.
+	A percentage can be specified by a number between 1 and 100 followed by '%',
+	for example, ``offset=20%`` to specify 20%.
 
 .. option:: offset_increment=int
 
diff --git a/fio.1 b/fio.1
index ac87c9d..ca99ad7 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "May 2017" "User Manual"
+.TH fio 1 "June 2017" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -916,8 +916,8 @@ bytes or a percentage. If a percentage is given, the next \fBblockalign\fR-ed
 offset will be used. Data before the given offset will not be touched. This
 effectively caps the file size at (real_size - offset). Can be combined with
 \fBsize\fR to constrain the start and end range of the I/O workload. A percentage
-can be specified by the percentage number plus 1 with preceding '-'. For example,
--1 is parsed as 0%, -10 is parsed as 9%, -101 is parsed as 100%.
+can be specified by a number between 1 and 100 followed by '%', for example,
+offset=20% to specify 20%.
 .TP
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes the
-- 
2.9.4


