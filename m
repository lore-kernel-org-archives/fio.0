Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaFDMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Jun 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Ws9rQ-0005bo-DH
	for fio@vger.kernel.org; Wed, 04 Jun 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140604120003.110564012D@lyth.info>
Date: Wed,  4 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 82340a9fb6da0c4cc6a213bfc575c69bfa702712:

  Make rbd engine use aio flush (2014-05-29 14:14:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 290a9a2ae1778428123d4a6b10d4db7c18993b17:

  glusterfs: remove glfs-handles.h include (2014-06-03 08:36:20 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      glusterfs: remove glfs-handles.h include

 engines/gfapi.h |    1 -
 1 file changed, 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/gfapi.h b/engines/gfapi.h
index f8acb98..c79838b 100644
--- a/engines/gfapi.h
+++ b/engines/gfapi.h
@@ -1,5 +1,4 @@
 #include <glusterfs/api/glfs.h>
-#include <glusterfs/api/glfs-handles.h>
 #include "../fio.h"
 
 struct gf_options {
