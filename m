Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/4] HOWTO: fix unit type suffix in "Parameter types" section
Date: Mon,  7 Aug 2017 20:37:52 +0300
Message-Id: <20170807173754.80126-3-tkusumi@tuxera.com>
In-Reply-To: <20170807173754.80126-1-tkusumi@tuxera.com>
References: <20170807173754.80126-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

These should be all in lower case or all in upper case, but not both.
Given the examples of these are mostly in lower case, this commit
uses lower.

The man page already has these in lower case.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/HOWTO b/HOWTO
index ee2b996..cad9500 100644
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
+		* *ki* -- means kilo (K) or 1000
+		* *mi* -- means mega (M) or 1000**2
+		* *gi* -- means giga (G) or 1000**3
+		* *ti* -- means tera (T) or 1000**4
+		* *pi* -- means peta (P) or 1000**5
 
 	To specify power-of-2 binary values defined in IEC 80000-13:
 
 		* *k* -- means kibi (Ki) or 1024
-		* *M* -- means mebi (Mi) or 1024**2
-		* *G* -- means gibi (Gi) or 1024**3
-		* *T* -- means tebi (Ti) or 1024**4
-		* *P* -- means pebi (Pi) or 1024**5
+		* *m* -- means mebi (Mi) or 1024**2
+		* *g* -- means gibi (Gi) or 1024**3
+		* *t* -- means tebi (Ti) or 1024**4
+		* *p* -- means pebi (Pi) or 1024**5
 
 	With :option:`kb_base`\=1024 (the default), the unit prefixes are opposite
 	from those specified in the SI and IEC 80000-13 standards to provide
-- 
2.9.4


