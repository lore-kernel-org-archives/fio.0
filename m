Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbbJ3MAC (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Oct 2015 08:00:02 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Zs8Li-0002b8-8S
	for fio@vger.kernel.org; Fri, 30 Oct 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151030120001.66EE32C0125@kernel.dk>
Date: Fri, 30 Oct 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 09c782bbe1c62d016c8b165f304c7085a7ff9ffd:

  Update documentation for mmapshared (MMAP_SHARED) (2015-10-28 14:04:24 +0900)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 125451c0455dfcfd11dbcf9570d23218ed4b8ad3:

  Bump the client ETA timeout from 5s to 30s (2015-10-30 11:52:23 +0900)

----------------------------------------------------------------
Jens Axboe (1):
      Bump the client ETA timeout from 5s to 30s

 server.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/server.h b/server.h
index 18a689c..eb29de7 100644
--- a/server.h
+++ b/server.h
@@ -74,7 +74,7 @@ enum {
 
 	FIO_NET_NAME_MAX		= 256,
 
-	FIO_NET_CLIENT_TIMEOUT		= 5000,
+	FIO_NET_CLIENT_TIMEOUT		= 30000,
 
 	FIO_PROBE_FLAG_ZLIB		= 1UL << 0,
 };
