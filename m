Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbbFKMAP (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 11 Jun 2015 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z319X-0004Fh-AD
	for fio@vger.kernel.org; Thu, 11 Jun 2015 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150611120001.800F52C0102@kernel.dk>
Date: Thu, 11 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f491a907983c1022ec3c4d3a76d969c286fe441b:

  Dropped commented out part of line. (2015-06-09 14:14:20 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7a717ac6e6f154deebfe2af75a82ca0a76025453:

  Fix compiler warning (2015-06-10 08:45:36 +0900)

----------------------------------------------------------------
Tomohiro Kusumi (1):
      Fix compiler warning

 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index e3b9338..76146a7 100644
--- a/options.c
+++ b/options.c
@@ -917,7 +917,7 @@ static int str_opendir_cb(void *data, const char fio_unused *str)
 static int pattern_cb(char *pattern, unsigned int max_size,
 		      const char *input, unsigned int *pattern_bytes)
 {
-	long off;
+	long off = 0;
 	int i = 0, j = 0, len, k, base = 10;
 	uint32_t pattern_length;
 	char *loc1, *loc2;
