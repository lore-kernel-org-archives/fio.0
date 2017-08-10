Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752012AbdHJMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Aug 2017 08:00:14 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dfm8M-0003lf-BU
        for fio@vger.kernel.org; Thu, 10 Aug 2017 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170810120002.9690A2C289E@kernel.dk>
Date: Thu, 10 Aug 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f9cfc7d44a80638f81810416385136c35ad34658:

  Add ability to keep memory-mapped files (2017-08-08 14:26:56 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a94a977497636bdcbef7106ce3617c96c8ad66bd:

  HOWTO: fix unit type suffix in "Parameter types" section to upper case (2017-08-09 08:14:18 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (1):
      HOWTO: fix unit type suffix in "Parameter types" section to upper case

 HOWTO | 20 ++++++++++----------
 fio.1 | 20 ++++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

---

Diff of recent changes:

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
