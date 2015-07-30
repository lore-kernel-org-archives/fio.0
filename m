Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40708 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbG3MAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 30 Jul 2015 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZKmVM-0007Ww-9T
	for fio@vger.kernel.org; Thu, 30 Jul 2015 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150730120001.DB3C82C005D@kernel.dk>
Date: Thu, 30 Jul 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 61054f0d5c2ccb945c240704fc4bfa6a708eaf46:

  configure: add --disable-optimizations (2015-07-27 15:10:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 669e8bf8d509458aa6b3978b9e8a2e3d666e892d:

  server: make the setsockopt() error output a bit more informative (2015-07-29 09:00:03 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      server: make the setsockopt() error output a bit more informative

 server.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index b4137d1..18b3a08 100644
--- a/server.c
+++ b/server.c
@@ -1495,13 +1495,13 @@ static int fio_init_server_ip(void)
 
 	opt = 1;
 	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, (void *)&opt, sizeof(opt)) < 0) {
-		log_err("fio: setsockopt: %s\n", strerror(errno));
+		log_err("fio: setsockopt(REUSEADDR): %s\n", strerror(errno));
 		close(sk);
 		return -1;
 	}
 #ifdef SO_REUSEPORT
 	if (setsockopt(sk, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt)) < 0) {
-		log_err("fio: setsockopt: %s\n", strerror(errno));
+		log_err("fio: setsockopt(REUSEPORT): %s\n", strerror(errno));
 		close(sk);
 		return -1;
 	}
