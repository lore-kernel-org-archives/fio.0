Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37256 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbeHPO6d (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Aug 2018 10:58:33 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fqGx0-0002qt-2f
        for fio@vger.kernel.org; Thu, 16 Aug 2018 12:00:26 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180816120001.F0C712C2FEA@kernel.dk>
Date: Thu, 16 Aug 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 875e8d6fa4d443068eb1c48a29f5367e454d2a37:

  Merge branch 'wip-http-engine' of https://github.com/l-mb/fio (2018-08-14 10:09:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 35e2d88fad2151f272af60babb5e6c98922d0bcd:

  Fix compilation on centos 7 (2018-08-15 12:06:14 -0600)

----------------------------------------------------------------
Manish Dusane (1):
      Fix compilation on centos 7

 log.h | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/log.h b/log.h
index b50d448..562f3f4 100644
--- a/log.h
+++ b/log.h
@@ -3,6 +3,7 @@
 
 #include <stdio.h>
 #include <stdarg.h>
+#include <unistd.h>
 
 #include "lib/output_buffer.h"
 

