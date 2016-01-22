Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbcAVNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Jan 2016 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aMbJr-0001V3-KB
	for fio@vger.kernel.org; Fri, 22 Jan 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160122130001.CCC742C00D8@kernel.dk>
Date: Fri, 22 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e3dae3b77f1a7285afd5a0ada6960eeb4a21e9a8:

  Fio 2.5 (2016-01-20 22:00:17 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6a971db3b3375bf9d6b835c64cac12850edc7760:

  ioengine: remove duplicate queue handler check (2016-01-21 17:45:44 +0100)

----------------------------------------------------------------
David Disseldorp (1):
      ioengine: remove duplicate queue handler check

 ioengines.c | 4 ----
 1 file changed, 4 deletions(-)

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index 9c5ac60..decc9cb 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -49,10 +49,6 @@ static int check_engine_ops(struct ioengine_ops *ops)
 		log_err("%s: no getevents handler\n", ops->name);
 		return 1;
 	}
-	if (!ops->queue) {
-		log_err("%s: no queue handler\n", ops->name);
-		return 1;
-	}
 
 	return 0;
 }
