Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] HOWTO: fix unit type suffix in "Parameter types" section to upper case
Date: Wed,  9 Aug 2017 16:44:34 +0300
Message-Id: <20170809134434.105384-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Redo 9ff84231('HOWTO: fix unit type suffix in "Parameter types" section').

> These should be all in lower case or all in upper case, but not both.
> The man page already has these in lower case.

Change above to all upper case based on below comment, instead of all
in lower. Fix the man page (which originally had in lower) as well.

RE: [PATCH 2/4] HOWTO: fix unit type suffix in "Parameter types" section
http://www.spinics.net/lists/fio/msg06146.html
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 20 ++++++++++----------
 fio.1 | 20 ++++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/HOWTO b/HOWTO
index 6c69a0e..fc173f0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -505,19 +505,19 @@ Parameter types
 	prefixes.  To specify power-of-10 decimal values defined in the
 	International System of Units (SI):
 
-		* *ki* -- means kilo (K) or 1000
-		* *mi* -- means mega (M) or 1000**2
-		* *gi* -- means giga (G) or 1000**3
-		* *ti* -- means tera (T) or 1000**4
-		* *pi* -- means peta (P) or 1000**5
+		* *Ki* -- means kilo (K) or 1000
+		* *Mi* -- means mega (M) or 1000**2
+		* *Gi* -- means giga (G) or 1000**3
+		* *Ti* -- means tera (T) or 1000**4
+		* *Pi* -- means peta (P) or 1000**5
 
 	To specify power-of-2 binary values defined in IEC 80000-13:
 
-		* *k* -- means kibi (Ki) or 1024
-		* *m* -- means mebi (Mi) or 1024**2
-		* *g* -- means gibi (Gi) or 1024**3
-		* *t* -- means tebi (Ti) or 1024**4
-		* *p* -- means pebi (Pi) or 1024**5
+		* *K* -- means kibi (Ki) or 1024
+		* *M* -- means mebi (Mi) or 1024**2
+		* *G* -- means gibi (Gi) or 1024**3
+		* *T* -- means tebi (Ti) or 1024**4
+		* *P* -- means pebi (Pi) or 1024**5
 
 	With :option:`kb_base`\=1024 (the default), the unit prefixes are opposite
 	from those specified in the SI and IEC 80000-13 standards to provide
diff --git a/fio.1 b/fio.1
index ab978ab..a3fba65 100644
--- a/fio.1
+++ b/fio.1
@@ -242,37 +242,37 @@ prefixes. To specify power-of-10 decimal values defined in the
 International System of Units (SI):
 .RS
 .P
-ki means kilo (K) or 1000
+Ki means kilo (K) or 1000
 .RE
 .RS
-mi means mega (M) or 1000**2
+Mi means mega (M) or 1000**2
 .RE
 .RS
-gi means giga (G) or 1000**3
+Gi means giga (G) or 1000**3
 .RE
 .RS
-ti means tera (T) or 1000**4
+Ti means tera (T) or 1000**4
 .RE
 .RS
-pi means peta (P) or 1000**5
+Pi means peta (P) or 1000**5
 .RE
 .P
 To specify power-of-2 binary values defined in IEC 80000-13:
 .RS
 .P
-k means kibi (Ki) or 1024
+K means kibi (Ki) or 1024
 .RE
 .RS
-m means mebi (Mi) or 1024**2
+M means mebi (Mi) or 1024**2
 .RE
 .RS
-g means gibi (Gi) or 1024**3
+G means gibi (Gi) or 1024**3
 .RE
 .RS
-t means tebi (Ti) or 1024**4
+T means tebi (Ti) or 1024**4
 .RE
 .RS
-p means pebi (Pi) or 1024**5
+P means pebi (Pi) or 1024**5
 .RE
 .P
 With `kb_base=1024' (the default), the unit prefixes are opposite
-- 
2.9.4


