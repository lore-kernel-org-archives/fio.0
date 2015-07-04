Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40980 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbbGELMW (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 5 Jul 2015 07:12:22 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZBM75-0000mk-IJ
	for fio@vger.kernel.org; Sat, 04 Jul 2015 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150704120001.5A1A12C006D@kernel.dk>
Date: Sat,  4 Jul 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit aa1af5fd4a7b801cc506cb511eb09f64c89648b6:

  smalloc: fix unused 'int_mask' warning if redzoning is turned off (2015-06-30 15:31:50 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 56d50ff3fccfd841921c799f6958ca1e33483959:

  t/debug: fix 'fio_debug' declaration (2015-07-03 14:26:08 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      smalloc: smalloc() already clears memory, scalloc() need not do it again
      t/debug: fix 'fio_debug' declaration

 smalloc.c | 8 +-------
 t/debug.c | 2 +-
 2 files changed, 2 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/smalloc.c b/smalloc.c
index 6bf66fc..8412e75 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -492,13 +492,7 @@ void *smalloc(size_t size)
 
 void *scalloc(size_t nmemb, size_t size)
 {
-	void *ret;
-
-	ret = smalloc(nmemb * size);
-	if (ret)
-		memset(ret, 0, nmemb * size);
-
-	return ret;
+	return smalloc(nmemb * size);
 }
 
 char *smalloc_strdup(const char *str)
diff --git a/t/debug.c b/t/debug.c
index c297d61..bf6f460 100644
--- a/t/debug.c
+++ b/t/debug.c
@@ -2,7 +2,7 @@
 
 FILE *f_err;
 struct timeval *fio_tv = NULL;
-unsigned int fio_debug = 0;
+unsigned long fio_debug = 0;
 
 void __dprint(int type, const char *str, ...)
 {
