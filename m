Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49214 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbDQMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Apr 2015 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Yj4wG-0006YV-IM
	for fio@vger.kernel.org; Fri, 17 Apr 2015 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150417120003.42259401B4@lyth.info>
Date: Fri, 17 Apr 2015 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4da24b69599f7f78dc1420345f91d90ec0cfe109:

  Fix wrong index bug (2015-04-15 21:51:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 51e962a7610f1aa69ffe0374f92774fb83526dc7:

  Fix mtd valgrind warning (2015-04-16 16:36:22 -0600)

----------------------------------------------------------------
Dan Ehrenberg (1):
      Fix mtd valgrind warning

 lib/libmtd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/lib/libmtd.c b/lib/libmtd.c
index e1b2be1..5c9eac2 100644
--- a/lib/libmtd.c
+++ b/lib/libmtd.c
@@ -55,7 +55,7 @@ static char *mkpath(const char *path, const char *name)
 	size_t len1 = strlen(path);
 	size_t len2 = strlen(name);
 
-	n = xmalloc(len1 + len2 + 2);
+	n = xmalloc(len1 + len2 + 6);
 
 	memcpy(n, path, len1);
 	if (n[len1 - 1] != '/')
