Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] HOWTO: fix wrong kb_base= description
Date: Wed, 16 Aug 2017 23:09:30 +0300
Message-Id: <20170816200930.76604-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Definition of [KMGTP] and [KMGTP]i for kb_base=1000 are opposite.
It instead describes how it works when kb_base=1024 which is default.

This was originally spotted by Mikhail Terekhov in the mailing list
(in a related thread about a week ago, and the patch hasn't been sent).
http://www.spinics.net/lists/fio/msg06151.html

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 20 ++++++++++----------
 fio.1 | 20 ++++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/HOWTO b/HOWTO
index 6ecc0a6..16ae708 100644
--- a/HOWTO
+++ b/HOWTO
@@ -505,19 +505,19 @@ Parameter types
 	prefixes.  To specify power-of-10 decimal values defined in the
 	International System of Units (SI):
 
-		* *Ki* -- means kilo (K) or 1000
-		* *Mi* -- means mega (M) or 1000**2
-		* *Gi* -- means giga (G) or 1000**3
-		* *Ti* -- means tera (T) or 1000**4
-		* *Pi* -- means peta (P) or 1000**5
+		* *K* -- means kilo (K) or 1000
+		* *M* -- means mega (M) or 1000**2
+		* *G* -- means giga (G) or 1000**3
+		* *T* -- means tera (T) or 1000**4
+		* *P* -- means peta (P) or 1000**5
 
 	To specify power-of-2 binary values defined in IEC 80000-13:
 
-		* *K* -- means kibi (Ki) or 1024
-		* *M* -- means mebi (Mi) or 1024**2
-		* *G* -- means gibi (Gi) or 1024**3
-		* *T* -- means tebi (Ti) or 1024**4
-		* *P* -- means pebi (Pi) or 1024**5
+		* *Ki* -- means kibi (Ki) or 1024
+		* *Mi* -- means mebi (Mi) or 1024**2
+		* *Gi* -- means gibi (Gi) or 1024**3
+		* *Ti* -- means tebi (Ti) or 1024**4
+		* *Pi* -- means pebi (Pi) or 1024**5
 
 	With :option:`kb_base`\=1024 (the default), the unit prefixes are opposite
 	from those specified in the SI and IEC 80000-13 standards to provide
diff --git a/fio.1 b/fio.1
index 31d0a3b..792bc9d 100644
--- a/fio.1
+++ b/fio.1
@@ -244,15 +244,15 @@ International System of Units (SI):
 .RS
 .P
 .PD 0
-Ki means kilo (K) or 1000
+K means kilo (K) or 1000
 .P
-Mi means mega (M) or 1000**2
+M means mega (M) or 1000**2
 .P
-Gi means giga (G) or 1000**3
+G means giga (G) or 1000**3
 .P
-Ti means tera (T) or 1000**4
+T means tera (T) or 1000**4
 .P
-Pi means peta (P) or 1000**5
+P means peta (P) or 1000**5
 .PD
 .RE
 .P
@@ -260,15 +260,15 @@ To specify power\-of\-2 binary values defined in IEC 80000\-13:
 .RS
 .P
 .PD 0
-K means kibi (Ki) or 1024
+Ki means kibi (Ki) or 1024
 .P
-M means mebi (Mi) or 1024**2
+Mi means mebi (Mi) or 1024**2
 .P
-G means gibi (Gi) or 1024**3
+Gi means gibi (Gi) or 1024**3
 .P
-T means tebi (Ti) or 1024**4
+Ti means tebi (Ti) or 1024**4
 .P
-P means pebi (Pi) or 1024**5
+Pi means pebi (Pi) or 1024**5
 .PD
 .RE
 .P
-- 
2.9.5


