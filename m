Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41018 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdI0MAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Sep 2017 08:00:21 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dxB0m-0003ll-MG
        for fio@vger.kernel.org; Wed, 27 Sep 2017 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170927120001.D97FE2C026C@kernel.dk>
Date: Wed, 27 Sep 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2ae7a90df2d2340c4503be8a91526f80b3b96789:

  init: typo in help output (2017-09-20 22:21:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7595fa09fbf048c9045617668bf0159a6cb82eac:

  Remove old exp/README.md file (2017-09-26 13:38:38 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Remove old exp/README.md file

 exp/README.md | 7 -------
 1 file changed, 7 deletions(-)
 delete mode 100644 exp/README.md

---

Diff of recent changes:

diff --git a/exp/README.md b/exp/README.md
deleted file mode 100644
index 48c11c9..0000000
--- a/exp/README.md
+++ /dev/null
@@ -1,7 +0,0 @@
-simple-expression-parser
-========================
-
-A simple expression parser for arithmetic expressions made with bison + flex
-
-To use, see the example test-expression-parser.c
-
