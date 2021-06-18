Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhFRMCQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Jun 2021 08:02:16 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABFAC061574
        for <fio@vger.kernel.org>; Fri, 18 Jun 2021 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luDAD-009B1z-CZ
        for fio@vger.kernel.org; Fri, 18 Jun 2021 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210618120001.A52FD1BC0100@kernel.dk>
Date: Fri, 18 Jun 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a59b12d2a5eb92c1128a5d8ebcd03b1831962ce5:

  t/zbd: update test case 42 (2021-06-14 08:54:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to afa37b56c6637967180e4409adbb682b2ce16bcb:

  filehash: ignore hashed file with fd == -1 (2021-06-17 10:55:20 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      filehash: ignore hashed file with fd == -1

 filehash.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/filehash.c b/filehash.c
index b55ab734..71ec7b18 100644
--- a/filehash.c
+++ b/filehash.c
@@ -60,10 +60,8 @@ static struct fio_file *__lookup_file_hash(const char *name)
 		if (!f->file_name)
 			continue;
 
-		if (!strcmp(f->file_name, name)) {
-			assert(f->fd != -1);
+		if (!strcmp(f->file_name, name))
 			return f;
-		}
 	}
 
 	return NULL;

