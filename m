Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbcHUMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 21 Aug 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bbRQ3-00026g-PY
        for fio@vger.kernel.org; Sun, 21 Aug 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160821120001.CE85E2C0285@kernel.dk>
Date: Sun, 21 Aug 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d1f6fcadb7cb28a5e57a5e573395fe2deb3cfd7b:

  Manual page for fiologparser_hist.py and Makefile updates to install them. (2016-08-18 18:56:17 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a86f6d07f12141a32ccad2007d4568e612e0df10:

  verify: use proper include for PATH_MAX (2016-08-20 10:28:57 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      verify: use proper include for PATH_MAX

 verify-state.h | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/verify-state.h b/verify-state.h
index 901aa0a..e46265e 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -3,6 +3,7 @@
 
 #include <stdint.h>
 #include <string.h>
+#include <limits.h>
 
 struct thread_rand32_state {
 	uint32_t s[4];
