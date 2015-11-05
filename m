Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49317 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889AbbKEJty (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Nov 2015 04:49:54 -0500
From: Martin Steigerwald <ms@teamix.de>
Subject: [PATCH] Fix spelling error in binary:
Date: Thu,  5 Nov 2015 10:42:05 +0100
Message-Id: <1446716526-11246-1-git-send-email-ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Martin Steigerwald <ms@teamix.de>

> lintian -IE fio_2.2.10-1_amd64.changes
I: fio: spelling-error-in-binary usr/bin/fio Recieve Receive
---
 engines/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/rdma.c b/engines/rdma.c
index 7eb0051..1006b7e 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -115,7 +115,7 @@ static struct fio_option options[] = {
 			  },
 			  { .ival = "recv",
 			    .oval = FIO_RDMA_CHA_RECV,
-			    .help = "Posted Recieve",
+			    .help = "Posted Receive",
 			  },
 		},
 		.category = FIO_OPT_C_ENGINE,
-- 
2.6.2

