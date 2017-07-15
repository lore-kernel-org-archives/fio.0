Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43515 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdGOMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Jul 2017 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dWLjv-0004i2-7s
        for fio@vger.kernel.org; Sat, 15 Jul 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170715120002.2B3892C008B@kernel.dk>
Date: Sat, 15 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8f4b9f2475a4524067b6a0662aff006783919922:

  Update documentation for write_hint (2017-07-13 09:39:01 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 74c30eab68f320d73f4c7cf192699cb8bfb14eaf:

  man: fix wrong info on sync_file_range= (2017-07-14 08:25:24 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (1):
      man: fix wrong info on sync_file_range=

 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index 5da9ecf..8a41321 100644
--- a/fio.1
+++ b/fio.1
@@ -1071,7 +1071,7 @@ SYNC_FILE_RANGE_WAIT_BEFORE
 SYNC_FILE_RANGE_WRITE
 .TP
 .B wait_after
-SYNC_FILE_RANGE_WRITE
+SYNC_FILE_RANGE_WAIT_AFTER
 .TP
 .RE
 .P
