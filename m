Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbhG2MAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Jul 2021 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE03C061765
        for <fio@vger.kernel.org>; Thu, 29 Jul 2021 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m94ho-003xd3-MV
        for fio@vger.kernel.org; Thu, 29 Jul 2021 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210729120002.1CE0C1BC0154@kernel.dk>
Date: Thu, 29 Jul 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9ce6f6f2bd636e9678982b86d6992ed419634c31:

  Merge branch 'evelu-fix-engines' of https://github.com/ErwanAliasr1/fio (2021-07-25 16:48:02 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7c8e6725155cae72a0a730d3c3a36776bc5621a3:

  Makefile: update libzbc git repository (2021-07-28 07:27:29 -0600)

----------------------------------------------------------------
Damien Le Moal (1):
      Makefile: update libzbc git repository

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 6b4b4122..5198f70e 100644
--- a/Makefile
+++ b/Makefile
@@ -651,7 +651,7 @@ test: fio
 fulltest:
 	sudo modprobe null_blk &&				 	\
 	if [ ! -e /usr/include/libzbc/zbc.h ]; then			\
-	  git clone https://github.com/hgst/libzbc &&		 	\
+	  git clone https://github.com/westerndigitalcorporation/libzbc && \
 	  (cd libzbc &&						 	\
 	   ./autogen.sh &&					 	\
 	   ./configure --prefix=/usr &&				 	\

