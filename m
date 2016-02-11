Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33878 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbcBKNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 11 Feb 2016 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aTqqq-00026N-5v
	for fio@vger.kernel.org; Thu, 11 Feb 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160211130001.9E4F92C2157@kernel.dk>
Date: Thu, 11 Feb 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 03d189b7d77f66ce4f4dba9885d34c7a55ff4e53:

  diskutil: don't print terse disk util twice for json,terse output format (2016-02-09 13:45:50 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8a768c2e725d6a527b904570949f6099c3f1434a:

  server: don't make SO_REUSEPORT errors fatal (2016-02-10 08:32:13 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      server: don't make SO_REUSEPORT errors fatal

 server.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index c3e034c..6416a5c 100644
--- a/server.c
+++ b/server.c
@@ -1916,11 +1916,10 @@ static int fio_init_server_ip(void)
 		return -1;
 	}
 #ifdef SO_REUSEPORT
-	if (setsockopt(sk, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt)) < 0) {
-		log_err("fio: setsockopt(REUSEPORT): %s\n", strerror(errno));
-		close(sk);
-		return -1;
-	}
+	/*
+	 * Not fatal if fails, so just ignore it if that happens
+	 */
+	setsockopt(sk, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt));
 #endif
 
 	if (use_ipv6) {
